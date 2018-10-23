module ShiftLeft2(ext16_32, ext16_32_left_shifted);

	input [31:0]  ext16_32; 
	output [31:0]  ext16_32_left_shifted; 

always @(*)
begin
      ext16_32_left_shifted[31:0] <= ext16_32[31:0] << 2'd2;
end

endmodule
