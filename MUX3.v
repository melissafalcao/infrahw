module MUX3(WriteReg, imediato, rt, reg31, reg29, MUX3out);

	input [1:0] WriteReg; 
	input [15:0] imediato; //pegar [15..11] do imediato no caso  dw ele ser a saida
	input [4:0] rt, reg31, reg29;
	output [4:0] MUX3out;

endmodule
