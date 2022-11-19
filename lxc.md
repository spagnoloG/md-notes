# LXC

### Installation
On debian install it using __snap__ it is the preferred way.

### Initialization:
Follow [this](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-lxd-on-ubuntu-20-04) tutorial to set up **lxd**.


### Launch and list containers:

```bash
	lxc launch ubuntu:22.04 <container-name>
	lxc list
```
to stop a container:
```bash
	lxc stop <container-name>
```
to delete a container:
```bash
	lxc delete <container-name>
```

### Setup static ip for container:

```bash
	 lxc config device override <container-name> eth0
	 lxc config device set <container-name> eth0 ipv4.address <container-ip> 
```

### Start a shell inside a container:
```
	lxc shell <container-name> 
```

### List available images:
```
lxc image alias list images:
lxc image alias list images: | grep -i arch
lxc image alias list images: | grep -i debian
lxc image alias list images: | grep -i fedora
```

### Exposing container to the public:
Todo, for now follow linked tutorial. Host it on your own.

### Running Docker inside lxc:
Firstly you need to create storage device:

```bash
	lxc sorage create <volume-name> btrfs
	lxc launch images:ubuntu/22.04 <container-name>	
```
Then add this storage device to container:
```bash
	lxc config device add <container-name> docker disk pool=<volume-name> source=<container-name> path=/var/lib/docker
```
Then set privileges for docker to have ability to call syscalls.
```bash
	lxc config set <container-name> security.nesting=true security.syscalls.intercept.mknod=true security.syscalls.intercept.setxattr=true
	lxc restart <container-name>
```

or read [this](https://ubuntu.com/tutorials/how-to-run-docker-inside-lxd-containers#2-create-lxd-container) tutorial.


## Troubleshooting

### No ipv4 in container??

```bash
for ipt in iptables iptables-legacy ip6tables ip6tables-legacy; do $ipt --flush; $ipt --flush -t nat; $ipt --delete-chain; $ipt --delete-chain -t nat; $ipt -P FORWARD ACCEPT; $ipt -P INPUT ACCEPT; $ipt -P OUTPUT ACCEPT; done
systemctl restart --now snap.lxd.daemon 
```
read [this](https://discuss.linuxcontainers.org/t/containers-do-not-have-outgoing-internet-access/10844/4) article.

