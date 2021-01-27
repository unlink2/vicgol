CC=lasm
BIN=vicgol.prg
LST=vicgol.sym

BINDIR=./bin
MAIN = ./src/main.asm

# main

$(BIN): | init
	$(CC) -o $(BINDIR)/$(BIN) -s ${BINDIR}/${LST} $(MAIN)

# other useful things

.PHONY: clean
clean:
	rm $(BINDIR)/*


.PHONY: setup
init:
	mkdir -p $(BINDIR)
