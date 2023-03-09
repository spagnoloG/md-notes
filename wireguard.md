## Resources

- [setup wireguard on ubuntu 20.4](https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04)
- [vagrant advanced guide](https://fedoramagazine.org/vagrant-beyond-basics/)
- [WireGuard RFC](https://www.wireguard.com/papers/wireguard.pdf)
- [Wireguard docker compose](https://gitea.spanskiduh.dev/spanskiduh/wireguard-docker/src/branch/main/docker-compose.yml)
- [multiple ansible playbooks](https://stackoverflow.com/a/43183939)

### Steps

#### Steps on the server
- Generate privatekey: `wg genkey | sudo tee /etc/wireguard/private.key`.
- Change the ownership of the file so that the root will be the only one who can access it: `sudo chmod go= /etc/wireguard/private.key`.
-  Generate a publickey `sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key`
-  choose IP from reserved ranage
	- by the  RFC 1918 specification:
		- `10.0.0.0 to 10.255.255.255 (10/8 prefix)`
		- `172.16.0.0 to 172.31.255.255 (172.16/12 prefix)`
		- `192.168.0.0 to 192.168.255.255 (192.168/16 prefix)`
- We will choose the `10.6.0.0/24` range
- Write a config in `/etc/wireguard/wg0.conf`
```bash
[Interface]
PrivateKey = <privkey>
Address = 10.6.0.1/24
ListenPort = 51820
SaveConfig = true
```
- If we wanted to expose servers local network and not only the point to point connection:
	- `sudo sh -c "echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf"`
- Find your public interface:
	- `ip route list default`:
		- `default via 192.168.121.1 dev eth0 proto dhcp src 192.168.121.115 metric 100`
		-  We pick `eth0`.
- Now lets add the iptables rules to our `wg0.conf`.
```bash
PostUp = ufw route allow in on wg0 out on eth0
PostUp = iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
PreDown = ufw route delete allow in on wg0 out on eth0
PreDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
```
- Explanation:
	- `ufw route allow in on wg0 out on eth0 `- This rule will allow forwarding IPv4 and IPv6 traffic that comes in on the wg0 VPN interface to the eth0 network interface on the server. It works in conjunction with the net.ipv4.ip_forward and net.ipv6.conf.all.forwarding sysctl values that you configured in the previous section.
	- `iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE` - This rule configures masquerading, and rewrites IPv4 traffic that comes in on the wg0 VPN interface to make it appear like it originates directly from the WireGuard Server’s public IPv4 address.
	- `ip6tables -t nat -I POSTROUTING -o eth0 -j MASQUERADE` - (OPTIONAL) This rule configures masquerading, and rewrites IPv6 traffic that comes in on the wg0 VPN interface to make it appear like it originates directly from the WireGuard Server’s public IPv6 address.

- Lets also setup the ufw:
	- `sudo ufw allow 51820/udp`
	- `sudo ufw allow OpenSSH`
	- `sudo ufw reload`
	- `sudo ufw status`

- Now start the service:
 	-  `sudo systemctl enable --now wg-quick@wg0.service`

#### Steps on client
- What you need:
	- Basically you must generate the priv and pub key same as on the server
	- public IP of a server
	- server pubkey

- Now generate a file `/etc/wireguard/wg0.conf`
```bash
[Interface]
PrivateKey = <Generted privkey on client>
Address = 10.6.0.X/24

[Peer]
PublicKey = <server pubkey>
AllowedIPs = 10.6.0.0/24
Endpoint = <server public ip>:51820
```

- Now login to a server and register a client:
	- `sudo wg set wg0 peer <client-pubkey> allowed-ips <client-wg-ip>`
	- And check if the peer is listed with `sudo wg`


### DNS
If you are using the WireGuard Server as a VPN gateway for all your peer’s traffic, you will need to add a line to the `[Interface]` section that specifies DNS resolvers. If you do not add this setting, then your DNS requests may not be secured by the VPN, or they might be revealed to your Internet Service Provider or other third parties.

- To get a list which DNS reslovers the wireguard server uses (issue this command on a connected peer):
	-  `resolvectl dns eth0`
	-  then select one and add the ip to tthe bottom of the `[Interface]`  section `/etc/wireguard/wg0.conf`
```bash
[Interface]
...
DNS = <ip from command>
```
