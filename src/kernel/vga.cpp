#include "vga.h"

inline uint8_t VGA::vga_entry_color(enum vga_color fg, enum vga_color bg) {
	return fg | bg << 4;
}

inline uint16_t VGA::vga_entry(unsigned char uc, uint8_t color) {
	return (uint16_t) uc | (uint16_t) color << 8;
}

size_t VGA::strlen(const char* str) {
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}

void VGA::linebreak() {
	if(terminal_row == VGA_HEIGHT) {
		for(size_t row = 1; row < VGA_HEIGHT; row++) {
			terminal_buffer[row - 1] = terminal_buffer[row];
		}
	}else {
		terminal_row++;
	}

	terminal_column = 0;
}

void VGA::terminal_setcolor(uint8_t color) {
	terminal_color = color;
}

void VGA::terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

void VGA::terminal_putchar(char c) {
	terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
	if(++terminal_column == VGA_WIDTH) {
		terminal_column = 0;
		if(++terminal_row == VGA_HEIGHT)
			terminal_row = 0;
	}
}

void VGA::terminal_write(const char* data, size_t size) {
	for(size_t i = 0; i < size; i++) {
		if(data[i] == '\n') {
			linebreak();
			continue;
		}
		terminal_putchar(data[i]);
	}
}

void VGA::terminal_writestring(const char* data) {
	terminal_write(data, strlen(data));
}

void VGA::terminal_init(void) {
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	terminal_buffer = (uint16_t*) 0xB8000;
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for(size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}
