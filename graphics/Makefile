imagefile.img: boot.bin
	dd if=boot.bin bs=512 of=imagefile.img

boot.bin: bootloader.asm
	nasm bootloader.asm -f bin -o boot.bin

test: boot.bin
	qemu-system-i386 -hda boot.bin
