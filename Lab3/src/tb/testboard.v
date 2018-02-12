`timescale 1ns / 1ps
module testboard;

	// Inputs
	reg [7:0] sw;
	reg btnS;
	reg btnR;
	reg clk;
	reg [50:0] counter;

	// Outputs
	wire [7:0] seg;
	wire [3:0] an;

	// Instantiate the Unit Under Test (UUT)
	nexys3 uut (
		.seg(seg), 
		.an(an), 
		.sw(sw), 
		.btnS(btnS), 
		.btnR(btnR), 
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		sw = 0;
		btnS = 0;
		btnR = 1;
		clk = 0; 
		counter=0;

		// Wait 100 ns for global reset to finish
		#500000;
      while (counter<4000) begin
			counter=counter+1;
			clk=~clk;
			#500000;
		end
		btnR=0;
		while (1) begin
			clk=~clk;
			#5;
		end
		// Add stimulus here

	end
      
endmodule

