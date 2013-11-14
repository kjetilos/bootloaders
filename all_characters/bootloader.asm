[bits 16]
[org 0x7c00]

  ;; Physical address 0xb8000 is the character buffer
  ;; So we setup the es segment to 0xb800 to since 
  ;;  physical = segment * 16 + offset
  
  mov ax, 0xb800
	mov es, ax
	xor di, di
	mov ah, 0x0c ;; initial color
  mov al, 0x00 ;; initial character

loop:
	call print_string
	jmp $

;; Text mode buffer is on 0xB8000
print_char:
;;	al - Character
;;	ah - Color
  mov [es:di], ax
  inc di
  inc di
	ret

print_string:
next_char:
	call print_char
  inc al
  jz exit_function
	jmp next_char
exit_function:
	ret

times 510 - ($ - $$) db 0
dw 0xaa55
