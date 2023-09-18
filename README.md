# Writing Linux OS Kernel From Scratch

This repo will demonstrate how to write a simple Linux operating system kernel and emulate it on the target system: `x86_64-linux` and `aarch64-linux`.

Due to our target system is `arm` based, we will need compile the kernel on `x86` host system, but run the kernel on the `arm` target architecture.

## Resources

Articles:

- [crosstool-NG](https://crosstool-ng.github.io/)


## Prerequisites

- Cross-compilation toolchain for compiling the target linux OS kernel
- QEMU for emulating the operating system

[Documentation](https://crosstool-ng.github.io/docs/)

[GitHub - messense/homebrew-macos-cross-toolchains: macOS cross compiler toolchains](https://github.com/messense/homebrew-macos-cross-toolchains)

[Cross compiling made easy, using Clang and LLVM · mcilloni's blog](https://mcilloni.ovh/2021/02/09/cxx-cross-clang/)

[GitHub - tpoechtrager/osxcross: Mac OS X cross toolchain for Linux, FreeBSD, OpenBSD and Android (Termux)](https://github.com/tpoechtrager/osxcross)

others:

https://stackoverflow.com/questions/72253511/using-llvm-clang-as-a-cross-compiler

https://stackoverflow.com/questions/61771494/how-do-i-cross-compile-llvm-clang-for-aarch64-on-x64-host

https://github.com/crosstool-ng/crosstool-ng/issues/1337

## Prerequisites

qemu

## Getting started

## Setup

## Using crosstool-NG

We use [crosstool-NG](https://crosstool-ng.github.io/) to build the required cross-compilation toolchain.

[Optional] Assumes that the `crosstool-NG` has already been installed in the host system.

Windows/WSL:

```sh
ct-ng aarch64-unknown-linux-gnu
```

```sh
ct-ng build
```

```sh
export PATH="${PATH}:/opt/"
```


Test:

```sh
$CC test/c/hello.c -o hello_aarch64
```



## Using cross-compilation toolchain from Docker

### Install Docker container
### Cross-compilation toolchain

#### Using crosstool-NG

Build a cross-compilation toolchain through `crosstool-NG`,

Mac m1,

```sh
brew install crosstool-ng coreutils
```

Create case-sensitive filesystem,

```sh
export target=x86_64-unknown-linux-gnu
```

```sh
hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 16g -volname build build.dmg
hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 1g -volname tools tools.dmg
# Detach old if exists
hdiutil detach /Volumes/build -force | true
hdiutil detach /Volumes/tools -force | true
# Attach new
hdiutil attach build.dmg.sparseimage
hdiutil attach tools.dmg.sparseimage
ls /Volumes
```

Build Toolchain,

```sh
mkdir /Volumes/build/src
cd ./toolchains/${{target}}
# `ct-ng source` hint to download all sources(Optional)
ct-ng source
ct-ng build -j $(($(nproc) - 1))
```

Archive Toolchain,

```sh
cd /Volumes/tools
tar czf ${{target}}-aarch64-darwin.tar.gz ${{target}}
sha256sum ${{target}}-aarch64-darwin.tar.gz | tee ${{target}}-aarch64-darwin.tar.gz.sha256
```

#### Using Docker

```sh
docker run --rm dockcross/linux-x86_64-full > ./dockcross-linux-x86_64
chmod 755 ./dockcross-linux-x86_64
```

Test the development environment.

Enter the dev environment(Docker container),

```sh
./dockcross-linux-x86_64 bash
```

Inside the container,

```sh
$CC test/c/hello.c -o hello_x86_64
```

### Building

Enter the dev environment(Docker container),

```sh
./dockcross-linux-x86_64 bash
```

Build,

```sh
make build-x86_64
```

## Emulating

```sh
qemu-system-x86_64 -cdrom dist/x86_64/kernel.iso
```

Test emulating `arm64-ubuntu`,

```sh
wget http://cdimage.ubuntu.com/ubuntu/releases/20.04/release/ubuntu-20.04.5-live-server-arm64.iso -o ubuntu-20.04.5-live-server-arm64.iso 

mkdir ubuntu-base-20.04.3-base-arm64
tar -xpf ubuntu-base-20.04.3-base-arm64.tar.gz -C ubuntu-base-20.04.3-base-arm64
```

```sh
qemu-system-aarch64 -m 2048 -cpu cortex-a57 -smp 4 -M virt \
    -nographic \
    -device virtio-scsi \
    -device scsi-cd,drive=cd \
    -drive if=none,id=cd,file=ubuntu-20.04.5-live-server-arm64.iso
```