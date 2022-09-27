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

### Setup static ip for container:

```bash
	 lxc config device override <container-name> eth0
	 lxc config device set <container-name> eth0 ipv4.address <container-ip> 
```

### Start a shell inside a container:
```
	lxc shell <container-name> 
```


### Exposing container to the public:
Todo, for now follow linked tutorial.
