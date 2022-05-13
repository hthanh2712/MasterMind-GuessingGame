// Comparator​.​sv ​-​ compare the numbers
// This module compares 2 2 bit numbers and returns 1 if they are equal
module comparator(A, B, out);
	input logic [1:0] A;
	input logic [1:0] B;
	output logic out;
	assign out = (A == B);
endmodule