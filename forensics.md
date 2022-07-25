# FORENSICS

### Sleuthkit
- [sleuthkit commands](http://wiki.sleuthkit.org/index.php?title=The_Sleuth_Kit_commands)
- always check the offset with `mmls` command
- `sudo mount -o loop,offset=9437184 disk_image.img /mnt/iso` ~ mount iso img with offset
- or option2 (better imho):
    - `udisksctl loop-setup --file disk.img` ~ this will create loop devices in `/dev/loopX`
    - then mount partitions as usual drive
    - to unomount, use flags `-f -l`


### Pdfgrep
- is another fancy tool to grep text in pdf files
