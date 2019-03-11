pkgname=devtools-qemu
pkgver=7.c1609f2
pkgrel=1
pkgdesc='QEMU based cross-build tools for Archlinux package maintainers'
arch=('x86_64')
url='http://github.com/petronny/devtools-qemu'
license=('GPL')
depends=('binfmt-qemu-static' 'devtools-alarm' 'qemu-user-static-bin')
makedepends=('git')
source=('git://github.com/petronny/devtools-qemu.git')
sha256sums=('SKIP')

pkgver() {
  cd "$srcdir/$pkgname"
  echo "$(git rev-list --count master).$(git rev-parse --short master)"
}

build() {
  cd $srcdir/$pkgname

  cp /usr/bin/archbuild qemu_archbuild
  patch qemu_archbuild < qemu.patch
}

package() {
  mkdir -p $pkgdir/usr/bin

  cp $srcdir/qemu_archbuild $pkgdir/usr/bin
  cp $srcdir/mirrorlist $pkgdir/usr/share/devtools/qemu-mirrorlist

  for i in armv6h armv7h aarch64
  do
    cp $srcdir/pacman-extra-$i.conf $pkgdir/share/devtools/
    ln -sf /usr/bin/qemu_archbuild $pkgdir/usr/bin/extra-$i-build
  done
}
