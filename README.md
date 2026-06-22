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

### Part 3 - Black Hat Bash Lab
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
