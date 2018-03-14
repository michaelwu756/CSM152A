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
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 0)
         showBlack();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 1)
         showYellow1();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 1)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 1)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 1)
         showYellow1();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 1)
         showWhite();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 1)
         showBlack();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 2)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 2)
         showWhite();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 2)
         showWhite();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 2)
         showWhite();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 2)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 3)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 3)
         showWhite();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 3)
         showWhite();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 3)
         showWhite();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 3)
         showBlack();
      else if (hc == bird_min_x + 1 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 4)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 4)
         showWhite();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 4)
         showBlack();
      else if (hc == bird_min_x + 1 && vc == bird_min_y + 5)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 5)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 5)
         showYellow1();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 5)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 5)
         showWhite();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 5)
         showBlack();
      else if (hc == bird_min_x + 1 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 6)
         showWhite();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 6)
         showWhite();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 6)
         showWhite();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 6)
         showYellow1();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 6)
         showBlack();
      else if (hc == bird_min_x + 2 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 7)
         showYellow1();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 7)
         showOrange();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 7)
         showOrange();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 7)
         showOrange();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 7)
         showOrange();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 7)
         showOrange();
      else if (hc == bird_min_x + 17 && vc == bird_min_y + 7)
         showBlack();
      else if (hc == bird_min_x + 3 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 4 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 8)
         showYellow2();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 8)
         showYellow2();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 8)
         showYellow2();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 8)
         showYellow2();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 8)
         showOrange();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 8)
         showBlack();
      else if (hc == bird_min_x + 5 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 9)
         showYellow2();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 9)
         showYellow2();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 9)
         showYellow2();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 9)
         showYellow2();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 9)
         showYellow2();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 9)
         showOrange();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 9)
         showOrange();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 9)
         showOrange();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 9)
         showOrange();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 9)
         showBlack();
      else if (hc == bird_min_x + 6 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 7 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 10)
         showYellow2();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 10)
         showYellow2();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 10)
         showYellow2();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 10)
         showYellow2();
      else if (hc == bird_min_x + 12 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 13 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 14 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 15 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 16 && vc == bird_min_y + 10)
         showBlack();
      else if (hc == bird_min_x + 8 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 9 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 10 && vc == bird_min_y + 11)
         showBlack();
      else if (hc == bird_min_x + 11 && vc == bird_min_y + 11)
         showBlack();
      //display pipes
      else if (hc >= pipe1_min_x && hc < pipe1_max_x &&
            !(vc >= pipe1_min_y && vc < pipe1_max_y)) begin
         red = 3'b000;
         green = 3'b111;
         blue = 2'b00;
      end
      else if (hc >= pipe2_min_x && hc < pipe2_max_x &&
            !(vc >= pipe2_min_y && vc < pipe2_max_y)) begin
         red = 3'b000;
         green = 3'b111;
         blue = 2'b00;
      end
      else begin
         red = 3'b111;
         green = 3'b000;
         blue = 2'b11;
      end
   end
   // we're outside active vertical range so display black
   else
      showBlack();
end

endmodule