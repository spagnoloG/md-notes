# Disk utils 

## Use dd
It should work
`dd if=/dev/old of=/dev/new bs=64K conv=noerror,sync`

## Resize drive

### ext4
`resize2fs /dev/sdb 100G` -> resized my partition on hetzner from 50G to 100G ez



### Best page to check if you land here:
[red_hat](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/storage_administration_guide/part-file-systems)
