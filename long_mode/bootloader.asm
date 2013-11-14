[BITS 16]       ; We need 16-bit intructions for Real mode

[ORG 0x7C00]    ; The BIOS loads the boot sector into memory location 0x7C00

        cli                     ; Disable interrupts, we want to be alone

        xor ax, ax
        mov ds, ax              ; Set DS-register to 0 - used by lgdt

        lgdt [gdt_desc]         ; Load the GDT descriptor

;; Enable PAE - Physical Address Extension
        mov eax, 100000b        ; eax = PAE flag set
        mov cr4,eax             ; Enable PAE

        mov ecx,0xc0000080                              ;ecx = MSR for EFER
        rdmsr                                           ;Enable long mode in the EFER MSR
        or eax,0x00000100
        wrmsr                                           ;Enable long mode in the EFER MSR

        mov eax, cr0            ; Copy the contents of CR0 into EAX
        or eax, 1               ; Set bit 0
        mov cr0, eax            ; Copy the contents of EAX into CR0

        jmp 08h:clear_pipe      ; Jump to code segment, offset clear_pipe


[BITS 64]                       ; We now need 64-bit instructions
clear_pipe:
        mov ax, 10h             ; Save data segment identifyer
        mov ds, ax              ; Move a valid data segment into the data segment register
        mov ss, ax              ; Move a valid data segment into the stack segment register
        mov esp, 090000h        ; Move the stack pointer to 090000h

        mov byte [0x0B8000], 'P'      ; Move the ASCII-code of 'P' into first video memory
        mov byte [0x0B8001], 1Bh      ; Assign a color code
        mov dword [0xb8002], 0x1b021b03  ; The number is reversed when rendering because of little-endian
        mov rax, 0x1b041b051b061b07
;;        mov 0x0b8000
hang:
        jmp hang                ; Loop, self-jump


gdt:                    ; Address for the GDT

gdt_null:               ; Null Segment
        dd 0
        dd 0

gdt_code:               ; Code segment, read/execute, nonconforming
        dw 0FFFFh
        dw 0
        db 0
        db 10011010b
        db 11001111b
        db 0

gdt_data:               ; Data segment, read/write, expand down
        dw 0FFFFh
        dw 0
        db 0
        db 10010010b
        db 11001111b
        db 0

gdt_end:                ; Used to calculate the size of the GDT



gdt_desc:                       ; The GDT descriptor
        dw gdt_end - gdt - 1    ; Limit (size)
        dd gdt                  ; Address of the GDT




times 510-($-$$) db 0           ; Fill up the file with zeros

        dw 0AA55h                ; Boot sector identifyer
