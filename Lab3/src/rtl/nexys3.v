module nexys3 (/*AUTOARG*/
   // Outputs
   led, seg, an,
   // Inputs
   sw, btnS, btnR, clk
   );

`include "display_definitions.v"

   // Misc.
   input  [7:0] sw;
   output [7:0] led;
   output [7:0] seg;
   output [3:0] an;
   input        btnS;                 // single-step instruction
   input        btnR;                 // arst
   
   // Logic
   input        clk;                  // 100MHz
   
   wire        rst;
   wire        arst_i;
   wire [17:0] clk_dv_inc;

   reg [1:0]   arst_ff;
   reg [16:0]  clk_dv;
   reg         clk_en;
   reg         clk_en_d;
   
   wire [9:0]  clk_en_inc;
   reg [8:0]   clk_en_count;
   reg         clk_1hz;
   reg         clk_1hz_d;
      
   reg [7:0]   inst_wd;
   reg         inst_vld;
   reg [2:0]   step_d;

   reg [7:0]   inst_cnt;
   reg [3:0]   enable_led;
   reg [7:0]   display_val;
   
   // ===========================================================================
   // Asynchronous Reset
   // ===========================================================================

   assign arst_i = btnR;
   assign rst = arst_ff[0];
   
   always @ (posedge clk or posedge arst_i)
     if (arst_i)
       arst_ff <= 2'b11;
     else
       arst_ff <= {1'b0, arst_ff[1]};

   // ===========================================================================
   // timing signal for clock enable
   // ===========================================================================

   assign clk_dv_inc = clk_dv + 1;
   assign clk_en_inc = clk_en_count+1;
   
   always @ (posedge clk)
     if (rst)
       begin
          clk_dv   <= 0;
          clk_en   <= 1'b0;
          clk_en_d <= 1'b0;
       end
     else
       begin
          clk_dv   <= clk_dv_inc[16:0];
          clk_en   <= clk_dv_inc[17];
          clk_en_d <= clk_en;
       end
   
   // ===========================================================================
   // Instruction Stepping Control / Debouncing
   // ===========================================================================

   always @ (posedge clk)
     if (rst)
       begin
          inst_wd[7:0] <= 0;
          step_d[2:0]  <= 0;
          clk_en_count <=0;
          clk_1hz <= 1'b0;
          clk_1hz_d <= 1'b0;
       end
     else if (clk_en) // Down sampling
       begin
          inst_wd[7:0] <= sw[7:0];
          step_d[2:0]  <= {btnS, step_d[2:1]};
          clk_en_count <= clk_en_inc[8:0];
          clk_1hz <= clk_en_inc[9];
          clk_1hz_d <= clk_1hz;
       end
            
   
   always @ (posedge clk_1hz_d)
      if (rst)
         begin
            enable_led   <= 4'b1110;
            display_val <= display_0;
         end
      else
         begin
            case (enable_led)
               4'b1110: enable_led <= 4'b1101;
               4'b1101: enable_led <= 4'b1011;
               4'b1011: enable_led <= 4'b0111;
               4'b0111: enable_led <= 4'b1110;
            endcase
            case (display_val)
               display_0: display_val<=display_1;
               display_1: display_val<=display_2;
               display_2: display_val<=display_3;
               display_3: display_val<=display_4;
               display_4: display_val<=display_5;
               display_5: display_val<=display_6;
               display_6: display_val<=display_7;
               display_7: display_val<=display_8;
               display_8: display_val<=display_9;
               display_9: display_val<=display_0;
            endcase
         end

   // Detecting posedge of btnS
   wire is_btnS_posedge;
   assign is_btnS_posedge = ~ step_d[0] & step_d[1];
   always @ (posedge clk)
     if (rst)
       inst_vld <= 1'b0;
     else if (clk_en_d)
       inst_vld <= is_btnS_posedge;
     else
       inst_vld <= 0;

   always @ (posedge clk)
     if (rst)
       inst_cnt <= 0;
     else if (inst_vld)
       inst_cnt <= inst_cnt + 1;

   assign led[7:0] = inst_cnt[7:0];
   assign an[3:0] = enable_led[3:0];
   assign seg = display_val;
   
endmodule // nexys3
// Local Variables:
// verilog-library-flags:("-f ../input.vc")
// End:
