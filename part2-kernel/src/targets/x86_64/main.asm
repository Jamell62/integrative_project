bits 32                        ; We are in 32-bit protected mode
global start                   ; Make 'start' visible to the linker

section .text
start:
    ; Write 'OK' directly to video memory (VGA text mode)
    ; 0xb8000 is the start address of VGA text buffer
    ; 0x2f = white text on green background
    ; 0x4b = 'K', 0x4f = 'O' in ASCII
    mov dword [0xb8000], 0x2f4b2f4f

    hlt                        ; Halt the CPU - stop execution
