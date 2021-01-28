update: {
    rts;
}

updateGame: {
    // test flip
    ldx #39;
    ldy #24;
    jsr flipCell;

    ldx #01;
    ldy #01;
    jsr flipCell;
    rts;
}
