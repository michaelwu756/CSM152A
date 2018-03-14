`timescale 1ns / 1ps
module vga640x480(
   input wire dclk,        //pixel clock: 25MHz
   input wire clr,         //asynchronous reset
   input wire [10:0] bird_y,
   input wire [10:0] pipe1_x,
   input wire [10:0] pipe1_y,
   input wire [10:0] pipe2_x,
   input wire [10:0] pipe2_y,
   output wire hsync,      //horizontal sync out
   output wire vsync,      //vertical sync out
   output reg [2:0] red,   //red vga output
   output reg [2:0] green, //green vga output
   output reg [1:0] blue   //blue vga output
);

`include "constants.v"

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr) begin
   // reset condition
   if (clr == 1) begin
      hc <= 0;
      vc <= 0;
   end
   else begin
      // keep counting until the end of the line
      if (hc < HPIXELS - 1)
         hc <= hc + 1;
      else begin
         // When we hit the end of the line, reset the horizontal
         // counter and increment the vertical counter.
         // If vertical counter is at the end of the frame, then
         // reset that one too.
         hc <= 0;
         if (vc < VLINES - 1)
            vc <= vc + 1;
         else
            vc <= 0;
      end
   end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < HPULSE) ? 0 : 1;
assign vsync = (vc < VPULSE) ? 0 : 1;

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =

wire [10:0] pipe1_min_x;
wire [10:0] pipe1_max_x;
wire [10:0] pipe1_min_y; 
wire [10:0] pipe1_max_y;
assign pipe1_min_x = pipe1_x - PIPE_WIDTH + HBP;
assign pipe1_max_x = pipe1_x + PIPE_WIDTH + HBP;
assign pipe1_min_y = pipe1_y - PIPE_HEIGHT_GAP + VBP;
assign pipe1_max_y = pipe1_y + PIPE_HEIGHT_GAP + VBP;

wire [10:0] pipe2_min_x;
wire [10:0] pipe2_max_x;
wire [10:0] pipe2_min_y; 
wire [10:0] pipe2_max_y;
assign pipe2_min_x = pipe2_x - PIPE_WIDTH + HBP;
assign pipe2_max_x = pipe2_x + PIPE_WIDTH + HBP;
assign pipe2_min_y = pipe2_y - PIPE_HEIGHT_GAP + VBP;
assign pipe2_max_y = pipe2_y + PIPE_HEIGHT_GAP + VBP;

wire [10:0] bird_min_x;
wire [10:0] bird_max_x;
wire [10:0] bird_min_y; 
wire [10:0] bird_max_y;
assign bird_min_x = BIRD_X - BIRD_WIDTH + HBP;
assign bird_max_x = BIRD_X + BIRD_WIDTH + HBP;
assign bird_min_y = bird_y - BIRD_HEIGHT + VBP;
assign bird_max_y = bird_y + BIRD_HEIGHT + VBP;

task showBlack;
   begin
      red = BLACK_R;
      green = BLACK_G;
      blue = BLACK_B;
   end
endtask

task showYellow1;
   begin
      red = YELLOW1_R;
      green = YELLOW1_G;
      blue = YELLOW1_B;
   end
endtask

task showYellow2;
   begin
      red = YELLOW2_R;
      green = YELLOW2_G;
      blue = YELLOW2_B;
   end
endtask

task showWhite;
   begin
      red = WHITE_R;
      green = WHITE_G;
      blue = WHITE_B;
   end
endtask

task showOrange;
   begin
      red = ORANGE_R;
      green = ORANGE_G;
      blue = ORANGE_B;
   end
endtask

task showLightGreen;
   begin
      red = LIGHT_GREEN_R;
      green = LIGHT_GREEN_G;
      blue = LIGHT_GREEN_B;
   end
endtask

task showMediumGreen;
   begin
      red = MEDIUM_GREEN_R;
      green = MEDIUM_GREEN_G;
      blue = MEDIUM_GREEN_B;
   end
endtask

task showGreen;
   begin
      red = GREEN_R;
      green = GREEN_G;
      blue = GREEN_B;
   end
endtask

task showDarkGreen;
   begin
      red = DARK_GREEN_R;
      green = DARK_GREEN_G;
      blue = DARK_GREEN_B;
   end
endtask

task showBackground;
   begin
      red = BACKGROUND_R;
      green = BACKGROUND_G;
      blue = BACKGROUND_B;
   end
endtask

