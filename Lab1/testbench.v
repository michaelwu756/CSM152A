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
	
	//wire sign;
	//wire [11:0] out;
	
	// Outputs
	wire sign;
	wire [2:0] exp;
	wire [3:0] sig;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
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
		#100;
		d = 12'b000000000000;
		#100;
		d = 12'b111111111111;
		#100;
		d = 12'b000000000111;
		#100;
		d = 12'b000011110101;
		#100;
		d = 12'b000011111010;
		#100;
		d = 12'b001010101010;
		#100;
		d = 12'b000010001010;
		#100;
		d = 12'b100000110110;
		#100;
		d = 12'b010001101010;
		#100;
		d = 12'b110000001111;
		#100;
		d = 12'b110101101001;
		#100;
		d = 12'b010010111000;
		#100;
		d = 12'b101010111110;
		#100;
		d = 12'b101101111010;
		#100;
		d = 12'b101100111101;
		#100;
		d = 12'b011110001110;
		#100;
		d = 12'b110000111100;
		#100;
		d = 12'b111100100010;
		#100;
		d = 12'b010001110101; 
		#100 $finish;
	end
endmodule

