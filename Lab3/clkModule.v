module clkModule(clk,pause,clk_1, clk_2, clk_2p5, clk_100);
  input clk, pause;
  output clk_1, clk_2, clk_2p5, clk_100;
  
  parameter TARGET_2 = 100/2;
  parameter TARGET_2p5 = 100/2.5;
  parameter TARGET_1 = 100/1;
  
  // Use 100Hz clock as clock divider
  clk100 secondaryClk(clk, pause, clk_100);
  reg [5:0] counter2 = 0;
  reg [5:0] counter2p5 = 0;
  reg [6:0] counter1 = 0;
  
  // Update/reset counters for other clks
  always @(posedge clk_100)
  begin
    counter2 = (counter2 == TARGET_2) ? 0 : counter2+1;
    counter2p5 = (counter2p5 == TARGET_2p5) ? 0 : counter2p5+1;
    counter1 = (counter1 == TARGET_1) ? 0 : counter1+1;
  end
  
  assign clk_2 = (counter2 == TARGET_2);
  assign clk_2p5 = (counter2p5 == TARGET_2p5);
  assign clk_1 = (counter1 == TARGET_1);

endmodule

module clk100(clk, pause, clk_100);
  input clk, pause;
  output clk_100;
  
  parameter MASTER_FREQ = 28'd100000000;
  parameter TARGET_100 = MASTER_FREQ/100;
  
  reg [27:0] counter100 = 0;
  
  always @(posedge clk)
  begin
    if(!pause) begin
      if(counter100 == TARGET_100)
  		counter100 = 28'd0;
  	else
  		counter100 = counter100+1;
    end
  end
  
  assign clk_100 = (counter100 == TARGET_100) ? 1 : 0;
endmodule



