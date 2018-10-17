module mux2(
    input logic[31:0] ulaOut,
    input logic[31:0] LSout,
    input logic[31:0] HIout,
    input logic[31:0] LOout,
    input logic[31:0] Shiftout,
    input logic[31:0] LT32,
    input logic[2:0] WriteData,
    output logic[31:0] MUX2out);
    
always_comb begin
    case(WriteData)
        3'b000: begin
			Mux2out[31:0] <= ulaOut[31:0];
		end
		3'b001: begin
			Mux2out[31:0] <= LSout[31:0];
		end
		3'b010: begin
			Mux2out[31:0] <= HIout[31:0];
		end
		3'b011: begin
			Mux2out[31:0] <= LOout[31:0];
        end
        3'b100: begin
			Mux2out[31:0] <= Shiftout[31:0];
        end
        3'b101: begin
			Mus2out[31:0] <= LT32[31:0];
        end
end

endmodule: mux2
