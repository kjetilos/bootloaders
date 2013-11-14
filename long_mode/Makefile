boot.bin: bootloader.asm
	nasm $^ -f bin -o $@

test: boot.bin
	qemu-system-x86_64 -hda boot.bin
