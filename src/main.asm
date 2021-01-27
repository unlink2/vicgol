include "defs.asm"
include "macros.asm"

db lo(BASIC_MEMORY), hi(BASIC_MEMORY); // ptr to next basic line

org BASIC_MEMORY;
// a very simple basic program that jumps to the start of machine code
db 0x0c, 0x08, 0x00, 0x00, BAS_SYS; // 10 sys
db "2062", 0x00, 0x00, 0x00; // the actual address in petscii

init: {
    sei; // no more interrupts
    lda #00;
    sta runtimeFlags;
    sta cursorX;
    sta cursorY;
    jsr init_screen;
    jsr clear_screen;

    // run until exit flag is set

mainLoop:
    strcpy(hello_string, SCREEN_BANK);
    // test flip
    ldx #39;
    ldy #24;
    jsr flipCell;

    jsr processInputs;

    lda runtimeFlags;
    and #0b10000000;
    beq mainLoop;

    // exit
    jsr clear_screen;
    jsr reset_screen;
    cli; // enable interrupts again
    rts; // back to basic
}

include "input.asm"
include "screen.asm"

hello_string:
defstrScreenCodeC64("(Q)UIT (P)AUSE (R)ESUME (F)LIP"); db 0;
