
	global DrawHLine
	
DrawHLine:
	mov ebp, esp		; save the stack pointer
	mov ecx, [ebp-2]
	mov edx, [ebp-4]
	
	mov eax, 320		; Setup di to point to (x,y) memory location
	mul edx			
	mov edi, eax
	add edi, ecx

	;; Next we overwrite the registers with new values
	mov edx, [ebp-6]		; X2 parameter
	mov eax, [ebp-8]		; Color parameter
	ret
