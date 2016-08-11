all: bin/os-image.bin

#run bochs to simulate booting of the os
#run: all
#	bochs

#create the actual disk image the system loads, which is the kernel concatenated to the bootsector
bin/os-image.bin: bin/boot_sect.bin bin/kernel.bin
	cat $^ > os-image.bin
	
#build the binary of the kernel from two object files:
#	-kernel_entry, which jumps to main() in the kernel
#	-the compiled kernel
bin/kernel.bin: src/kernel/kernel_entry.o src/kernel/kernel.o
	ld -T NUL -o kernel.tmp -Ttext 0x1000 $^
	objcopy -O binary -j .text  kernel.tmp $@
	rm kernel.tmp

#build the kernel object file
src/kernel/kernel.o : src/kernel/kernel.c
	gcc -ffreestanding -c $< -o $@
	
#build kernel entry object file
src/kernel/kernel_entry.o : src/kernel/kernel_entry.asm
	nasm $< -f elf -o $@
	
#assemble the boot sector to machine code
bin/boot_sect.bin : src/boot_sect.asm
	nasm $< -f bin -I '/ASM/16' -o $@
	

#clear generated files
clean:
	del *.bin *.dis *.o os-image *.map
	
#dissassemble the kernel for debugging
kernel.dis : kernel.bin
	ndisasm -b 32 $< > $@