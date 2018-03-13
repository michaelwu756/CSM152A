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
      if (hc < hpixels - 1)
         hc <= hc + 1;
      else begin
         // When we hit the end of the line, reset the horizontal
         // counter and increment the vertical counter.
         // If vertical counter is at the end of the frame, then
         // reset that one too.
         hc <= 0;
         if (vc < vlines - 1)
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
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

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
assign pipe1_min_x = pipe1_x - pipe_width + hbp;
assign pipe1_max_x = pipe1_x + pipe_width + hbp;
assign pipe1_min_y = pipe1_y - pipe_height_gap + vbp;
assign pipe1_max_y = pipe1_y + pipe_height_gap + vbp;

wire [10:0] pipe2_min_x;
wire [10:0] pipe2_max_x;
wire [10:0] pipe2_min_y; 
wire [10:0] pipe2_max_y;
assign pipe2_min_x = pipe2_x - pipe_width + hbp;
assign pipe2_max_x = pipe2_x + pipe_width + hbp;
assign pipe2_min_y = pipe2_y - pipe_height_gap + vbp;
assign pipe2_max_y = pipe2_y + pipe_height_gap + vbp;

wire [10:0] bird_min_x;
wire [10:0] bird_max_x;
wire [10:0] bird_min_y; 
wire [10:0] bird_max_y;
assign bird_min_x = bird_x - bird_width + hbp;
assign bird_max_x = bird_x + bird_width + hbp;
assign bird_min_y = bird_y - bird_height + vbp;
assign bird_max_y = bird_y + bird_height + vbp;

always @(*) begin
   // first check if we're within vertical active video range
   if (vc >= vbp && vc < vfp && hc >= hbp && hc < hfp) begin
      //border
      if (hc == hbp || hc == hfp - 1 || vc == vbp || vc == vfp - 1) begin
         red = 3'b111;
         green = 3'b000;
         blue = 2'b00;
      end
      //display bird
      else if (hc >= bird_min_x && hc < bird_max_x &&
            vc >= bird_min_y && vc < bird_max_y ) begin
         red = 3'b111;
         green = 3'b111;
         blue = 2'b11;
      end
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
   else begin
      red = 0;
      green = 0;
      blue = 0;
   end
end

endmodule