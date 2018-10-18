module MUX5(ULAb, B, ext16_32, reg4, reg1, ext16_32_left_shifted, MUX5out);
 	input [2:0] ULAb; 
	input [31:0]  B, ext16_32, reg4, reg1, ext16_32_left_shifted; 
	output reg[31:0] MUX5out;
 
 always @(*)
begin
   case (ULAb)
      3'b000:
         MUX5out[31:0] <= B[31:0];
      3'b001:
         MUX5out[31:0] <= ext16_32[31:0];
      3'b010:
         MUX5out[31:0] <= reg4[31:0];
      3'b011:
         MUX5out[31:0] <= reg1[31:0];
      3'b100:
         MUX5out[31:0] <= ext16_32_left_shifted[31:0];
         endcase
end

endmodule