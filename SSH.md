# SSH

### basic
- `/etc/ssh/ssh_config` - config location (client)
- `/etc/ssh/sshd_config` - config location (server)

### Enable encryption

- `ssh-keygen -t rsa` - generate private and public key
- `ssh-copy-id <server-ip>` - copy ssh identity to server

--> uncomment `PasswordAuthentication no` (on server)
**Warning** store private key on a secure location, if you lose it, you will lose connection to a server!

### SSH ECDSA (smaller keys)

#### Generate keypair

```bash
ssh-keygen -t ed25519 -f ~/.ssh/keys/id_ed25519_devel_server
```
### Copy to remote

```bash
ssh-copy-id -i ~/.ssh/keys/id_ed25520_devel_server devel@devel.hsrv
```

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

### Jump host
```bash
ssh -J jumphost_user@jumphost.example.com target_user@target_host
```
or directly in ssh config
```bash
Host jumphost
  HostName jumphost.example.com
  User jumphost_user
  IdentityFile /path/to/jumphost_key

Host target_host
  HostName target_host.example.com
  User target_user
  IdentityFile /path/to/target_key
  ProxyJump jumphost
```

### How to joke around with medic

```bash
oli@bert:~$ ssh tim
oli@tim:~$ export DISPLAY=:0
oli@tim:~$ firefox
```

### Reverse SSH tunnel
If you want some port that is behind the firewall, but exposed on the server.
You can spawn a reverse ssh tunnel to that port issuing this command:

```bash
ssh -L 8888:localhost:8888 -f -N hsrv_devel
```

or: `ssh -L [LOCAL_IP:]LOCAL_PORT:DESTINATION:DESTINATION_PORT [USER@]SSH_SERVER`

read [here](https://linuxize.com/post/how-to-setup-ssh-tunneling/) more.

or forcily:

```bash
ssh -L 8888:localhost:8888 -f -N hsrv_devel -o ClearAllForwardings=yes
```
