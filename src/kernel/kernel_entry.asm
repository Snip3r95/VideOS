;ensures the system jumps into the kernels entry function
[bits 32]
[extern _os_main]		;declare reference of external symbol main so the linker can substitute the final address

call _os_main			;invoke main in the c kernel
jmp $				;hang forever when returning from the kernel