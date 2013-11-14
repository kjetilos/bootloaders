CFLAGS = -m32 -nostdlib

all: kernel.img

bootsect.bin: bootsect.asm
	nasm $^ -f bin -o $@

kernel.img: main.c video.c ports.c makeboot bootsect.bin
	gcc $(CFLAGS) -c main.c -o main.o
	gcc $(CFLAGS) -c video.c -o video.o
	gcc $(CFLAGS) -c ports.c -o ports.o
#	ld -m32 -e main -Ttext 0x1000 -Map=kernel.map -o kernel.o main.o video.o ports.o
	ld -m elf_i386 -e main -Map=kernel.map -T kernel.ld -o kernel.o main.o video.o ports.o
#	gcc -m32 -ffreestanding -nostdlib -Wl,-emain -Wl,-Ttext=0x1000 -o kernel.o main.o video.o ports.o
	objcopy -R .note -R .comment -S -O binary kernel.o kernel.bin
	./makeboot kernel.img bootsect.bin kernel.bin

makeboot: makeboot.c
	gcc $^ -o $@

test: kernel.img
	qemu-system-i386 -hda kernel.img

clean:
	rm -rf *.o *.bin *.img

debug: kernel.img
	qemu-system-i386 -s -S -m 512 -hda kernel.img
