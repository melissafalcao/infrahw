module MUX14(MUX14, ulaResult, LSout, MUX14out);

input MUX14; 
input [31:0]  ulaResult, LSout; 
output reg[31:0]  MUX14out;

always @(*)
begin
    case (MUX14)
        1'b0: begin
            MUX14out[31:0] <= ulaResult[31:0];
        end
        1'b1: begin
        	MUX14out[31:0] <= LSout[31:0];
        end
    endcase
end
endmodule
