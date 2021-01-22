// Code your design here
`timescale 1ns / 1ns
module clockDivBy6(clkIn, reset, clkDiv_6);

  input clkIn;
  input reset;

  output wire clkDiv_6;

  wire [2:0] counter;
  reg reg1, reg2;
  wire w1;

  //Mod 6 Counter
  mod6Counter mod6(.clk(clkIn), .reset(reset), .out(counter));

  always @(posedge clkIn)
    reg1 <= (!reset) ? 0 : counter[2];
  
  assign w1 = counter[2];
  
  or(clkDiv_6, reg1, w1);

endmodule
module clockDivBy4(clkIn, reset, clkDiv_4);

  input clkIn;
  input reset;

  output wire clkDiv_4;

  wire [1:0] counter;
  reg reg1;
  wire w1;

  //Mod 4 Counter
  mod4Counter mod4(.clk(clkIn), .reset(reset), .out(counter));

  assign clkDiv_4 = counter[1];

endmodule
module clockDivBy5(clkIn, reset, clkDiv_5);

  input clkIn;
  input reset;

  output wire clkDiv_5;

  wire [2:0] counter;
  reg reg1;
  wire w1;

  //Mod 5 Counter
  mod5Counter mod5(.clk(clkIn), .reset(reset), .out(counter));

  assign w1 = counter[1];
  
  always @(negedge clkIn)
  begin
    reg1 <= (!reset) ? 0 : counter[1];
  end
    
  or(clkDiv_5, w1, reg1);

endmodule

/*****************************************************************/
module mod5Counter(clk, reset, out);
  
  input clk;
  input reset;
  
  output reg [2:0] out;
  
  localparam S_0 = 3'b000,
             S_1 = 3'b001,
             S_2 = 3'b010,
             S_3 = 3'b011,
             S_4 = 3'b100;
  
  reg [2:0] currState, nextState;
  
  always @(posedge clk or negedge reset)
    begin
      if(!reset)
        currState <= S_0;
      else
        currState <= nextState;
    end
  
  always @(currState)
    begin
      case(currState)
        S_0: begin
          nextState <= S_1;
          
          out <= 3'b000;
        end
        S_1: begin
          nextState <= S_2;
          
          out <= 3'b001;
        end
        S_2: begin
          nextState <= S_3;
          
          out <= 3'b010;
        end
        S_3: begin
          nextState <= S_4;
          
          out <= 3'b011;
        end
        S_4: begin
          nextState <= S_0;
          
          out <= 3'b100;
        end
      endcase
    end
  
endmodule

/**********************************************************/
module mod4Counter(clk, reset, out);
  
  input clk;
  input reset;
  
  output reg [1:0] out;
  
  localparam S_0 = 2'b00,
             S_1 = 2'b01,
             S_2 = 2'b10,
             S_3 = 2'b11;
  
  reg [1:0] currState, nextState;
  
  always @(posedge clk or negedge reset)
    begin
      if(!reset)
        currState <= S_0;
      else
        currState <= nextState;
    end
  
  always @(currState)
    begin
      case(currState)
        S_0: begin
          nextState <= S_1;
          
          out <= 2'b00;
        end
        S_1: begin
          nextState <= S_2;
          
          out <= 2'b01;
        end
        S_2: begin
          nextState <= S_3;
          
          out <= 2'b10;
        end
        S_3: begin
          nextState <= S_0;
          
          out <= 2'b11;
        end
      endcase
    end
  
endmodule

/**********************************************************/
module mod6Counter(clk, reset, out);
  
  input clk;
  input reset;
  
  output reg [2:0] out;
  
  localparam S_0 = 3'b000,
             S_1 = 3'b001,
             S_2 = 3'b010,
             S_3 = 3'b011,
  			 S_4 = 3'b100,
  			 S_5 = 3'b101;
  
  reg [2:0] currState, nextState;
  
  always @(posedge clk or negedge reset)
    begin
      if(!reset)
        currState <= S_0;
      else
        currState <= nextState;
    end
  
  always @(currState)
    begin
      case(currState)
        S_0: begin
          nextState <= S_1;
          
          out <= 3'b000;
        end
        S_1: begin
          nextState <= S_2;
          
          out <= 3'b001;
        end
        S_2: begin
          nextState <= S_3;
          
          out <= 3'b010;
        end
        S_3: begin
          nextState <= S_4;
          
          out <= 3'b011;
        end
        S_4: begin
          nextState <= S_5;
          
          out <= 3'b100;
        end
        S_5: begin
          nextState <= S_0;
          
          out <= 3'b101;
        end
      endcase
    end
  
endmodule

/**********************************************************/
module mod5RTL(clk, reset, out);
  
  input clk;
  input reset;
  
  output [2:0] out;
  
  wire [2:0] q_next;
  reg [2:0] q_curr;
  
  wire [2:0] q_currInv;
  wire w1, w2;
  
  
  always @(posedge clk or negedge reset)
    begin
      q_curr <= (reset) ? q_next : 3'b000;
    end
  
  assign out = q_curr;
  
  not(q_currInv[0], q_curr[0]);
  not(q_currInv[1], q_curr[1]);
  not(q_currInv[2], q_curr[2]);
  
  // q_next[0]
  and (q_next[0], q_currInv[2], q_currInv[0]); 
  
  // q_next[1]
  and (w1, q_currInv[2], q_currInv[1], q_curr[0]);
  and (w2, q_currInv[2], q_curr[1], q_currInv[0]);
  or (q_next[1], w1, w2);
  
  // q_next[2]
  and (q_next[2], q_currInv[2], q_curr[1], q_curr[0]);
  
endmodule
  
