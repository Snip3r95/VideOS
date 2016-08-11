;defining the gdt
gdt_start:

gdt_null:	;define the mandatory null entry in the gdt
	dd 0x0	;fill all 8 bytes (two double words == 4 bytes * 2) with zeroes
	dd 0x0
	
gdt_code:	;the code segment descriptor
	;base address=0x0, limit=0xffff
	;1st flags: 	(present=1, priviledge=00, descriptor type=1) == 1001b
	;type flags: 	(code=1, conforming=0, readable=1, accessed=0) == 1010b
	;2nd flags:		(granularity=1, 32 bit default=1, 64 bit segment=0, AVL used for debugging=0) == 1100b
	dw 0xffff	;limit bits 0-15
	dw 0x0		;base bits 0-15
	db 0x0		;base bits 16-23
	db 10011010b;1st flags, type flags
	db 11001111b;2nd flags, limit bits 16-19
	db 0x0		;base bits 24-31
	
gdt_data:	;the data segment descriptor	
			;identical to code segment except for type flags
			;type flags: (code=0, expand down=0, writable=1, accessed=0) == 0010b
	dw 0xffff	;limit bits 0-15
	dw 0x0		;base bits 0-15
	db 0x0		;base bits 16-23
	db 10010010b;1st flags, type flags
	db 11001111b;2nd flags, limit bits 16-19
	db 0x0 		;base bits 24-31
	
gdt_end:		;adding the label at the end so I can compute the size of the whole gdt

;gdt descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1	;size of the gdt, always less than one of the true size
	
	dd gdt_start				;start address of gdt
	
;define handy constants for the gdt segment descriptor offsets
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start