module MUX7eMUX8(MDcontrol, himult, hidiv, lomult, lodiv, mux7out, mux8out);

	input [1:0] MDcontrol; 
	input [31:0] himult, hidiv, lomult, lodiv; 
	output reg[31:0] mux7out;
	output reg[31:0] mux8out; 

always @(*)
begin
    case (MDcontrol)
        1'b0: begin
            mux7out[31:0] <= himult[31:0];
			mux8out[31:0] <= lomult[31:0];
        end
        1'b1: begin
        	mux7out[31:0] <= hidiv[31:0];
			mux8out[31:0] <= lodiv[31:0];
        end
    endcase
end
endmodule
