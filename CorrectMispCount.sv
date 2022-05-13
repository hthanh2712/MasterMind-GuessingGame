// This module computes the number of correct and misplaced digits in the user // passcode by comparing it to the randome passcode 
// As shown in the block diagram: 
// Inputs: Reset, Sequence of digits, Random number, Clock, submit 
// Output : Number of correct digits and misplaced digits 
module correctMispCount(dig0, dig1, dig2, dig3, random, countCorrect, countMisplaced, CLOCK_50, reset, submit); 
input logic [1:0] dig0; 
input logic [1:0] dig1; 
input logic [1:0] dig2; 
input logic [1:0] dig3; 
input logic [7:0] random; 
input logic CLOCK_50; 
input logic reset; 
input reg submit; 
output reg [2:0] countCorrect; 
output reg [2:0] countMisplaced; 
reg [2:0] tempCorrect = 3'b000; 
reg [2:0] tempMisp = 3'b000; 
reg match [3:0]; 
reg misp [3:0]; 
comparator comp1(.A(dig0), .B(random[1:0]), .out(match[0])); 
comparator comp2(.A(dig1), .B(random[3:2]), .out(match[1])); 
comparator comp3(.A(dig2), .B(random[5:4]), .out(match[2])); 
comparator comp4(.A(dig3), .B(random[7:6]), .out(match[3])); 
always @* begin 
misp[0] = ~match[0] & ((dig0 == random[3:2] & ~match[1]) | (dig0 == random[5:4]& ~match[2]) | (dig0 == random[7:6] & ~match[3]));
misp[1] = ~match[1] & ((dig1 == random[1:0] & ~match[0]) | (dig1 == random[5:4]& ~match[2]) | (dig1 == random[7:6] & ~match[3])); 
misp[2] = ~match[2] & ((dig2 == random[3:2] & ~match[1]) | (dig2 == random[1:0]& ~match[0]) | (dig2 == random[7:6] & ~match[3])); 
misp[3] = ~match[3] & ((dig3 == random[3:2] & ~match[1]) | (dig3 == random[5:4]& ~match[2]) | (dig3 == random[1:0] & ~match[0])); 
end 
always @* begin 
 tempMisp = (misp[0]) + (misp[1]) + (misp[2] ) + (misp[3]); 
 tempCorrect = match[0] + match[1] + match[2] + match[3]; 
end 
always_ff @(posedge CLOCK_50) begin 
if (reset) begin 
countCorrect <= 3'b000; 
countMisplaced <= 3'b000; 
end 
else if (submit) begin 
countCorrect <= tempCorrect; 
countMisplaced <= tempMisp; 
end 
 end 
endmodule 

// This module creates a testbench for the correctMispCount module 
module correctMispCount_testbench(); 
logic CLOCK_50; 
// various values for digits were used 
logic [1:0] dig0 = 2'b00; 
logic [1:0] dig1 = 2'b00; 
logic [1:0] dig2 = 2'b00; 
logic [1:0] dig3 = 2'b00; 
logic [2:0] countCorrect; 
logic [2:0] countMisplaced; 
logic [7:0] random; 
logic reset; 
logic submit; 
reg [2:0] count;
correctMispCount dut(.dig0, .dig1, .dig2, .dig3, .random, .countCorrect, .countMisplaced, .CLOCK_50, .reset, .submit); 
// test for all random values 
integer i; 
initial begin 
reset = 1; #100; 
reset = 0; #100; 
for(i = 0; i <64; i++) begin 
{random} = i; #10; 
end 
end 
initial begin 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
@(posedge CLOCK_50); 
 end 
endmodule 
