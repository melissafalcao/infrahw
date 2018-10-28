module MUX6(PCmux, A, ULAout, SLAC, EPCout, MDRout, ULAresult, Mem, MUX6out);
 	input [2:0]  PCmux; 
	input [31:0]  A, ULAout, SLAC, EPCout, MDRout, ULAresult, Mem; 
	output reg[31:0]  MUX6out;

always @(*)
begin
   case (PCmux)
      3'b000:begin
        MUX6out[31:0] <= A[31:0];
      end
      3'b001:begin
        MUX6out[31:0] <= ULAout[31:0];
      end
      3'b010:begin
        MUX6out[31:0] <= SLAC[31:0];
      end
      3'b011:begin
        MUX6out[31:0] <= EPCout[31:0];
      end
      3'b100:begin
        MUX6out[31:0] <= MDRout[31:0];
      end
      3'b101:begin
        MUX6out[31:0] <= ULAresult[31:0];
      end
      3'b110:begin
        MUX6out[31:0] <= Mem[31:0];
      end
    endcase
end

endmodule
