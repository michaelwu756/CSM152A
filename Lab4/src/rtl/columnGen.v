module columnGen(
   input wire gameClk,
   input wire reset,
   input wire finished,
   output reg [10:0] Ax,
   output reg [10:0] Ay,
   output reg [10:0] Bx,
   output reg [10:0] By,
   output reg passColumn
);

`include "constants.v"

initial begin
   Ax = (SCREEN_WIDTH + PIPE_WIDTH)/2;
   Ay = PADDING + PIPE_HEIGHT_GAP + 624%(SCREEN_HEIGHT - 2*(PADDING + PIPE_HEIGHT_GAP));
   Bx = SCREEN_WIDTH + PIPE_WIDTH;
   By = PADDING + PIPE_HEIGHT_GAP + (2*624)%(SCREEN_HEIGHT - 2*(PADDING + PIPE_HEIGHT_GAP));
end

wire [15:0] random;
lfsr rng(gameClk, reset, random);

reg [14:0] delay = DELAY;
always @(posedge gameClk or posedge reset) begin
   if (reset) begin
      Ax <= (SCREEN_WIDTH + PIPE_WIDTH)/2;
      Ay <= PADDING + PIPE_HEIGHT_GAP + random%(SCREEN_HEIGHT - 2*(PADDING + PIPE_HEIGHT_GAP));

      Bx <= SCREEN_WIDTH + PIPE_WIDTH;
      By <= PADDING + PIPE_HEIGHT_GAP + (2*random)%(SCREEN_HEIGHT - 2*(PADDING + PIPE_HEIGHT_GAP));
      delay <= DELAY;
      passColumn <= 0;
   end
   else if (!finished) begin
      if(delay != 0)
         delay <= delay - 1;
      else begin
         if (Ax == BIRD_X || Bx == BIRD_X)
            passColumn <= 1;
         else
            passColumn <= 0;
         // if first col of Ainfo is 0, generate new column
         if (Ax == 0) begin
            Ax <= SCREEN_WIDTH + PIPE_WIDTH;
            Ay <= PADDING + PIPE_HEIGHT_GAP + random%(SCREEN_HEIGHT - 2*(PADDING + PIPE_HEIGHT_GAP));
            Bx <= Bx - 1;
         end
         // if first col of Binfo is 0, generate new column
         else if (Bx == 0) begin
            Bx <= SCREEN_WIDTH + PIPE_WIDTH;
            By <= PADDING + PIPE_HEIGHT_GAP + random%(SCREEN_HEIGHT - 2*(PADDING + PIPE_HEIGHT_GAP));
            Ax <= Ax - 1;
         end
         else begin
            Ax <= Ax - 1;
            Bx <= Bx - 1;
         end
      end
   end
end

endmodule

module lfsr(
   input wire clk,
   input wire reset,
   output reg [15:0] q
);

always @(posedge clk or posedge reset) begin
   if (reset) begin
      if (q == 0)
         q <= 16'b1001100001010100; // can be anything except zero
   end
   else
      q <= {q[14:0], q[7] ^ q[5] ^ q[4] ^ q[3]}; // polynomial for maximal LFSR
end

endmodule