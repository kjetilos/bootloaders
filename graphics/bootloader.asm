[bits 16]
[org 0x7c00]
start:

	;; Call VideoService interrupt 0x10
	;; ah = 0x00 -> SetVideoMode
	;; al = 0x13 -> 320x200 16 color
	mov ah, 0x00
	mov al, 0x13
	int 0x10

	;; Setup registers to point to video address 
	;;   es:di = 0xa000:0x0000
	mov ax, 0xa000
	mov es, ax
	xor di, di

	;; Fill screen with color from al register
	;; it will start with color 0x00
	mov cx, 0x0000
.loop:	
	mov byte [es:di], al
	inc di
	cmp di, 0xffff
	jnz .loop

	;; Increment color
	inc al

	;; Set data register to 0 for beginning of video address
	xor di, di
	jmp .loop

	
times 510 - ($ - $$) db 0
dw 0xaa55
