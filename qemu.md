# Qemu

### Emulating raspberry pi 4

- firstly generate two images
`qemu-img create -f qcow2 arm.img 16G` ~ Image for os
`qemu-img create -f qcow2 varstore.img 64M` ~ EFI varaible store
- then download EFI file (A UEFI image for QEMU’s virt machine type, I use an EDK II derived snapshot image from Linaro)
`http://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/latest/QEMU-AARCH64/RELEASE_GCC5/QEMU_EFI.img.gz`

- install
`qemu-system-aarch64 \                                                    
    -cpu cortex-a72 -smp 4 -M virt -m 4096 -nographic \
    -drive if=pflash,format=raw,file=QEMU_EFI.img \
    -drive if=pflash,file=varstore.img \
    -drive if=virtio,file=arm.img\
    -drive if=virtio, format=raw, file=file.iso`
- run
`qemu-system-aarch64 \                                                    
    -cpu cortex-a72 -smp 4 -M virt -m 4096 -nographic \
    -drive if=pflash,format=raw,file=QEMU_EFI.img \
    -drive if=pflash,file=varstore.img \
    -drive if=virtio,file=arm.img\`
