module mux3(
    input imediato[15:0],
    input rt[4:0],
    input WriteReg[1:0],
    output MUX3out[4:0]
);

begin
    case (WriteReg)
        2'b00: begin
            Muxout[4:0] <= imediato[15:11];
        end
        2'b01: begin
            Muxout[4:0] <= rt[4:0];
        end
        2'b10: begin
            Muxout[4:0] <= 5'd31;
        end
        2'b11: begin
            Muxout[4:0] <= 5'd29;
        end

    endcase
end

endmodule: mux3
