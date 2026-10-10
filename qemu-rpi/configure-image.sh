#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "needs root" >&2
  exit 1
fi

vm_dir=$(realpath -- "${1:?usage: configure-image.sh VM_DIR}")
cd "$vm_dir"
image=$vm_dir/rpi-os.raw
mnt=$vm_dir/mnt

[[ -f $image && ! -L $image ]]
[[ -s boot/Image && -s boot/initrd.gz && -s boot/kernel-release && -s userconf.txt ]]
kver=$(cat boot/kernel-release)
[[ -d modules-stage/lib/modules/$kver ]]
if [[ -n $(losetup -j "$image") ]]; then
  echo "$image is already on a loop device" >&2
  exit 1
fi

mkdir -p "$mnt"
if mountpoint -q "$mnt"; then
  echo "$mnt is already mounted" >&2
  exit 1
fi

loopdev=
cleanup() {
  local failed=0
  if mountpoint -q "$mnt/boot/firmware"; then
    umount "$mnt/boot/firmware" || failed=1
  fi
  if mountpoint -q "$mnt"; then
    umount "$mnt" || failed=1
  fi
  if [[ -n $loopdev && $failed -eq 0 ]]; then
    losetup -d "$loopdev" || true
  fi
  if [[ $failed -ne 0 ]]; then
    echo "umount failed, close whatever is using $mnt and detach $loopdev by hand" >&2
  fi
}
trap cleanup EXIT

loopdev=$(losetup --find --show --partscan "$image")
udevadm settle

sfdisk --json "$loopdev" | python -c '
import json, sys
parts = json.load(sys.stdin)["partitiontable"]["partitions"]
assert len(parts) == 2, "expected 2 partitions"
assert parts[1]["type"].lower() == "83", "partition 2 is not type 83"
'

parted --script "$loopdev" resizepart 2 100%
partx --update "$loopdev"
udevadm settle
bootdev=${loopdev}p1
rootdev=${loopdev}p2
[[ -b $rootdev && -b $bootdev ]]

# e2fsck exits 1 if it fixed something, that's fine
rc=0
e2fsck -f -p "$rootdev" || rc=$?
if (( rc > 1 )); then
  echo "e2fsck failed ($rc)" >&2
  exit "$rc"
fi
resize2fs "$rootdev"

mount "$rootdev" "$mnt"
mkdir -p "$mnt/boot/firmware"
mount "$bootdev" "$mnt/boot/firmware"
[[ -f $mnt/etc/os-release ]]
[[ -x $mnt/usr/lib/userconf-pi/userconf-service ]]

# not /lib, it is a symlink to usr/lib
mkdir -p "$mnt/usr/lib/modules"
cp -a "modules-stage/lib/modules/$kver" "$mnt/usr/lib/modules/"

[[ -e $mnt/etc/fstab.before-qemu ]] || cp -a "$mnt/etc/fstab" "$mnt/etc/fstab.before-qemu"
awk '
  /^[[:space:]]*#/ { print; next }
  $2 == "/" { $1 = "/dev/vda2" }
  $2 == "/boot/firmware" { $1 = "/dev/vda1" }
  { print }
' "$mnt/etc/fstab" > "$mnt/etc/fstab.qemu"
mv "$mnt/etc/fstab.qemu" "$mnt/etc/fstab"

cp userconf.txt "$mnt/boot/firmware/userconf.txt"
touch "$mnt/boot/firmware/ssh"

mkdir -p "$mnt/etc/cloud"
touch "$mnt/etc/cloud/cloud-init.disabled"

cat > "$mnt/etc/profile.d/qemu-software-rendering.sh" <<'EOF'
export LIBGL_ALWAYS_SOFTWARE=1
export WLR_RENDERER=pixman
EOF
for var in LIBGL_ALWAYS_SOFTWARE=1 WLR_RENDERER=pixman; do
  grep -qxF "$var" "$mnt/etc/environment" || echo "$var" >> "$mnt/etc/environment"
done

systemctl --root="$mnt" enable userconfig.service ssh.service
systemctl --root="$mnt" set-default graphical.target
systemctl --root="$mnt" mask hciuart.service rpi-eeprom-update.service
sync
echo "image configured"
