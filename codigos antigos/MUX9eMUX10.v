module MUX9eMUX10(ShifterMux, endB, shamt, reg16, A, B, imediato, mux9out, mux10out);

	input [1:0] ShifterMux; 
	input [4:0] endB, shamt, reg16; 
	input [31:0] A, B; 
	input [15:0] imediato; //extender imediato 
	output [31:0] mux9out, mux10out; 

endmodule
