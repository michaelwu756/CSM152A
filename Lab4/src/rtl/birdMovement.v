module birdMovement(
   input wire gameClk,
   input wire button,
   input wire reset,
   input wire finished,
   output reg signed [10:0] y_out,
   output reg signed [10:0] v_out
);

`include "constants.v"

reg [14:0] delay = DELAY;

always @(posedge gameClk or posedge reset) begin
   if(reset) begin
      y_out <= Y_INIT;
      v_out <= 0;
      delay <= DELAY;
   end
   else if (!finished) begin
      if (delay != 0)
         delay <= delay - 1;
      else begin
         v_out <= (y_out + v_out/16 > SCREEN_HEIGHT - BIRD_HEIGHT) ? 0 :
            (button) ? MAX_VELOCITY :
            (v_out - ACCEL > -MAX_VELOCITY) ? v_out - ACCEL : -MAX_VELOCITY;
         y_out<=(y_out + v_out/16 > SCREEN_HEIGHT - BIRD_HEIGHT) ? SCREEN_HEIGHT - BIRD_HEIGHT :
            (y_out + v_out/16 < BIRD_HEIGHT) ? BIRD_HEIGHT : y_out + v_out/16;
      end
   end
end

endmodule