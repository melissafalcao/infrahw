module mux6(
   input [2:0] PCmux,
   input [31:0] A,
   input [31:0] ULAout,
   input [31:0] SLAC,
   input [31:0] EPCout,
   input [31:0] MDRout,
   input [31:0] ulaResult,
   input [31:0] Mem,
   output [31:0] MUX6out);

begin
   case (PCmux)
      3'b000
         MUXout[31:0] <= A[31:0];
      3'b001
         MUXout[31:0] <= ULAout[31:0];
      3'b010
         MUXout[31:0] <= SLAC[31:0];
      3'b011
         MUXout[31:0] <= EPCout[31:0];
      3'b100
         MUXout[31:0] <= MDRout[31:0];
      3'b101
         MUXout[31:0] <= ulaResult[31:0];
      3'b110
         MUXout[31:0] <= Mem[31:0];
end

endmodule: mux6
