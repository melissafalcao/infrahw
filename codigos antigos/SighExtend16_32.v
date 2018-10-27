module SighExtend16_32(
	input [15:0]  imediato, 
	output [31:0]  ext16_32);

begin
	output[15:0] <= imediato[15:0] << 16'd16;
end 

endmodule
