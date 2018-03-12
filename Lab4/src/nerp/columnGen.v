module columnGen(gameClk, reset, finished, Ax, Ay, Bx, By, passColumn);

  `include "constants.v"
  input gameClk, reset, finished;
  output reg [10:0] Ax;
  output reg [10:0] Ay;
  output reg [10:0] Bx;
  output reg [10:0] By;
  output reg passColumn;

  // Ainfo -- 0: x-offset of RIGHT SIDE of COL, 1: y-coord of GAP CENTER
  wire [15:0] random;
  lfsr rng(gameClk, reset, random);

  always @(posedge gameClk or posedge reset) begin
	 if (reset) begin
		Ax <= SCREEN_WIDTH/2 + pipe_width*2 - 1;
      Ay <= PADDING+pipe_height_gap+random%(SCREEN_HEIGHT-2*(PADDING+pipe_height_gap));

		Bx <= SCREEN_WIDTH + pipe_width*2 - 1;
      By <= PADDING+pipe_height_gap+(2*random)%(SCREEN_HEIGHT-2*(PADDING+pipe_height_gap));
	 end
	 // if first col of Ainfo is 0, generate new column
    else if (Ax == 0) begin
        Ax <= SCREEN_WIDTH + pipe_width*2 - 1;    //
        Ay <= PADDING+pipe_height_gap+random%(SCREEN_HEIGHT-2*(PADDING+pipe_height_gap));
        Bx <= Bx - 1;
        passColumn <= 1;
    end
    // if first col of Binfo is 0, generate new column
    else if (Bx == 0) begin
      Bx <= SCREEN_WIDTH + pipe_width*2 - 1;
      By <= PADDING+pipe_height_gap+random%(SCREEN_HEIGHT-2*(PADDING+pipe_height_gap));
      Ax <= Ax - 1;
      passColumn <= 1;
    end
    else begin
      Ax <= Ax - 1;
      Bx <= Bx - 1;
      passColumn <= 0;
    end
  end

endmodule

module lfsr(input clk, reset, output reg [15:0] q);
  always @(posedge clk or posedge reset) begin
    if (reset)
      q <= 16'b1001100001010100; // can be anything except zero
    else
      q <= {q[14:0], q[7] ^ q[5] ^ q[4] ^ q[3]}; // polynomial for maximal LFSR
  end
endmodule