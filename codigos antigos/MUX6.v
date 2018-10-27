module MUX6(PCmux, A, ULAout, SLAC, EPCout, MDRout, ULAresult, MUX6out);
 	input [2:0]  PCmux; 
	input [31:0]  a, ULAout, SLAC, EPCout, MDRout, ULAresult; 
	output [31:0]  MUX6out;
   
begin
   case (PCmux)
      3'b000
         MUX6out[31:0] <= A[31:0];
      3'b001
         MUX6out[31:0] <= ULAout[31:0];
      3'b010
         MUX6out[31:0] <= SLAC[31:0];
      3'b011
         MUX6out[31:0] <= EPCout[31:0];
      3'b100
         MUX6out[31:0] <= MDRout[31:0];
      3'b101
      MUX6out[31:0] <= ULAResult[31:0];
      3'b110
         MUX6out[31:0] <= Mem[31:0];
end

endmodule: MUX6
