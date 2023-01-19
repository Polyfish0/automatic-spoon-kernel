#include "kernel/vga.h"

void main() {
	VGA vga = VGA();
	vga.terminal_init();
	vga.terminal_writestring("Hello from kernel main\nTest\n");
	for(int i = 0; i < 80; i++)
		vga.terminal_writestring("YEET\n");
}

extern "C" void kernel_main(void) {
	main();
}
