`timescale 1ns / 1ps
module segdisplay(
   input wire segclk,      //7-segment clock
   input wire [9:0] score,
   input wire clr,         //asynchronous reset
   output reg [6:0] seg,   //7-segment display LEDs
   output reg [3:0] an     //7-segment display anode enable
);

`include "constants.v"

wire [3:0] wleft;
wire [3:0] wmidleft;
wire [3:0] wmidright;
wire [3:0] wright;

assign wleft = score/1000;
assign wmidleft = (score%1000 - score%100)/100;
assign wmidright = (score%100 - score%10)/10;
assign wright = score%10;

// state register
reg [1:0] state;

// FSM which cycles though every digit of the display every 2.62ms.
// This should be fast enough to trick our eyes into seeing that
// all four digits are on display at the same time.
always @(posedge segclk or posedge clr) begin
   // reset condition
   if (clr == 1) begin
      seg <= 7'b1111111;
      an <= 7'b1111;
      state <= SEG_LEFT;
   end
   // display the character for the current position
   // and then move to the next state
   else begin
      case(state)
         SEG_LEFT: begin
            case (wleft)
               1: seg <= DISPLAY_1;
               2: seg <= DISPLAY_2;
               3: seg <= DISPLAY_3;
               4: seg <= DISPLAY_4;
               5: seg <= DISPLAY_5;
               6: seg <= DISPLAY_6;
               7: seg <= DISPLAY_7;
               8: seg <= DISPLAY_8;
               9: seg <= DISPLAY_9;
               0: seg <= DISPLAY_0;
            endcase
            an <= 4'b0111;
            state <= SEG_MIDLEFT;
         end
         SEG_MIDLEFT: begin
            case (wmidleft)
               1: seg <= DISPLAY_1;
               2: seg <= DISPLAY_2;
               3: seg <= DISPLAY_3;
               4: seg <= DISPLAY_4;
               5: seg <= DISPLAY_5;
               6: seg <= DISPLAY_6;
               7: seg <= DISPLAY_7;
               8: seg <= DISPLAY_8;
               9: seg <= DISPLAY_9;
               0: seg <= DISPLAY_0;
            endcase
            an <= 4'b1011;
            state <= SEG_MIDRIGHT;
         end
         SEG_MIDRIGHT: begin
            case (wmidright)
               1: seg <= DISPLAY_1;
               2: seg <= DISPLAY_2;
               3: seg <= DISPLAY_3;
               4: seg <= DISPLAY_4;
               5: seg <= DISPLAY_5;
               6: seg <= DISPLAY_6;
               7: seg <= DISPLAY_7;
               8: seg <= DISPLAY_8;
               9: seg <= DISPLAY_9;
               0: seg <= DISPLAY_0;
            endcase
            an <= 4'b1101;
            state <= SEG_RIGHT;
         end
         SEG_RIGHT: begin
            case (wright)
               1: seg <= DISPLAY_1;
               2: seg <= DISPLAY_2;
               3: seg <= DISPLAY_3;
               4: seg <= DISPLAY_4;
               5: seg <= DISPLAY_5;
               6: seg <= DISPLAY_6;
               7: seg <= DISPLAY_7;
               8: seg <= DISPLAY_8;
               9: seg <= DISPLAY_9;
               0: seg <= DISPLAY_0;
            endcase
            an <= 4'b1110;
            state <= SEG_LEFT;
         end
      endcase
   end
end

endmodule