//NAO FUNCIONA AINDA	
module DIV(clock, reset, operacao, A, B, hidiv, lodiv, Div0);

	input wire clock, reset, operacao;
	input[31:0] A, B;
	output reg[31:0] hidiv, lodiv;
	output wire Div0;
	
	reg[31:0] quociente;
	reg[63:0] divisor;
	reg[63:0] resto;
	reg[5:0] contador;
	reg estado;

	parameter espera = 1'd0;
	parameter contagem = 1'd1;

	initial begin
		resto[63:0] = { 32'd0, A[31:0] };		// inicialmente o resto é o dividendo
		divisor[63:0] = { B[31:0], 32'd0 };
		quociente[31:0] = 32'd0;
		contador[5:0] = 5'd0;
		estado = espera;
		hidiv[31:0] = 32'd0;
		lodiv[31:0] = 32'd0;
		Div0 = 1'b0;
	end

	always @(posedge clock)	begin
		// só opera se o controle solicitar a divisão:
		if((operacao == 1'd0)&&(contador != 6'd32)) begin
			// se o divisor for zero, seta a excessão:
			if(B[31:0] == 32'd0) begin
				Div0 = 1'b1;
			end 
			// senão, começa a operação para setar o quociente e o resto:
			if(B[31:0] != 32'd0) begin
				// se estiver em espera, muda o estado para iniciar a operação:
				if(estado == espera) begin
					estado = contagem;
				end
				// verifica se ainda está em contagem:
				if(estado == contagem) begin
					// algoritmo de subtrações sucessivas:
					Resto[63:0] = Resto[63:0] - Divisor[63:0];
					if(Resto[63:0] >= 64'd0) begin
						Quociente[31:0] = Quociente[31:0] << 1'd1;
						Quociente[0] = 1;
						Divisor[63:0] = Divisor[63:0] >> 1'd1;
					end
					if(Resto[63:0] < 64'd0) begin
						Resto[63:0] = Resto[63:0] + Divisor[63:0];
						Quociente[31:0] = Quociente[31:0] << 1'd1;
						Quociente[0] = 0;
						Divisor[63:0] = Divisor[63:0] >> 1'd1;
					end
					// incrementa a contagem:
					contador = contador + 6'd1;
					// se chegar ao fim da contagem, seta as saídas:
					if(contador == 6'd32) begin
						hidiv[31:0] <= Resto[31:0];
						lodiv[31:0] <= Quociente[31:0];
						estado = espera;
					end

				end

			end

		end

	end

endmodule
