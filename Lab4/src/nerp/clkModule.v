module clkModule(clk, score, clk_VGA, clk_button, clk_game);
  input clk, score;
  output clk_VGA, clk_button, clk_game;
  
  parameter TARGET_db = 2;  // at 250 Hz
  parameter TARGET_gameraw = 50;    // how fast the screen scrolls (10 Hz)
  wire TARGET_game;         // adjusted based on score (game progression)
  assign TARGET_game = TARGET_gameraw - score/100;
  wire clk_500;
  
  // Use 500Hz clock as clock divider
  clk500 secondaryClk(clk, clk_500);
  reg [10:0] counterDB = 1;
  reg [10:0] counterG = 1;
  
  assign clk_VGA = clk_500;
  
  // Update/reset counters for other clks
  always @(posedge clk_500)
  begin
    counterDB = (counterDB == TARGET_db) ? 1 : counterDB+1;
    counterG = (counterG == TARGET_game) ? 1 : counterG+1;
  end
  
  assign clk_button = (counterDB == TARGET_db && clk_500) ? 1 : 0;
  assign clk_game = (counterG == TARGET_game && clk_500) ? 1 : 0;

endmodule


module clk500(clk, clk_500);
  input clk;
  output clk_500;
  
  parameter MASTER_FREQ = 28'd100000000;
  parameter TARGET_500 = MASTER_FREQ/500;
  //parameter TARGET_500 = 4;
 
  reg [27:0] counter500 = 1;
  
  always @(posedge clk)
  begin
      if(counter500 == TARGET_500)
        counter500 = 28'd1;
      else
        counter500 = counter500+1;
  end
  
  assign clk_500 = (counter500 == TARGET_500) ? 1 : 0;
endmodule