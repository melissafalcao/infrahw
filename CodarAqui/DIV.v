module testdiv(clock, reset, comeco, A, B, hidiv, lodiv, Div0);

	input wire clock, reset, comeco;
	input[31:0] A, B;
	output reg[31:0] hidiv, lodiv;
	output reg Div0;
	
	//reg [31:0] quociente;
	//reg [63:0] divisor;
	//reg [63:0] resto;
	reg [5:0] contador;
	reg [1:0] estado;

    parameter inicial = 2'd0;
	parameter espera = 2'd1;
	parameter contagem = 2'd2;
    parameter fim = 2'd3;

    reg[31:0] a1,b1,p1;

	initial begin
		  //resto = { 64'd0 };
          //divisor = { 64'd0 };
          //quociente = 32'd0;
            contador = 6'd0;
            estado = espera;
            hidiv= 32'd0;
            lodiv = 32'd0;
            Div0 = 1'b0;
            a1=32'd0;
            b1=32'd0;
            p1=32'd0;
	end

	always @(posedge clock)	begin
        if(reset == 1'd1)begin
            //resto = { 64'd0 };
            //divisor = { 64'd0 };
            //quociente = 32'd0;
            contador = 6'd0;
            estado = espera;
            hidiv= 32'd0;
            lodiv = 32'd0;
            Div0 = 1'b0;
            a1=32'd0;
            b1=32'd0;
            p1=32'd0;
        end
        else if(comeco == 1'd1 && estado == espera)begin
            estado = inicial;
        end

        case(estado)
        inicial: begin
           //resto = { 32'd0, A[31:0] };		// inicialmente o resto é o dividendo
           //divisor = { B[31:0], 32'd0 };
           //quociente = 32'd0;
            contador = 6'd0;
            hidiv = 32'd0;
            lodiv = 32'd0;
            Div0 = 1'b0;
            estado = contagem;
            a1=A;
            b1=B;
            p1=32'd0;
            if(B == 32'd0) begin
				Div0 = 1'b1;
                estado = fim;
			end
        end
        contagem:begin
            p1 = {p1[30:0],a1[31]};
            a1 [31:1] = a1[30:0];
            p1 = p1 - b1;
            if (p1[31] == 1) begin
              a1[0]=0;
              p1 = p1 + b1;
            end
            else begin
              a1[0]=1;
            end    
        

            //resto = resto - divisor;
			//if(resto >= 64'd0) begin
			//quociente = quociente << 1;
			//quociente[0] = 1;
			//divisor = divisor >> 1;
			//end
			//else if(resto < 64'd0) begin
			//resto = resto + divisor;
			//quociente = quociente << 1;
			//quociente[0] = 0;
			//divisor = divisor >> 1;
			//end
			// incrementa a contagem:
		contador = contador + 6'd1;
			// se chegar ao fim da contagem, seta as saídas:
		if(contador == 6'd32) begin
		estado = fim;
		end
        end
          
          fim:begin
            if(Div0==0)begin
                hidiv = a1;
				lodiv = p1;
				estado = espera;
            end
          end
        endcase
        end
endmodule

