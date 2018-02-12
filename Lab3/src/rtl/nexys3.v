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

   reg [3:0]   digit0;
	reg [3:0]   digit1;
	reg [3:0]   digit2;
	reg [3:0]   digit3;
	reg [1:0] 	display_digit;

   
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
	
	
	task incrementDigit0;
		begin
			if(digit0==9) begin
				digit0=0;
				incrementDigit1();
				end
			else 
				digit0=digit0+1;
		end
	endtask
	
	task incrementDigit1;
		begin
			if(digit1==5) begin
				digit1=0;
				incrementDigit2();
				end
			else 
				digit1=digit1+1;
		end
	endtask
	
		
	task incrementDigit2;
		begin
			if(digit2==9) begin
				digit2=0;
				incrementDigit3();
				end
			else 
				digit2=digit2+1;
		end
	endtask

	task incrementDigit3;
		begin
			if(digit3==5) 
				digit3=0;
			else 
				digit3=digit3+1;
		end
	endtask
	
	task convertToDisplay;
		reg digit_val;
		begin
			case (display_digit)
				0: begin enable_led = 4'b1110; digit_val=digit0; end
				1: begin enable_led = 4'b1101; digit_val=digit1; end
				2: begin enable_led = 4'b1011; digit_val=digit2; end
				3: begin enable_led = 4'b0111; digit_val=digit3; end
			endcase		
			case (digit_val)
				1: display_val=display_1;
				2: display_val=display_2;
				3: display_val=display_3;
				4: display_val=display_4;
				5: display_val=display_5;
				6: display_val=display_6;
				7: display_val=display_7;
				8: display_val=display_8;
				9: display_val=display_9;
				0: display_val=display_0;
			endcase
		end
	endtask
	
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
            digit3 = 0;
            digit2 = 0;
            digit1 = 0;
            digit0 = 0;
         end
      else 
         incrementDigit0();

   always @ (posedge clk_500)
		if (rst)
			begin
				display_val=display_0;
				enable_led=4'b0000;
				display_digit=0;
			end
		else
			begin
				convertToDisplay();	
				display_digit=display_digit+1;
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
