# Writing Linux OS Kernel From Scratch

This repo will demonstrate how to write a simple Linux operating system kernel and emulate it on the target system: `x86_64-linux` and `aarch64-linux`.

Due to our target system is `arm` based, we will need compile the kernel on `x86` host system, but run the kernel on the `arm` target architecture.

## Resources

Articles:

- [crosstool-NG](https://crosstool-ng.github.io/)


## Prerequisites

- Cross-compilation toolchain for compiling the target linux OS kernel
- QEMU for emulating the operating system

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