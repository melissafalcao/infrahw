module MUX9eMUX10(ShifterMux, endB, shamt, A, B, imediato, mux9out, mux10out);

	input [1:0] ShifterMux; 
	input [4:0] endB, shamt; 
	input [31:0] A, B; 
	input [15:0] imediato; //extender imediato 
	output [31:0]  mux10out;
	output [4:0] mux9out; 
//QUANDO FOR CODAR ESSE, LEMBRAR Q UMA DAS SAIDAS DO MUX10 eh O VALOR 5'd16 (conferir no diagrama dos fios nomeados, tah junto com o deslocamento box)
//Deslocamento box é o RegDesloc q foi fornecido, nao precisamos codar ele
endmodule
