module pc(PCwrite, mux6OUT, pc); 

input PCwrite;
input [31:0] mux6OUT;
output [31:0] pc;

case (PCwrite)
  1'd1:pc = mux6OUT;
  1'd0:pc; 
  default:; 
endcase

endmodule