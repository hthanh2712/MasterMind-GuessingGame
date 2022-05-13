// LFSR module which outputs a random 8 bit number when SW[8] is turned on
module LFSR (clk, reset, random, sw);

	output reg [7:0] random;
	input clk, reset, sw;

	wire feedback;

	assign feedback = ~(random[7] ^ random[6]);

	always_ff @(posedge clk) begin
		if (~reset & sw) begin
			random = {random[6:0], feedback};
		end
	end
endmodule	

module LFSR_testbench();

   reg clk, reset, sw;

   wire [7:0] random;

   LFSR UUT(.clk(clk), .reset(reset), .random(random), .sw(sw));

	initial begin
		 clk = 0;
		 reset = 1;
		 #15;
		 
		 reset = 0;
		 #200;
	end

	always
	begin
		 #5;
		 clk = ~ clk;
	end
endmodule