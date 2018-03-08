module columnGen(gameClk, reset, finished, Ax, Ay, Bx, By, passColumn);

  input gameClk, reset, finished;
  output [9:0] Ax, Ay, Bx, By;
  output passColumn;

  parameter DISPLAY_HEIGHT = 480;
  parameter DISPLAY_WIDTH = 640;
  parameter COL_WIDTH = 20;
  parameter GAP_HEIGHT = 100;
  parameter PADDING = 20;


  // Ainfo -- 0: x-offset of RIGHT SIDE of COL, 1: y-coord of GAP CENTER
  reg [9:0] Ax, Ay, Bx, By;
  reg passColumn;

  always @(posedge gameClk) begin
    // if first col of Ainfo is 0, generate new column
    if (Ax == 0) begin
      Ax <= DISPLAY_WIDTH + COL_WIDTH - 1;    //
      Ay <= ($urandom % (DISPLAY_HEIGHT - 2*PADDING - GAP_HEIGHT)) + PADDING + GAP_HEIGHT/2;
      Bx <= Bx - 1;
      passColumn <= 1;
    end
    // if first col of Binfo is 0, generate new column
    else if (Bx == 0) begin
      Bx <= DISPLAY_WIDTH + COL_WIDTH - 1;
      By <= ($urandom % (DISPLAY_HEIGHT - 2*PADDING - GAP_HEIGHT)) + PADDING + GAP_HEIGHT/2;
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
