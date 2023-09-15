# Writing Linux OS Kernel From Scratch

## Prerequisites

## Getting started

WSL
MacOS
Linux

### Set up development environment

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

### Build

Enter the dev environment(Docker container),

```sh
./dockcross-linux-x86_64 bash
```

Build,

```sh
make build-x86_64
```

### Emulate