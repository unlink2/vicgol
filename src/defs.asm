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

// zero page
bss 0xFB {
    srcPtr 2,
    destPtr 2,
    // 7th bit -> exit
    runtimeFlags 1
}

bss 0x2A7 {
    cursorX 1,
    cursorY 1
}


