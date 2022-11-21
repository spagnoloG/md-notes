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


### Netstat command // by default use ss


- `netstat -r` -- show routes
- `netstat -t` -- display all current tcp connections, useful with grep command
- `netstat -ltnp / -lu` list local TCP or UPD connections

#### [netstat](https://www.cyberciti.biz/faq/linux-ip-command-examples-usage-syntax/) is deprecated: 
|                   Old command (Deprecated)                  |                       New command                       |
|:-----------------------------------------------------------:|:-------------------------------------------------------:|
| ifconfig -a                                                 | ip a                                                    |
| ifconfig enp6s0 down                                        | ip link set enp6s0 down                                 |
| ifconfig enp6s0 up                                          | ip link set enp6s0 up                                   |
| ifconfig enp6s0 192.168.2.24                                | ip addr add 192.168.2.24/24 dev enp6s0                  |
| ifconfig enp6s0 netmask 255.255.255.0                       | ip addr add 192.168.1.1/24 dev enp6s0                   |
| ifconfig enp6s0 mtu 9000                                    | ip link set enp6s0 mtu 9000                             |
| ifconfig enp6s0:0 192.168.2.25                              | ip addr add 192.168.2.25/24 dev enp6s0                  |
| netstat                                                     | ss                                                      |
| netstat -tulpn                                              | ss -tulpn                                               |
| netstat -neopa                                              | ss -neopa                                               |
| netstat -g                                                  | ip maddr                                                |
| route                                                       | ip r                                                    |
| route add -net 192.168.2.0 netmask 255.255.255.0 dev enp6s0 | ip route add 192.168.2.0/24 dev enp6s0                  |
| route add default gw 192.168.2.254                          | ip route add default via 192.168.2.254                  |
| arp -a                                                      | ip neigh                                                |
| arp -v                                                      | ip -s neigh                                             |
| arp -s 192.168.2.33 1:2:3:4:5:6                             | ip neigh add 192.168.3.33 lladdr 1:2:3:4:5:6 dev enp6s0 |
| arp -i enp6s0 -d 192.168.2.254                              | ip neigh del 192.168.2.254 dev wlp7s0                   |

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

## Gobuster
Scan for subdomains

```bash
gobuster vhost -w /opt/useful/SecLists/Discovery/DNS/subdomains-top1million5000.txt -u http://thetoppers.htb
```
