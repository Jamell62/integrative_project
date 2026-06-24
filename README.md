# Integrative Project -  UIDE 2026

## Description
Build, Boot and Attack — a full Linux stack project covering custom distro, 64-bit kernel, and offensive security lab.

## Group Members
- Paula Cevallos (Part 1 - Custom Distro)
- Odalis Anangonó (Part 2 - 64-bit Kernel)
- Joselyn Laguna (Part 3 - Black Hat Bash Lab)

## Project Structure
- `part1-distro/` - Custom Linux distribution built with Cubic
- `part2-kernel/` - 64-bit kernel built from scratch
- `part3-lab/` - Black Hat Bash offensive security lab

## Link to reporduce video
https://youtu.be/P-pr14Q4dl0

## How to reproduce

## Part 1 - Custom Distro
```bash
#Download the .iso file named interstellar_fijo.iso
interstellar_fijo.iso
#This is the installation image you'll mount into the VM later

#Open VirtualBox
#Launches the VirtualBox application where you'll build the VM

#Create a new virtual machine
Name: RolliePollieNew #The display name VirtualBox will use to identify this VM. In this case. But you can customize the name to your liking
OS Type: Oracle Linux (64-bit) #Tells VirtualBox which OS profile to optimize settings for; must be manually chosen upon uploading the .iso file

#System settings
Base Memory: 9478 MB #Amount of host RAM allocated to the VM, so it runs smooth, but it can be set to 1024 MB (1 GB) (will be sluggish)
Processors: 9 #Number of virtual CPU cores assigned to the VM, for smoothness, but you can work with 1 processor
Disk Size: 60 GB #Total virtual hard disk capacity available to the guest OS, for smoothness, can be ran in 15 GB
Boot Order: Floppy, Optical, Hard Disk #Defines the sequence VirtualBox checks devices in to find a bootable OS
Acceleration: Nested Paging, KVM Paravirtualization #Hardware/virtualization features that let the VM run closer to native speed

#Display settings
Video Memory: 7 MB #Amount of memory reserved for rendering the VM's graphical output
Graphics Controller: VBoxVGA #The virtual graphics adapter emulated for the guest OS
Remote Desktop Server: Disabled #Turns off the ability to connect to this VM remotely via RDP
Recording: Disabled #Turns off VirtualBox's built-in screen/video capture of the VM session

#Storage settings
Controller: IDE #The virtual disk interface type used to connect storage devices to the VM
IDE Primary Device 0: RolliePollieNew.vdi (Normal, 149.97 GB) #The virtual hard disk file that acts as the VM's main storage
IDE Secondary Device 0: [Optical Drive] interstellar_fijo.iso (2.94 GB) #The virtual CD/DVD drive where the install ISO is mounted

#Network settings
Adapter 1: PCnet-FAST III (NAT) #Virtual network card set to NAT mode, letting the VM access the internet through the host

#When you are finished configuring the VM, install the interstellar_fijo.iso when you are inside the VM, it will only take a couple of minutes
#This boots the VM from the mounted ISO and runs the Linux Mint installer
```
### Part 2 - Kernel
```bash
### Part 2 - Kernel

```bash
cd part2-kernel # Navigate to the kernel project directory

nasm -f elf64 src/targets/x86_64/boot.asm -o /tmp/boot.o # Assemble the bootloader source file into a 64-bit object file

nasm -f elf64 src/targets/x86_64/long_mode_start.asm -o /tmp/long_mode.o # Assemble the long mode initialization code for 64-bit execution

gcc -m64 -ffreestanding -fno-stack-protector -mno-red-zone -c src/targets/x86_64/kernel.c -o /tmp/kernel.o # Compile the main kernel source code written in C

ld -m elf_x86_64 -T src/targets/x86_64/linker.ld -o iso/boot/kernel.bin /tmp/boot.o /tmp/long_mode.o /tmp/kernel.o # Link all object files into the final kernel binary using the linker script

grub-mkrescue -o kernel.iso iso # Create a bootable ISO image containing the kernel and GRUB configuration

qemu-system-x86_64 -drive file=kernel.iso,media=cdrom -m 512M -no-reboot # Run the kernel ISO in QEMU for testing and validation
```
### Part 3 - Black Hat Bash Lab
```bash
To reproduce the offensive lab infrastructure and execute the automated scanning, run the following commands:

```bash
# 1. Clone the repository and fix the validator script
git clone [https://github.com/dolevf/Black-Hat-Bash.git](https://github.com/dolevf/Black-Hat-Bash.git)  # Downloads the official lab files
cd Black-Hat-Bash/lab                                   # Enters the lab directory
sed -i 's/docker compose/docker-compose/g' run.sh       # Fixes Docker syntax compatibility
sed -i 's/--parallel//g' run.sh                         # Removes deprecated flags causing errors

# 2. Deploy the infrastructure
sudo make deploy                                        # Automates building and starting all 8 containers

# 3. Verify lab status and network configuration
sudo make test                                          # Runs health check to confirm "Lab is up"
sudo docker ps --format "{{.Names}}"                    # Lists active containers to verify deployment
ip addr | grep "br_"                                    # Displays the isolated Docker bridge networks

# 4. Demonstrate interactive access to a vulnerable container
sudo docker exec -it p-web-01 bash                      # Opens an interactive root shell inside the server
whoami                                                  # Confirms maximum administrator privileges
exit                                                    # Closes the interactive shell

# 5. Install and configure Nuclei (Manual Binary Installation)
sudo apt install wget unzip -y                          # Installs required download and extraction tools
wget [https://github.com/projectdiscovery/nuclei/releases/download/v3.0.0/nuclei_3.0.0_linux_amd64.zip](https://github.com/projectdiscovery/nuclei/releases/download/v3.0.0/nuclei_3.0.0_linux_amd64.zip)
unzip nuclei_3.0.0_linux_amd64.zip                      # Extracts the downloaded archive
sudo mv nuclei /usr/local/bin                           # Moves the binary to the system path
nuclei -update-templates                                # Downloads the latest security templates

# 6. Execute the advanced hacking technique (Nuclei)
nuclei -u [http://172.16.10.12](http://172.16.10.12)          # Launches the vulnerability scan against the target
```

## Instructor
Ing. Jonathan Eduardo Tito Ontaneda
