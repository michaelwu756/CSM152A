module calcScore(input game_clk,
                 input reset,
                 input passColumn,
                 output [9:0] score_out);

  reg [9:0] score_out;

  always @ (posedge game_clk) begin
    if (reset)
      score_out <= 0;
    else
      score_out <= passColumn ? score_out+1 : score_out;
  end

endmodule
