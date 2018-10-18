module ULAout(ALUout, ulaResult, ULAout);

	input ALUout; 
	input [31:0]  ulaResult; 
	output reg[31:0] ULAout;

always @(*)
case(ALUout)
	1'd1:ULAout <= ulaResult;
endcase

endmodule
