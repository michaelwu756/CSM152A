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

		// Wait for global reset to finish
		#250000;
      while (counter<4) begin
			counter=counter+1;
			clk=~clk;
			#250000;
		end
		btnR=0;
		while (1) begin
			counter=counter+1;
			if(counter==1000)
				btnS=1;
			if(counter==2000)
				btnS=0;
			clk=~clk;
			#250000;
		end
		// Add stimulus here

	end
      
endmodule

