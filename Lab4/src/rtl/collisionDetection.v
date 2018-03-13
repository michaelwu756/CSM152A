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

assign Atop = Ay + pipe_height_gap;
assign Abottom = Ay - pipe_height_gap;
assign Btop = By + pipe_height_gap;
assign Bbottom = By - pipe_height_gap;
assign Aleft = Ax - pipe_width;
assign Bleft = Bx - pipe_width;
assign Aright = Ax + pipe_width;
assign Bright = Bx + pipe_width;

always @(posedge gameClk or posedge reset) begin
   if (reset)
      hitColumn <= 0;
   else begin
      if (y_in == bird_height)
         hitColumn <= 1;
      else if ((bird_x - bird_width > Aleft && bird_x - bird_width < Aright) ||
            (bird_x+bird_width > Aleft && bird_x+bird_width < Aright)) begin
         if (y_in + bird_height > Atop || y_in - bird_height < Abottom)
            hitColumn <= 1;
      end
      else if ((bird_x - bird_width > Bleft && bird_x - bird_width < Bright) ||
            (bird_x + bird_width > Bleft && bird_x + bird_width < Bright)) begin
         if (y_in + bird_height > Btop || y_in - bird_height < Bbottom)
            hitColumn <= 1;
      end
      else
         hitColumn <= 0;
   end
end

endmodule