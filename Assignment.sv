// Assignment​.​sv ​-​ find the assigns the stabilized inputs received ​from​ the userInput
// This module assigns the stabilized inputs received from the userInput module (as shown in the block diagram)
// As shown in the block diagram: Inputs: Stabilized Keystrokes, Reset, Clock
// As shown in the block diagram: Output : Sequence of digits as entered by stabilized input, Number of Attempts

module assignment(CLOCK_50, dig0, dig1, dig2, dig3, zero, one, two, three, reset, attempts);
	output logic [1:0] dig0;
	output logic [1:0] dig1;
	output logic [1:0] dig2;
	output logic [1:0] dig3;
	
	input logic reset;
	input logic CLOCK_50; // 50MHz clock.
	
	input logic zero;
	input logic one;
	input logic two;
	input logic three;
	
	logic [1:0] dig0Next;
	logic [1:0] dig1Next;
	logic [1:0] dig2Next;
	logic [1:0] dig3Next;
	
	output reg [3:0] attempts;
	
	// Inittialize attempts to be zero
	reg [2:0] count;
	reg [2:0] countNext = 3'b000;
	reg [3:0] attemptsNext = 3'b0000;
	
	// Decide the combinational logic that does the assignment
	always @* begin
		case(count)
		3'b000: begin
			if (zero & ~reset) dig0Next = 2'b00;
			else if (one & ~reset) dig0Next = 2'b01;
			else if (two & ~reset) dig0Next = 2'b10;
			else if (three & ~reset) dig0Next = 2'b11;
			else dig0Next = dig0;
			countNext = count;
			attemptsNext = attempts;
			dig1Next = dig1;
			dig2Next = dig2;
			dig3Next = dig3;
		end
		3'b001: begin
			if (zero) dig1Next = 2'b00;
			else if (one) dig1Next = 2'b01;
			else if (two) dig1Next = 2'b10;
			else if (three) dig1Next = 2'b11;
			else dig1Next = dig1;
			countNext = count;
			attemptsNext = attempts;
			dig0Next = dig0;
			dig2Next = dig2;
			dig3Next = dig3;
		end

		3'b010: begin
			if (zero) dig2Next = 2'b00;
			else if (one) dig2Next = 2'b01;
			else if (two) dig2Next = 2'b10;
			else if (three) dig2Next = 2'b11;
			else dig2Next = dig2;
			countNext = count;
			attemptsNext = attempts;
			dig0Next = dig0;
			dig1Next = dig1;
			dig3Next = dig3;
		end
		3'b011: begin
			if (zero) dig3Next = 2'b00;
			else if (one) dig3Next = 2'b01;
			else if (two) dig3Next = 2'b10;
			else if (three) dig3Next = 2'b11;
			else dig3Next = dig3;
			dig0Next = dig0;
			dig1Next = dig1;
			dig2Next = dig2;
			countNext = count;
		end
		default: begin
			countNext = 3'b000;
			attemptsNext = attempts + 3'b001;
			dig0Next = dig0;
			dig1Next = dig1;
			dig2Next = dig2;
			dig3Next = dig3;
		end
	endcase
	
	if (zero | one | two | three) 
		countNext = countNext + 2'b01;
	end
	
	// Assign the next state to the present state
	always_ff @(posedge CLOCK_50) begin
		if (reset) begin
			count <= 3'b000;
			attempts <= 4
			'b0000;
		end
		else begin
			dig0 <= dig0Next;
			dig1 <= dig1Next;
			dig2 <= dig2Next;
			dig3 <= dig3Next;
			count <= countNext;
			attempts <= attemptsNext;
		end
	end
endmodule

// This module creates a testbench for the assignment module
module assignment_testbench();
	logic clk;
	logic [1:0] dig0;
	logic [1:0] dig1;
	logic [1:0] dig2;
	logic [1:0] dig3;
	
	logic reset;
	logic zero;
	logic one;
	logic two;
	logic three;
	
	reg [3:0] attempts;
	
	assignment dut(.CLOCK_50(clk), .dig0, .dig1, .dig2, .dig3, .zero, .one, .two, .three,
	.reset, .attempts);
	
	parameter CLOCK_PERIOD = 100;
	initial clk = 1;

	always begin
		#(CLOCK_PERIOD / 2)
		clk = ~clk;
	end
	// assign diff values to check
	initial begin
			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);
			reset <= 1; @(posedge clk);
			reset <= 0; @(posedge clk);
			zero <= 1; @(posedge clk);

			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);

			zero <= 1;
			@(posedge clk);
			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);
			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);
			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);
			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);
			one <= 1; @(posedge clk);
			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);
			three <= 1; @(posedge clk);

			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);

			@(posedge clk);

			one <= 1; @(posedge clk);

			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);

			zero <= 1;
			@(posedge clk);
			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);
			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);
			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);

			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);
			one <= 1; @(posedge clk);
			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);
			three <= 1; @(posedge clk);

			zero <= 0; one <= 0; two <= 0; three <= 0; @(posedge clk);

			@(posedge clk);
			@(posedge clk);
		$stop;
	end
endmodule