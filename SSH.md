# SSH

### basic
- `/etc/ssh/ssh_config` - config location (client)
- `/etc/ssh/sshd_config` - config location (server)

### Enable encryption

- `ssh-keygen -t rsa` - generate private and public key
- `ssh-copy-id <server-ip>` - copy ssh identity to server

--> uncomment `PasswordAuthentication no` (on server)
**Warning** store private key on a secure location, if you lose it, you will lose connection to a server!

### FAIL2BAN
- use it to secure ssh

### SCP
- `scp <filename> <user@server_ip:/destination_folder>` - copy file to server, same goes for rsync

### SSH CONFIG FILE

example for github:
```bash
Host github.com
  User git
  Hostname github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_ed25519
```

exmaple for any server:
```bash
Host vpn.de 
  HostName vpn.de 
  IdentityFile ~/.ssh/keys/vpn_de
  Port 22
  User root
```

*note*:  You should put your server's ip in `/etc/hosts/` for easier migrations.

### How to joke around with medic

```bash
oli@bert:~$ ssh tim
oli@tim:~$ export DISPLAY=:0
oli@tim:~$ firefox
```
