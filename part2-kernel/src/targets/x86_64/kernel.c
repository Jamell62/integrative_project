#include <stdint.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_MEMORY (uint16_t*)0xb8000

uint16_t* vga = VGA_MEMORY;
int cursor = 0;

void set_color(uint8_t fg, uint8_t bg) {
}

void clear() {
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga[i] = (uint16_t)(' ') | (uint16_t)(0x0F << 8);
    }
    cursor = 0;
}

void print_char(char c, uint8_t color) {
    if (c == '\n') {
        cursor += VGA_WIDTH - (cursor % VGA_WIDTH);
        return;
    }
    vga[cursor] = (uint16_t)c | (uint16_t)(color << 8);
    cursor++;
}

void print_str(const char* str, uint8_t color) {
    for (int i = 0; str[i] != '\0'; i++) {
        print_char(str[i], color);
    }
}

void kernel_main() {
    clear();
    print_str("================================================\n", 0x0A);
    print_str("   64 bits Kernel - UIDE 2026\n", 0x0B);
    print_str("   Odalis, Joselyn & Paula\n", 0x0E);
    print_str("   Systems Engineering - Introduction to UNIX\n", 0x0D);
    print_str("================================================\n", 0x0A);
    print_str("\n   Long mode active. Kernel running!\n", 0x0F);
}
