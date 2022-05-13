// Thanh Tran
// EE 271
// Spring 2021

// This is the top level module, as mentioned in the block diagram
// Inputs: KeyStrokes to get user attempt, Reset (SW9), get random (SW8), Clock, get answer (SW8), Hack (SW5), Get Hint (SW1)
// Outputs : HEX0 - Number of digits in right place and right value
// HEX1 - Number of right digits not in right value
// HEX4 and 5 - Attempts made
// LED9 - Lost, LED8 - Win, LED7 - 0 = Hack
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	logic [7:0] random;
	
	logic zero, one, two, three;
	
	logic [1:0] dig0;
	logic [1:0] dig1;
	logic [1:0] dig2;
	logic [1:0] dig3;
	
	reg count;
	reg [3:0] attempts; // 16 attempts
	reg [2:0] countCorrect;
	reg [2:0] countMisplaced;
	
	logic submit;
	
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	
	always @* begin
		submit = SW[0];
	end
	
	assign LEDR [7:0] = random;
	
	LFSR lfsr(.clk(CLOCK_50), .reset(SW[9]), .random, .sw(SW[8]));
	userInput in1(.clk(CLOCK_50), .button(~KEY[0]), .out(zero), .reset(SW[9]));
	userInput in2(.clk(CLOCK_50), .button(~KEY[1]), .out(one), .reset(SW[9]));

	userInput in3(.clk(CLOCK_50), .button(~KEY[2]), .out(two), .reset(SW[9]));
	userInput in4(.clk(CLOCK_50), .button(~KEY[3]), .out(three), .reset(SW[9]));

	assignment ass(.CLOCK_50, .dig0, .dig1, .dig2, .dig3, .zero, .one, .two, .three,
	.reset(SW[9]), .attempts);
		
	correctMispCount corr(.dig0, .dig1, .dig2, .dig3, .random, .countCorrect,
	.countMisplaced, .CLOCK_50, .reset(SW[9]), .submit);
	
	display disp1(.score(countCorrect), .seg7(HEX0), .reset(SW[9]));
	display disp2(.score(countMisplaced), .seg7(HEX1), .reset(SW[9]));
	display3 disp3(.score(attempts), .HEX5, .HEX4, .reset(SW[9]));
	
	//display2 losing(.state(lost), .LEDs(LEDR[9]), .reset(SW[9]));
	//display2 winning(.state(win), .LEDs(LEDR[8]), .reset(SW[9]));
	always @* begin
		if (SW[5]) LEDR [7:0] = random;
		else 
			LEDR [7:0] = 8'b00000000;
			if (attempts == 4'b1111) begin	//losing case
				LEDR[9] = 1'b1;
				LEDR[8] = 1'b0;
			end
			else if (countCorrect == 3'b100)	begin		//winning case
				LEDR[9] = 1'b0;
				LEDR[8] = 1'b1;
			end
	end
endmodule

// This module creates a testbench for the DE1_SoC module
module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic CLOCK_50;
		
	// Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial CLOCK_50 = 1;
		always begin
		#(CLOCK_PERIOD / 2);
		CLOCK_50 = ~CLOCK_50;
	end

	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
		
		initial begin
			SW[7] <= 0; 													@(posedge CLOCK_50);
																					@(posedge CLOCK_50);

		SW[9] <= 1; 												@(posedge CLOCK_50);
		SW[9] <= 0; 										@(posedge CLOCK_50);
		SW[8] <= 1; 												@(posedge CLOCK_50);

																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);

		SW[8] <= 0;													 @(posedge CLOCK_50);
		KEY <= 4'b1011; 									@(posedge CLOCK_50);

		@(posedge CLOCK_50);
		@(posedge CLOCK_50);

		KEY <= 4'b1111; 		@(posedge CLOCK_50);

																@(posedge CLOCK_50);
																@(posedge CLOCK_50);

		KEY <= 4'b1011;@(posedge CLOCK_50);

														@(posedge CLOCK_50);
														@(posedge CLOCK_50);
														@(posedge CLOCK_50);

		KEY <= 4'b1111;@(posedge CLOCK_50);

														@(posedge CLOCK_50);
														@(posedge CLOCK_50);
														@(posedge CLOCK_50);

		KEY <= 4'b0111;@(posedge CLOCK_50);

														@(posedge CLOCK_50);
														@(posedge CLOCK_50);
														@(posedge CLOCK_50);

		KEY <= 4'b1111;@(posedge CLOCK_50);

														@(posedge CLOCK_50);
														@(posedge CLOCK_50);
														@(posedge CLOCK_50);

		KEY <= 4'b1101;@(posedge CLOCK_50);

														@(posedge CLOCK_50);
														@(posedge CLOCK_50);
														@(posedge CLOCK_50);

		KEY <= 4'B1111;			@(posedge CLOCK_50);
		SW[7] <= 1; 								@(posedge CLOCK_50);

										@(posedge CLOCK_50);

		SW[7] <= 0; 								@(posedge CLOCK_50);

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
		$stop;
		end
endmodule
