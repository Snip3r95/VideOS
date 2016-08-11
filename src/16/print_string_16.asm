print_string:				;prints a null terminated string defined at bx
	pusha					;push all register values on to the stack
	mov ah, 0x0e			;put 0x0e at the high byte of ax to begin BIOS tele-type routine
	loop_start:				;define the start of the print loop
		cmp [bx],byte 0x00	;check if we have reached the end of the null terminated string
		je loop_end			;if we have reached the end of the null terminated string, jump out of the loop a
		mov al, byte [es:bx]	;move the char located at the lower byte of bx to the lower byte of ax in preparation for printing
		int 0x10			;trigger the print interrupt to print the character at al to the screen
		inc bx				;increment the offset located at bx
		jmp loop_start		;restart the print loop
	loop_end:
		popa				;restore the register values
		ret					;return