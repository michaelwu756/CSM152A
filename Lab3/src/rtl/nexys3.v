module nexys3 (/*AUTOARG*/
   // Outputs
   seg, an,
   // Inputs
   sw, btnS, btnR, clk
   );

`include "display_definitions.v"

   // Misc.
   input  [7:0] sw;
   output [7:0] seg;
   output [3:0] an;
   input        btnS;                 // single-step instruction
   input        btnR;                 // arst

   // Logic
   input        clk;                  // 100MHz
   
   wire        rst;
   wire        arst_i;

   reg [1:0]   arst_ff;

   reg [7:0]   inst_wd;
   reg [2:0]   step_d;
   reg pause;

   reg [3:0]   enable_led;
   reg [7:0]   display_val;

   reg [5:0]   seconds;
   reg [5:0]   minutes;
   reg [3:0][3:0]   digit;

   
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

   wire clk, clk_1, clk_2, clk_2p5, clk_500;

   clkModule clkA(clk, pause, clk_1, clk_2, clk_2p5, clk_500);

   // ===========================================================================
   // Instruction Stepping Control / Debouncing
   // ===========================================================================

   always @ (posedge clk)
     if (rst)
       begin
          inst_wd[7:0] <= 0;
          step_d[2:0]  <= 0;
       end
     else if (clk_500) // Down sampling
       begin
          inst_wd[7:0] <= sw[7:0];
          step_d[2:0]  <= {btnS, step_d[2:1]};
       end

   always @ (posedge clk_1)
      if (rst)
         begin
            seconds <= 0;
            minutes <= 0;
            digit[3] <= 0;
            digit[2] <= 0;
            digit[1] <= 0;
            digit[0] <= 0;
         end
      else begin
         digit[3] <= (minutes - (minutes % 10))/ 10;
         digit[2] <= minutes % 10;
         digit[1] <= (seconds - (seconds % 10))/ 10;
         digit[0] <= seconds % 10;
         if (seconds==59)
            begin
               seconds <=0;
               if(minutes == 59)
                  minutes <= 0;
               else
                  minutes <= minutes+1;
            end
         else
            seconds <= seconds + 1;
      end

   always @ (posedge clk_500)
      if (rst)
         begin
            enable_led   <= 4'b1110;
            case (digit[0])
               1: display_val<=display_1;
               2: display_val<=display_2;
               3: display_val<=display_3;
               4: display_val<=display_4;
               5: display_val<=display_5;
               6: display_val<=display_6;
               7: display_val<=display_7;
               8: display_val<=display_8;
               9: display_val<=display_9;
               0: display_val<=display_0;
            endcase
         end
      else
         begin
            case (enable_led)
               4'b1110: begin
                  enable_led <= 4'b1101;
                  case (digit[1])
                     1: display_val<=display_1;
                     2: display_val<=display_2;
                     3: display_val<=display_3;
                     4: display_val<=display_4;
                     5: display_val<=display_5;
                     6: display_val<=display_6;
                     7: display_val<=display_7;
                     8: display_val<=display_8;
                     9: display_val<=display_9;
                     0: display_val<=display_0;
                  endcase
               end
               4'b1101: begin
                  enable_led <= 4'b1011;
                  case (digit[2])
                     1: display_val<=display_1;
                     2: display_val<=display_2;
                     3: display_val<=display_3;
                     4: display_val<=display_4;
                     5: display_val<=display_5;
                     6: display_val<=display_6;
                     7: display_val<=display_7;
                     8: display_val<=display_8;
                     9: display_val<=display_9;
                     0: display_val<=display_0;
                  endcase
               end
               4'b1011: begin
                  enable_led <= 4'b0111;
                  case (digit[3])
                     1: display_val<=display_1;
                     2: display_val<=display_2;
                     3: display_val<=display_3;
                     4: display_val<=display_4;
                     5: display_val<=display_5;
                     6: display_val<=display_6;
                     7: display_val<=display_7;
                     8: display_val<=display_8;
                     9: display_val<=display_9;
                     0: display_val<=display_0;
                  endcase
               end
               4'b0111: begin
                  enable_led <= 4'b1110;
                  case (digit[0])
                     1: display_val<=display_1;
                     2: display_val<=display_2;
                     3: display_val<=display_3;
                     4: display_val<=display_4;
                     5: display_val<=display_5;
                     6: display_val<=display_6;
                     7: display_val<=display_7;
                     8: display_val<=display_8;
                     9: display_val<=display_9;
                     0: display_val<=display_0;
                  endcase
               end
            endcase
         end

   // Detecting posedge of btnS
   wire is_btnS_posedge;
   assign is_btnS_posedge = ~ step_d[0] & step_d[1];
   always @ (posedge clk)
     if (rst)
       pause <= 0;
     else if (is_btnS_posedge)
       pause <= !pause;

   assign an[3:0] = enable_led[3:0];
   assign seg = display_val;
   
endmodule // nexys3
// Local Variables:
// verilog-library-flags:("-f ../input.vc")
// End:
