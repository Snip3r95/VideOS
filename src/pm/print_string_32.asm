[bits 32]
;Define Constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

;prints a null terminated string pointed to by edx
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY	;set edx to the start of the video memory
	
print_string_pm_loop:
	mov al, [ebx]			;store the char at ebx in al
	mov ah, WHITE_ON_BLACK	;store the character attributes in ah
	
	cmp al, 0				;if al == 0, the string is terminated, so jump to done
	je print_string_pm_done
	
	mov [edx], ax			;store the char and attributes at the current character cell
	
	add ebx, 1				;incrememnt ebx to the next char in the string
	add edx, 2				;move to the next character cell in video memory
	
	jmp print_string_pm_loop;jump back to the start of the loop

print_string_pm_done:
	popa
	ret