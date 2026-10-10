# Raspberry Pi OS ARM64 in QEMU

**Arch Linux Cortex-A72  4 CPUs · 4 GB RAM · 32 GB disk**

Uses QEMU `virt` and a **prebuilt Debian kernel**. 

Scripts: [qemu-rpi/](qemu-rpi/). VM files: `~/VMs/raspberry-pi-os`.

## 1. Install tools

```bash
sudo pacman -Syu --needed \
  qemu-system-aarch64 qemu-img qemu-ui-gtk qemu-hw-display-virtio-gpu-pci \
  openssl kmod libarchive cpio gzip \
  curl xz parted e2fsprogs util-linux python
```

## 2. Download and prepare

Downloads the official **64-bit Trixie desktop image (2026-10-06)** and Debian's **6.12.111 ARM64 kernel**, then packages its boot drivers into an initramfs.

```bash
bash "$HOME/Documents/md-notes/qemu-rpi/download.sh"
bash "$HOME/Documents/md-notes/qemu-rpi/prepare-kernel.sh"
```

Stop if either command fails. If `rpi-os.raw` already exists, skip `download.sh`. The original image is kept.

## 3. Set password and prepare disk

Username: **`pi`**. Enter your chosen password when prompted.

```bash
umask 077
printf 'pi:%s\n' "$(openssl passwd -6)" > "$HOME/VMs/raspberry-pi-os/userconf.txt"
sudo bash "$HOME/Documents/md-notes/qemu-rpi/configure-image.sh" \
  "$HOME/VMs/raspberry-pi-os"
```

If using PolicyKit, replace `sudo bash` with `pkexec /usr/bin/bash`. Keep QEMU stopped during disk preparation.

## 4. Run 

```bash
bash "$HOME/Documents/md-notes/qemu-rpi/run.sh"
```

A desktop window opens; log in as `pi`. Allow several minutes for first boot. Use the same command for later runs.

SSH from another host terminal:

```bash
ssh -p 2222 pi@127.0.0.1
```

Inside the guest, `uname -m` should show **`aarch64`**. Shut down with `sudo poweroff`.

##  clipboard

On the **host**:

```bash
sudo pacman -Syu --needed qemu-ui-spice-core qemu-chardev-spice virt-viewer
```

Inside the **guest**:

```bash
sudo apt update
sudo apt install spice-vdagent
sudo raspi-config
```

Choose **Advanced Options ->  Wayland -> W1 X11**, then shut down. Trixie's SPICE agent uses an X11 session.

Start on the **host**:

```bash
DISPLAY_MODE=spice bash "$HOME/Documents/md-notes/qemu-rpi/run.sh"
```

In another host terminal:

```bash
remote-viewer spice://127.0.0.1:5930
```
