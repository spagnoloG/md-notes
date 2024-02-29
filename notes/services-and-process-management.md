# Services and process management

### PS command

- `ps aux` - display **all** running services (snapshot) ex. `ps aux | grep "ssh"`
- `sudo kill <pid>` - kill process with provided pid, provided by `ps` command
- `pkill <process-name>` - kill process by name :sunglasses:

**OG COMMAND** -> `ps -auxf` (tree structure)

## Systemd (Ubuntu/Debian)

- `systemctl | grep <service_name>` - display all running services or grep one
- `sudo systemctl is-enabled ssh` - check if service is enabled
- `systemctl list-unit-files --type=service --state=enabled` - list all enabled services
- `sudo systemctl enable --now ssh` - Enable and start service
- `sudo systemctl disable --now ssh` - Disable and stop service
- `sudo systemctl status ssh` - check status of service
- `sudo systemctl start ssh` - start service
- `sudo systemctl stop ssh` - stop service
- `systemctl --failed --type=service` - list failed services
- `systemctl list-units --type=service` - list all running services
- `systemctl list-units --type=service --state=inactive` - list all inactive services
- `systemctl list-units --type=service --all` - list all services

## RedHat/CentOS

- `chkconfig --list` - list all services
- `chkconfig --list | grep ssh` - list service by name
- `chkconfig sshd on` - enable service
- `chkconfig sshd off` - disable service
- `service sshd status` - check status of service
- `service sshd start` - start service
- `service sshd stop` - stop service
- `service sshd restart` - restart service
- `service sshd reload` - reload service
- `service sshd condrestart` - restart service if it is already running
- `service sshd try-restart` - restart service if it is already running
- `service sshd force-reload` - force reload service
