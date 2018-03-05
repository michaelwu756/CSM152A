module collisionDetection(
    input gameClk,
    input [9:0] Ax, Ay, Bx, By,
    input [9:0] y_in,
    output hitColumn
    );

  // y_in interpreted as center of bird
  parameter BIRD_LEFT = 60;	// left of bird
  parameter BIRD_RIGHT = 100;
  parameter BIRD_WIDTH = 20;
  parameter BIRD_HEIGHT = 20;
  parameter COL_WIDTH = 20;
  parameter GAP_HEIGHT = 100;

  wire [9:0] Aleft, Bleft, Aright, Bright;
  wire [9:0] Atop, Abottom, Btop, Bbottom, bird_top, bird_bottom;
  reg hitColumn;

  assign Atop = Ay + GAP_HEIGHT/2;
  assign Abottom = Ay - GAP_HEIGHT/2;
  assign Btop = By + GAP_HEIGHT/2;
  assign Bbottom = By - GAP_HEIGHT/2;
  assign bird_top = y_in + BIRD_HEIGHT/2;
  assign bird_bottom = y_in - BIRD_HEIGHT/2;
  assign Aleft = Ax - COL_WIDTH/2;
  assign Bleft = Bx - COL_WIDTH/2;
  assign Aright = Ax + COL_WIDTH/2;
  assign Bright = Bx + COL_WIDTH/2;

  always @(posedge gameClk) begin

    if ((BIRD_LEFT > Aleft && BIRD_LEFT < Aright) || (BIRD_RIGHT > Aleft && BIRD_RIGHT < Aright)) begin
      if (bird_top > Atop || bird_bottom < Abottom)
        hitColumn <= 1;
    end
    else if ((BIRD_LEFT > Bleft && BIRD_LEFT < Bright) || (BIRD_RIGHT > Bleft && BIRD_RIGHT < Bright)) begin
      if (bird_top > Btop || bird_bottom < Bbottom)
        hitColumn <= 1;
    end
    else
      hitColumn <= 0;

  end


endmodule
