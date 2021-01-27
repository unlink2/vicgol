fn getScreenBank(banknum) {
    return SCREEN_BANK+banknum*SCREEN_BANK_OFFSET;
}

fn defstrScreenCodeC64(str) {
    for (let i = 0; i < len(str); i = i + 1) {
        let c = str[i];
        if ((c >= 64 && c <= 95) || (c >= 160 && c <= 191)) {
            db c-64;
        } else if (c >= 31 && c <= 63) {
            db c;
        }
        // TODO add the rest (https://sta.c64.org/cbm64scrtopet.html)
    }
}

fn strcpy(src, dest) {
    lda #lo(src);
    sta srcPtr;
    lda #hi(src);
    sta srcPtr+1;
    lda #lo(dest);
    sta destPtr;
    lda #hi(dest);
    sta destPtr+1;
    jsr gol_strcpy;
}
