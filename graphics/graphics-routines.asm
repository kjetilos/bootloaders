[bits 16]
[org 0x7c00]
start:	
	mov ah, 0x00		; SetVideoMode
	mov al, 0x13 		; Video mode ?
	int 0x10

	;; 16 bit registry holds 2 bytes
	;;  so address format is ffff:eeee
	mov ax, 0xa000
	mov es, ax
	xor di, di

	;; Fill background with color
	mov al, 0x7		; Background Color
.loop:	
	mov byte [es:di], al
	inc di
	cmp di, 0xffff
	jnz .loop

	inc al
	and al, 0xf
	xor di, di
	jmp .loop

	;; DrawHLine (4, 4, 8, 6)
	;; Draw from (4,4) and to (8,4)
	push 0xa		; color
	push 0xf		; end x
	push 0x4		; y
	push 0x4		; start x
	call DrawHLine
	add sp, 8 		; cleanup stack
	
	push 0xa
	push 300
	push 0x8
	push 50
	call DrawHLine
	add sp, 8

	push 0xa		; color
	push 100		; y1
	push 0x6		; y0
	push 0x10		; x0
	call DrawVLine
	add sp, 8

	push 0xa
	push 60
	push 80
	push 0x12
	push 0x12
	call FillRect
	add sp, 10
	
	jmp $			; Hang

	;; Index =
	;;  x = 0, y = 5 :> di = y * width + x
	;; Arguments x, y must be in cx and dx
WritePixel:
	mov ax, 320
	mul dx
	mov di, ax
	add di, cx
	mov al, 0x05		; Color
	mov byte [es:di], al
	ret

	;; Draw a Horizontal line
	;; DrawHLine(x, y, x2, color)
DrawHLine:
	;; First a function prologue
	;;
	;;  basically does
	;;   push bp
	;;   mov bp, sp
	;; 
	enter 0, 0		; function prologue
	
	mov cx, [bp+4]
	mov dx, [bp+6]
	
	mov ax, 320		; Setup di to point to (x,y) memory location
	mul dx			
	mov di, ax
	add di, cx

	;; Next we overwrite the registers with new values
	mov dx, [bp+8]
	mov ax, [bp+10]
.next:
	mov byte [es:di], al
	inc cx
	inc di
	cmp cx, dx
	jne .next		; Draw next pixel if cx and dx are not equal

	;; Epilogue
	;;
	;; will reverse the enter instruction, by resetting stack
	;; and popping base/frame pointer
	;;  mov sp, bp
	;;  pop bp
	leave
	ret
	
	;; DrawVLine(x, y, y2, color)
DrawVLine:
	enter 0, 0

	mov cx, [bp+4]		; x
	mov dx, [bp+6]		; y

	mov ax, 320		; Setup di to point to (x,y)
	mul dx
	mov di, ax
	add di, cx

	;; (x,y) = y * 320 + x
	;; (x,y2) = y2 * 320 + x
	mov cx, [bp+8]		; cx = y1, dx = y0
	sub cx, dx		; cx = y1 - y0 (length of line)

	;; sub ax, bx => ax = ax - bx
	mov ax, [bp+10]		; color
.next:
	mov byte [es:di], al
	add di, 320
	dec cx
	jnz .next

	leave
	ret

	;; FillRect(x0, y0, x1, y2, color)
FillRect:
	;; Make room for a 16 bit local variable
	;; which can be referred to as bp-2
	enter 2, 0

	mov cx, [bp+6]
	mov word [bp-2], cx
.next:
	push word [bp+12]	; color
	push word [bp+8]	; x1
	push cx			; y0
	push word [bp+4]	; x0
	call DrawHLine
	sub sp, 8

	;; Check if we want to continue
	mov cx, [bp-2]
	inc cx
	mov word [bp-2], cx
	mov dx, [bp+10]
	cmp cx, dx
	jne .next

	leave
	ret

	
times 510 - ($ - $$) db 0
dw 0xaa55
