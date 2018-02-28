module clkModule(clk,clk_1, clk_2, clk_10, clk_500);
  input clk;
  output clk_1, clk_2, clk_10, clk_500;
  
  parameter TARGET_2 = 250;
  parameter TARGET_10 = 50;
  parameter TARGET_1 = 500;
  
  // Use 100Hz clock as clock divider
  clk500 secondaryClk(clk, clk_500);
  reg [7:0] counter2 = 1;
  reg [7:0] counter10 = 1;
  reg [8:0] counter1 = 1;
  
  // Update/reset counters for other clks
  always @(posedge clk_500)
  begin
    counter2 = (counter2 == TARGET_2) ? 1 : counter2+1;
    counter10 = (counter10 == TARGET_10) ? 1 : counter10+1;
    counter1 = (counter1 == TARGET_1) ? 1 : counter1+1;
  end
  
  assign clk_2 = (counter2 == TARGET_2 && clk_500) ? 1 : 0;
  assign clk_10 = (counter10 == TARGET_10 && clk_500) ? 1 : 0;
  assign clk_1 = (counter1 == TARGET_1 && clk_500) ? 1 : 0;

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



