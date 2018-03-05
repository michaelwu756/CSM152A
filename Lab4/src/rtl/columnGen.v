module columnGen(gameClk, reset, finished, Ax, Ay, Bx, By);
  input gameClk, reset, finished;
  output Ax, Ay, Bx, By;

  // Ainfo -- 0: x-offset of RIGHT SIDE of COL, 1: y-coord of GAP CENTER
  wire [9:0] Ax, Ay, Bx, By;

  always @(posedge gameClk) begin
    // if first col of Ainfo is 0, generate new column
    if (Ax == 0) begin
      Ax <= DISPLAY_WIDTH + COL_WIDTH - 1;    //
      Ay <= ($urandom % (DISPLAY_HEIGHT - 2*PADDING - GAP_HEIGHT)) + PADDING + GAP_HEIGHT/2;
      Bx <= Bx - 1;
    end
    // if first col of Binfo is 0, generate new column
    else if (Bx == 0) begin
      Bx <= DISPLAY_WIDTH + COL_WIDTH - 1;
      By <= ($urandom % (DISPLAY_HEIGHT - 2*PADDING - GAP_HEIGHT)) + PADDING + GAP_HEIGHT/2;
      Ax <= Ax - 1;
    end
    else begin
      Ax <= Ax - 1;
      Bx <= Bx - 1;
    end
  end

endmodule
