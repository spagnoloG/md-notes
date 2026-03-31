# Libvirt


## Setup on ubuntu server

Check if your pc supports virtualization (it probably does:))
```bash
lscpu | grep -E 'vmx|svm'
```

Install it
```bash
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
```

Enable and start libvirtd:

```bash
sudo systemctl enable --now libvirtd
```

Check if default network is already started, if not start it:

```bash
sudo virsh net-list --all
sudo virsh net-start default # Run only if not started !!!
sudo virsh net-autostart default
```
Now you are mostly ready to go.

## General VM commands

Check for IP address of a VM and ssh to it:

```bash
sudo virsh net-dhcp-leases default
ssh <vm-user>@<vm-ip>
```

Destroy the VM when you are done:

```bash
sudo virsh destroy <vm-name> 2>/dev/null || true
sudo virsh undefine <vm-name> --nvram 2>/dev/null || true
sudo rm -f /var/lib/libvirt/images/<vm-disk>.qcow2
```

List existing VMs:

```bash
sudo virsh list --all
```

Start a VM:

```bash
sudo virsh start <vm-name>
```


## Creating a new Ubuntu virtual machine

Lets create a ubuntu 22.04 server VM

```bash
sudo mkdir -p  /var/lib/libvirt/images/
cd /var/lib/libvirt/images/; sudo wget https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso; cd -
sudo chmod 644 /var/lib/libvirt/images/ubuntu-22.04.5-live-server-amd64.iso
```

Install cloud image tools:

```bash
 sudo apt install -y cloud-image-utils
```

Create cloud temp image directory:

```bash
mkdir -p ~/vmseed/ubuntu-server
cd ~/vmseed/ubuntu-server
```

Generate password hash for cloud image and store the hash:

```bash
openssl passwd -6
```

Create the `user-data` file with the following content (replace the password hash with the one you generated):

```yaml
#cloud-config
autoinstall:
  version: 1

  locale: en_US.UTF-8
  keyboard:
    layout: us

  identity:
    hostname: ubuntu-server
    username: ubuntu 
    password: "$6$PUT_YOUR_HASH_HERE"

  ssh:
    install-server: true
    allow-pw: true
    #authorized-keys:
    #  - ssh-ed25519 AAAA... only if you want also ssh key auth

  storage:
    layout:
      name: direct

  packages:
    - qemu-guest-agent

  late-commands:
    - curtin in-target -- systemctl enable ssh
    - curtin in-target -- systemctl enable qemu-guest-agent
```

Create the `meta-data` file with the following content:

```yaml
instance-id: ubuntu-server-01
local-hostname: ubuntu-server
```

Build seed iso with cloud image tools and then copy it to `/var/lib/libvirt/images/`:

```bash
cloud-localds -f iso seed.iso user-data meta-data
sudo cp ~/vmseed/ubuntu-server/seed.iso /var/lib/libvirt/images/seed-ubuntu-server-22.iso
```

Then lets creat a disk(sparse, thin client) for our VM

```bash
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/ubuntu-server-22.qcow2 30G
```
(if for some reason you wanted a full raw disk, then there exists `-o preallocation=full` flag)

Now mount the iso locally:

```bash
sudo mkdir -p /mnt/ubuntu-server-22
sudo mount -o loop ~/Documents/isos/ubuntu-22.04.5-live-server-amd64.iso /mnt/ubuntu-server-22
```

And now create VM with preffered settings:

```bash
sudo virt-install \
  --name ubuntu-server-22 \
  --memory 4096 \
  --vcpus 6 \
  --cpu host \
  --osinfo ubuntu22.04 \
  --disk path=/var/lib/libvirt/images/ubuntu-server-22.qcow2,format=qcow2,bus=virtio \
  --disk path=/var/lib/libvirt/images/seed-ubuntu-server-22.iso,device=cdrom,readonly=on \
  --disk path=/var/lib/libvirt/images/ubuntu-22.04.5-live-server-amd64.iso,device=cdrom,readonly=on \
  --network network=default,model=virtio \
  --graphics none \
  --console pty,target_type=serial \
  --location /mnt/ubuntu-server-22,kernel=casper/vmlinuz,initrd=casper/initrd \
  --extra-args "autoinstall console=ttyS0,115200n8 serial" \
  --noautoconsole \
  --wait=-1
```

## Creating a new Debian virtual machine

