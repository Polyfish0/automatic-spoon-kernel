LINKFILE=linker.ld
QEMU=qemu-system-i386
BUILDPATH=build
SOURCEPATH=src
CC=i686-elf-g++
CFLAGS=-m32 -c -Wmultichar -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti -Wwrite-strings -fpermissive -g
#OBJ=$(BUILDPATH)/boot.o $(BUILDPATH)/kernel.o $(BUILDPATH)/kernel/vga.o $(BUILDPATH)/kernel/keyboard.o $(BUILDPATH)/kernel/idt.o
OBJ=$(BUILDPATH)/boot.o $(BUILDPATH)/kernel.o $(BUILDPATH)/kernel/vga.o
ASMC=i686-elf-as
LD=ld
LDFLAGS=-m elf_i386 -T $(LINKFILE) -z muldefs -g

all: $(BUILDPATH)/kernel.elf
	$(QEMU) -kernel $(BUILDPATH)/kernel.elf

debug: $(BUILDPATH)/kernel.elf
	$(QEMU) -s -S -kernel $(BUILDPATH)/kernel.elf

$(BUILDPATH)/boot.o: $(SOURCEPATH)/boot.asm
	$(ASMC) $(SOURCEPATH)/boot.asm -o $(BUILDPATH)/boot.o

$(BUILDPATH)/kernel.o: $(SOURCEPATH)/kernel.*
	$(CC) $(CFLAGS) $(SOURCEPATH)/kernel.cpp -o $(BUILDPATH)/kernel.o

$(BUILDPATH)/kernel/vga.o: $(SOURCEPATH)/kernel/vga.*
	$(CC) $(CFLAGS) $(SOURCEPATH)/kernel/vga.cpp -o $(BUILDPATH)/kernel/vga.o

$(BUILDPATH)/kernel/keyboard.o: $(SOURCEPATH)/kernel/keyboard.* $(BUILDPATH)/boot.o
	$(CC) $(CFLAGS) $(SOURCEPATH)/kernel/keyboard.cpp -o $(BUILDPATH)/kernel/keyboard.o

$(BUILDPATH)/kernel/idt.o: $(SOURCEPATH)/kernel/idt.* $(BUILDPATH)/boot.o
	$(CC) $(CFLAGS) $(SOURCEPATH)/kernel/idt.cpp -o $(BUILDPATH)/kernel/idt.o

$(BUILDPATH)/kernel.elf: $(OBJ)
	$(LD) $(LDFLAGS) -o $(BUILDPATH)/kernel.elf $(OBJ)

clean:
	rm $(OBJ)
