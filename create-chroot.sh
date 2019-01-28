#!/bin/sh
set -e
build_prefix=extra
arch=armv6h
build_path=/home/petron/devtools-qemu
pkgcache=$build_path/pkg
mirror_name=ArchLinuxARM-rpi-latest.tar.gz
mirror_url=https://mirrors.tuna.tsinghua.edu.cn/archlinuxarm/os/$mirror_name

build_dir=$build_path/$build_prefix-$arch

rm -rf $build_dir/root
mkdir -p $build_dir/root
[ ! -f /tmp/$mirror_name ] && wget $mirror_url -O /tmp/$mirror_name
bsdtar -xpf /tmp/$mirror_name -C $build_dir/root

cd $build_dir/root

# Install binfmt-qemu-static and reboot
# qemu-user-static-bin
cp $(which qemu-arm-static) usr/bin/

# Configurations
echo 'Server = http://mirrors.tuna.tsinghua.edu.cn/archlinuxarm/$arch/$repo' > etc/pacman.d/mirrorlist
sed 's/^CheckSpace/#CheckSpace/' -i etc/pacman.conf

mount -o bind $pkgcache var/cache/pacman/pkg

cat << EOF | arch-chroot . usr/bin/bash
uname -a
pacman-key --init
echo -e '\nn' | pacman -Sw archlinuxarm-keyring
yes | pacman -U \$(ls /var/cache/pacman/pkg/archlinuxarm-keyring-*)
echo -e '\n\n' | pacman -Sy base base-devel
mkdir /build
#ln -s /usr/bin/archbuild /usr/bin/extra-$arch-build
#cp /etc/pacman.conf /usr/share/devtools/pacman-extra.conf
#echo 'MAKEFLAGS="-j32"' >> /etc/makepkg.conf
#echo 'COMPRESSXZ=(xz -T0 -c -z -)' >> /etc/makepkg.conf
#cp /etc/makepkg.conf /usr/share/devtools/makepkg-armv6h.conf
mkdir -p /etc/sudoers.d
echo v4 > /.arch-chroot
EOF

umount var/cache/pacman/pkg
