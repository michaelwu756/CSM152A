`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:49:36 03/19/2013
// Design Name:
// Module Name:    clockdiv
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
module clockdiv(
    input wire clk,     //master clock: 50MHz
    input wire clr,     //asynchronous reset
    output wire dclk,       //pixel clock: 25MHz
    output wire segclk, //7-segment clock: 381.47Hz
    output wire gameclk  //7-segment clock: 381.47Hz
    );

// 17-bit counter variable
reg [17:0] q;

reg [32:0] gc;
//a target
reg [31:0] target;

wire mintarget;
assign mintarget=131072;

// Clock divider --
// Each bit in q is a clock signal that is
// only a fraction of the master clock.
always @(posedge clk or posedge clr)
begin
    // reset condition
  if (clr == 1) begin
        q <= 0;
        gc <= 0;
        target <= 524288;
    // increment counter by one
  end
    else
        q <= q + 1;
        if(target>mintarget && gc==target)
            target <= target - 1;
        gc <= gc + 1;
end

// 50Mhz � 2^17 = 381.47Hz
assign segclk = q[17];
assign gameclk = gc==target-1;
// 50Mhz � 2^1 = 25MHz
assign dclk = q[1];

endmodule
