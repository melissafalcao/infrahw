module DIV(clock, reset, DIVcontrol, A, B, hidiv, lodiv, Div0);

	input wire clock, reset, DIVcontrol;
	input[31:0] A, B;
	output reg[31:0] hidiv, lodiv;
	output reg Div0;

	reg [5:0] contador;
	reg [1:0] estado;
    reg negativo;

    parameter inicial = 2'd0;
	parameter espera = 2'd1;
	parameter contagem = 2'd2;
    parameter fim = 2'd3;

    reg[31:0] quociente,aux,resto;

	initial begin
            contador = 6'd0;
            estado = espera;
            hidiv= 32'd0;
            lodiv = 32'd0;
            Div0 = 1'b0;
            quociente=32'd0;
            aux=32'd0;
            resto=32'd0;
            negativo = 1'b0;
	end

	always @(posedge clock)	begin
        if(reset == 1'd1)begin
            contador = 6'd0;
            negativo = 1'b0;
            estado = espera;
            hidiv= 32'd0;
            lodiv = 32'd0;
            Div0 = 1'b0;
            quociente=32'd0;
            aux=32'd0;
            resto=32'd0;
        end
        else if(DIVcontrol == 1'd1 && estado == espera)begin
            estado = inicial;
        end

        case(estado)
        inicial: begin
           
            Div0 = 1'd0;
            contador = 6'd0;
            hidiv = 32'd0;
            lodiv = 32'd0;
            Div0 = 1'b0;
            estado = contagem;
            quociente=A;
            aux=B;
            resto=32'd0;
            
             if(A[31]==1 && B[31]==0)begin
            negativo = 1'b1;
            quociente = ~A+1;
            end
            else if(A[31]==0 && B[31]==1) begin
            negativo = 1'b1;
            aux = ~B+1;
            end
            
            
            if(B == 32'd0) begin
				Div0 = 1'd1;
                estado = fim;
			end
        end
        contagem:begin
            resto = {resto[30:0],quociente[31]};
            quociente [31:1] = quociente[30:0];
            resto = resto - aux;
            if (resto[31] == 1) begin
              quociente[0]=0;
              resto = resto + aux;
            end
            else begin
              quociente[0]=1;
            end    
    
		contador = contador + 6'd1;
		if(contador == 6'd32) begin
		estado = fim;
		end
        end
          
          fim:begin
            if(Div0==0)begin
                hidiv = resto;
				lodiv = quociente;
				estado = espera;
                if(negativo==1)begin
                  lodiv= ~lodiv+1;
                end
            end
          end
        endcase
        end
endmodule
