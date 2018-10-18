module MUX6(PCmux, A, ULAout, SLAC, EPCout, MDRout, ULAresult, Mem, MUX6out);
 	input [2:0]  PCmux; 
	input [31:0]  A, ULAout, SLAC, EPCout, MDRout, ULAresult, Mem; 
	output reg[31:0]  MUX6out;

always @(*)
begin
   case (PCmux)
      3'b000:
         MUX6out[31:0] <= A[31:0];
      3'b001:
         MUX6out[31:0] <= ULAout[31:0];
      3'b010:
         MUX6out[31:0] <= SLAC[31:0];
      3'b011:
         MUX6out[31:0] <= EPCout[31:0];
      3'b100:
         MUX6out[31:0] <= MDRout[31:0];
      3'b101:
      MUX6out[31:0] <= ULAresult[31:0];
      3'b110:
         MUX6out[31:0] <= Mem[31:0];
         endcase
end

endmodule
