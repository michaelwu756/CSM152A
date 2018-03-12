parameter pipe_width=25;
parameter pipe_height_gap=90;
parameter bird_x=100;
parameter bird_width=10;
parameter bird_height=10;

parameter ACCEL = 4;
parameter MAX_VELOCITY = 256;
parameter Y_INIT = 200;
parameter SCREEN_HEIGHT=480;
parameter SCREEN_WIDTH=640;
parameter COL_WIDTH = 20;
parameter GAP_HEIGHT = 100;
parameter PADDING = 20;

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480