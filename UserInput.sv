// UserInput​.​sv ​-​ ​Stabilize​ the key stroke

// This module stabilizes the user input to have a key press which is
// on for a long time to be on for only one clock cycle
module userInput(clk, button, out, reset);
	input logic clk, button, reset;
	output logic out;
	
	logic ns, ps, oldButton;
	
	parameter on = 1'b1;
	parameter off = 1'b0;
	
	// combinational logic for state machine
	always_comb begin
		case(ps)
			on: ns = off;
			off:
				if(button == on & oldButton != on)
					ns = on;
				else
					ns = off;
			
			default: ns = 1'b0;
		endcase
	end
	
	// flip flop the output for stability
	always_ff @(posedge clk) begin
		if (reset) begin
			out <= off;
			oldButton <= off;
			ps <= off;
		end
		else begin
			out <= ns;
			oldButton <= button;
		end
	end
endmodule

// This module creates a testbench for userInput module
module userInput_testbench();
	logic clk;
	logic reset;
	logic button;
	logic out;
	
	userInput dut(.clk, .reset, .button, .out);
	
	// set up clock period
	parameter CLOCK_PERIOD = 100;
	initial clk = 1;

	always begin
		#(CLOCK_PERIOD / 2)
		clk = ~clk;
	end
	
	// write inputs
	initial begin
		@(posedge clk);
		@(posedge clk);

		reset <= 1; @(posedge clk);
		reset <= 0; button <= 0; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		button <= 1; @(posedge clk);

		@(posedge clk);
		button <= 0; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		button <= 1; @(posedge clk);

		@(posedge clk);
		@(posedge clk);
		
		$stop;
	end
endmodule