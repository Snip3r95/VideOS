disk_load:			;load dh sectors to es:bx from drive dl
	push dx			;store dx on the stack so we can later recall how many sectors were requested to be read
	mov ah, 0x02	;preparing for bios read interrupt
	mov al, dh		;read dh sectors
	mov ch, 0x00	;select cylinder 0
	mov dh, 0x00	;select head 0
	mov cl, 0x02	;select sector 2 (after the boot sector)
	
	int 0x13		;bios disk read interrupt
	
	jc disk_error	;if the read fails (which sets the carry flag) then jump to the disk read error routine
	
	pop dx			;restore dx from the stack
	cmp dh, al		;compare al (sectors read) to dh (sectors expected)
	jne disk_error	;if al != dh, jump to error routine
	ret				;return
	
disk_error:			;print an error to the screen when reading the drive fails
	mov bx, DISK_ERROR_MSG	;store the disk error message at bx
	call print_string		;print the string at bx to the screen
	jmp $					;hang
	
DISK_ERROR_MSG db "Disk read error", 0