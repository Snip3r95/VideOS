print_hex:					;prints the value stored at bx in hex
	pusha					;push all the local registers to the stack
	mov ah, 0x0e			;move 0x0e to the high byte of ax in preparation for a teletype interrupt
	mov al, "0"				;move the ascii char 0 to the lower byte of ax
	int 0x10				;perform a teletype interrupt
	mov al, "x"				;move the ascii char x to the lower byte of ax
	int 0x10				;perfrom a teletype interrupt
	mov dx, 0				;move 0 to dx in preparation for the loop
	mov cx, 0				;zero out cx
	hex_print_loop_start:
		mov cl, bl			;move bl to cl to isolate the lowest nybble of bx
		add cl, [ascii_table]	;set the table offset with cx
		mov al, cl			;get the value at the offset index of the table and store it in al for printing
		int 0x10			;perform a teletype interrupt
		inc dx				;increment dx by one
		shr bx, 1			;shift bx right in preparation for reading the next character
		cmp dx, byte 0x04	;check if the loop has been performed 4 times
		jl hex_print_loop_start	;if it hasn't been performed 4 times, jump to the beginning of the loop
	popa					;restore local registers
	ret						;return
	
	ascii_table:			;define a table to store ascii characters for conversion
		db "0123456789ABCDEF"