[BITS 16]
[ORG 0x7C00]

mov al, 65
call PrintCharacter
jmp $

PrintCharacter:
mov ah, 0x0E
mov bh, 0x00
mov bl, 0x07

int 0x10
ret

times 510 - ($ - $$) db 0
dw 0xaa55
