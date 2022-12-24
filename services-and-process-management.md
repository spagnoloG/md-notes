# Services and process management

### PS command
- `ps aux` - display  **all** running services (snapshot)  ex. `ps aux | grep "ssh"`
- `sudo kill <pid>` - kill process with provided pid, provided by `ps` command
- `pkill <process-name>` - kill process by name :sunglasses:

**OG COMMAND** -> `ps -auxf` (tree structure)

## on systemd u can also
- `systemctl | grep <service_name>` - display all running services or grep one
- `sudo systemctl is-enabled ssh` - check if service is enabled
