module mux6(
   input logic [2:0] PCmux,
   input logic [31:0] A,
   input logic [31:0] ULAout,
   input logic [31:0] SLAC,
   input logic [31:0] EPCout,
   input logic [31:0] MDRout,
   input logic [31:0] ulaResult,
   output logic [31:0] MUX6out);

always_comb begin
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
end

endmodule: mux6
