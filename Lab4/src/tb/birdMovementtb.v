`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:04:38 03/07/2018
// Design Name:   birdMovement
// Module Name:   C:/Users/Public/Documents/CSM152A/Lab4/src/tb/birdmivementtb.v
// Project Name:  Lab4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: birdMovement
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module birdmivementtb;

	// Inputs
	reg gameClk;
	reg button;
	reg reset;
	reg finished;

	// Outputs
	wire [10:0] y_out;

	// Instantiate the Unit Under Test (UUT)
	birdMovement uut (
		.gameClk(gameClk), 
		.button(button), 
		.reset(reset), 
		.finished(finished), 
		.y_out(y_out)
	);
	
	reg [50:0] count;

	initial begin
		// Initialize Inputs
		gameClk = 0;
		button = 0;
		reset = 1;
		finished = 0;
		
		count=0;

		// Wait 100 ns for global reset to finish
		#1;
      while (count<4) begin
			count=count+1;
			gameClk=~gameClk;
			#1;
		end
		reset=0;
		while (1) begin
			count=count+1;
			if(count%1000==0)
				button=~button;
			gameClk=~gameClk;
			#1;
		end
		// Add stimulus here

	end
      
endmodule