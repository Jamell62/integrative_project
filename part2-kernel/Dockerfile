FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    nasm \
    grub-pc-bin \
    grub-common \
    xorriso \
    binutils \
    make
WORKDIR /kernel
