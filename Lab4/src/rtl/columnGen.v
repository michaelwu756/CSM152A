module columnGen(gameClk, reset, finished, Ainfo, Binfo) 
  input gameClk, reset, finished;
  output Ainfo, Binfo;
  
  // Ainfo -- 0: x-offset, 1: gap height
  wire [9:0] Ainfo [1:0];
  wire [9:0] Binfo [1:0];
  
  always @(posedge gameClk) begin     
    // if first col of Ainfo is 0, generate new column
    if (Ainfo[0] == 0) begin
      Ainfo[0] = Binfo[0] - 1;
      Ainfo[1] = Binfo[1];
      Binfo[0] = DISPLAY_WIDTH - 1;
      Binfo[1] = $urandom / (DISPLAY_HEIGHT - GAP_HEIGHT);
    end
    else begin 
      Ainfo[0] = Ainfo[0] + 1;
      Binfo[0] = Binfo[0] + 1;
    end    
  end
  
endmodule 