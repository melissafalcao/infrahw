module StoreSize(SS, MDRout, B, SSout);

	input [1:0] SS; 
	input [31:0] B, MDRout;
	output [31:0] SSout;

always @(*)
begin
	case (SS)
		2'b00: begin//sb
			SSout[31:0] <=  { MDRout[31:8], B[7:0] };
		end
		2'b01: begin//sh
			SSout[31:0] <=  { MDRout[31:16], B[15:0] };
		end
		2'b10: begin//sw
			SSout[31:0] <=  B[31:0];
		end
	endcase
end

endmodule
