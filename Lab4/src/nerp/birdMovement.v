module birdMovement(
    input gameClk,
    input button,
    input reset,
    input finished,
    output reg signed [10:0] y_out,
    output reg signed [10:0] v_out
    );
`include "constants.v"

always @(posedge gameClk or posedge reset)
   begin
      if(reset)
         begin
            y_out<=Y_INIT;
            v_out<=0;
         end
      else if (!finished)
         begin
            v_out<=(y_out+v_out/16>SCREEN_HEIGHT-bird_height) ? 0 :
               (button) ? MAX_VELOCITY :
               (v_out-ACCEL > -MAX_VELOCITY) ? v_out-ACCEL : -MAX_VELOCITY;
            y_out<=(y_out+v_out/16>SCREEN_HEIGHT-bird_height) ? SCREEN_HEIGHT-bird_height :
               (y_out+v_out/16<bird_height) ? bird_height : y_out+v_out/16;
         end
   end

endmodule
