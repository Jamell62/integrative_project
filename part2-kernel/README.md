# Part 2 - 64-bit Kernel

## Description
A minimal 64-bit operating system kernel built from scratch using NASM, GCC, and GRUB.

## Build Instructions
```bash
# Compile and generate ISO
nasm -f elf64 src/targets/x86_64/boot.asm -o /tmp/boot.o
nasm -f elf64 src/targets/x86_64/long_mode_start.asm -o /tmp/long_mode.o
gcc -m64 -ffreestanding -fno-stack-protector -mno-red-zone -c src/targets/x86_64/kernel.c -o /tmp/kernel.o
ld -m elf_x86_64 -T src/targets/x86_64/linker.ld -o iso/boot/kernel.bin /tmp/boot.o /tmp/long_mode.o /tmp/kernel.o
grub-mkrescue -o kernel.iso iso

# Run in QEMU
qemu-system-x86_64 -drive file=kernel.iso,media=cdrom -m 512M -no-reboot
```

## File Structure

## What it does
- **Episode 1:** Multiboot2 header, boots and prints OK in QEMU
- **Episode 2:** Verifies CPUID/long mode, sets up paging, builds 64-bit GDT, jumps to long mode, prints custom message in C


## Requirements
- nasm
- gcc
- binutils (ld)
- grub-pc-bin, grub-common, xorriso
- qemu-system-x86
