module mux1(
	input  [31:0] pc,
	input  [31:0] ulaResult,
	input  [31:0] ext16_32, 
    	input  [31:0] ulaOut,
    	input  [31:0] input_253,
    	input  [31:0] input_254,
    	input  [31:0] input_255,
    	input  [31:0] ext25_32,
	input  [2:0] MemoryAdress, 
	output  [31:0] out);

begin
	case (MemoryAdress)
		3'b000: begin
			Mux1out[31:0] <= pc[31:0];
		end
		3'b001: begin
			Mux1out[31:0] <= ulaResult[31:0];
		end
		3'b010: begin
			Mux1out[31:0] <= ext16_32[31:0];
		end
		3'b011: begin
			Mux1out[31:0] <= ulaOut[31:0];
        	end
        	3'b100: begin
			Mux1out[31:0] <= 32'd253;
        	end
        	3'b101: begin
			Mux1out[31:0] <= 32'd254;
        	end
        	3'b110: begin
			Mux1out[31:0] <= 32'd255;
        	end
        	3'b111: begin
			Mux1out[31:0] <= ext25_32[31:0];
		end
	endcase
end


endmodule: mux1
