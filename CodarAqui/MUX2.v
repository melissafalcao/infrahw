module MUX2 (WriteData, ULAout, LSout, HIout, LOout, Shiftout, LT32, MUX2out);
	
input [2:0] WriteData;
input [31:0]  ULAout, LSout, HIout, LOout, Shiftout, LT32;
output reg[31:0] MUX2out;

always @(*)
begin
    case(WriteData)
        3'b000: begin
		MUX2out <= ULAout;
	end
	3'b001: begin
		MUX2out <= LSout;
	end
	3'b010: begin
		MUX2out <= HIout;
	end
	3'b011: begin
		MUX2out<= LOout;
        end
        3'b100: begin
		MUX2out <= Shiftout;
        end
        3'b101: begin
		MUX2out <= LT32;
        end
       endcase
end

endmodule
