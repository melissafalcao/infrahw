//FUNCIONANDO
module MUX2 (WriteData, ULAout, LSout, HIout, LOout, Shiftout, LT32, MUX2out);
	
input [2:0] WriteData;
input [31:0]  ULAout, LSout, HIout, LOout, Shiftout, LT32;
output reg[31:0] MUX2out;

always @(*)
begin
    case(WriteData)
		3'b000: begin
			MUX2out[31:0] <= ULAout[31:0];
		end
		3'b001: begin
			MUX2out[31:0] <= LSout[31:0];
		end
		3'b010: begin
			MUX2out[31:0] <= HIout[31:0];
		end
		3'b011: begin
			MUX2out[31:0]<= LOout[31:0];
		end
		3'b100: begin
			MUX2out[31:0] <= Shiftout[31:0];
		end
		3'b101: begin
			MUX2out[31:0] <= LT32[31:0];
		end
    endcase
end

endmodule
