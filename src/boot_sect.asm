;boot sector that boots a C kernel in 32 bit protective mode
[org 0x7c00]
KERNEL_OFFSET equ 0x1000		;memory address where the kernel will be loaded

mov [BOOT_DRIVE], dl			;BIOS stores boot drive in dl
	
mov bp, 0x9000					;set up the stack
mov sp, bp
	
mov bx, MSG_REAL_MODE			;print to the screen that the system is booting in to 16 bit real mode
call print_string
	
call load_kernel				;load the kernel
	
call switch_to_pm				;switch to protected mode
	
jmp $
	
%include "D:\Documents\VideOS\src\16\print_string_16.asm"
%include "D:\Documents\VideOS\src\disk\disk_load.asm"
%include "D:\Documents\VideOS\src\pm\gdt.asm"
%include "D:\Documents\VideOS\src\pm\print_string_32.asm"
%include "D:\Documents\VideOS\src\pm\switch_to_pm.asm"
	
[bits 16]

;load kernel
load_kernel:
	mov bx, MSG_LOAD_KERNEL		;print to screen that the kernel is loading
	call print_string
	
	mov bx, KERNEL_OFFSET		;set up parameters for disk load routine. load 15 sectors from boot disk to KERNEL_OFFSET
	mov dh, 15
	mov dl, [BOOT_DRIVE]
	call disk_load
	
	ret

[bits 32]

BEGIN_PM:
	
	mov ebx, MSG_PROT_MODE		;print to screen that the system is in protected mode
	call print_string_pm
	
	call KERNEL_OFFSET			;jump to the address of the loaded kernel code
	
	jmp $
	
;global variables
BOOT_DRIVE 		db 0
MSG_REAL_MODE 	db "Started in 16 bit real mode", 0x0D, 0x0A, 0
MSG_PROT_MODE	db "Successfully landed in 32-bit protected mode", 0x0D, 0x0A, 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0x0D, 0x0A, 0

;bootsector padding
times 510-($-$$) db 0
dw 0xaa55