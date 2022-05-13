//​ Assign​ the hex displays to be to required values
// This module sets the hex display according to what score it gets
module display(score, seg7, reset);
	input logic [3:0] score;
	output logic [6:0] seg7;
	
	input logic reset;
	
	always_comb begin
		if (~reset) begin
			case (score)
				3'b000 : seg7 = 7'b1000000;
				3'b001 : seg7 = 7'b1111001;
				3'b010 : seg7 = 7'b0100100;
				3'b011 : seg7 = 7'b0110000;
				3'b100 : seg7 = 7'b0011001;
				3'b101 : seg7 = 7'b0010010;
				3'b110 : seg7 = 7'b0000010;
				3'b111 : seg7 = 7'b1111000;
				default : seg7 = 7'bxxxxxxx;
			endcase
		end
		else begin
			seg7 = 7'b1000000;
		end
	end
endmodule

// This module sets the to of the hex display saccording to what score it gets
module display3(score, HEX5, HEX4, reset);
	input logic [4:0] score;
	output logic [6:0] HEX5;
	output logic [6:0] HEX4;
	
	input logic reset;
	
	always_comb begin
		if (~reset) begin
			case (score)
				4'b000 :begin HEX4 = 7'b1000000; HEX5 = 7'b1000000;end
				4'b001 :begin HEX4 = 7'b1111001; HEX5 = 7'b1000000;end
				4'b010 :begin HEX4 = 7'b0100100; HEX5 = 7'b1000000;end
				4'b011 :begin HEX4 = 7'b0110000; HEX5 = 7'b1000000;end
				4'b100 :begin HEX4 = 7'b0011001; HEX5 = 7'b1000000;end
				4'b101 :begin HEX4 = 7'b0010010; HEX5 = 7'b1000000;end
				4'b110 :begin HEX4 = 7'b0000010; HEX5 = 7'b1000000;end
				4'b111 :begin HEX4 = 7'b1111000; HEX5 = 7'b1000000;end
				4'b1000 :begin HEX4 = 7'b0000000; HEX5 = 7'b1000000;end
				4'b1001 :begin HEX4 = ~7'b1101111; HEX5 = 7'b1000000;end
				4'b1010 :begin HEX4 = 7'b1000000; HEX5 = 7'b1111001; end
				4'b1011 :begin HEX4 = 7'b1111001; HEX5 = 7'b1111001; end
				4'b1100 :begin HEX4 = 7'b0100100; HEX5 = 7'b1111001; end
				4'b1101 :begin HEX4 = 7'b0110000; HEX5 = 7'b1111001; end
				4'b1110 :begin HEX4 = 7'b0011001; HEX5 = 7'b1111001; end
				4'b1111 :begin HEX4 = 7'b0010010; HEX5 = 7'b1111001; end
				default :begin HEX4 = 7'bxxxxxxx; HEX5 = 7'b1111001; end
			endcase
		end
		else begin
			HEX4 = 7'b1000000;HEX5 = 7'b1000000;
		end
	end
endmodule