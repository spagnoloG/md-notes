# MPI


### Setup on fedora

```bash
sudo dnf install openmpi openmpi-devel
sudo dnf provides */mpicc # to list where binaries are stored
ln -s /usr/lib64/openmpi/bin/mpicc /usr/bin/mpicc # Create symbolic link to binary
```


