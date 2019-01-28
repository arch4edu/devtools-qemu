#!/bin/sh
set -e
build_prefix=extra
arch=armv6h
build_path=/home/petron/devtools-qemu
pkgcache=$build_path/pkg
session=$USER
build_dir=$build_path/$build_prefix-$arch

# Updating [root]
sudo mount -o bind $pkgcache $build_dir/root/var/cache/pacman/pkg

cat << EOF | sudo arch-chroot $build_dir/root
uname -a
echo -e '\n\n' | pacman -Syu
exit
EOF

sudo umount $build_dir/root/var/cache/pacman/pkg

# Creating a copy of [root]
sudo rm -rf $build_dir/$session
sudo cp -r $build_dir/root $build_dir/$session

# Installing missing dependencies
sudo mount -o bind . $build_dir/$session/build
sudo mount -o bind $pkgcache $build_dir/$session/var/cache/pacman/pkg

cat << EOF | sudo arch-chroot $build_dir/$session
uname -a
yes | pacman -S $@
exit
EOF

sudo umount $build_dir/$session/build
sudo umount $build_dir/$session/var/cache/pacman/pkg

# makepkg
makechrootpkg -r $build_dir
