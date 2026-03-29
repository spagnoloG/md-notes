# OS Flashing

Find the USB device first:

```bash
lsblk
```

Use the whole disk, not a partition: `/dev/sdX`, not `/dev/sdX1`.

## Linux

Write the ISO with `dd`:

```bash
sudo dd if=/path/to/linux.iso of=/dev/sdX bs=4M status=progress conv=fsync
sync
```

## Windows

Use `woeusb`:

```bash
sudo apt install -y woeusb
sudo woeusb --device /path/to/windows.iso /dev/sdX
```
