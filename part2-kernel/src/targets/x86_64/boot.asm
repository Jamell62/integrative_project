; Multiboot2 header - tells GRUB this is a valid kernel
section .multiboot_header
header_start:
    dd 0xe85250d6              ; Multiboot2 magic number
    dd 0                       ; Architecture: i386 protected mode
    dd header_end - header_start ; Header size
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start)) ; Checksum
    dw 0                       ; End tag type
    dw 0                       ; End tag flags
    dd 8                       ; End tag size
header_end:

global start                   ; Entry point visible to linker
extern long_mode_start         ; Defined in long_mode_start.asm

section .text
bits 32                        ; Start in 32-bit protected mode
start:
    mov esp, stack_top         ; Set up the stack pointer

    ; Verify that GRUB passed the Multiboot2 magic number
    cmp eax, 0x36d76289
    jne .no_multiboot          ; If not valid, halt

    ; Run all required checks before entering 64-bit mode
    call check_cpuid           ; Check if CPUID instruction is available
    call check_long_mode       ; Check if CPU supports 64-bit long mode
    call setup_page_tables     ; Set up paging structures
    call enable_paging         ; Enable paging in CR0

    lgdt [gdt64.pointer]       ; Load the 64-bit Global Descriptor Table
    jmp gdt64.code:long_mode_start ; Far jump to 64-bit code segment

.no_multiboot:
    hlt                        ; Halt if Multiboot2 not detected

; Check if CPUID instruction is supported by the CPU
check_cpuid:
    pushfd                     ; Save EFLAGS
    pop eax
    mov ecx, eax
    xor eax, 1 << 21          ; Flip bit 21 (CPUID availability bit)
    push eax
    popfd                      ; Load modified flags
    pushfd
    pop eax
    push ecx
    popfd                      ; Restore original flags
    cmp eax, ecx              ; If bit 21 didn't change, CPUID not supported
    je .no_cpuid
    ret
.no_cpuid:
    hlt

; Check if the CPU supports 64-bit long mode
check_long_mode:
    mov eax, 0x80000000       ; Request extended CPUID info
    cpuid
    cmp eax, 0x80000001       ; Check if extended info is available
    jb .no_long_mode
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29         ; Bit 29 = long mode support
    jz .no_long_mode
    ret
.no_long_mode:
    hlt

; Set up page tables for identity mapping the first 1GB
setup_page_tables:
    mov eax, page_table_l3
    or eax, 0b11              ; Present + writable flags
    mov [page_table_l4], eax  ; L4 points to L3

    mov eax, page_table_l2
    or eax, 0b11              ; Present + writable flags
    mov [page_table_l3], eax  ; L3 points to L2

    mov ecx, 0                ; Counter for 512 entries
.loop:
    mov eax, 0x200000         ; 2MB per huge page
    mul ecx
    or eax, 0b10000011        ; Present + writable + huge page flags
    mov [page_table_l2 + ecx * 8], eax ; Map each 2MB page
    inc ecx
    cmp ecx, 512              ; Map all 512 entries (1GB total)
    jne .loop
    ret

; Enable paging by setting bits in control registers
enable_paging:
    mov eax, page_table_l4
    mov cr3, eax              ; CR3 = address of page table L4

    mov eax, cr4
    or eax, 1 << 5            ; Set PAE bit (Physical Address Extension)
    mov cr4, eax

    mov ecx, 0xC0000080       ; EFER MSR (Extended Feature Enable Register)
    rdmsr
    or eax, 1 << 8            ; Set Long Mode Enable bit
    wrmsr

    mov eax, cr0
    or eax, 1 << 31           ; Set paging enable bit
    mov cr0, eax
    ret

; BSS section - uninitialized data (page tables and stack)
section .bss
align 4096
page_table_l4:
    resb 4096                 ; Level 4 page table (512 entries x 8 bytes)
page_table_l3:
    resb 4096                 ; Level 3 page table
page_table_l2:
    resb 4096                 ; Level 2 page table (huge pages)
stack_bottom:
    resb 4096 * 4             ; 16KB stack
stack_top:

; Read-only data section - GDT for 64-bit mode
section .rodata
gdt64:
    dq 0                      ; Null descriptor (required)
.code: equ $ - gdt64          ; Offset of code segment
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53) ; 64-bit code segment
.pointer:
    dw $ - gdt64 - 1          ; GDT size minus 1
    dq gdt64                  ; GDT base address
