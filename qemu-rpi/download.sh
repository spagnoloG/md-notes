#!/usr/bin/env bash
set -euo pipefail

vm_dir=${RPI_VM_DIR:-$HOME/VMs/raspberry-pi-os}
image=2026-10-06-raspios-trixie-arm64.img
url=https://downloads.raspberrypi.com/raspios_arm64/images/raspios_arm64-2026-10-06/$image.xz
sha256=976766570bee2aaf3047dd78649cfe82abb8fe9687b7f15030cd533ba4e9f7a9

mkdir -p "$vm_dir/boot" "$vm_dir/logs"
cd "$vm_dir"

if [[ -e rpi-os.raw ]]; then
  echo "rpi-os.raw already exists, not touching it" >&2
  exit 1
fi

curl -fL --retry 3 --continue-at - "$url" -o "$image.xz"
echo "$sha256  $image.xz" | sha256sum -c -
[[ -f $image ]] || xz -dk "$image.xz"

cp --reflink=auto --sparse=always "$image" rpi-os.raw
qemu-img resize -f raw rpi-os.raw 32G
