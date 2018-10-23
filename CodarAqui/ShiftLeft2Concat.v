module ShiftLeft2Concat(concatout, PC, SLAC);

	input [25:0] concatout; 
	input [31:0]  PC; 
	output reg [31:0]  SLAC;

always @(*)
begin
	SLAC[31:0] <= {PC[31:28], concatout[25:0], 2'd0};//concatena PC com concatout(offset) extendido de 2 bits para a esquerda  
end

endmodule
