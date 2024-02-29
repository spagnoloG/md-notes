# UFW

### Connections

- `sudo ufw status numbered verbose` - check ufw status
- `sudo ufw default deny incoming` - deny incoming connections
- `sudo ufw default allow outgoing` - enable outgoing connections
- `sudo ufw allow ssh` - allow certian connection (you can also specify a port number instead of protocol!)
- `sudo ufw deny ssh` - deny certian connection
- `sudo ufw allow/deny proto tcp from any to any port 80,443` - deny / allow all 80 and 443 connections
- `sudo ufw allow from 192.168.1.103 to any port 22`- allow incomming ssh connections with specified ip.
- `sudo ufw allow from 192.168.1.1/24 to any port 22` - same thing, but now with specified subnet
- `sudo ufw delete <rule-id>` - delete rule from ufw, get id with status command
