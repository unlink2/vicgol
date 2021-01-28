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
    // test S
    testInput(0b11111101, 0b00100000);
    bne noDown; {
        inc cursorY;
    }
    noDown:

    // test d
    testInput(0b11111011, 0b00000100);
    bne noRight; {
        inc cursorX;
    }
    noRight:

    // test w
    testInput(0b11111101, 0b00000010);
    bne noUp; {
        dec cursorY;
    }
    noUp:

    // test a
    testInput(0b11111101, 0b00000100);
    bne noLeft; {
        dec cursorX;
    }
    noLeft:

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
