# LXC

### Installation
On debian install it using __snap__ it is the preferred way.

### Initialization:
Follow [this](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-lxd-on-ubuntu-20-04) tutorial to set up **lxd**.


### Launch and list containers:

```bash
	lxc launch ubuntu:22.04 testserver
	lxc list
```
to stop a container
```bash
	lxc stop
```

### Setup static ip for container:

```bash
	 lxc config device override testserver eth0
	 lxc config device set testserver eth0 ipv4.address <container-ip> 
```

### Start a shell inside a container:
```
	lxc shell testserver
```


### Exposing container to the public:
To bos naredu ti doma s svojim serverjem heehe (mas navodila step4 na zgornjem linku)


