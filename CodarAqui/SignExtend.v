//FUNCIONANDO
module SignExtend(concatout, ext25_32);

	input [25:0]  concatout; 
	output reg[31:0]  ext25_32;


always @(*)
begin
    ext25_32 <= {6'd0,concatout[25:0]};//adiciona 6 bits a esquerda
end

endmodule
