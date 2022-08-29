# Disk Clone


## Use dd
It should work
`dd if=/dev/old of=/dev/new bs=64K conv=noerror,sync`
