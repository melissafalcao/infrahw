module mux5(
   input [2:0] ULAb,
   input [31:0]  B,
   input [31:0] ext16_32,
   input [31:0] reg4,
   input [31:0] reg1,
   input [31:0] ext16_32_left_shifted,
   output [31:0] MUX5out);
 
begin
   case (PCmux)
      3'b000
         MUX5out[31:0] <= B[31:0];
      3'b001
         MUX5out[31:0] <= ext16_32[31:0];
      3'b010
         MUX5out[31:0] <= reg4[31:0];
      3'b011
         MUX5out[31:0] <= reg1[31:0];
      3'b100
         MUX5out[31:0] <= ext16_32_left_shifted[31:0];
end

endmodule: mux5
