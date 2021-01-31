
init_screen: {
    jsr SCREENPOSRESET;

    ldx #0x00;
    stx BG_COLOR;
    ldx #0x03;
    stx BORDER_COLOR;
    rts;
}

clear_screen: {
    ldx #0xFF;
    lda #ord(' ');

    loop: {
        sta getScreenBank(0), x;
        sta getScreenBank(1), x;
        sta getScreenBank(2), x;
        sta getScreenBank(3), x;
        dex;
        cpx #0xFF;
        bne loop;
    }

    rts;
}

reset_screen: {
    jsr RESETSCREEN;
    rts;
}

// copies or prints a string to
// c64 memory:
// inputs:
//   dest_ptr -> screen location
//   src_ptr -> string location (\0 terminated!)
gol_strcpy: {
    loop: {
        ldy #0x00;
        lda (srcPtr), y;
        cmp #0x00;
        beq done;
        sta (destPtr), y;

        // string + 1;
        lda srcPtr;
        clc;
        adc #0x01;
        sta srcPtr;
        lda srcPtr+1;
        adc #0x00;
        sta srcPtr+1;

        // screen + 1;
        lda destPtr;
        clc;
        adc #0x01;
        sta destPtr;
        lda destPtr+1;
        adc #0x00;
        sta destPtr+1;
        jmp loop;
    }
    done:
    rts;
}

// lookup table for x/y coordinate conversion
// 40x25
screenLookupHi:
for (let i = 0; i < 25; i = i + 1) {
    db hi(i*40);
}
screenLookupLo:
for (let i = 0; i < 25; i = i + 1) {
    db lo(i*40);
}

// reads cell at x/y
// into a
fn readCell() {
    txa;
    clc;
    adc #lo(SCREEN_BANK);
    adc screenLookupLo, y;
    sta srcPtr;
    lda #hi(SCREEN_BANK);
    adc screenLookupHi, y;
    sta srcPtr+1;

    ldy #0x00;
    lda (srcPtr), y;
}

fn getCellUnrolled() {
    readCell();
    cmp #DEAD;
    beq dead;
        lda #1;
        bne done;
    dead:
        lda #0;
    done:
}

// gets the state of a cell
// inputs:
//  x -> x location
//  y -> y location
// returns:
//  a -> 0/1
getCell: {
    getCellUnrolled();
    rts;
}

// flips the state of a cell from
// inputs:
//  x -> x position
//  y -> y position
//  a -> if a == FF flip current content, otherwise flip to content of A
flipCell: {
    cmp #0xFF;
    bne writeConst;

    readCell();
    cmp #DEAD;
    bne dead;

        lda #ALIVE;
        sta (srcPtr), y;
        rts;
    dead:
        lda #DEAD;
        sta (srcPtr), y;
        rts;

    writeConst:
        pha;
        readCell();
        pla;
        sta (srcPtr), y;
        rts;
}

// sprite for cursor
align 64, 0;
cursorSpritePattern:
for (let i = 0; i < 64; i = i + 1) {
    db 255;
}
