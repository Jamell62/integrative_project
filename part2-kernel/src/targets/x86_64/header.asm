section .multiboot_header      ; Special section that GRUB looks for at boot

header_start:
    dd 0xe85250d6              ; Magic number that identifies Multiboot2
    dd 0                       ; Architecture: 0 = i386 (32-bit protected mode)
    dd header_end - header_start ; Total size of the header
    ; Checksum: sum of all 4 fields must equal 0
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

    ; End tag - required in Multiboot2
    dw 0                       ; Type: 0 = end
    dw 0                       ; Flags
    dd 8                       ; Tag size
header_end:
