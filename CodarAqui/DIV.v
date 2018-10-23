module DIV(clock, reset, A, B, hidiv, lodiv, Div0);

	input wire clock, reset;
	input [31:0] A, B;
	output [31:0] hidiv, lodiv; 
	output reg Div0;
	
initial begin
	reg [31:0] Quociente;
	reg [63:0] Resto <= {32'd0, A[31:0]};
	reg [63:0] Divisor <= {32'd0, B[31:0]};
end

always @(*)
begin
	if(B[31:0] == 32'd0) begin		// se o divisor for zero, seta a excessão
		Div0 <= 1'b1;
	end 
	
	if(B[31:0] != 32'd0) begin		//
		for (i = 0; i =< 32; i++) begin
			Resto[63:0] <= Resto[63:0] - Divisor[63:0];
			if(R[63:0] >= 63'd0) begin
				Quociente[31:0] <= Quociente[31:0] << 1'd1;
				Quociente[0] <= 1;
				Divisor[63:0] <= Divisor[63:0] >> 1'd1;
			end
			if(Resto[63:0] < 63'd0) begin
				Resto[63:0] <= Resto[63:0] + Divisor[63:0];
				Quociente[31:0] <= Quociente[31:0] << 1'd1;
				Quociente[0] <= 0;
				Divisor[63:0] <= Divisor[63:0] >> 1'd1;
			end
		end
	end
	hidiv[31:0] <= Resto[31:0];
	lodiv[31:0] <= Quociente[31:0];
end
endmodule
