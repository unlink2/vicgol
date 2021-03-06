let BASIC_MEMORY = 0x0801; // start of basic memory
let BAS_SYS = 0x9E;
let BSOUT = 0xFFD2; // prints A to screen
let BG_COLOR = 0xD021;
let BORDER_COLOR = 0xD020;

// screen

let SCREEN_BANK = 0x0400;
let SCREEN_BANK_OFFSET = 0x100;
let SCREENCTRL = 0xD011;
let RESETSCREEN = 0xE59A;

// keyboard
let PRA = 0xDC00; // (Port register) KB Matix cols
let DDRA = 0xDC02; // (Data direction)
let PRB = 0xDC01; // (Port register) KB Matrix rows
let DDRB = 0xDC03; // (Data direction)


// cel characters
let DEAD = 0x20; 
let ALIVE = 0x66; 

// built-in kernal routine
let SCREENPOSRESET = 0xE566;

// sprite
let SPRITEENABLE = 0xD015;
let cursorSpriteX = 0xD000;
let cursorSpriteY = 0xD001;
let cursorSpriteXBitMask = 0b10000000;
let cursorSpritePatternPtr = SCREEN_BANK+1016;

// frames
let DEFAULT_CURSOR_DELAY = 6;
let DEFAULT_FLIP_DELAY = 10;

// zero page
bss 0xFB {
    srcPtr 2,
    destPtr 2,
    // 7th bit -> exit
    // 6th bit -> pause game
    // 5th bit -> Raster IRQ was recently called -> game can advance to next tick
    runtimeFlags 1
}

bss 0x2A7 {
    cursorX 1,
    cursorY 1,
    // frames of delay
    cursorMoveDelay 1,
    flipDelay 1
}


