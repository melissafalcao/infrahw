module pc(PCwrite, mux6OUT, pc); 

input PCwrite;
input [31:0] mux6OUT;
output reg [31:0] pc;

always @(*)
begin
case (PCwrite)
  1'd1:pc <= mux6OUT;
endcase
end


endmodule
