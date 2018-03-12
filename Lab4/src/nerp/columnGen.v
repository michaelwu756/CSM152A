module columnGen(gameClk, reset, finished, Ax, Ay, Bx, By, passColumn);

  `include "constants.v"
  input gameClk, reset, finished;
  output reg [10:0] Ax;
  output reg [10:0] Ay;
  output reg [10:0] Bx;
  output reg [10:0] By;
  output reg passColumn;

  // Ainfo -- 0: x-offset of RIGHT SIDE of COL, 1: y-coord of GAP CENTER
  wire [31:0] random;

  //GARO rng(0, gameClk, reset, random);
  fibonacci_lfsr_nbit rng(gameClk, reset, random);

  always @(posedge gameClk or posedge reset) begin
	 if (reset) begin
		Ax <= SCREEN_WIDTH/2 + pipe_width*2 - 1;
        Ay <= SCREEN_HEIGHT/2 + random % (SCREEN_HEIGHT-2*(GAP_HEIGHT+PADDING));

		Bx <= SCREEN_WIDTH + pipe_width*2 - 1;
        By <= SCREEN_HEIGHT/2 + random % (SCREEN_HEIGHT-2*(GAP_HEIGHT+PADDING));
	 end
	 // if first col of Ainfo is 0, generate new column
    else if (Ax == 0) begin
        Ax <= SCREEN_WIDTH + pipe_width*2 - 1;    //
        Ay <= SCREEN_HEIGHT/2 + random % (SCREEN_HEIGHT-2*(GAP_HEIGHT+PADDING));

        Bx <= Bx - 1;
        passColumn <= 1;
    end
    // if first col of Binfo is 0, generate new column
    else if (Bx == 0) begin
      Bx <= SCREEN_WIDTH + pipe_width*2 - 1;
      By <= SCREEN_HEIGHT/2 + random % (SCREEN_HEIGHT-2*(GAP_HEIGHT+PADDING));
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


module fibonacci_lfsr_nbit   #(parameter BITS = 32)   (
    input             clk,
    input             rst_n,
    output reg [31:0] data
    );

   reg [31:0] data_next;
   always @* begin
      data_next = data;
      repeat(BITS) begin
         data_next = {(data_next[31]^data_next[1]), data_next[31:1]};
      end
   end

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
         data <= 32'h1f;
      else
         data <= data_next;
   end

endmodule
