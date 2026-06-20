/* Linker script - defines how the kernel is laid out in memory */

ENTRY(start)                   /* Entry point: start label in boot.asm */

SECTIONS {
    . = 1M;                    /* Load kernel at 1MB (conventional for x86) */

    .boot : {
        KEEP(*(.multiboot_header)) /* Keep Multiboot2 header at the very start */
    }

    .text : {
        *(.text)               /* All executable code */
    }

    .rodata : {
        *(.rodata)             /* Read-only data (GDT, strings) */
    }

    .data : {
        *(.data)               /* Initialized global variables */
    }

    .bss : {
        *(COMMON)              /* Common uninitialized data */
        *(.bss)                /* Uninitialized data (page tables, stack) */
    }
}
