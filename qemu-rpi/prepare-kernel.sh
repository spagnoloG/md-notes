#!/usr/bin/env bash
set -euo pipefail

vm_dir=${RPI_VM_DIR:-$HOME/VMs/raspberry-pi-os}
mkdir -p "$vm_dir/boot" "$vm_dir/packages" "$vm_dir/logs"
cd "$vm_dir"

kver=6.12.111+deb13-arm64
kernel_deb=linux-image-${kver}_6.12.111-1_arm64.deb
busybox_deb=busybox-static_1.37.0-6+b9_arm64.deb

fetch() {
  local file=packages/$1 url=$2 sum=$3
  if [[ ! -f $file ]]; then
    curl -fL --retry 3 "$url" -o "$file.partial"
    mv "$file.partial" "$file"
  fi
  echo "$sum  $file" | sha256sum -c -
}

fetch "$kernel_deb" \
  "https://security.debian.org/debian-security/pool/updates/main/l/linux-signed-arm64/$kernel_deb" \
  981370389cb9f6241b41f66ea5c8a0e7bdd28b9e959cec4d3bac97b1eb1248bf
fetch "$busybox_deb" \
  "https://deb.debian.org/debian/pool/main/b/busybox/$busybox_deb" \
  c833be48abfa16bc19c4966ec93e289ff1ce5d2f1476cad3a57bd105378cd15c

stage=$(mktemp -d "$vm_dir/.kernel-prepare.XXXXXX")
trap 'rm -rf -- "$stage"' EXIT

extract_deb() {
  bsdtar -xOf "$1" data.tar.xz | bsdtar -xf - -C "$2"
}

mkdir -p "$stage/kernel" "$stage/busybox" "$stage/modules/lib/modules"
extract_deb "packages/$kernel_deb" "$stage/kernel"
extract_deb "packages/$busybox_deb" "$stage/busybox"
cp -a "$stage/kernel/usr/lib/modules/$kver" "$stage/modules/lib/modules/"
depmod -b "$stage/modules" -F "$stage/kernel/boot/System.map-$kver" "$kver"

python - "$stage/kernel/boot/vmlinuz-$kver" "$stage/Image" <<'EOF'
import gzip, sys
from pathlib import Path

data = Path(sys.argv[1]).read_bytes()
if data[:2] == b'\x1f\x8b':
    data = gzip.decompress(data)
if data[56:60] != b'ARM\x64':
    sys.exit('not an arm64 Image')
Path(sys.argv[2]).write_bytes(data)
EOF

initrd=$stage/initrd
mkdir -p "$initrd"/{bin,dev,proc,sys,newroot,etc,modules}
cp "$stage/busybox/usr/bin/busybox" "$initrd/bin/busybox"
ln -s busybox "$initrd/bin/sh"

for mod in virtio_blk ext4; do
  modprobe --show-depends -d "$stage/modules" -S "$kver" "$mod"
done > "$stage/dependencies"
awk '$1 == "insmod" && !seen[$2]++ { print $2 }' "$stage/dependencies" > "$stage/module-files"

while IFS= read -r ko; do
  name=$(basename -- "$ko")
  case $name in
    *.xz) name=${name%.xz}; xz -dc "$ko" > "$initrd/modules/$name" ;;
    *.ko) cp "$ko" "$initrd/modules/$name" ;;
    *) echo "unexpected module: $ko" >&2; exit 1 ;;
  esac
  echo "/modules/$name" >> "$initrd/etc/boot-modules"
done < "$stage/module-files"
[[ -s $initrd/etc/boot-modules ]]

cat > "$initrd/init" <<'EOF'
#!/bin/sh
set -eu
bb=/bin/busybox

$bb mount -t devtmpfs devtmpfs /dev
exec </dev/console >/dev/console 2>&1

rescue() {
  echo 'initramfs failed, dropping to a shell'
  exec /bin/busybox sh
}
trap rescue EXIT

$bb mount -t proc proc /proc
$bb mount -t sysfs sysfs /sys

while IFS= read -r mod; do
  $bb insmod "$mod"
done < /etc/boot-modules

rootdev=/dev/vda2
for arg in $($bb cat /proc/cmdline); do
  case "$arg" in root=*) rootdev=${arg#root=} ;; esac
done

n=0
until [ -b "$rootdev" ]; do
  n=$((n + 1))
  [ "$n" -le 30 ] || { echo "no root device: $rootdev"; exit 1; }
  $bb sleep 1
done

$bb mount -t ext4 -o rw "$rootdev" /newroot
$bb mkdir -p /newroot/dev /newroot/proc /newroot/sys
$bb mount --move /dev /newroot/dev
$bb mount --move /proc /newroot/proc
$bb mount --move /sys /newroot/sys

echo "initramfs: switching to $rootdev"
exec $bb switch_root /newroot /sbin/init
EOF
chmod 755 "$initrd/init" "$initrd/bin/busybox"

(cd "$initrd" && find . -print0 | LC_ALL=C sort -z |
  cpio --null -o --format=newc --owner=0:0 --quiet | gzip -n > "$stage/initrd.gz")

mkdir -p modules-stage/lib/modules
cp -a "$stage/modules/lib/modules/$kver" modules-stage/lib/modules/
cp "$stage/Image" boot/Image
cp "$stage/initrd.gz" boot/initrd.gz
cp "$stage/kernel/boot/config-$kver" boot/kernel.config
echo "$kver" > boot/kernel-release
echo "kernel and initrd ready ($kver)"
