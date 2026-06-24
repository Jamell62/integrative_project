.PHONY: build run

build:

	docker build -t kernel-builder .
	docker run --rm -v $(PWD):/kernel kernel-builder bash -c "\
		nasm -f elf64 src/targets/x86_64/boot.asm -o /tmp/boot.o && \
		nasm -f elf64 src/targets/x86_64/long_mode_start.asm -o /tmp/long_mode.o && \
		gcc -m64 -ffreestanding -fno-stack-protector -mno-red-zone -c src/targets/x86_64/kernel.c -o /tmp/kernel.o && \
		ld -m elf_x86_64 -T src/targets/x86_64/linker.ld -o iso/boot/kernel.bin /tmp/boot.o /tmp/long_mode.o /tmp/kernel.o && \
		grub-mkrescue -o kernel.iso iso"

run:
	qemu-system-x86_64 -drive file=kernel.iso,media=cdrom -m 512M -no-reboot
