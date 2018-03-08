`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NERP_demo_top(
	input wire clk,			//master clock = 50MHz
	input wire btnR,			//right-most pushbutton for reset
	input wire btnC,
	output wire [6:0] seg,	//7-segment display LEDs
	output wire [3:0] an,	//7-segment display anode enable
	output wire dp,			//7-segment display decimal point
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync			//vertical sync out
	);
`include "constants.v"
// 7-segment clock interconnect
wire segclk;

// VGA display clock interconnect
wire dclk;

// disable the 7-segment decimal points
assign dp = 1;


wire [10:0] bird_v;

wire [10:0] bird_y;

// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(btnR),
	.segclk(segclk),
	.dclk(dclk)
	);

// 7-segment display controller
segdisplay U2(
	.segclk(segclk),
	.clr(btnR),
	.seg(seg),
	.an(an)
	);


// VGA controller
vga640x480 U3(
	.dclk(dclk),
	.clr(btnR),
	.bird_y(bird_y),
	/*.pipe1_x(pipe1_x),
	.pipe2_x(pipe2_x),
	.pipe1_y(pipe1_y),
	.pipe2_y(pipe2_y),*/
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue)
	);

birdMovement bm(
	 .gameClk(segclk),
    .button(btnC),
    .reset(btnR),
    .finished(0),
    .y_out(bird_y),
	 .v_out(bird_v)
);
endmodule
