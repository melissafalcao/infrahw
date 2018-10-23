//FUNCIONANDO
module MUX13 (MemoryData, SSout, ext16_32, ulaResult, MUX13out);

input [1:0]MemoryData;
input [31:0] SSout, ext16_32, ulaResult;
output reg [31:0] MUX13out;


always @(*)
begin
	case (MemoryData)
		2'b00: begin
			MUX13out[31:0] <= SSout[31:0];
		end
		2'b01: begin
			MUX13out[31:0] <= ext16_32[31:0];
		end
		2'b10: begin
			MUX13out[31:0] <= ulaResult[31:0];
		end
	endcase
end


endmodule
