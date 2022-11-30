# PROXMOX


## Virtual machine does not have nested virtualization enabled?
ssh into host proxmox and execute
```bash
root@spanskiduh:~#  qm set <vm_id> --cpu host
```
Next go to web interface and shut down the machine (just reboot won't work).


### Add data disk to vm

Firstly locate your partition using: 

```bash
ls -n /dev/disk/by-id
```

Then add it to vm using:

```bash
 /sbin/qm set <vm-id> -virtio2 /dev/disk/by-id/<disk-uuid>
 /sbin/qm set 102 -virtio2 /dev/disk/by-id/ata-WDC_WD10EARS-003BB1_WD-WCAV5L270787-part1
```
