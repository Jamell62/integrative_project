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

## Evidence
#Refresh the package list to get the newest versions available
sudo apt update

#Install Docker Engine components to allow containerized builds if needed
sudo apt install -y docker-ce docker-ce-cli containerd.io

#Add your user to the docker group so you can execute docker commands without 'sudo'
sudo usermod -aG docker $USER

#Instantly activate the docker group permission changes for your current terminal session
newgrp docker

#Print the Docker version to confirm successful installation
docker --version
<img width="771" height="141" alt="WhatsApp Image 2026-06-24 at 4 49 38 PM" src="https://github.com/user-attachments/assets/27206487-51a9-43aa-ba3d-5d707889e685" />

#Install primary tools: Git version control, x86 architecture QEMU emulator, GNU Make, and Nano editor
sudo apt install -y git qemu-system-x86 make nano

#Print versions to confirm Git and the 64-bit QEMU emulator are properly installed
git --version && qemu-system-x86_64 --version

#Jump back to the user's home directory
cd ~

#Clone your specific repository from GitHub onto your local system
git clone https://github.com/Jamell62/integrative_project.git

#Enter into your newly cloned project repository directory
cd integrative_project
<img width="468" height="95" alt="image" src="https://github.com/user-attachments/assets/0f669bfd-4283-47a0-bf26-dc75c437f04f" />

#Create nested directories for the distribution, the kernel targets, GRUB boot files, and the lab work
mkdir -p part1-distro
mkdir -p part2-kernel/src/targets/x86_64
mkdir -p part2-kernel/iso/boot/grub
mkdir -p part3-lab

#List files and directories to verify the structure was built properly
ls

#Open/create a .gitignore file to prevent tracking unnecessary compilation artifacts
nano .gitignore

#Stage all files and directory trees in the current folder for Git tracking
git add .

#Save the staged files into local history with a clean descriptive message
git commit -m "chore: initial project structure"

#Push the newly created project structure commit to the remote GitHub repository
git push
<img width="556" height="65" alt="image" src="https://github.com/user-attachments/assets/116bcb3a-4458-4b67-9383-9c28e7c37a60" />

#Navigate deep into the kernel workspace directory
cd part2-kernel

#Open or create a Dockerfile for reproducible build environments
nano Dockerfile

#Create the initial assembly files, standard linker scripts, GRUB configurations, and automatic build scripts
nano src/targets/x86_64/header.asm
nano src/targets/x86_64/main.asm
nano src/targets/x86_64/linker.ld
nano iso/boot/grub/grub.cfg
nano Makefile

#Check for hidden characters or verify tab syntax formatting in the first 10 lines of the Makefile
cat -A Makefile | head -10

#Execute the Makefile's automation build instructions to assemble the project
make build

#Launch the compiled operating system inside a QEMU emulation window
make run

#Manually execute QEMU booting your custom generated ISO file directly as a CD-ROM device
qemu-system-x86_64 -cdrom kernel.iso -boot d

#View detailed file specifications and total size of your compiled ISO output
ls -lh kernel.iso

#Search inside the ISO structure metadata to check if your compiled kernel payload is placed correctly
isoinfo -l -i kernel.iso | grep kernel

#Install the standard ISO 9660 image testing tool package
sudo apt install -y genisoimage

#Perform case-insensitive string parsing over the ISO contents to check for the kernel binary
isoinfo -l -i kernel.iso | grep -i kernel

#List every file mapped out inside your compiled ISO to double-check GRUB structure mapping
isoinfo -l -i kernel.iso

#Boot QEMU with a specific safe memory limit (512MB) and instruct it not to loop restart upon a system crash
qemu-system-x86_64 -cdrom kernel.iso -boot d -m 512M -no-reboot

#Move back to root project level directory
cd integrative_project

#Return down into the kernel subproject track directory
cd part2-kernel

#Emulate the operating system using an alternate syntax specifying the ISO as a system drive media
qemu-system-x86_64 -drive file=kernel.iso,media=cdrom -m 512M -no-reboot

#Recursively reassign ownership of the 'iso/' work directory to your standard active user account to avoid permission locks
sudo chowm -R $USER:$USER iso/

#Install tools needed for compiling operating systems: assembly interpreters, binary linkers, and ISO utilities
sudo apt install -y grub-pc-bin grub-common xorriso nasm binutils

#Manually assemble 32-bit object files, link them through your custom mapping script, and bundle into a new bootable ISO image
nasm -f elf32 src/targets/x86_64/header.asm -o /tmp/header.o
nasm -f elf32 src/targets/x86_64/main.asm -o /tmp/main.o
ld -m elf_i386 -T src/targets/x86_64/linker.ld -o iso/boot/kernel.bin /tmp/header.o /tmp/main.o
grub-mkrescue -o kernel.iso iso

#Erase the current old ISO image and quickly regenerate it clean from source files
sudo rm kernel.iso
grub-mkrescue -o kernel.iso iso

#Call the base command to quickly verify terminal autocomplete bindings for QEMU
qemu-system

#Test run the newly built 32-bit Multiboot environment to confirm it successfully hits a CPU halt
qemu-system-x86_64 -drive file=kernel.iso,media=cdrom -m 512M -no-reboot

#Track all new logic states inside the source tracker repository
git add .

#Log the completion milestone of the 32-bit bootstrap baseline code
git commit -m "feat: part2 - kernel episode 1 boots OK in Qemu"

#Intentional typo checking: attempt package install with a misspelled string
sudo apt install -y gcc binutuls build-essential

#Fix the typo and install compiler bundles (GCC, linker tools, standard build utilities)
sudo apt install -y gcc binutils build-essential

#Open and write the 64-bit Multiboot initialization, long mode execution entry, and C display outputs
nano src/targets/x86_64/boot.asm
nano src/targets/x86_64/long_mode_start.asm
nano src/targets/x86_64/kernel.c
nano src/targets/x86_64/linker.ld

#Compile 64-bit Assembly files, compile freestanding C code, and link them using a 64-bit architecture layout
nasm -f elf64 src/targets/x86_64/boot.asm -o /tmp/boot.o
nasm -f elf64 src/targets/x86_64/long_mode_start.asm -o /tmp/long_mode.o
gcc -m64 -ffreestanding -fno-stack-protector -mno-red-zone -c src/targets/x86_64/kernel.c -o /tmp/kernel.o
ld -m elf_x86_64 -T src/targets/x86_64/linker.ld -o iso/boot/kernel.bin /tmp/boot.o /tmp/long_mode.o /tmp/kernel.o
grub-mkrescue -o kernel.iso iso

#Boot QEMU to see if the machine successfully passes page allocation checks and reads the C payload
qemu-system-x86_64 -drive file=kernel.iso,media=cdrom -m 512M -no-reboot

#The image shows the successful boot of the 64-bit MiniKernel in QEMU, confirming that the kernel loaded correctly and is ready to run.
<img width="758" height="482" alt="WhatsApp Image 2026-06-19 at 10 12 40 PM" src="https://github.com/user-attachments/assets/21efc753-80ac-46f6-a944-2fe9c514defd" />

#The image shows that the 64-bit MiniKernel is running, confirming that Long Mode is activated and the system is working correctly in QEMU.
<img width="725" height="485" alt="WhatsApp Image 2026-06-19 at 10 12 40 PM (1)" src="https://github.com/user-attachments/assets/5d31b95e-b62e-4ce5-a7ce-37f9fbe4ebd9" />
