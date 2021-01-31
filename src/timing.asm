
init_irq: {
    sei;
    lda #0b01111111; // switch off interrupt signals from CIA-1
    sta 0xDC0D;
    and 0xD011; // clear most significant bit of VIC's raster register
    sta 0xD011;

    lda 0xDC0D; // acknowledge pending interrupts from CIA-1
    lda 0xDD0D; // acknowledge pending interrupts from CIA-2

    lda #210; // set rasterline where interrupt shall occur
    sta 0xD012;

    // irq routine
    lda #lo(irq);
    sta 0x314;
    lda #hi(irq);
    sta 0x315;

    // enabel raster irq
    lda #0b00000001;
    sta 0xD01A;

    cli;
    rts;
}

irq: {
    pha;

    // set wait flag
    // we can advance to next tick
    lda runtimeFlags;
    ora #0b00100000;
    sta runtimeFlags;
    asl 0xD019;

    lda cursorMoveDelay;
    beq skipDecCursorMove;
        dec cursorMoveDelay;
    skipDecCursorMove:

    lda flipDelay;
    beq skipDecFlip;
        dec flipDelay;
    skipDecFlip:

    pla;
    jmp 0xEA31; // basic irq
}
