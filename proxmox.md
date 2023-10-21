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


### Containers

* Create a new container
```bash
pct create <ct_id> <template> -hostname <hostname> -password <password>
```

* List active containers
```bash
pct list
```

* Start / Stop / destroy containers 
```bash
pct stop <ct_id>
pct destroy <ct_id>
pct start <ct_id>
```

* Migrate Container to Another Proxmox Node:
```bash
pct migrate <ct_id> <target-node>
```

* Get the container shell :)
```bash
pct enter <ct_id>
```

* Backup / restore container
```bash
pct backup <ct_id> <backup_path>
pct restore <ct_id>  <backup_path>
```

* Snapshots
```bash
pct snapshot <ct_id> <snapshot-name>
pct rollback <ct_id> <snapshot-name>
pct delsnapshot <ct_id> <snapshot-name>
```


### Virtual Machines

* Create a new VM
```bash
qm create <vm_id> -name <name> -memory <memory_size> -net0 <network_options>
```

* List active VMs
```bash
qm list
```

* Start / Stop / Reset / Shutdown VMs
```bash
qm start <vm_id>
qm stop <vm_id>
qm reset <vm_id>
qm shutdown <vm_id>
```

* Clone a VM
```bash
qm clone <source_vm_id> <new_vm_id> --name <new_name>
```

* Migrate VM to Another Proxmox Node
```bash
qm migrate <vm_id> <target-node>
```

* Display VM Configuration
```bash
qm config <vm_id>
```

* Delete a VM
```bash
qm destroy <vm_id>
```

* Backup / Restore VM
```bash
qm backup <vm_id> <backup_storage> <backup_filename>
qmrestore <backup_path> <new_vm_id>
```

* Snapshots
```bash
qm snapshot <vm_id> <snapshot-name>
qm rollback <vm_id> <snapshot-name>
qm delsnapshot <vm_id> <snapshot-name>
```

* Resize Disk Size
```bash
qm resize <vm_id> <disk-name> <+size>
```

* Set Options for VM
```bash
qm set <vm_id> -option value
```

* Monitor and Manage VM Agent
```bash
qm agent <vm_id> <command>
```

* Send Key Event to VM
```bash
qm sendkey <vm_id> <key>
```
