.PHONY: build run

build:
	docker build -t kernel-builder .
	docker run --rm -v $(PWD):/kernel kernel-builder bash -c "\
		nasm -f elf32 src/targets/x86_64/header.asm -o /tmp/header.o && \
		nasm -f elf32 src/targets/x86_64/main.asm -o /tmp/main.o && \
		ld -m elf_i386 -T src/targets/x86_64/linker.ld -o iso/boot/kernel.bin /tmp/header.o /tmp/main.o && \
		grub-mkrescue -o kernel.iso iso"

run:
	qemu-system-x86_64 -cdrom kernel.iso
