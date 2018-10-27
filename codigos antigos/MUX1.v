module MUX1 (MemoryAdress, ext35_32, PC, ulaResult, ext16_32, ULAout, reg253, reg254, reg255, MUX1outMUX1out)
	
	input [2:0] MemoryAdress;
	input [31:0] ext35_32, PC, ulaResult, ext16_32, ULAout, reg253, reg254, reg255;
	output [31:0] MUX1out;

begin
	case (MemoryAdress)
		3'b000: begin
			MUX1out[31:0] <= PC[31:0];
		end
		3'b001: begin
			MUX1out[31:0] <= ulaResult[31:0];
		end
		3'b010: begin
			MUX1out[31:0] <= ext16_32[31:0];
		end
		3'b011: begin
			MUX1out[31:0] <= ULAout[31:0];
        	end
        	3'b100: begin
			MUX1out[31:0] <= 32'd253;
        	end
        	3'b101: begin
			MUX1out[31:0] <= 32'd254;
        	end
        	3'b110: begin
			MUX1out[31:0] <= 32'd255;
        	end
        	3'b111: begin
			MUX1out[31:0] <= ext25_32[31:0];
		end
	endcase
end


endmodule: mux1
