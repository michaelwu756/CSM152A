module collisionDetection(
    input gameClk,
    input [9:0] Ax, Ay, Bx, By,
    input [9:0] y_in,
    output hitColumn
    );

  `include "constants.v"

  wire [9:0] Aleft, Bleft, Aright, Bright;
  wire [9:0] Atop, Abottom, Btop, Bbottom;
  reg hitColumn;

  assign Atop = Ay + pipe_height_gap;
  assign Abottom = Ay - pipe_height_gap;
  assign Btop = By + pipe_height_gap;
  assign Bbottom = By - pipe_height_gap;
  assign Aleft = Ax - pipe_width;
  assign Bleft = Bx - pipe_width;
  assign Aright = Ax + pipe_width;
  assign Bright = Bx + pipe_width;

  always @(posedge gameClk) begin

    if ((bird_x-bird_width > Aleft && bird_x-bird_width < Aright) || (bird_x+bird_width > Aleft && bird_x+bird_width < Aright)) begin
      if (y_in+bird_height > Atop || y_in-bird_height < Abottom)
        hitColumn <= 1;
    end
    else if ((bird_x-bird_width > Bleft && bird_x-bird_width < Bright) || (bird_x+bird_width > Bleft && bird_x+bird_width < Bright)) begin
      if (y_in+bird_height > Btop || y_in-bird_height < Bbottom)
        hitColumn <= 1;
    end
    else
      hitColumn <= 0;
  end


endmodule
