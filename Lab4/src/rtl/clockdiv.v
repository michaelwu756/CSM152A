`timescale 1ns / 1ps
module clockdiv(
   input wire clk,      //master clock: 100MHz
   input wire [9:0] score,
   input wire clr,      //asynchronous reset
   output wire dclk,    //pixel clock: 25MHz
   output wire segclk,  //7-segment clock: 381.47Hz
   output wire gameclk  //Scaling clock: 200Hz+
);

`include "constants.v"

// 18-bit counter variable
reg [17:0] q;
reg [32:0] gc;

// Clock divider --
// Each bit in q is a clock signal that is
// only a fraction of the master clock.
always @(posedge clk or posedge clr) begin
   // reset condition
   if (clr == 1) begin
      q <= 0;
      gc <= 0;
   end
   // increment counter by one
   else begin
      q <= q + 1;
      if (GC_SCALING_CONSTANT*score < GC_TARGET) begin
         if(gc >= GC_TARGET - GC_SCALING_CONSTANT*score)
            gc <= 0;
         else
            gc <= gc + 1;
      end
      else if(gc >= GC_SCALING_CONSTANT)
         gc <= 0;
      else
         gc <= gc + 1;
   end
end

// 100Mhz � 2^18 = 381.47Hz
assign segclk = q[17];
assign gameclk = (GC_SCALING_CONSTANT*score < GC_TARGET) ? gc ==  GC_TARGET - GC_SCALING_CONSTANT*score : gc == GC_SCALING_CONSTANT;
// 100Mhz � 2^2 = 25MHz
assign dclk = q[1];

endmodule