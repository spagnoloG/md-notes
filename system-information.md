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
