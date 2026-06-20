global long_mode_start         ; Entry point from boot.asm far jump
extern kernel_main             ; C function defined in kernel.c

section .text
bits 64                        ; We are now in 64-bit long mode
long_mode_start:
    ; Clear all segment registers (not used in 64-bit mode)
    mov ax, 0
    mov ss, ax                 ; Stack segment
    mov ds, ax                 ; Data segment
    mov es, ax                 ; Extra segment
    mov fs, ax                 ; F segment
    mov gs, ax                 ; G segment

    call kernel_main           ; Jump to C kernel code
    hlt                        ; Halt if kernel_main returns
