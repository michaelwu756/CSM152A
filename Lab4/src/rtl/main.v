`timescale 1ns / 1ps
module main(
   input wire clk,         //master clock = 50MHz
   input wire btnR,        //right-most pushbutton for reset
   input wire btnC,
   output wire [6:0] seg,  //7-segment display LEDs
   output wire [3:0] an,   //7-segment display anode enable
   output wire dp,         //7-segment display decimal point
   output wire [2:0] red,  //red vga output - 3 bits
   output wire [2:0] green,//green vga output - 3 bits
   output wire [1:0] blue, //blue vga output - 2 bits
   output wire hsync,      //horizontal sync out
   output wire vsync       //vertical sync out
   );

`include "constants.v"

// 7-segment clock interconnect
wire segclk;

// VGA display clock interconnect
wire dclk;
wire gameclk;
// disable the 7-segment decimal points
assign dp = 1;

reg btnCDownSample;
reg btnCClicked;
reg finished;

wire [10:0] bird_v;

wire hitColumn;
wire passColumn;
wire [10:0] pipe1_x;
wire [10:0] pipe1_y;
wire [10:0] pipe2_x;
wire [10:0] pipe2_y;
wire [10:0] bird_y;
wire [9:0] score;

always @ (posedge gameclk or posedge btnR)
   if (btnR) begin
      btnCDownSample <= 0;
      btnCClicked <= 0;
      finished <= 0;
   end
   else begin
      if(hitColumn)
         finished <= 1;
      btnCClicked <= btnC & !btnCDownSample;
      btnCDownSample <= btnC;
   end

// generate 7-segment clock & display clock
clockdiv clocks(
   .clk(clk),
   .score(0),
   .clr(btnR),
   .segclk(segclk),
   .dclk(dclk),
   .gameclk(gameclk)
);

// 7-segment display controller
segdisplay segdisp(
   .segclk(segclk),
   .clr(btnR),
   .score(score),
   .seg(seg),
   .an(an)
);

// VGA controller
vga640x480 vga(
   .dclk(dclk),
   .clr(btnR),
   .bird_y(SCREEN_HEIGHT - bird_y),
   .pipe1_x(pipe1_x),
   .pipe1_y(SCREEN_HEIGHT - pipe1_y),
   .pipe2_x(pipe2_x),
   .pipe2_y(SCREEN_HEIGHT - pipe2_y),
   .hsync(hsync),
   .vsync(vsync),
   .red(red),
   .green(green),
   .blue(blue)
);

birdMovement bm(
   .gameClk(gameclk),
   .button(btnCClicked),
   .reset(btnR),
   .finished(finished),
   .y_out(bird_y),
   .v_out(bird_v)
);

columnGen cg(.gameClk(gameclk),
   .reset(btnR),
   .finished(finished),
   .Ax(pipe1_x),
   .Ay(pipe1_y),
   .Bx(pipe2_x),
   .By(pipe2_y),
   .passColumn(passColumn)
);

collisionDetection cd(
   .gameClk(gameclk),
   .Ax(pipe1_x),
   .Ay(pipe1_y),
   .Bx(pipe2_x),
   .By(pipe2_y),
   .y_in(bird_y),
   .reset(btnR),
   .hitColumn(hitColumn)
);

calcScore cs(
   .game_clk(gameclk),
   .reset(btnR),
   .passColumn(passColumn),
   .score_out(score)
);

endmodule