#!/usr/bin/env bash
set -euo pipefail

vm_dir=${RPI_VM_DIR:-$HOME/VMs/raspberry-pi-os}
mkdir -p "$vm_dir"
cd "$vm_dir"

[[ -s boot/Image && -s boot/initrd.gz && -f rpi-os.raw ]]
if [[ -n $(losetup -j "$PWD/rpi-os.raw") ]]; then
  echo "rpi-os.raw is still on a loop device, unmount and detach it first" >&2
  exit 1
fi
mkdir -p logs

display_mode=${DISPLAY_MODE:-gtk}
case $display_mode in
  gtk)
    display_args=(-display 'gtk,gl=off')
    ;;
  spice)
    display_args=(
      -display none
      -spice 'addr=127.0.0.1,port=5930,disable-ticketing=on'
      -device virtio-serial-pci
      -chardev 'spicevmc,id=vdagent,name=vdagent'
      -device 'virtserialport,chardev=vdagent,name=com.redhat.spice.0'
    )
    ;;
  *)
    echo "unknown DISPLAY_MODE: $display_mode" >&2
    exit 1
    ;;
esac

exec qemu-system-aarch64 \
  -name rpi4-os-arm64 \
  -machine virt,gic-version=3 \
  -accel tcg,thread=multi \
  -cpu cortex-a72 -smp 4 -m 4096 \
  -kernel boot/Image \
  -initrd boot/initrd.gz \
  -append 'root=/dev/vda2 rootfstype=ext4 rw rootwait console=tty0 console=ttyAMA0,115200 net.ifnames=0' \
  -drive if=none,id=osdisk,file=rpi-os.raw,format=raw \
  -device virtio-blk-pci,drive=osdisk \
  -netdev user,id=net0,hostfwd=tcp:127.0.0.1:2222-:22 \
  -device virtio-net-pci,netdev=net0 \
  -device virtio-gpu-pci \
  -device qemu-xhci -device usb-kbd -device usb-tablet \
  -object rng-random,id=rng0,filename=/dev/urandom \
  -device virtio-rng-pci,rng=rng0 \
  -chardev stdio,id=serial0,signal=off,logfile=logs/serial.log,logappend=on \
  -serial chardev:serial0 -monitor none \
  "${display_args[@]}"
