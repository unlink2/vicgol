fn testInput(row, col) {
    ldy #row;
    ldx #col;
    jsr _testInput;
}

processInputs: {
    lda #0b11111111;
    sta DDRA;
    lda #0b00000000;
    sta DDRB;

    // test Q. if it is pressed exit
    testInput(0b01111111, 0b01000000);
    bne noExit; {
        lda #0b10000000;
        ora runtimeFlags;
        sta runtimeFlags;
    }
    noExit:

    lda cursorMoveDelay;
    bne skipCursorMove;

    // test S
    testInput(0b11111101, 0b00100000);
    bne noDown; {
        inc cursorY;
        lda #DEFAULT_CURSOR_DELAY;
        sta cursorMoveDelay;
    }
    noDown:

    // test d
    testInput(0b11111011, 0b00000100);
    bne noRight; {
        inc cursorX;
        lda #DEFAULT_CURSOR_DELAY;
        sta cursorMoveDelay;
    }
    noRight:

    // test w
    testInput(0b11111101, 0b00000010);
    bne noUp; {
        dec cursorY;
        lda #DEFAULT_CURSOR_DELAY;
        sta cursorMoveDelay;
    }
    noUp:

    // test a
    testInput(0b11111101, 0b00000100);
    bne noLeft; {
        dec cursorX;
        lda #DEFAULT_CURSOR_DELAY;
        sta cursorMoveDelay;
    }
    noLeft:

    skipCursorMove:

    lda flipDelay;
    bne skipAction;
    // test f
    testInput(0b11111011, 0b00100000);
    bne noFlip; {
        ldx cursorX;
        ldy cursorY;
        lda #0xFF;
        jsr flipCell;
        lda #DEFAULT_FLIP_DELAY;
        sta flipDelay;
    }
    noFlip:

    // test p
    testInput(0b11011111, 0b00000010);
    bne noPause; {
        lda runtimeFlags;
        eor #0b01000000;
        sta runtimeFlags; // flip pause flag
        lda #DEFAULT_FLIP_DELAY;
        sta flipDelay;
    }
    noPause:

    skipAction:


    rts;
}

// tests inputs of row/col
//  x -> col to test
//  y -> row to test
// returns:
//  a -> zero if not pressed
_testInput: {
    // test col y
    sty PRA;

    // test row x
    txa;
    and PRB;

    rts;
}