Same process as with ubuntu,
but this time we will use [their cloud image](https://wiki.debian.org/Xen/InstallDebianGuestFromCloudImages).

```bash
sudo mkdir -p  /var/lib/libvirt/images/
cd /var/lib/libvirt/images/;  sudo wget sudo wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2 -O debian-12-generic-amd64.qcow2; cd -
sudo chmod 644 /var/lib/libvirt/images/debian-12-generic-amd64.qcow2
```

Resize the qcow2 image to desired size (default is 10G):
```bash
sudo qemu-img resize /var/lib/libvirt/images/debian-12-generic-amd64.qcow2 30G
```

Create temp cloud image directory:

```bash
mkdir -p ~/vmseed/debian-server
cd ~/vmseed/debian-server
```

Generate password hash:

```bash
openssl passwd -6
```

Create the `user-data` file with the following content (replace the password hash with the one you generated):

```yaml
#cloud-config
hostname: debian-server
fqdn: debian-server.local

users:
  - name: debian
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    shell: /bin/bash
    lock_passwd: false
    passwd: "$6$PUT_YOUR_HASH_HERE"

ssh_pwauth: true

package_update: true
packages:
  - qemu-guest-agent

runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
```

Create the `meta-data` file with the following content:

```yaml
instance-id: debian-server-01
local-hostname: debian-server
```

Build seed iso with cloud image tools and then copy it to `/var/lib/libvirt/images/`:

```bash
cloud-localds -f iso seed.iso user-data meta-data
sudo cp ~/vmseed/debian-server/seed.iso /var/lib/libvirt/images/seed-debian-12.iso
sudo chmod 644 /var/lib/libvirt/images/seed-debian-12.iso
```

Now create the VM with preffered settings:

```bash
sudo virt-install \
  --name debian-server-12 \
  --memory 4096 \
  --vcpus 6 \
  --cpu host \
  --osinfo detect=on,name=debian12 \
  --import \
  --disk path=/var/lib/libvirt/images/debian-12-generic-amd64.qcow2,format=qcow2,bus=virtio \
  --disk path=/var/lib/libvirt/images/seed-debian-12.iso,device=cdrom,readonly=on \
  --network network=default,model=virtio \
  --graphics none \
  --console pty,target_type=serial \
  --boot hd,useserial=on \
  --noautoconsole
```

## Creating a new Alma Linux virtual machine

Similar as other os-es, just has the diffrent cloud init.
Check for [newer images](https://wiki.almalinux.org/cloud/Generic-cloud.html).

```bash
sudo mkdir -p /var/lib/libvirt/images
cd /var/lib/libvirt/images
sudo wget https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2 -O almalinux-9-genericcloud.qcow2
sudo chmod 644 almalinux-9-genericcloud.qcow2
sudo qemu-img create -f qcow2 -F qcow2 \
  -b /var/lib/libvirt/images/almalinux-9-genericcloud.qcow2 \
  /var/lib/libvirt/images/almalinux-server.qcow2 30G
sudo chmod 644 /var/lib/libvirt/images/almalinux-server.qcow2
mkdir -p ~/vmseed/almalinux-server
cd ~/vmseed/almalinux-server
openssl passwd -6
```

`usar-data` file:


```yaml
#cloud-config
ssh_pwauth: true
password: "$6$PUT_YOUR_HASH_HERE"
chpasswd:
  expire: false

hostname: almalinux-server

packages:
  - qemu-guest-agent

runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
```

.. defult username is `almalinux`.

`meta-data` file:

```yaml
instance-id: almalinux-server-01
local-hostname: almalinux-server
```

and then install it:

```bash
sudo virt-install \
  --connect qemu:///system \
  --name almalinux-server \
  --memory 4096 \
  --vcpus 6 \
  --cpu host-passthrough \
  --machine q35 \
  --import \
  --osinfo name=almalinux9 \
  --disk path=/var/lib/libvirt/images/almalinux-server.qcow2,format=qcow2,bus=virtio \
  --network network=default,model=virtio \
  --graphics none \
  --cloud-init user-data=$HOME/vmseed/almalinux-server/user-data,meta-data=$HOME/vmseed/almalinux-server/meta-data \
  --noautoconsole
```


## Creating a new Alpine virtual machine

Again a bit different, here is [source](https://alpinelinux.org/cloud/).

```bash
sudo mkdir -p /var/lib/libvirt/images
cd /var/lib/libvirt/images
sudo wget https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/cloud/generic_alpine-3.23.3-x86_64-bios-cloudinit-r0.qcow2 \
  -O alpine-3.23.3-cloudinit.qcow2
sudo chmod 644 /var/lib/libvirt/images/alpine-3.23.3-cloudinit.qcow2
sudo qemu-img create -f qcow2 -F qcow2 \
  -b /var/lib/libvirt/images/alpine-3.23.3-cloudinit.qcow2 \
  /var/lib/libvirt/images/alpine-server.qcow2 20G
sudo chmod 644 /var/lib/libvirt/images/alpine-server.qcow2
```

A bit different cloud file:


```bash
mkdir -p ~/vmseed/alpine-server
cd ~/vmseed/alpine-server
```

`user-data` file:

```yaml
#cloud-config
hostname: alpine-server
ssh_pwauth: true
chpasswd:
  list: |
    alpine:PASS
  expire: false


packages:
  - qemu-guest-agent
  - openssh
  - sudo

runcmd:
  - rc-update add qemu-guest-agent default
  - rc-service qemu-guest-agent start || true
  - rc-update add sshd default
  - rc-service sshd start || true
  - echo "cloud-init finished" > /root/cloud-init.done
```

`meta-data` file:

```yaml
instance-id: alpine-server-01
local-hostname: alpine-server
```

And then install like:

```bash
sudo virt-install \
  --connect qemu:///system \
  --name alpine-server \
  --memory 2048 \
  --vcpus 2 \
  --cpu host-passthrough \
  --import \
  --disk path=/var/lib/libvirt/images/alpine-server.qcow2,format=qcow2,bus=virtio \
  --network network=default,model=virtio \
  --graphics none \
  --cloud-init user-data=$HOME/vmseed/alpine-server/user-data,meta-data=$HOME/vmseed/alpine-server/meta-data \
  --noautoconsole \
  --osinfo detect=on,require=off
```

## Creating a new CentOS virtual machine

Same procedure as for all above, just now from another [source](https://www.centos.org/download/)

Again download and setup the files:

```bash
sudo mkdir -p /var/lib/libvirt/images
cd /var/lib/libvirt/images
sudo wget https://cloud.centos.org/centos/10-stream/x86_64/images/CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2 \
  -O centos-stream-10-genericcloud.qcow2
sudo chmod 644 /var/lib/libvirt/images/centos-stream-10-genericcloud.qcow2
sudo qemu-img create -f qcow2 -F qcow2 \
  -b /var/lib/libvirt/images/centos-stream-10-genericcloud.qcow2 \
  /var/lib/libvirt/images/centos-server.qcow2 30G
sudo chmod 644 /var/lib/libvirt/images/centos-server.qcow2
mkdir -p ~/vmseed/centos-server
cd ~/vmseed/centos-server
openssl passwd -6
```

`user-data` file:

```yaml
#cloud-config
hostname: centos-server

users:
  - name: centos
    lock_passwd: false
    passwd: "$6$PUT_YOUR_HASH_HERE"
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel
    shell: /bin/bash

ssh_pwauth: true

packages:
  - qemu-guest-agent

runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - echo "cloud-init finished" > /root/cloud-init.done
```

`meta-data` file:

```yaml
instance-id: centos-server-01
local-hostname: centos-server
```

And the vm cration:

```bash
sudo virt-install \
  --connect qemu:///system \
  --name centos-server \
  --memory 4096 \
  --vcpus 6 \
  --cpu host-passthrough \
  --machine q35 \
  --import \
  --osinfo detect=on,name=centos-stream10 \
  --disk path=/var/lib/libvirt/images/centos-server.qcow2,format=qcow2,bus=virtio \
  --network network=default,model=virtio \
  --graphics none \
  --cloud-init user-data=$HOME/vmseed/centos-server/user-data,meta-data=$HOME/vmseed/centos-server/meta-data \
  --noautoconsole
```


## Creating a new RockyLinux virtual machine

Again download source from [official site](https://dl.rockylinux.org/pub/rocky/9/images/x86_64)

```bash
sudo mkdir -p /var/lib/libvirt/images
cd /var/lib/libvirt/images
sudo wget https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2 \
  -O rocky-9-genericcloud.qcow2
sudo chmod 644 /var/lib/libvirt/images/rocky-9-genericcloud.qcow2
sudo qemu-img create -f qcow2 -F qcow2 \
  -b /var/lib/libvirt/images/rocky-9-genericcloud.qcow2 \
  /var/lib/libvirt/images/rocky-server.qcow2 30G
sudo chmod 644 /var/lib/libvirt/images/rocky-server.qcow2
mkdir -p ~/vmseed/rocky-server
cd ~/vmseed/rocky-server
openssl passwd -6
```
Create seed files:

`user-data`:

```yaml
#cloud-config
hostname: rocky-server

users:
  - name: rocky
    plain_text_passwd: "YOURPASS"
    lock_passwd: false
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel
    shell: /bin/bash

ssh_pwauth: true

runcmd:
  - [ sh, -c, "echo cloud-init-worked > /root/cloud-init.done" ]
```

`meta-data`:

```yaml
instance-id: rocky-server-01
local-hostname: rocky-server
```


Generate iso image:

```bash
cd ~/vmseed/rocky-server
genisoimage -output seed.iso -volid cidata -joliet -rock user-data meta-data
sudo cp ~/vmseed/rocky-server/seed.iso /var/lib/libvirt/images/rocky-server-seed.iso
sudo chmod 644 /var/lib/libvirt/images/rocky-server-seed.iso
```

And then install it:

```bash
sudo virt-install \
  --connect qemu:///system \
  --name rocky-server \
  --memory 4096 \
  --vcpus 6 \
  --cpu host-passthrough \
  --machine q35 \
  --import \
  --os-variant rocky9 \
  --disk path=/var/lib/libvirt/images/rocky-server.qcow2,format=qcow2,bus=virtio \
  --disk path=/var/lib/libvirt/images/rocky-server-seed.iso,device=cdrom \
  --network network=default,model=virtio \
  --graphics vnc \
  --noautoconsole
```
