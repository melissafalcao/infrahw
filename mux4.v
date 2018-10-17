module mux4(
    input ULAa[1:0],
    input pc[31:0],
    input mdr[31:0],
    input a[31:0],
    output Mux4out[31:0]
);

begin  
    case (ULAa)
        2'b00: begin
            Mux4out[31:0] <= pc[31:0]
        end
        2'b01: begin
            Mux4out[31:0] <= mdr[31:0]
        end
        2'b10: begin
            Mux4out[31:0] <= a[31:0]
        end
    endcase
    
end
    
endmodule: mux4
