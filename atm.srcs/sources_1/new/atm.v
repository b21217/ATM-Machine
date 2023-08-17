`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2023 11:11:30
// Design Name: 
// Module Name: atm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module atm( rst,pin,keypad,clk,valid,need_cash,new_pin,cash,final_cash,display);
input rst;
input [3:0]pin;
input [3:0]keypad;
input clk,valid;
input [9:0]need_cash;
input [3:0]new_pin;
output reg cash;
output reg [9:0]final_cash;
output reg [7:0]display;


  parameter insert_card = 4'b1000;
  parameter enter_pin = 4'b1001;
  parameter withdraw = 4'b0000;
  parameter change_pin = 4'b0001;
  parameter balance_check = 4'b0010;
  parameter idle = 4'b0100;
  parameter amount_tb_wd = 4'b0111; 
  reg [3:0]vpin = 4'b0100;
  reg [3:0]curr_state,nxt_state;
  reg [9:0]remain_bal = 10'b0001000100;
  
always @ (*) begin
case( curr_state)
 idle: begin
 display <= 8'b11111111;
 final_cash <= 8'bxxxxxxxx;
 cash  <= 1'bx; end
 
 insert_card : begin
 display <= 8'b00000000;
 final_cash <= 8'bxxxxxxxx;
 cash  <= 1'bx; end
 
 enter_pin : begin
 display <= 8'b00000001;
 final_cash <= 8'bxxxxxxxx;  
 cash  <= 1'bx; end  
  
 withdraw : begin
 display <= 8'b00000010;
 cash  <= 1'bx; end   
  
 change_pin : begin
 display <= 8'b00000011;
 final_cash <= 8'bxxxxxxxx;  
 vpin <= new_pin;
 cash  <= 1'bx; end  
  
 balance_check : begin
 display <= 8'b00000100;
 // check remain_bal <= remain_bal - need_cash;
 final_cash <=  remain_bal;
 cash  <= 1'bx; end  
  
 amount_tb_wd : begin
 display <= 8'b00000101;
 cash  <= 1'b1; end 
 
  endcase
  end
  always @ (posedge clk ) begin   
   if (rst) 
 curr_state<= idle;
 else begin
 curr_state<=nxt_state;
 end
 end
 
 always @ (posedge clk) begin
 nxt_state <= curr_state;
 case(curr_state) 
 idle:begin
 nxt_state<=curr_state;
 end
insert_card : begin
if (valid) begin
nxt_state <= enter_pin;
end
else
nxt_state <= idle;
end

enter_pin : begin
if (pin == vpin) begin
   if (keypad == 0)
   nxt_state <= withdraw;
   else if (keypad == 1)
   nxt_state <= balance_check;
   else if (keypad == 2)
   nxt_state<=change_pin;
   end
 else
 nxt_state<=insert_card;
 end
 
 withdraw : begin
 nxt_state <= amount_tb_wd; end
 
 amount_tb_wd : begin
 if (need_cash <= remain_bal) begin
  remain_bal <= remain_bal - need_cash;
  nxt_state <= insert_card;
  end
 else
 nxt_state<= idle;
 end
 
 balance_check : begin
 nxt_state<= idle;
 end
 
 change_pin : begin
 nxt_state<= insert_card;
  end
  
 default : 
 nxt_state <= insert_card;
 
 endcase
 end
 
endmodule

