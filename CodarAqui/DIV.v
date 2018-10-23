//NAO FUNCIONA AINDA	
module DIV(clock, reset, A, B, hidiv, lodiv, Div0);

	input wire clock, reset;
	input [31:0] A, B;
	output reg[31:0] hidiv, lodiv; 
	output reg Div0;
	reg [31:0] Quociente;
	reg [63:0] Resto ;
	reg [63:0] Divisor ;
	reg [5:0] i;
initial begin
	  Resto[63:0] = {32'd0, A[31:0]};
	  Divisor[63:0] = { B[31:0],32'd0};
	  Quociente[31:0] = 32'd0;
	  Div0 = 1'b0;
end

always @(*)
begin
	if(B[31:0] == 32'd0) begin		// se o divisor for zero, seta a excessão
		Div0 <= 1'b1;
	end 
	
	if(B[31:0] != 32'd0) begin		//
		for (i =6'd0; i <= 6'd32; i=i+1) begin
			Resto[63:0] <= Resto[63:0] - Divisor[63:0];
			if(Resto[63:0] >= 64'd0) begin
				Quociente[31:0] <= Quociente[31:0] << 1'd1;
				Quociente[0] <= 1;
				Divisor[63:0] <= Divisor[63:0] >> 1'd1;
			end//endif
			if(Resto[63:0] < 64'd0) begin
				Resto[63:0] <= Resto[63:0] + Divisor[63:0];
				Quociente[31:0] <= Quociente[31:0] << 1'd1;
				Quociente[0] <= 0;
				Divisor[63:0] <= Divisor[63:0] >> 1'd1;
			end//endif
		end//endfor
	end//endif
	hidiv[31:0] <= Resto[31:0];
	lodiv[31:0] <= Quociente[31:0];
end
endmodule
