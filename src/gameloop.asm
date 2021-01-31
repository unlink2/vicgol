let maxCursorX = 42;
let maxCursorY = 32;

spriteCoordinateLookupX:
for (let i = 0; i < maxCursorX; i = i + 1) {
    db lo((3 + i) * 8);
}

spriteCoordinateLookupXExtra:
for (let i = 0; i < maxCursorX; i = i + 1) {
    if ((3 + i)*8 > 255) {
        db 0xFF;
    } else {
        db 0x00;
    }
}

spriteCoordinateLookupY:
for (let i = 0; i < maxCursorY; i = i + 1) {
    db (6 + i) * 8;
}


update: {
    // is cursor out of bounds?
    lda cursorX;
    cmp #maxCursorX;
    bcc noXOverflow;
        lda #00;
        sta cursorX;
    noXOverflow:

    lda cursorY;
    cmp #maxCursorY;
    bcc noYOverflow;
        lda #00;
        sta cursorY;
    noYOverflow:

    // put cursor in right position
    ldx cursorX;
    lda spriteCoordinateLookupX, x;
    sta cursorSpriteX;

    lda spriteCoordinateLookupXExtra, x;
    sta 0xD010;

    ldx cursorY;
    lda spriteCoordinateLookupY, x;
    sta cursorSpriteY;


    rts;
}

// apply game rule to a cell
// inputs:
//   x -> x coordinate
//   y -> y coordinate
applyRule: {
    stx ruleTempX;
    sty ruleTempY;

    // count cells
    lda #00;
    sta ruleTempCount;

    // check every adjacent cell

    // left
    dex;
    getCellUnrolled();
    clc;
    adc ruleTempCount;
    sta ruleTempCount;

    // right
    ldx ruleTempX;
    ldy ruleTempY;
    inx;
    getCellUnrolled();
    clc;
    adc ruleTempCount;
    sta ruleTempCount;

    // up
    ldx ruleTempX;
    ldy ruleTempY;
    dey;
    getCellUnrolled();
    clc;
    adc ruleTempCount;
    sta ruleTempCount;

    // down
    ldx ruleTempX;
    ldy ruleTempY;
    iny;
    getCellUnrolled();
    clc;
    adc ruleTempCount;
    sta ruleTempCount;

    // up/right
    ldx ruleTempX;
    ldy ruleTempY;
    inx;
    dey;
    getCellUnrolled();
    clc;
    adc ruleTempCount;
    sta ruleTempCount;

    // up/left
    ldx ruleTempX;
    ldy ruleTempY;
    dex;
    dey;
    getCellUnrolled();
    clc;
    adc ruleTempCount;
    sta ruleTempCount;

    // down/right
    ldx ruleTempX;
    ldy ruleTempY;
    inx;
    iny;
    getCellUnrolled();
    clc;
    adc ruleTempCount;
    sta ruleTempCount;

    // down/left
    ldx ruleTempX;
    ldy ruleTempY;
    dex;
    iny;
    getCellUnrolled();
    clc;
    adc ruleTempCount;
    sta ruleTempCount;

    ldx ruleTempX;
    ldy ruleTempY;
    getCellUnrolled();
    beq deadRules;

    aliveRules: {
        lda ruleTempCount;

        cmp #02;
        beq done;
        cmp #03;
        beq done;
        die:
            ldx ruleTempX;
            ldy ruleTempY;
            lda #DEAD;
            jsr flipCell;
            jmp done;
    }
    deadRules: {
        // apply rules
        lda ruleTempCount;
        cmp #03;
        bne done;

        alive:
            ldx ruleTempX;
            ldy ruleTempY;
            lda #ALIVE;
            jsr flipCell;
    }

done:
    // restore original x and y
    ldx ruleTempX;
    ldy ruleTempY;
    rts;
}
ruleTempX:
db 0;
ruleTempY:
db 0;
ruleTempCount:
db 0;

updateGame: {

    // test every valid cell
    ldy #2;
        yLoop:
            ldx #2;
            xLoop:
                jsr applyRule;
                inx;
                cpx #30;
                bne xLoop;

            iny;
            cpy #20;
            bne yLoop;



    rts;
}
