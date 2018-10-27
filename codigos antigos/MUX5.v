module MUX5(ULAb, B, ext16_32, ext16_32_left_shifted, MUX5out);

input [2:0] ULAb; 
input [31:0]  B, ext16_32, ext16_32_left_shifted; 
output reg[31:0] MUX5out;
 
 always @(*)
begin
   case (ULAb)
        3'b000: begin
            MUX5out[31:0] <= B[31:0];
        end
        3'b001: begin
            MUX5out[31:0] <= ext16_32[31:0];
        end
        3'b010: begin
            MUX5out[31:0] <= 32'd4;
        end
        3'b011: begin
            MUX5out[31:0] <= 32'd1;
        end
        3'b100: begin
            MUX5out[31:0] <= ext16_32_left_shifted[31:0];
        end
    endcase
end
endmodule
