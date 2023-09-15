FROM randomdude/gcc-cross-x86_64-elf:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y nasm xorriso grub-pc-bin grub-common && \
    apt-get clean

VOLUME /root/env
WORKDIR /root/env