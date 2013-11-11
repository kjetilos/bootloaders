[bits 16]
[org 0x7c00]

loop:
	mov si, my_string
	call print_string
	jmp loop

print_char:
	mov ah, 0x0e
	mov bh, 0x00
	mov bl, 0x07

	int 0x10
	ret

print_string:
next_char:
	mov al, [si]
	inc si
	or al, al
	jz exit_function
	call print_char
	jmp next_char
exit_function:
	ret

my_string db 'all work and no play', 0

times 510 - ($ - $$) db 0
dw 0xaa55
