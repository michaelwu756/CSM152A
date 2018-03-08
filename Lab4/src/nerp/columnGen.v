module columnGen(gameClk, reset, finished, Ax, Ay, Bx, By, passColumn);

  input gameClk, reset, finished;
  output reg [10:0] Ax;
  output reg [10:0] Ay;
  output reg [10:0] Bx;
  output reg [10:0] By;
  output reg passColumn;

`include "constants.v"

  // Ainfo -- 0: x-offset of RIGHT SIDE of COL, 1: y-coord of GAP CENTER


  always @(posedge gameClk or posedge reset) begin
	 if (reset) begin
		Ax <= SCREEN_WIDTH/2 + pipe_width*2 - 1;    //
      //Ay <= ($urandom % (SCREEN_HEIGHT - 2*PADDING - 2*pipe_height_gap)) + PADDING + pipe_height_gap;
		Ay <= 200;
		Bx <= SCREEN_WIDTH + pipe_width*2 - 1;
      //By <= ($urandom % (SCREEN_HEIGHT - 2*PADDING - 2*pipe_height_gap)) + PADDING + pipe_height_gap;
		By <= 230;
	 end
	 // if first col of Ainfo is 0, generate new column
    else if (Ax == 0) begin
      Ax <= SCREEN_WIDTH + pipe_width*2 - 1;    //
      //Ay <= ($urandom % (SCREEN_HEIGHT - 2*PADDING - 2*pipe_height_gap)) + PADDING + pipe_height_gap;
      Bx <= Bx - 1;
      passColumn <= 1;
    end
    // if first col of Binfo is 0, generate new column
    else if (Bx == 0) begin
      Bx <= SCREEN_WIDTH + pipe_width*2 - 1;
      //By <= ($urandom % (SCREEN_HEIGHT - 2*PADDING - 2*pipe_height_gap)) + PADDING + pipe_height_gap;
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
