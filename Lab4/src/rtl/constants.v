parameter PIPE_WIDTH = 25;
parameter PIPE_HEIGHT_GAP = 90;
parameter BIRD_X = 100;
parameter BIRD_WIDTH = 17;
parameter BIRD_HEIGHT = 12;

parameter ACCEL = 2;
parameter MAX_VELOCITY = 64;
parameter Y_INIT = 200;
parameter SCREEN_HEIGHT = 480;
parameter SCREEN_WIDTH = 640;
parameter PADDING = 20;
parameter DELAY = 500;

parameter GC_TARGET = 500000;
parameter GC_SCALING_CONSTANT = 2000;

// video structure constants
parameter HPIXELS = 800;// horizontal pixels per line
parameter VLINES = 521; // vertical lines per frame
parameter HPULSE = 96;  // hsync pulse length
parameter VPULSE = 2;   // vsync pulse length
parameter HBP = 144;    // end of horizontal back porch
parameter HFP = 784;    // beginning of horizontal front porch
parameter VBP = 31;     // end of vertical back porch
parameter VFP = 511;    // beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

parameter BLACK_R = 3'b000;
parameter BLACK_G = 3'b000;
parameter BLACK_B = 2'b00;

parameter YELLOW1_R = 3'b111;
parameter YELLOW1_G = 3'b111;
parameter YELLOW1_B = 2'b00;

parameter YELLOW2_R = 3'b111;
parameter YELLOW2_G = 3'b110;
parameter YELLOW2_B = 2'b00;

parameter WHITE_R = 3'b111;
parameter WHITE_G = 3'b111;
parameter WHITE_B = 2'b11;

parameter ORANGE_R = 3'b111;
parameter ORANGE_G = 3'b100;
parameter ORANGE_B = 2'b00;

// constants for displaying letters on 7-segment display
parameter SEG_LEFT = 2'b00;
parameter SEG_MIDLEFT = 2'b01;
parameter SEG_MIDRIGHT = 2'b10;
parameter SEG_RIGHT = 2'b11;

parameter DISPLAY_0 = 7'b1000000;
parameter DISPLAY_1 = 7'b1111001;
parameter DISPLAY_2 = 7'b0100100;
parameter DISPLAY_3 = 7'b0110000;
parameter DISPLAY_4 = 7'b0011001;
parameter DISPLAY_5 = 7'b0010010;
parameter DISPLAY_6 = 7'b0000010;
parameter DISPLAY_7 = 7'b1111000;
parameter DISPLAY_8 = 7'b0000000;
parameter DISPLAY_9 = 7'b0010000;