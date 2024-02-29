# Find

### Examples of find command

- `sudo find / -type d -iname "gasper"` - search direcotry
- `sudo find /etc -type f -name "*.conf"` - display all configuration files, for more percison you should `|` into `grep`.
- `sudo find / -iname "*~"  -exec rm -i {} \;` - remove all files with `~` in name
- `sudo find / -type f -size +100M` - find files larger than 100MB
- `sudo find / -type f -size +100M -exec ls -lh {} \;` - find files larger than 100MB and list them
- `sudo find / -type f -size +100M -exec ls -lh {} \; | awk '{print $9 ": " $5}'` - find files larger than 100MB and list them with size
- `sudo find / -type f -size +100M -exec ls -lh {} \; | awk '{print $9 ": " $5}' | fzf` - find files larger than 100MB and list them with size and select one with fzf

You can also add `size` flag to narrow down results to expected filesize. Other useful flags: `user`, `group`.
