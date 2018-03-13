module calcScore(
   input wire game_clk,
   input wire reset,
   input wire passColumn,
   output reg [9:0] score_out
);

always @ (posedge game_clk or posedge reset) begin
   if (reset)
      score_out <= 0;
   else
      score_out <= passColumn ? score_out + 1 : score_out;
end

endmodule