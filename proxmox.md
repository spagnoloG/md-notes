# PROXMOX


## Virtual machine does not have nested virtualization enabled?
ssh into host proxmox and execute
```bash
root@spanskiduh:~#  qm set <vm_id> --cpu host
```
Next go to web interface and shut down the machine (just reboot won't work).
