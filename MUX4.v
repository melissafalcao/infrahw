module MUX4(ULAa, pc, mdr, a, MUX4out);

input [1:0] ULAa; 
input [31:0] pc, mdr, a; 
output reg [31:0] MUX4out;

always @(*)
begin  
    case (ULAa)
        2'b00: begin
            MUX4out[31:0] <= pc[31:0];
        end
        2'b01: begin
            MUX4out[31:0] <= mdr[31:0];
        end
        2'b10: begin
            MUX4out[31:0] <= a[31:0];
        end
    endcase
end
endmodule
