module clkModule(clk,pause,clk_1, clk_2, clk_2p5, clk_500);
  input clk, pause;
  output clk_1, clk_2, clk_2p5, clk_500;
  
  parameter TARGET_2 = 500/2;
  parameter TARGET_2p5 = 1000/5;
  parameter TARGET_1 = 500/1;
  
  // Use 100Hz clock as clock divider
  clk500 secondaryClk(clk, pause, clk_500);
  reg [5:0] counter2 = 0;
  reg [5:0] counter2p5 = 0;
  reg [6:0] counter1 = 0;
  
  // Update/reset counters for other clks
  always @(posedge clk_500)
  begin
    counter2 = (counter2 == TARGET_2) ? 0 : counter2+1;
    counter2p5 = (counter2p5 == TARGET_2p5) ? 0 : counter2p5+1;
    counter1 = (counter1 == TARGET_1) ? 0 : counter1+1;
  end
  
  assign clk_2 = (counter2 == TARGET_2);
  assign clk_2p5 = (counter2p5 == TARGET_2p5);
  assign clk_1 = (counter1 == TARGET_1);

endmodule

module clk500(clk, pause, clk_500);
  input clk, pause;
  output clk_500;
  
  parameter MASTER_FREQ = 28'd100000000;
  parameter TARGET_500 = MASTER_FREQ/500;
  
  reg [27:0] counter500 = 0;
  
  always @(posedge clk)
  begin
    if(!pause) begin
      if(counter500 == TARGET_500)
  		counter500 = 28'd0;
  	else
  		counter500 = counter500+1;
    end
  end
  
  assign clk_500 = (counter500 == TARGET_500) ? 1 : 0;
endmodule



