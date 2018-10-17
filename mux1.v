module mux1(
    input logic [31:0] pc,
	input logic [31:0] ulaResult,
	input logic [31:0] ext16_32, 
    input logic [31:0] ulaOut,
    input logic [31:0] input_253,
    input logic [31:0] input_254,
    input logic [31:0] input_255,
    input logic [31:0] ext25_32,
	input logic [1:0] MemoryAdress, 
	output logic [31:0] out);

always_comb begin
	case (MemoryAdress)
		3'b000: begin
			out[31:0] <= pc[31:0];
		end
		3'b001: begin
			out[31:0] <= ulaResult[31:0];
		end
		3'b010: begin
			out[31:0] <= ext16_32[31:0];
		end
		3'b011: begin
			out[31:0] <= ulaOut[31:0];
        end
        3'b100: begin
			out[31:0] <= 32'd253;
        end
        3'b101: begin
			out[31:0] <= 32'd254;
        end
        3'b110: begin
			out[31:0] <= 32'd255;
        end
        3'b111: begin
			out[31:0] <= ext25_32[31:0];
		end
	endcase
end


endmodule: mux1
