
sudo mount /dev/sda4 /mnt/gentoo
sudo mount -t proc none /mnt/gentoo/proc
sudo mount -o bind /dev /mnt/gentoo/dev
sudo chroot /mnt/gentoo/ /bin/bash
