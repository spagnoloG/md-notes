# OS FLASHING

## WINDOWS

Firstly locate the connected usb issuing the command:

```bash
lsblk -f
```

Then when you located the drive just issue the `dd` command:

```bash
 sudo dd if=Win10_22H2_En_x64.iso of=/dev/sda bs=4M status=progress
```

## Linux

Use simple tool like [etcher](https://www.balena.io/etcher/).
