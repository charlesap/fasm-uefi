# fasm-uefi
bare-bones fasm uefi application

build with:
* fasm ok.asm
* sudo mount uefi.iso /mnt
* sudo cp yo.efi /mnt/EFI/BOOT/BOOTX64.EFI
* sudo umount /mnt

Launch QEMU with:

* /usr/bin/qemu-system-x86_64 -machine accel=kvm -name guest=uefiguest -machine pc,accel=kvm,usb=off,dump-guest-core=off  -smp 2,sockets=2,cores=1,threads=1 -uuid 515645b7-ab3a-4e82-ba62-25751e4b523f -bios ./OVMF.fd -m 2G  -vga qxl -spice port=5900,addr=127.0.0.1,disable-ticketing -drive file=uefi.iso 

Launch the Spice viewer with:
* remote-viewer spice://localhost:5900

Output should appear in the Spice viewer.




