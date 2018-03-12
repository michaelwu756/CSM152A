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

  assign Atop = Ay + GAP_HEIGHT/2;
  assign Abottom = Ay - GAP_HEIGHT/2;
  assign Btop = By + GAP_HEIGHT/2;
  assign Bbottom = By - GAP_HEIGHT/2;
  assign Aleft = Ax - COL_WIDTH/2;
  assign Bleft = Bx - COL_WIDTH/2;
  assign Aright = Ax + COL_WIDTH/2;
  assign Bright = Bx + COL_WIDTH/2;

  always @(posedge gameClk) begin

    if ((bird_x-bird_width/2 > Aleft && bird_x-bird_width/2 < Aright) || (bird_x+bird_width/2 > Aleft && bird_x+bird_width/2 < Aright)) begin
      if (y_in+bird_height > Atop || y_in-bird_height < Abottom)
        hitColumn <= 1;
    end
    else if ((bird_x-bird_width/2 > Bleft && bird_x-bird_width/2 < Bright) || (bird_x+bird_width/2 > Bleft && bird_x+bird_width/2 < Bright)) begin
      if (y_in+bird_height > Btop || y_in-bird_height < Bbottom)
        hitColumn <= 1;
    end
    else
      hitColumn <= 0;
  end


endmodule
