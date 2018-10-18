module ULAout(ALUout, ulaResult, ULAout);

	input ALUout; 
	input [31:0]  ulaResult; 
	output [31:0] ULAout;
	
	assign ULAout => ulaResult;

endmodule
