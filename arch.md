# Arch

Fix broken mirrors on upgrade

```bash

# 2Refresh arch keyring package + keyring content
pacman -Sy --needed archlinux-keyring

# Re-init + populate pacman keyring 
pacman-key --init
pacman-key --populate archlinux

# Refresh keys from keyservers
pacman-key --refresh-keys
```
