---
favorited: true
tags: [linux]
title: System information
created: '2021-10-27T22:55:40.432Z'
modified: '2021-12-26T15:51:15.496Z'
---

# System information
### Basic user enumeration

- `whoami` `hostname` - get username and hostname
- `id` - get information which group ids current user belongs to
- `groups $USER` - check groups
- `last` - check users that logged in recently


### Cpu, memory
- `lscpu` - show cpu information
- `free -h` - display memory usage
- `uname -p` or `uname -m` - show system architecture
- `uname -r` - see a running kernel
- `lsb_release -a` or `cat /etc/*release` - see running distribution

### Another useful tool `sysstat` package
- `iostat` - show current io (disk usage, cpu usage)
- `mpstat` - show current cpu usage (detailed)
