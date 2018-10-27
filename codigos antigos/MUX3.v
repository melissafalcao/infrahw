module MUX3(WriteReg, imediato, rt, reg31, reg29, MUX3out);
 	input [1:0] WriteReg; 
	input [15:0] imediato; //pegar [15..11] do imediato no caso  dw ele ser a saida
	input [4:0] rt, reg31, reg29;
	output [4:0] MUX3out;

begin
    case (WriteReg)
        2'b00: begin
            MUX3out[4:0] <= imediato[15:11];
        end
        2'b01: begin
            MUX3out[4:0] <= rt[4:0];
        end
        2'b10: begin
            MUX3out[4:0] <= 5'd31;
        end
        2'b11: begin
            MUX3out[4:0] <= 5'd29;
        end

    endcase
end

endmodule: MUX3
