# VFS

## Superblock

Representation of mounted filesystem.
properties: - device, where the fs is located - fs type - block size - flags - root inode pointer (!) - low level operations on the filesystem

## Inode

File of any type. Represents everything, except the filename!
properties: - includes pointers to blocks with data!!! - owner, group, perms info - inode number, file size. - date & time of most recent access

## Dentry

It maps file names to to inodes
properties: - filename - inode pointer that represents file - pointer to parent dirent - counter of usages
