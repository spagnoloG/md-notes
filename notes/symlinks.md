# Difference between hardlinks and symlinks

### Hardlinks

- implementation of `ln`
- kinda like shortcut, but a shortcut to a physical memory location!!!!

```c
/*
 * creates new file, that points to same memory location as provided file
 *  - if one of the files is edited, then both files change
 *  - if one of the files gets deleted, then just inode of that file, that points to that location is deleted
 *      other file stays undeleted, with same content
 */
int hardlink(char *dest, char *name) {
    if(link(dest, name) < 0)
       return errno;
    return 0;
}
```

### Softlinks

- implementation of `ln -s`
- it works like a shortcut to original file

```c
/*
 * creates a new file, that points to provided file
 *  - if one of the files is edited, then both files change
 *  - if original file gets deleted, then also disk contents gets deleted, and link is broken
 */
int softlink(char *dest, char *name) {
    if(symlink(dest, name) < 0)
        return errno;
    return 0;
}
```
