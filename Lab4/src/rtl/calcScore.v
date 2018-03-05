module calcScore(input game_clk,
                 input reset,
                 input [9:0] score_in,
                 input passColumn,
                 output [9:0] score_out);

  reg [9:0] score_out;

  always @ (posedge game_clk) begin
    if (reset)
      score_out <= 0;
    else
      score_out <= passColumn ? score_in+1 : score_in;
  end

endmodule
