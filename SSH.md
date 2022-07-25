---
tags: [linux]
title: SSH
created: '2021-11-25T00:11:55.575Z'
modified: '2021-12-09T21:54:30.814Z'
---

# SSH

### basic
- `/etc/ssh/ssh_config` - config location (client)
- `/etc/ssh/sshd_config` - config location (server)

It is *always* smart to disable root login!
--> uncomment `PermitRootLogin no`

### Enable encryption

- `ssh-keygen -t rsa` - generate private and public key
- `ssh-copy-id <server-ip>` - copy ssh identity to server

--> uncomment `PasswordAuthentication no` (on server)
**Warning** store private key on a secure location, if you lose it, you will lose connection to a server!

### FAIL2BAN
- use it to secure ssh
- install a basic ubuntu vm and watch from 4:20 in video he he u get it, but it is actually there

### SCP
- `scp <filename> <user@server_ip:/destination_folder>` - copy file to server
