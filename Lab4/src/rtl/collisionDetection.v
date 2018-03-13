module collisionDetection(
   input wire gameClk,
   input wire [10:0] Ax,
   input wire [10:0] Ay,
   input wire [10:0] Bx,
   input wire [10:0] By,
   input wire [10:0] y_in,
   input wire reset,
   output reg hitColumn
);

`include "constants.v"

wire [10:0] Aleft, Bleft, Aright, Bright;
wire [10:0] Atop, Abottom, Btop, Bbottom;

assign Atop = Ay + PIPE_HEIGHT_GAP;
assign Abottom = Ay - PIPE_HEIGHT_GAP;
assign Btop = By + PIPE_HEIGHT_GAP;
assign Bbottom = By - PIPE_HEIGHT_GAP;
assign Aleft = Ax - PIPE_WIDTH;
assign Bleft = Bx - PIPE_WIDTH;
assign Aright = Ax + PIPE_WIDTH;
assign Bright = Bx + PIPE_WIDTH;

always @(posedge gameClk or posedge reset) begin
   if (reset)
      hitColumn <= 0;
   else begin
      if (y_in == BIRD_HEIGHT)
         hitColumn <= 1;
      else if ((BIRD_X - BIRD_WIDTH > Aleft && BIRD_X - BIRD_WIDTH < Aright) ||
            (BIRD_X + BIRD_WIDTH > Aleft && BIRD_X + BIRD_WIDTH < Aright)) begin
         if (y_in + BIRD_HEIGHT > Atop || y_in - BIRD_HEIGHT < Abottom)
            hitColumn <= 1;
      end
      else if ((BIRD_X - BIRD_WIDTH > Bleft && BIRD_X - BIRD_WIDTH < Bright) ||
            (BIRD_X + BIRD_WIDTH > Bleft && BIRD_X + BIRD_WIDTH < Bright)) begin
         if (y_in + BIRD_HEIGHT > Btop || y_in - BIRD_HEIGHT < Bbottom)
            hitColumn <= 1;
      end
      else
         hitColumn <= 0;
   end
end

endmodule