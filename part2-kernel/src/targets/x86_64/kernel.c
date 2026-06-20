#include <stdint.h>

/* VGA text mode constants */
#define VGA_WIDTH  80          /* Number of columns */
#define VGA_HEIGHT 25          /* Number of rows */
#define VGA_MEMORY (uint16_t*)0xb8000  /* VGA buffer address */

uint16_t* vga = VGA_MEMORY;   /* Pointer to VGA text buffer */
int cursor = 0;               /* Current cursor position */

/* Clear the screen by filling with spaces */
void clear() {
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga[i] = (uint16_t)(' ') | (uint16_t)(0x0F << 8);
    }
    cursor = 0;
}

/* Print a single character with a given color */
void print_char(char c, uint8_t color) {
    if (c == '\n') {
        /* Move cursor to next line */
        cursor += VGA_WIDTH - (cursor % VGA_WIDTH);
        return;
    }
    /* Write character and color to VGA buffer */
    vga[cursor] = (uint16_t)c | (uint16_t)(color << 8);
    cursor++;
}

/* Print a string with a given color */
void print_str(const char* str, uint8_t color) {
    for (int i = 0; str[i] != '\0'; i++) {
        print_char(str[i], color);
    }
}

/* Kernel entry point - called from long_mode_start.asm */
void kernel_main() {
    clear();                   /* Clear screen before printing */

    /* Print group information */
    print_str("================================================\n", 0x0A); /* Green */
    print_str("   64-bit Kernel - UIDE 2026\n", 0x0B);                    /* Cyan */
    print_str("   Odalis, Joselyn & Paula\n", 0x0E);                       /* Yellow */
    print_str("   Systems Engineering - Introduction to UNIX\n", 0x0D);    /* Magenta */
    print_str("================================================\n", 0x0A); /* Green */
    print_str("\n   Long mode active. Kernel running!\n", 0x0F);           /* White */
}
