`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:20:51 01/22/2018
// Design Name:   combinedComb
// Module Name:   C:/Users/152/Desktop/temp/testbench.v
// Project Name:  temp
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: combinedComb
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	// Inputs
	reg [11:0] d;

	// Outputs
	wire sign;
	wire [2:0] exp;
	wire [3:0] sig;

	// Instantiate the Unit Under Test (UUT)
	combinedComb uut (
		.d(d), 
		.sign(sign), 
		.exp(exp), 
		.sig(sig)
	);

	initial begin
		// Initialize Inputs
		d = 12'b100000000000;
		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		d = 12'b011111111111;
		#100;
		d = 12'b000000000001;
	end
      
endmodule

