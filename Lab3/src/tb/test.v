`timescale 1ns / 1ps
module test;

	// Inputs
	reg clk;

	// Outputs
	wire clk_1;
	wire clk_2;
	wire clk_2p5;
	wire clk_500;

	// Instantiate the Unit Under Test (UUT)
	clkModule uut (
		.clk(clk),
		.clk_1(clk_1),
		.clk_2(clk_2),
		.clk_2p5(clk_2p5),
		.clk_500(clk_500)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		pause = 0;

		// Wait 100 ns for global reset to finish
		#5;
      while (1) begin
			clk=~clk;
			#5;
		end
		// Add stimulus here

	end

endmodule

