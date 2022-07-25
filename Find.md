---
tags: [linux]
title: Find
created: '2021-10-27T23:21:40.274Z'
modified: '2021-12-09T21:12:58.481Z'
---

# Find
### Examples of find command
- `sudo find / -type d -iname "gasper"` - search direcotry
- `sudo find /etc -type f -name "*.conf"` - display all configuration files, for more percison you should `|`  into `grep`.


You can also add `szie` flag to narrow down results to expected filesize. Other useful flags: `user`, `group`.
