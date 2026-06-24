# Part 2 - 64-bit Kernel

## Description
A minimal 64-bit operating system kernel built from scratch using NASM, GCC, and GRUB.

## File Structure
```text
part2-kernel/
├── Dockerfile                  # Isolated cross-compilation environment
├── Makefile                    # Automation script for building and emulating the system
├── README.md                   # Project documentation
├── kernel.iso                  # Final bootable disk image generated after build
├── iso/                        # Boot directory structure for GRUB media generation
│   └── boot/
│       └── grub/
│           └── grub.cfg        # GRUB bootloader configuration file
└── src/                        # Kernel source code directory
    └── targets/
        └── x86_64/
            ├── header.asm      # Mandatory Multiboot2 header specification
            ├── boot.asm        # 32-bit initialization, CPU verification, and paging
            ├── main.asm        # Episode 1 test entry point (Direct VGA print)
            ├── long_mode_start.asm # Register configuration and 64-bit jump
            ├── linker.ld       # Linker script mapping hardware RAM addresses
            └── kernel.c        # Main C kernel code managing the VGA screen buffer.

## Build Instructions
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
