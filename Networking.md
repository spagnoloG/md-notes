---
tags: [linux]
title: Networking
created: '2021-11-08T22:28:05.169Z'
modified: '2021-12-09T21:20:59.016Z'
---

# Networking

### IP command

- `ip route show` -- display all routes `man ip | grep route` -- neat way to find more information about this command
- `ip a` -- display all interfaces


### Netstat command


- `netstat -r` -- show routes
- `netstat -t` -- display all current tcp connections, useful with grep command
- `netstat -ltnp / -lu` list local TCP or UPD connections

If u dont wont get cought use` tor + proxychains`

### Proxychains
- `systemctl start tor`
- [setup](https://medium.com/cyberxerx/how-to-setup-proxychains-in-kali-linux-by-terminal-618e2039b663)

### Nmap
- [cheat-sheet](https://hackertarget.com/nmap-cheatsheet-a-quick-reference-guide/)

### Sslscan
Queries SSL/TLS services (such as HTTPS) and reports the protocol versions, cipher suites, key exchanges, signature algorithms, and certificates in use.  This helps the user understand which parameters are weak from a security standpoint.

### Whois
Find information about domain name `whois spanskiduh.xyz`
