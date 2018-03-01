`timescale 1ns / 1ps
module bridMovement(
    input gameClk,
    input [9:0] y_in,
    input signed [4:0] v_in,
    input button,
    input reset,
    input finished,
    output [9:0] y_out,
    output signed [5:0] v_out
    );

parameter ACCEL = 3;
parameter MAX_VELOCITY = 30;
parameter Y_INIT = 340;

always @(posedge gameClk)
   begin
      if(reset)
         begin
            y_out<=Y_INIT;
            v_out<=0;
         end
      else if (finished)
         begin
            y_out<=y_in;
            v_out<=v_in;
         end
      else
         begin
            v_out<=(button) ? MAX_VELOCITY : (v_in-ACCEL > -MAX_VELOCITY) ? v_in-ACCEL : -MAX_VELOCITY;
            y_out<=(y_in+v_in>680) ? 680 : (y_in+v_in<0) ? 0 : y_in+v_in;
         end
   end

endmodule
