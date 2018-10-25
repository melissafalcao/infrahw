module LoadSize (LS, MDRout, LSout);

input [1:0] LS;
input [31:0] MDRout;
output reg[31:0] LSout;

always @(*)
begin
	case (LS)
		2'b00: begin//lb
			LSout[31:0] <=  { 26'd0, MDRout[7:0] };
		end
		2'b01: begin//lh
			LSout[31:0] <=  { 16'd0, MDRout[15:0] };
		end
		2'b10: begin//lw
			LSout[31:0] <=  MDRout[31:0];
		end
	endcase
end


endmodule