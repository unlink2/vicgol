include "defs.asm"
include "macros.asm"

db lo(BASIC_MEMORY), hi(BASIC_MEMORY); // ptr to next basic line

org BASIC_MEMORY;
// a very simple basic program that jumps to the start of machine code
db 0x0c, 0x08, 0x00, 0x00, BAS_SYS; // 10 sys
db "2062", 0x00, 0x00, 0x00; // the actual address in petscii

init: {
    jsr init_irq;

    lda #lo(cursorSpritePattern);
    sta cursorSpritePatternPtr;
    lda #hi(cursorSpritePattern);
    sta cursorSpritePatternPtr+1;

    lda #00;
    sta runtimeFlags;
    sta cursorMoveDelay;
    sta flipDelay;
    sta cursorX;
    sta cursorY;
    jsr init_screen;
    jsr clear_screen;
    lda #01;
    sta SPRITEENABLE;

    // run until exit flag is set
mainLoop:
    strcpy(hello_string, SCREEN_BANK);

    jsr processInputs;

    jsr update;

    lda runtimeFlags;
    and #0b01000000;
    // skip if paused
    bne isPaused;
        jsr updateGame;
    isPaused:

    // wait until frame flag is set
    waitLoop:
        lda runtimeFlags;
        and #0b00100000;
        beq waitLoop;
    lda runtimeFlags;
    and #0b11011111;
    sta runtimeFlags;

    lda runtimeFlags;
    and #0b10000000;
    beq mainLoop;

    // exit
    jsr clear_screen;
    jsr reset_screen;
    rts; // back to basic
}

include "input.asm"
include "screen.asm"
include "gameloop.asm"
include "timing.asm"

hello_string:
defstrScreenCodeC64("(Q)UIT (P)AUSE/UNPAUSE (F)LIP"); db 0;
