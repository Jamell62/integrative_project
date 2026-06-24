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

nasm -f elf64 src/targets/x86_64/boot.asm -o /tmp/boot.o # Assemble the bootloader initialization code into a 64-bit object file 

nasm -f elf64 src/targets/x86_64/long_mode_start.asm -o /tmp/long_mode.o # Assemble the code responsible for switching the CPU into 64-bit long mode 

gcc -m64 -ffreestanding -fno-stack-protector -mno-red-zone -c src/targets/x86_64/kernel.c -o /tmp/kernel.o # Compile the main kernel source code written in C 

ld -m elf_x86_64 -T src/targets/x86_64/linker.ld -o iso/boot/kernel.bin /tmp/boot.o /tmp/long_mode.o /tmp/kernel.o # Link all object files into a single kernel binary using the linker script 

grub-mkrescue -o kernel.iso iso # Generate a bootable ISO image containing the kernel and GRUB bootloader 

qemu-system-x86_64 -drive file=kernel.iso,media=cdrom -m 512M -no-reboot # Launch the generated ISO in the QEMU virtual machine emulator 

```

## File Structure

## What it does
- **Episode 1:** Multiboot2 header, boots and prints OK in QEMU

- **Episode 2:** Verifies CPUID/long mode, sets up paging, builds 64-bit GDT, jumps to long mode, prints custom message in C


## Requirements

- nasm # NASM assembler used to build assembly source files

- gcc # GCC compiler used to compile the kernel source code

- binutils (ld) # GNU Binutils linker required to generate the kernel binary

- grub-pc-bin, grub-common, xorriso # GRUB and ISO creation tools used to build bootable media

- qemu-system-x86 # QEMU emulator used to test and execute the kernel

´´´
## Evidence
<img width="758" height="482" alt="WhatsApp Image 2026-06-19 at 10 12 40 PM" src="https://github.com/user-attachments/assets/21efc753-80ac-46f6-a944-2fe9c514defd" />

<img width="725" height="485" alt="WhatsApp Image 2026-06-19 at 10 12 40 PM (1)" src="https://github.com/user-attachments/assets/5d31b95e-b62e-4ce5-a7ce-37f9fbe4ebd9" />
