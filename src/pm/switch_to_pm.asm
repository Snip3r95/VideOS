[bits 16]
;switch to 32 bit protected mode
switch_to_pm:
	cli						;turn off all the interrupts until 32 bit protected mode interrupt table is set up	
	lgdt [gdt_descriptor]	;load the global descriptor table
	
	mov eax, cr0			;set the first bit of the cr0 register to signal to the cpu to start 32 bit mode. must be done indirectly
	or eax, 0x1
	mov cr0, eax
	
	jmp CODE_SEG:init_pm	;make a far jump to the 32 bit code and flush the cpu pipeline
	
[bits 32]
;initialize registers and the stack once in pm
init_pm:
	mov ax, DATA_SEG		;update the segment registers to the data selector defined in the GDT
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	mov ebp, 0x90000		;update the stack position so it's on top of free space
	mov esp, ebp
	
	call BEGIN_PM