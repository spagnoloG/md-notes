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
| ifconfig enp7s0:0 192.168.2.25                              | ip addr add 192.168.2.25/24 dev enp6s0                  |
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

### Manipulate interfaces 

```bash
# Set bridged network interface down and remove it
sudo ip link set br-24cd8c4a8185 down
sudo ip link delete br-24cd8c4a8185 type bridge
```

### Reset dns records in chrome / brave

```text
chrome://net-internals/#dns -> Clear host cache
chrome://net-internals/#sockets -> flush socket pools
```


### Nmcli

List all available netowrks:
```bash
nmcli device wifi list
```

List all  active connections:

```bash
nmcli con show --active
```


## Bettercap
What is it?
from website: The Swiss Army knife for WiFi, Bluetooth Low Energy, wireless HID hijacking and IPv4 and IPv6 networks reconnaissance and MITM attacks.


### Setup monitoring mode on wireless card

Identify card using tool `iwconfig` and then set it to monitor mode (using `airmon-ng`):

```bash
sudo airmon-ng start <your_interface>
```

Then to stop monitoring issue:

```bash
sudo airmon-ng stop <monitor_interface>
sudo systemctl restart NetworkManager # or sudo service network-manager restart
```

### Start bettercap

```bash
sudo bettercap -iface <monitor_interface>
```

Keep deauthing clients from the access point with `BSSID DE:AD:BE:EF:DE:AD` every five seconds:

```bash
> set ticker.period 5; set ticker.commands "wifi.deauth DE:AD:BE:EF:DE:AD"; ticker on
```

[Read more](https://www.bettercap.org/modules/wifi/) about wifi module. For bluetooth and others also refer to docs ;).
[Bluetooth low energy](https://www.bettercap.org/modules/ble/)


### Deauth attack

```bash
sudo bettercap -iface <monitor_interface>
```

```bash
> wifi.recon on
> wifi.show
> wifi.deauth DE:AD:BE:EF:DE:AD # to deauth specific AP
> wifi.deauth  ff:ff:ff:ff:ff:ff # to deauth all APs
```

captured handshakes are stored in `~/bettercap-wifi-handshakes.pcap`


## Network usage

nload (nice graphs in terminal)

```bash
nload -i <interface>
```

or 
```
ss -i
```
