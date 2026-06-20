# Integrative Project 

## Description
Build, Boot and Attack — a full Linux stack project covering custom distro, 64-bit kernel, and offensive security lab.

## Group Members
- Paula (Part 1 - Custom Distro)
- Odalis (Part 2 - 64-bit Kernel)
- Joselyn (Part 3 - Black Hat Bash Lab)

## Project Structure
- `part1-distro/` - Custom Linux distribution built with Cubic
- `part2-kernel/` - 64-bit kernel built from scratch
- `part3-lab/` - Black Hat Bash offensive security lab

## How to reproduce

### Part 2 - Kernel
```bash
cd part2-kernel
nasm -f elf64 src/targets/x86_64/boot.asm -o /tmp/boot.o
nasm -f elf64 src/targets/x86_64/long_mode_start.asm -o /tmp/long_mode.o
gcc -m64 -ffreestanding -fno-stack-protector -mno-red-zone -c src/targets/x86_64/kernel.c -o /tmp/kernel.o
ld -m elf_x86_64 -T src/targets/x86_64/linker.ld -o iso/boot/kernel.bin /tmp/boot.o /tmp/long_mode.o /tmp/kernel.o
grub-mkrescue -o kernel.iso iso
qemu-system-x86_64 -drive file=kernel.iso,media=cdrom -m 512M -no-reboot
```

## Professor
Ing. Jonathan Tito 
