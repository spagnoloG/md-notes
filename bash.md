#  Bash

### Read file line by line using bash
Gotta love those oneliners ;)
```bash
    while read line; do printf "$line\n"; printf "other commands\n"; done < /etc/passwd
```
