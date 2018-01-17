`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 

// Create Date:    14:47:53 01/17/2018 
// Design Name: 
// Module Name:    floatingpoint 
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
module signMagnitude(
	input wire[11:0]  d,
	output wire sign,
	output wire[11:0] out
);

	assign sign = (d[11]==1'b1) ? 1'b1 : 1'b0;
	assign out = (d[11]==1'b1) ? d[11:0] : ~d[11:0] + 1'b1;

endmodule


module countZerosExtractData(
	input wire [11:0] d,
	output reg [2:0] exponent,
	output reg [3:0] significand,
	output reg fifthBit
);
	reg i;
	reg leadingZeroes;
	
	always @(*) begin
		if(d[11]==0) begin
			if(d[10]==0) begin
				if(d[9]==0) begin
					if(d[8]==0) begin
						if(d[7]==0) begin
							if(d[6]==0) begin
								if(d[5]==0) begin
									if(d[4]==0) begin
										i=3;
									end
									else i=4;
								end
								else i=5;
							end
							else i=6;
						end
						else i=7;
					end
					else i=8;
				end
				else i=9;
			end
			else i=10;
		end
		leadingZeroes	= 11-i;
		exponent = 8-leadingZeroes;

		significand[3] = d[i];
		significand[2] = d[i-1];
		significand[1] = d[i-2];
		significand[0] = d[i-3];
		
		fifthBit = (i==3) ? 0 : d[i-4];
	end
endmodule

// if significand 1111, make it 1000, add 1 to exp
// else add 1 dep on fifthbit+
module round(
	input wire [2:0] exponent,
	input wire [3:0] significand,
	input wire fifthBit,
	output reg [2:0] exponent_out,
	output reg [3:0] significand_out
);

	always @(*) begin

		exponent_out = exponent;
		significand_out = significand;
		
		if (fifthBit == 1'b1) begin
			if (significand == 4'b1111) begin
				significand_out = 4'b1000;
				exponent_out = exponent + 1'b1;
			end
			else
				significand_out = significand + 1'b1;
		end	
	end

endmodule

// edge cases -- every thing is all 1's
// everything is all 0's

module combinedComb(
	input wire [11:0]  d,
	output wire sign,
	output wire [2:0] exp,
	output wire [3:0] sig
);

	wire [11:0] smag;
	wire [2:0] exponent;
	wire [3:0] significand;
	wire fifthBit;
	signMagnitude sM_1 ( d, sign, smag);
	countZerosExtractData cZ_2 (smag, exponent,significand,fifthBit);
	round r_3( exponent,significand,fifthBit, exp_alpha, significand_alpha);

assign exp = (smag[10:7] == 4'b1111) ? 
	3'b111 : ((d[11]==1 && d[10:0] ==0) ? 
	3'b111 : exp_alpha);
assign sig = (smag[10:7] == 4'b1111) ? 
	4'b1111 : ((d[11]==1 && d[10:0] ==0) ? 
	4'b1111 : significand_alpha);

endmodule