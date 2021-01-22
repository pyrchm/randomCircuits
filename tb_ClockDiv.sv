// Code your testbench here
// or browse Examples
`timescale 1ns / 1ns
module tb_mod5Counter();
  
  reg clk, reset;
  
  //wire [2:0] out1, out2;
  wire out4, out5, out6;
  wire invalid;
  
  //mod5Counter DUT1(.clk(clk), .reset(reset), .out(out1));
  //mod5RTL DUT2(.clk(clk), .reset(reset), .out(out2));
  clockDivBy5 DUT1(.clkIn(clk), .reset(reset), .clkDiv_5(out5));
  clockDivBy4 DUT2(.clkIn(clk), .reset(reset), .clkDiv_4(out4));
  clockDivBy6 DUT3(.clkIn(clk), .reset(reset), .clkDiv_6(out6));
  
  initial begin
    reset = 0;
    
    #50 reset = 1;
    #250 reset = 0;
    #20 reset = 1;
  
  end
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  //assign invalid = (out1 == out2) ? 0 : 1;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $dumpon;
    
    #5000;
    $dumpoff;
    $finish;
  end
  
endmodule
