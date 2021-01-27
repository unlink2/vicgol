
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

// gets the state of a cell
// inputs:
//  x -> x location
//  y -> y location
// returns:
//  a -> 0/1
getCell: {
    readCell();
    cmp #DEAD;
    bne alive;
        lda #0;
        rts;
    alive:
        lda #1;
        rts;
}

// flips the state of a cell from
// inputs:
//  x -> x position
//  y -> y position
flipCell: {
    readCell();

    cmp #DEAD;
    bne alive;

        lda #DEAD;
        sta (srcPtr), y;
        rts;
    alive:
        lda #ALIVE;
        sta (srcPtr), y;
        rts;
}