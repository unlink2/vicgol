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
