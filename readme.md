### Dependencies

* binfmt-qemu-static
* qemu-user-static-bin

### Usage

* Install `binfmt-qemu-static` and reboot
* Update the variables at the top of `create-chroot.sh`
* Run `create-chroot.sh` with `sudo`
* Prepare build sources (`python-pigpio` for example here)
```sh
yaourt -G python-pigpio
```
* Manually set the dependencies (for now) and build the package
```sh
cd python-pigpio
../extra-armv6h-build.sh python
```