always @(*) begin
   // first check if we're within vertical active video range
   if (vc >= VBP && vc < VFP && hc >= HBP && hc < HFP) begin
      //border
      if (hc == HBP || hc == HFP - 1 || vc == VBP || vc == VFP - 1) begin
         red = 3'b111;
         green = 3'b000;
         blue = 2'b00;
      end
      //display bird
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 2)
         showWhite();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 2)
         showWhite();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 3)
         showWhite();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 3)
         showWhite();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 5)
         showBlack();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 5)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 5)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 5)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 5)
         showBlack();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 5)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 6)
         showWhite();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 6)
         showWhite();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 6)
         showWhite();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 6)
         showWhite();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 6)
         showWhite();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 6)
         showWhite();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 7)
         showWhite();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 7)
         showWhite();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 7)
         showWhite();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 7)
         showWhite();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 7)
         showWhite();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 7)
         showWhite();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 0 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 1 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 8)
         showYellow1();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 8)
         showYellow1();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 8)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 8)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 8)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 8)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 8)
         showWhite();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 0 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 1 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 9)
         showYellow1();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 9)
         showYellow1();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 9)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 9)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 9)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 9)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 9)
         showWhite();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 0 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 1 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 10)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 10)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 10)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 10)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 10)
         showYellow1();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 10)
         showYellow1();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 10)
         showWhite();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 0 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 1 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 11)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 11)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 11)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 11)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 11)
         showYellow1();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 11)
         showYellow1();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 11)
         showWhite();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 0 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 1 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 12)
         showWhite();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 12)
         showWhite();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 12)
         showWhite();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 12)
         showWhite();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 12)
         showWhite();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 12)
         showWhite();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 12)
         showYellow1();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 30 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 31 && vc == bird_min_y + 12)
         showBlack();
      else if (hc == bird_min_x + 0 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 1 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 13)
         showWhite();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 13)
         showWhite();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 13)
         showWhite();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 13)
         showWhite();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 13)
         showWhite();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 13)
         showWhite();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 13)
         showYellow1();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 30 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 31 && vc == bird_min_y + 13)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 14)
         showBlack();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 14)
         showBlack();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 14)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 14)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 14)
         showYellow1();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 14)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 14)
         showBlack();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 14)
         showOrange();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 14)
         showOrange();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 14)
         showOrange();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 14)
         showOrange();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 14)
         showOrange();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 14)
         showOrange();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 14)
         showOrange();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 14)
         showOrange();
      else if (hc == bird_min_x + 30 && vc == bird_min_y + 14)
         showOrange();
      else if (hc == bird_min_x + 31 && vc == bird_min_y + 14)
         showOrange();
      else if (hc == bird_min_x + 32 && vc == bird_min_y + 14)
         showBlack();
      else if (hc == bird_min_x + 33 && vc == bird_min_y + 14)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 15)
         showBlack();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 15)
         showBlack();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 15)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 15)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 15)
         showYellow1();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 15)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 15)
         showBlack();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 15)
         showOrange();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 15)
         showOrange();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 15)
         showOrange();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 15)
         showOrange();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 15)
         showOrange();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 15)
         showOrange();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 15)
         showOrange();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 15)
         showOrange();
      else if (hc == bird_min_x + 30 && vc == bird_min_y + 15)
         showOrange();
      else if (hc == bird_min_x + 31 && vc == bird_min_y + 15)
         showOrange();
      else if (hc == bird_min_x + 32 && vc == bird_min_y + 15)
         showBlack();
      else if (hc == bird_min_x + 33 && vc == bird_min_y + 15)
         showBlack();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 16)
         showYellow2();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 16)
         showYellow2();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 16)
         showYellow2();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 16)
         showYellow2();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 16)
         showYellow2();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 16)
         showYellow2();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 16)
         showYellow2();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 16)
         showYellow2();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 16)
         showOrange();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 16)
         showOrange();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 30 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 31 && vc == bird_min_y + 16)
         showBlack();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 17)
         showYellow2();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 17)
         showYellow2();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 17)
         showYellow2();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 17)
         showYellow2();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 17)
         showYellow2();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 17)
         showYellow2();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 17)
         showYellow2();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 17)
         showYellow2();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 17)
         showOrange();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 17)
         showOrange();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 30 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 31 && vc == bird_min_y + 17)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 18)
         showBlack();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 18)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 18)
         showYellow2();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 18)
         showYellow2();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 18)
         showYellow2();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 18)
         showYellow2();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 18)
         showYellow2();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 18)
         showYellow2();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 18)
         showYellow2();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 18)
         showYellow2();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 18)
         showYellow2();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 18)
         showYellow2();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 18)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 18)
         showBlack();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 18)
         showOrange();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 18)
         showOrange();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 18)
         showOrange();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 18)
         showOrange();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 18)
         showOrange();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 18)
         showOrange();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 18)
         showOrange();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 18)
         showOrange();
      else if (hc == bird_min_x + 30 && vc == bird_min_y + 18)
         showBlack();
      else if (hc == bird_min_x + 31 && vc == bird_min_y + 18)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 19)
         showBlack();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 19)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 19)
         showYellow2();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 19)
         showYellow2();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 19)
         showYellow2();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 19)
         showYellow2();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 19)
         showYellow2();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 19)
         showYellow2();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 19)
         showYellow2();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 19)
         showYellow2();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 19)
         showYellow2();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 19)
         showYellow2();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 19)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 19)
         showBlack();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 19)
         showOrange();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 19)
         showOrange();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 19)
         showOrange();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 19)
         showOrange();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 19)
         showOrange();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 19)
         showOrange();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 19)
         showOrange();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 19)
         showOrange();
      else if (hc == bird_min_x + 30 && vc == bird_min_y + 19)
         showBlack();
      else if (hc == bird_min_x + 31 && vc == bird_min_y + 19)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 20)
         showYellow2();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 20)
         showYellow2();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 20)
         showYellow2();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 20)
         showYellow2();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 20)
         showYellow2();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 20)
         showYellow2();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 20)
         showYellow2();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 20)
         showYellow2();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 30 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 31 && vc == bird_min_y + 20)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 21)
         showYellow2();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 21)
         showYellow2();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 21)
         showYellow2();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 21)
         showYellow2();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 21)
         showYellow2();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 21)
         showYellow2();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 21)
         showYellow2();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 21)
         showYellow2();
      else if (hc == bird_min_x + 22 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 23 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 24 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 25 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 26 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 27 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 28 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 29 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 30 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 31 && vc == bird_min_y + 21)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 22)
         showBlack();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 22)
         showBlack();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 22)
         showBlack();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 22)
         showBlack();
      else if (hc == bird_min_x + 18 && vc == bird_min_y + 22)
         showBlack();
      else if (hc == bird_min_x + 19 && vc == bird_min_y + 22)
         showBlack();
      else if (hc == bird_min_x + 20 && vc == bird_min_y + 22)
         showBlack();
      else if (hc == bird_min_x + 21 && vc == bird_min_y + 22)
         showBlack();
      //display pipes
      else if (((vc >= pipe1_min_y - 2 && vc < pipe1_min_y) || (vc >= pipe1_max_y && vc < pipe1_max_y + 2)) && (hc >= pipe1_min_x && hc < pipe1_max_x))
         showBlack();
      else if (((vc >= pipe1_min_y - 4 && vc < pipe1_min_y - 2) || (vc >= pipe1_max_y + 2 && vc < pipe1_max_y + 4)) && (hc >= pipe1_min_x && hc < pipe1_max_x)) begin
         if (hc == pipe1_min_x + 0)
            showBlack();
         else if (hc == pipe1_min_x + 1)
            showBlack();
         else if (hc == pipe1_min_x + 2)
            showMediumGreen();
         else if (hc == pipe1_min_x + 3)
            showMediumGreen();
         else if (hc == pipe1_min_x + 4)
            showMediumGreen();
         else if (hc == pipe1_min_x + 5)
            showMediumGreen();
         else if (hc == pipe1_min_x + 6)
            showLightGreen();
         else if (hc == pipe1_min_x + 7)
            showLightGreen();
         else if (hc == pipe1_min_x + 8)
            showLightGreen();
         else if (hc == pipe1_min_x + 9)
            showLightGreen();
         else if (hc == pipe1_min_x + 10)
            showLightGreen();
         else if (hc == pipe1_min_x + 11)
            showLightGreen();
         else if (hc == pipe1_min_x + 12)
            showLightGreen();
         else if (hc == pipe1_min_x + 13)
            showLightGreen();
         else if (hc == pipe1_min_x + 14)
            showLightGreen();
         else if (hc == pipe1_min_x + 15)
            showLightGreen();
         else if (hc == pipe1_min_x + 16)
            showLightGreen();
         else if (hc == pipe1_min_x + 17)
            showLightGreen();
         else if (hc == pipe1_min_x + 18)
            showLightGreen();
         else if (hc == pipe1_min_x + 19)
            showLightGreen();
         else if (hc == pipe1_min_x + 20)
            showLightGreen();
         else if (hc == pipe1_min_x + 21)
            showLightGreen();
         else if (hc == pipe1_min_x + 22)
            showLightGreen();
         else if (hc == pipe1_min_x + 23)
            showLightGreen();
         else if (hc == pipe1_min_x + 24)
            showLightGreen();
         else if (hc == pipe1_min_x + 25)
            showLightGreen();
         else if (hc == pipe1_min_x + 26)
            showLightGreen();
         else if (hc == pipe1_min_x + 27)
            showLightGreen();
         else if (hc == pipe1_min_x + 28)
            showLightGreen();
         else if (hc == pipe1_min_x + 29)
            showLightGreen();
         else if (hc == pipe1_min_x + 30)
            showLightGreen();
         else if (hc == pipe1_min_x + 31)
            showLightGreen();
         else if (hc == pipe1_min_x + 32)
            showGreen();
         else if (hc == pipe1_min_x + 33)
            showGreen();
         else if (hc == pipe1_min_x + 34)
            showLightGreen();
         else if (hc == pipe1_min_x + 35)
            showLightGreen();
         else if (hc == pipe1_min_x + 36)
            showMediumGreen();
         else if (hc == pipe1_min_x + 37)
            showMediumGreen();
         else if (hc == pipe1_min_x + 38)
            showMediumGreen();
         else if (hc == pipe1_min_x + 39)
            showMediumGreen();
         else if (hc == pipe1_min_x + 40)
            showMediumGreen();
         else if (hc == pipe1_min_x + 41)
            showMediumGreen();
         else if (hc == pipe1_min_x + 42)
            showMediumGreen();
         else if (hc == pipe1_min_x + 43)
            showMediumGreen();
         else if (hc == pipe1_min_x + 44)
            showMediumGreen();
         else if (hc == pipe1_min_x + 45)
            showMediumGreen();
         else if (hc == pipe1_min_x + 46)
            showDarkGreen();
         else if (hc == pipe1_min_x + 47)
            showDarkGreen();
         else if (hc == pipe1_min_x + 48)
            showBlack();
         else if (hc == pipe1_min_x + 49)
            showBlack();
      end
      else if (((vc >= pipe1_min_y - 16 && vc < pipe1_min_y - 4) || (vc >= pipe1_max_y + 4 && vc < pipe1_max_y + 16)) && (hc >= pipe1_min_x && hc < pipe1_max_x)) begin
         if (hc == pipe1_min_x + 0)
            showBlack();
         else if (hc == pipe1_min_x + 1)
            showBlack();
         else if (hc == pipe1_min_x + 2)
            showMediumGreen();
         else if (hc == pipe1_min_x + 3)
            showMediumGreen();
         else if (hc == pipe1_min_x + 4)
            showLightGreen();
         else if (hc == pipe1_min_x + 5)
            showLightGreen();
         else if (hc == pipe1_min_x + 6)
            showMediumGreen();
         else if (hc == pipe1_min_x + 7)
            showMediumGreen();
         else if (hc == pipe1_min_x + 8)
            showMediumGreen();
         else if (hc == pipe1_min_x + 9)
            showMediumGreen();
         else if (hc == pipe1_min_x + 10)
            showGreen();
         else if (hc == pipe1_min_x + 11)
            showGreen();
         else if (hc == pipe1_min_x + 12)
            showMediumGreen();
         else if (hc == pipe1_min_x + 13)
            showMediumGreen();
         else if (hc == pipe1_min_x + 14)
            showGreen();
         else if (hc == pipe1_min_x + 15)
            showGreen();
         else if (hc == pipe1_min_x + 16)
            showGreen();
         else if (hc == pipe1_min_x + 17)
            showGreen();
         else if (hc == pipe1_min_x + 18)
            showGreen();
         else if (hc == pipe1_min_x + 19)
            showGreen();
         else if (hc == pipe1_min_x + 20)
            showGreen();
         else if (hc == pipe1_min_x + 21)
            showGreen();
         else if (hc == pipe1_min_x + 22)
            showGreen();
         else if (hc == pipe1_min_x + 23)
            showGreen();
         else if (hc == pipe1_min_x + 24)
            showGreen();
         else if (hc == pipe1_min_x + 25)
            showGreen();
         else if (hc == pipe1_min_x + 26)
            showGreen();
         else if (hc == pipe1_min_x + 27)
            showGreen();
         else if (hc == pipe1_min_x + 28)
            showGreen();
         else if (hc == pipe1_min_x + 29)
            showGreen();
         else if (hc == pipe1_min_x + 30)
            showGreen();
         else if (hc == pipe1_min_x + 31)
            showGreen();
         else if (hc == pipe1_min_x + 32)
            showGreen();
         else if (hc == pipe1_min_x + 33)
            showGreen();
         else if (hc == pipe1_min_x + 34)
            showGreen();
         else if (hc == pipe1_min_x + 35)
            showGreen();
         else if (hc == pipe1_min_x + 36)
            showGreen();
         else if (hc == pipe1_min_x + 37)
            showGreen();
         else if (hc == pipe1_min_x + 38)
            showGreen();
         else if (hc == pipe1_min_x + 39)
            showGreen();
         else if (hc == pipe1_min_x + 40)
            showDarkGreen();
         else if (hc == pipe1_min_x + 41)
            showDarkGreen();
         else if (hc == pipe1_min_x + 42)
            showGreen();
         else if (hc == pipe1_min_x + 43)
            showGreen();
         else if (hc == pipe1_min_x + 44)
            showDarkGreen();
         else if (hc == pipe1_min_x + 45)
            showDarkGreen();
         else if (hc == pipe1_min_x + 46)
            showDarkGreen();
         else if (hc == pipe1_min_x + 47)
            showDarkGreen();
         else if (hc == pipe1_min_x + 48)
            showBlack();
         else if (hc == pipe1_min_x + 49)
            showBlack();
      end
      else if (((vc >= pipe1_min_y - 18 && vc < pipe1_min_y - 16) || (vc >= pipe1_max_y + 16 && vc < pipe1_max_y + 18)) && (hc >= pipe1_min_x && hc < pipe1_max_x)) begin
         if (hc == pipe1_min_x + 0)
            showBlack();
         else if (hc == pipe1_min_x + 1)
            showBlack();
         else if (hc == pipe1_min_x + 2)
            showDarkGreen();
         else if (hc == pipe1_min_x + 3)
            showDarkGreen();
         else if (hc == pipe1_min_x + 4)
            showDarkGreen();
         else if (hc == pipe1_min_x + 5)
            showDarkGreen();
         else if (hc == pipe1_min_x + 6)
            showDarkGreen();
         else if (hc == pipe1_min_x + 7)
            showDarkGreen();
         else if (hc == pipe1_min_x + 8)
            showDarkGreen();
         else if (hc == pipe1_min_x + 9)
            showDarkGreen();
         else if (hc == pipe1_min_x + 10)
            showDarkGreen();
         else if (hc == pipe1_min_x + 11)
            showDarkGreen();
         else if (hc == pipe1_min_x + 12)
            showDarkGreen();
         else if (hc == pipe1_min_x + 13)
            showDarkGreen();
         else if (hc == pipe1_min_x + 14)
            showDarkGreen();
         else if (hc == pipe1_min_x + 15)
            showDarkGreen();
         else if (hc == pipe1_min_x + 16)
            showDarkGreen();
         else if (hc == pipe1_min_x + 17)
            showDarkGreen();
         else if (hc == pipe1_min_x + 18)
            showDarkGreen();
         else if (hc == pipe1_min_x + 19)
            showDarkGreen();
         else if (hc == pipe1_min_x + 20)
            showDarkGreen();
         else if (hc == pipe1_min_x + 21)
            showDarkGreen();
         else if (hc == pipe1_min_x + 22)
            showDarkGreen();
         else if (hc == pipe1_min_x + 23)
            showDarkGreen();
         else if (hc == pipe1_min_x + 24)
            showDarkGreen();
         else if (hc == pipe1_min_x + 25)
            showDarkGreen();
         else if (hc == pipe1_min_x + 26)
            showDarkGreen();
         else if (hc == pipe1_min_x + 27)
            showDarkGreen();
         else if (hc == pipe1_min_x + 28)
            showDarkGreen();
         else if (hc == pipe1_min_x + 29)
            showDarkGreen();
         else if (hc == pipe1_min_x + 30)
            showDarkGreen();
         else if (hc == pipe1_min_x + 31)
            showDarkGreen();
         else if (hc == pipe1_min_x + 32)
            showDarkGreen();
         else if (hc == pipe1_min_x + 33)
            showDarkGreen();
         else if (hc == pipe1_min_x + 34)
            showDarkGreen();
         else if (hc == pipe1_min_x + 35)
            showDarkGreen();
         else if (hc == pipe1_min_x + 36)
            showDarkGreen();
         else if (hc == pipe1_min_x + 37)
            showDarkGreen();
         else if (hc == pipe1_min_x + 38)
            showDarkGreen();
         else if (hc == pipe1_min_x + 39)
            showDarkGreen();
         else if (hc == pipe1_min_x + 40)
            showDarkGreen();
         else if (hc == pipe1_min_x + 41)
            showDarkGreen();
         else if (hc == pipe1_min_x + 42)
            showDarkGreen();
         else if (hc == pipe1_min_x + 43)
            showDarkGreen();
         else if (hc == pipe1_min_x + 44)
            showDarkGreen();
         else if (hc == pipe1_min_x + 45)
            showDarkGreen();
         else if (hc == pipe1_min_x + 46)
            showDarkGreen();
         else if (hc == pipe1_min_x + 47)
            showDarkGreen();
         else if (hc == pipe1_min_x + 48)
            showBlack();
         else if (hc == pipe1_min_x + 49)
            showBlack();
      end
      else if (((vc >= pipe1_min_y - 20 && vc < pipe1_min_y - 18) || (vc >= pipe1_max_y + 18 && vc < pipe1_max_y + 20)) && (hc >= pipe1_min_x && hc < pipe1_max_x))
         showBlack();
      else if ((vc < pipe1_min_y - 18 || vc >= pipe1_max_y + 20) && (hc >= pipe1_min_x + 2 && hc < pipe1_max_x - 2)) begin
         if (hc == pipe1_min_x + 2)
            showBlack();
         else if (hc == pipe1_min_x + 3)
            showBlack();
         else if (hc == pipe1_min_x + 4)
            showMediumGreen();
         else if (hc == pipe1_min_x + 5)
            showMediumGreen();
         else if (hc == pipe1_min_x + 6)
            showLightGreen();
         else if (hc == pipe1_min_x + 7)
            showLightGreen();
         else if (hc == pipe1_min_x + 8)
            showMediumGreen();
         else if (hc == pipe1_min_x + 9)
            showMediumGreen();
         else if (hc == pipe1_min_x + 10)
            showMediumGreen();
         else if (hc == pipe1_min_x + 11)
            showMediumGreen();
         else if (hc == pipe1_min_x + 12)
            showMediumGreen();
         else if (hc == pipe1_min_x + 13)
            showMediumGreen();
         else if (hc == pipe1_min_x + 14)
            showGreen();
         else if (hc == pipe1_min_x + 15)
            showGreen();
         else if (hc == pipe1_min_x + 16)
            showMediumGreen();
         else if (hc == pipe1_min_x + 17)
            showMediumGreen();
         else if (hc == pipe1_min_x + 18)
            showGreen();
         else if (hc == pipe1_min_x + 19)
            showGreen();
         else if (hc == pipe1_min_x + 20)
            showGreen();
         else if (hc == pipe1_min_x + 21)
            showGreen();
         else if (hc == pipe1_min_x + 22)
            showGreen();
         else if (hc == pipe1_min_x + 23)
            showGreen();
         else if (hc == pipe1_min_x + 24)
            showGreen();
         else if (hc == pipe1_min_x + 25)
            showGreen();
         else if (hc == pipe1_min_x + 26)
            showGreen();
         else if (hc == pipe1_min_x + 27)
            showGreen();
         else if (hc == pipe1_min_x + 28)
            showGreen();
         else if (hc == pipe1_min_x + 29)
            showGreen();
         else if (hc == pipe1_min_x + 30)
            showGreen();
         else if (hc == pipe1_min_x + 31)
            showGreen();
         else if (hc == pipe1_min_x + 32)
            showGreen();
         else if (hc == pipe1_min_x + 33)
            showGreen();
         else if (hc == pipe1_min_x + 34)
            showGreen();
         else if (hc == pipe1_min_x + 35)
            showGreen();
         else if (hc == pipe1_min_x + 36)
            showGreen();
         else if (hc == pipe1_min_x + 37)
            showGreen();
         else if (hc == pipe1_min_x + 38)
            showDarkGreen();
         else if (hc == pipe1_min_x + 39)
            showDarkGreen();
         else if (hc == pipe1_min_x + 40)
            showMediumGreen();
         else if (hc == pipe1_min_x + 41)
            showMediumGreen();
         else if (hc == pipe1_min_x + 42)
            showDarkGreen();
         else if (hc == pipe1_min_x + 43)
            showDarkGreen();
         else if (hc == pipe1_min_x + 44)
            showDarkGreen();
         else if (hc == pipe1_min_x + 45)
            showDarkGreen();
         else if (hc == pipe1_min_x + 46)
            showBlack();
         else if (hc == pipe1_min_x + 47)
            showBlack();
      end
      else if (((vc >= pipe2_min_y - 2 && vc < pipe2_min_y) || (vc >= pipe2_max_y && vc < pipe2_max_y + 2)) && (hc >= pipe2_min_x && hc < pipe2_max_x))
         showBlack();
      else if (((vc >= pipe2_min_y - 4 && vc < pipe2_min_y - 2) || (vc >= pipe2_max_y + 2 && vc < pipe2_max_y + 4)) && (hc >= pipe2_min_x && hc < pipe2_max_x)) begin
         if (hc == pipe2_min_x + 0)
            showBlack();
         else if (hc == pipe2_min_x + 1)
            showBlack();
         else if (hc == pipe2_min_x + 2)
            showMediumGreen();
         else if (hc == pipe2_min_x + 3)
            showMediumGreen();
         else if (hc == pipe2_min_x + 4)
            showMediumGreen();
         else if (hc == pipe2_min_x + 5)
            showMediumGreen();
         else if (hc == pipe2_min_x + 6)
            showLightGreen();
         else if (hc == pipe2_min_x + 7)
            showLightGreen();
         else if (hc == pipe2_min_x + 8)
            showLightGreen();
         else if (hc == pipe2_min_x + 9)
            showLightGreen();
         else if (hc == pipe2_min_x + 10)
            showLightGreen();
         else if (hc == pipe2_min_x + 11)
            showLightGreen();
         else if (hc == pipe2_min_x + 12)
            showLightGreen();
         else if (hc == pipe2_min_x + 13)
            showLightGreen();
         else if (hc == pipe2_min_x + 14)
            showLightGreen();
         else if (hc == pipe2_min_x + 15)
            showLightGreen();
         else if (hc == pipe2_min_x + 16)
            showLightGreen();
         else if (hc == pipe2_min_x + 17)
            showLightGreen();
         else if (hc == pipe2_min_x + 18)
            showLightGreen();
         else if (hc == pipe2_min_x + 19)
            showLightGreen();
         else if (hc == pipe2_min_x + 20)
            showLightGreen();
         else if (hc == pipe2_min_x + 21)
            showLightGreen();
         else if (hc == pipe2_min_x + 22)
            showLightGreen();
         else if (hc == pipe2_min_x + 23)
            showLightGreen();
         else if (hc == pipe2_min_x + 24)
            showLightGreen();
         else if (hc == pipe2_min_x + 25)
            showLightGreen();
         else if (hc == pipe2_min_x + 26)
            showLightGreen();
         else if (hc == pipe2_min_x + 27)
            showLightGreen();
         else if (hc == pipe2_min_x + 28)
            showLightGreen();
         else if (hc == pipe2_min_x + 29)
            showLightGreen();
         else if (hc == pipe2_min_x + 30)
            showLightGreen();
         else if (hc == pipe2_min_x + 31)
            showLightGreen();
         else if (hc == pipe2_min_x + 32)
            showGreen();
         else if (hc == pipe2_min_x + 33)
            showGreen();
         else if (hc == pipe2_min_x + 34)
            showLightGreen();
         else if (hc == pipe2_min_x + 35)
            showLightGreen();
         else if (hc == pipe2_min_x + 36)
            showMediumGreen();
         else if (hc == pipe2_min_x + 37)
            showMediumGreen();
         else if (hc == pipe2_min_x + 38)
            showMediumGreen();
         else if (hc == pipe2_min_x + 39)
            showMediumGreen();
         else if (hc == pipe2_min_x + 40)
            showMediumGreen();
         else if (hc == pipe2_min_x + 41)
            showMediumGreen();
         else if (hc == pipe2_min_x + 42)
            showMediumGreen();
         else if (hc == pipe2_min_x + 43)
            showMediumGreen();
         else if (hc == pipe2_min_x + 44)
            showMediumGreen();
         else if (hc == pipe2_min_x + 45)
            showMediumGreen();
         else if (hc == pipe2_min_x + 46)
            showDarkGreen();
         else if (hc == pipe2_min_x + 47)
            showDarkGreen();
         else if (hc == pipe2_min_x + 48)
            showBlack();
         else if (hc == pipe2_min_x + 49)
            showBlack();
      end
      else if (((vc >= pipe2_min_y - 16 && vc < pipe2_min_y - 4) || (vc >= pipe2_max_y + 4 && vc < pipe2_max_y + 16)) && (hc >= pipe2_min_x && hc < pipe2_max_x)) begin
         if (hc == pipe2_min_x + 0)
            showBlack();
         else if (hc == pipe2_min_x + 1)
            showBlack();
         else if (hc == pipe2_min_x + 2)
            showMediumGreen();
         else if (hc == pipe2_min_x + 3)
            showMediumGreen();
         else if (hc == pipe2_min_x + 4)
            showLightGreen();
         else if (hc == pipe2_min_x + 5)
            showLightGreen();
         else if (hc == pipe2_min_x + 6)
            showMediumGreen();
         else if (hc == pipe2_min_x + 7)
            showMediumGreen();
         else if (hc == pipe2_min_x + 8)
            showMediumGreen();
         else if (hc == pipe2_min_x + 9)
            showMediumGreen();
         else if (hc == pipe2_min_x + 10)
            showGreen();
         else if (hc == pipe2_min_x + 11)
            showGreen();
         else if (hc == pipe2_min_x + 12)
            showMediumGreen();
         else if (hc == pipe2_min_x + 13)
            showMediumGreen();
         else if (hc == pipe2_min_x + 14)
            showGreen();
         else if (hc == pipe2_min_x + 15)
            showGreen();
         else if (hc == pipe2_min_x + 16)
            showGreen();
         else if (hc == pipe2_min_x + 17)
            showGreen();
         else if (hc == pipe2_min_x + 18)
            showGreen();
         else if (hc == pipe2_min_x + 19)
            showGreen();
         else if (hc == pipe2_min_x + 20)
            showGreen();
         else if (hc == pipe2_min_x + 21)
            showGreen();
         else if (hc == pipe2_min_x + 22)
            showGreen();
         else if (hc == pipe2_min_x + 23)
            showGreen();
         else if (hc == pipe2_min_x + 24)
            showGreen();
         else if (hc == pipe2_min_x + 25)
            showGreen();
         else if (hc == pipe2_min_x + 26)
            showGreen();
         else if (hc == pipe2_min_x + 27)
            showGreen();
         else if (hc == pipe2_min_x + 28)
            showGreen();
         else if (hc == pipe2_min_x + 29)
            showGreen();
         else if (hc == pipe2_min_x + 30)
            showGreen();
         else if (hc == pipe2_min_x + 31)
            showGreen();
         else if (hc == pipe2_min_x + 32)
            showGreen();
         else if (hc == pipe2_min_x + 33)
            showGreen();
         else if (hc == pipe2_min_x + 34)
            showGreen();
         else if (hc == pipe2_min_x + 35)
            showGreen();
         else if (hc == pipe2_min_x + 36)
            showGreen();
         else if (hc == pipe2_min_x + 37)
            showGreen();
         else if (hc == pipe2_min_x + 38)
            showGreen();
         else if (hc == pipe2_min_x + 39)
            showGreen();
         else if (hc == pipe2_min_x + 40)
            showDarkGreen();
         else if (hc == pipe2_min_x + 41)
            showDarkGreen();
         else if (hc == pipe2_min_x + 42)
            showGreen();
         else if (hc == pipe2_min_x + 43)
            showGreen();
         else if (hc == pipe2_min_x + 44)
            showDarkGreen();
         else if (hc == pipe2_min_x + 45)
            showDarkGreen();
         else if (hc == pipe2_min_x + 46)
            showDarkGreen();
         else if (hc == pipe2_min_x + 47)
            showDarkGreen();
         else if (hc == pipe2_min_x + 48)
            showBlack();
         else if (hc == pipe2_min_x + 49)
            showBlack();
      end
      else if (((vc >= pipe2_min_y - 18 && vc < pipe2_min_y - 16) || (vc >= pipe2_max_y + 16 && vc < pipe2_max_y + 18)) && (hc >= pipe2_min_x && hc < pipe2_max_x)) begin
         if (hc == pipe2_min_x + 0)
            showBlack();
         else if (hc == pipe2_min_x + 1)
            showBlack();
         else if (hc == pipe2_min_x + 2)
            showDarkGreen();
         else if (hc == pipe2_min_x + 3)
            showDarkGreen();
         else if (hc == pipe2_min_x + 4)
            showDarkGreen();
         else if (hc == pipe2_min_x + 5)
            showDarkGreen();
         else if (hc == pipe2_min_x + 6)
            showDarkGreen();
         else if (hc == pipe2_min_x + 7)
            showDarkGreen();
         else if (hc == pipe2_min_x + 8)
            showDarkGreen();
         else if (hc == pipe2_min_x + 9)
            showDarkGreen();
         else if (hc == pipe2_min_x + 10)
            showDarkGreen();
         else if (hc == pipe2_min_x + 11)
            showDarkGreen();
         else if (hc == pipe2_min_x + 12)
            showDarkGreen();
         else if (hc == pipe2_min_x + 13)
            showDarkGreen();
         else if (hc == pipe2_min_x + 14)
            showDarkGreen();
         else if (hc == pipe2_min_x + 15)
            showDarkGreen();
         else if (hc == pipe2_min_x + 16)
            showDarkGreen();
         else if (hc == pipe2_min_x + 17)
            showDarkGreen();
         else if (hc == pipe2_min_x + 18)
            showDarkGreen();
         else if (hc == pipe2_min_x + 19)
            showDarkGreen();
         else if (hc == pipe2_min_x + 20)
            showDarkGreen();
         else if (hc == pipe2_min_x + 21)
            showDarkGreen();
         else if (hc == pipe2_min_x + 22)
            showDarkGreen();
         else if (hc == pipe2_min_x + 23)
            showDarkGreen();
         else if (hc == pipe2_min_x + 24)
            showDarkGreen();
         else if (hc == pipe2_min_x + 25)
            showDarkGreen();
         else if (hc == pipe2_min_x + 26)
            showDarkGreen();
         else if (hc == pipe2_min_x + 27)
            showDarkGreen();
         else if (hc == pipe2_min_x + 28)
            showDarkGreen();
         else if (hc == pipe2_min_x + 29)
            showDarkGreen();
         else if (hc == pipe2_min_x + 30)
            showDarkGreen();
         else if (hc == pipe2_min_x + 31)
            showDarkGreen();
         else if (hc == pipe2_min_x + 32)
            showDarkGreen();
         else if (hc == pipe2_min_x + 33)
            showDarkGreen();
         else if (hc == pipe2_min_x + 34)
            showDarkGreen();
         else if (hc == pipe2_min_x + 35)
            showDarkGreen();
         else if (hc == pipe2_min_x + 36)
            showDarkGreen();
         else if (hc == pipe2_min_x + 37)
            showDarkGreen();
         else if (hc == pipe2_min_x + 38)
            showDarkGreen();
         else if (hc == pipe2_min_x + 39)
            showDarkGreen();
         else if (hc == pipe2_min_x + 40)
            showDarkGreen();
         else if (hc == pipe2_min_x + 41)
            showDarkGreen();
         else if (hc == pipe2_min_x + 42)
            showDarkGreen();
         else if (hc == pipe2_min_x + 43)
            showDarkGreen();
         else if (hc == pipe2_min_x + 44)
            showDarkGreen();
         else if (hc == pipe2_min_x + 45)
            showDarkGreen();
         else if (hc == pipe2_min_x + 46)
            showDarkGreen();
         else if (hc == pipe2_min_x + 47)
            showDarkGreen();
         else if (hc == pipe2_min_x + 48)
            showBlack();
         else if (hc == pipe2_min_x + 49)
            showBlack();
      end
      else if (((vc >= pipe2_min_y - 20 && vc < pipe2_min_y - 18) || (vc >= pipe2_max_y + 18 && vc < pipe2_max_y + 20)) && (hc >= pipe2_min_x && hc < pipe2_max_x))
         showBlack();
      else if ((vc < pipe2_min_y - 18 || vc >= pipe2_max_y + 20) && (hc >= pipe2_min_x + 2 && hc < pipe2_max_x - 2)) begin
         if (hc == pipe2_min_x + 2)
            showBlack();
         else if (hc == pipe2_min_x + 3)
            showBlack();
         else if (hc == pipe2_min_x + 4)
            showMediumGreen();
         else if (hc == pipe2_min_x + 5)
            showMediumGreen();
         else if (hc == pipe2_min_x + 6)
            showLightGreen();
         else if (hc == pipe2_min_x + 7)
            showLightGreen();
         else if (hc == pipe2_min_x + 8)
            showMediumGreen();
         else if (hc == pipe2_min_x + 9)
            showMediumGreen();
         else if (hc == pipe2_min_x + 10)
            showMediumGreen();
         else if (hc == pipe2_min_x + 11)
            showMediumGreen();
         else if (hc == pipe2_min_x + 12)
            showMediumGreen();
         else if (hc == pipe2_min_x + 13)
            showMediumGreen();
         else if (hc == pipe2_min_x + 14)
            showGreen();
         else if (hc == pipe2_min_x + 15)
            showGreen();
         else if (hc == pipe2_min_x + 16)
            showMediumGreen();
         else if (hc == pipe2_min_x + 17)
            showMediumGreen();
         else if (hc == pipe2_min_x + 18)
            showGreen();
         else if (hc == pipe2_min_x + 19)
            showGreen();
         else if (hc == pipe2_min_x + 20)
            showGreen();
         else if (hc == pipe2_min_x + 21)
            showGreen();
         else if (hc == pipe2_min_x + 22)
            showGreen();
         else if (hc == pipe2_min_x + 23)
            showGreen();
         else if (hc == pipe2_min_x + 24)
            showGreen();
         else if (hc == pipe2_min_x + 25)
            showGreen();
         else if (hc == pipe2_min_x + 26)
            showGreen();
         else if (hc == pipe2_min_x + 27)
            showGreen();
         else if (hc == pipe2_min_x + 28)
            showGreen();
         else if (hc == pipe2_min_x + 29)
            showGreen();
         else if (hc == pipe2_min_x + 30)
            showGreen();
         else if (hc == pipe2_min_x + 31)
            showGreen();
         else if (hc == pipe2_min_x + 32)
            showGreen();
         else if (hc == pipe2_min_x + 33)
            showGreen();
         else if (hc == pipe2_min_x + 34)
            showGreen();
         else if (hc == pipe2_min_x + 35)
            showGreen();
         else if (hc == pipe2_min_x + 36)
            showGreen();
         else if (hc == pipe2_min_x + 37)
            showGreen();
         else if (hc == pipe2_min_x + 38)
            showDarkGreen();
         else if (hc == pipe2_min_x + 39)
            showDarkGreen();
         else if (hc == pipe2_min_x + 40)
            showMediumGreen();
         else if (hc == pipe2_min_x + 41)
            showMediumGreen();
         else if (hc == pipe2_min_x + 42)
            showDarkGreen();
         else if (hc == pipe2_min_x + 43)
            showDarkGreen();
         else if (hc == pipe2_min_x + 44)
            showDarkGreen();
         else if (hc == pipe2_min_x + 45)
            showDarkGreen();
         else if (hc == pipe2_min_x + 46)
            showBlack();
         else if (hc == pipe2_min_x + 47)
            showBlack();
      end
      else
         showBackground();
   end
   // we're outside active vertical range so display black
   else
      showBlack();
end

endmodule