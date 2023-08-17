`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2023 13:16:35
// Design Name: 
// Module Name: tb
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


module tb(
    );
    reg rst;
    reg [3:0]pin;
    reg [3:0]keypad;
    reg clk,valid;
    reg [9:0]need_cash;
    reg [3:0]new_pin;
    wire cash;
    wire [9:0]final_cash;
    wire [7:0]display;
    
    atm uut(.rst(rst),.pin(pin),.keypad(keypad),.clk(clk),.valid(valid),.need_cash(need_cash),.new_pin(new_pin),.cash(cash),.final_cash(final_cash),.display(display)  );
            
    
    initial begin
    clk = 0;
    rst =1;
    #3 rst =0;
    pin = 4;
    keypad = 0;
    valid = 1;
    need_cash = 5;
       #18
    pin = 4;
    keypad = 2;
   // need_cash = 10'bxxxxxxxxxx;
    valid = 1;
    new_pin = 12;  
    
          #18
  pin = 4;
  keypad = 0;
  valid = 1;
  need_cash = 3;
    #18
    pin = 12;
    keypad = 1;
    valid = 1;

    
    #100 $finish;
    end
    
    
     
     always
     #1 clk = ~clk;
     
     
     

endmodule
