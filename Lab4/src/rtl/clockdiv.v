`timescale 1ns / 1ps
module clockdiv(
   input wire clk,      //master clock: 50MHz
   input wire clr,      //asynchronous reset
   input wire [9:0] score,
   output wire dclk,    //pixel clock: 25MHz
   output wire segclk,  //7-segment clock: 381.47Hz
   output wire gameclk  //7-segment clock: 381.47Hz
   );

// 17-bit counter variable
reg [17:0] q;
reg [32:0] gc;

parameter target = 500000;
parameter constant = 500;

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
      if(gc == target - constant*score)
         gc <= 0;
      else
         gc <= gc + 1;
   end
end

// 50Mhz ÷ 2^17 = 381.47Hz
assign segclk = q[17];
assign gameclk = gc == target - constant*score;
// 50Mhz ÷ 2^1 = 25MHz
assign dclk = q[1];

endmodule