
compile:
	nasm -f elf x.asm
	ld -m elf_i386 x.o -o x

run:
	./x

clean:
	rm -f x *.o
