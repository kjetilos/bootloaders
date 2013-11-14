[bits 16]
[org 0x7c00]

  ;; Physical address 0xb8000 is the character buffer
  ;; So we setup the es segment to 0xb800 to since 
  ;;  physical = segment * 16 + offset
  
  mov ax, 0xb800
	mov es, ax
	xor di, di
	mov ah, 0x0 ;; initial color
	mov cx, 0x0

loop:
	mov si, my_string
	call print_string
	jmp $

;; Text mode buffer is on 0xB8000
print_char:
;;	mov al, 0x69  ;; Character
;;	mov ah, 0x1f  ;; Color
  mov [es:di], ax
  inc di
  inc di
  inc ah
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

my_string db 'kjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkjetilkj', 0

times 510 - ($ - $$) db 0
dw 0xaa55
