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

      if (y_in+bird_height > Btop || y_in-bird_height < Bbottom)
        hitColumn <= 1;
    end
    else
      hitColumn <= 0;
  end


endmodule
