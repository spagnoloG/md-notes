# Clipboard

### On xorg

- `cat file.txt | xclip -selection clipboard -i` - store file into clipboard

### On wayland

- `cat file.txt | wl-copy` - store file into clipboard

## Change keyboard layout on wayland

- `swaymsg input type:keyboard xkb_layout "sl"`
- `swaymsg input type:keyboard xkb_layout "us"`
