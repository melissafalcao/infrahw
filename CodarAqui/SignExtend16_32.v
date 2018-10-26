//FUNCIONANDO
module SignExtend16_32(imediato,  ext16_32);
	input [15:0]  imediato;
	output reg [31:0]  ext16_32;
	
always @(*)
begin
	ext16_32[31:0] <= {16'd0, imediato[15:0]};
end 

endmodule
