ASMSRC = processes.asm
OBJ = processes.o
EXE = processes

all: $(EXE)

$(EXE): $(OBJ)
	ld -s -o $(EXE) $(OBJ) -lc

$(OBJ): $(ASMSRC)
	nasm -f elf64 $(ASMSRC)

clean:
	rm -f $(OBJ) $(EXE)