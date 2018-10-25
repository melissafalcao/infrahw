module MULT(clock, reset, MULTcontrol, a, b, hi, lo);

    input wire reset;
    input wire clock;
    input wire MULTcontrol;
	input [31:0] a, b;  //fazer multi aqui jogando a saida no hi e lo
	output reg [31:0] hi, lo; 


    reg [64:0] multiplicando;
    reg [64:0] multiplicador;
    reg [5:0] contador;
    reg [1:0] estado;

    parameter espera = 2'd0;
    parameter inicial = 2'd1;
    parameter repeticao = 2'd2;
    parameter fim = 2'd3;

    initial begin
        multiplicando = {65'd0};
        multiplicador = {65'd0};
        contador = {6'd0};
        estado = espera;
        hi = {32'd0};
        lo = {32'd0};
    end

            

  always @(posedge clock) begin
        if(reset == 1'd1) begin
            multiplicando = {65'd0};
            multiplicador = {65'd0};
            contador = {6'd0};
            estado = espera;
            hi = {32'd0};
            lo = {32'd0};
        end
        else if(MULTcontrol == 1'd1 && estado == espera)begin
            estado = inicial;
        end

        case (estado)
        inicial: begin
            multiplicando = {a[31:0],32'd0,1'd0};
            multiplicador = {32'd0,b[31:0],1'd0};
            contador = 6'd1;
            estado = repeticao;
        end
        repeticao: begin
            if(multiplicador[1]==0 && multiplicador[0]==0)begin
				if(multiplicador[64]==1'd1) begin
					multiplicador = multiplicador >>> 1;
					multiplicador[64]=1;
				end
				else begin
					multiplicador = multiplicador >>> 1;
				end
            contador = contador + 6'd1;
            end
            else if(multiplicador[1]==1 && multiplicador[0]==1)begin
				if(multiplicador[64]==1'd1) begin
					multiplicador = multiplicador >>> 1;
					multiplicador[64]=1;
				end
				else begin
					multiplicador = multiplicador >>> 1;
				end
            contador = contador + 6'd1;
            end
            else if(multiplicador[1]==0 && multiplicador[0]==1)begin
            multiplicador = multiplicador + multiplicando;
				if(multiplicador[64]==1'd1) begin
					multiplicador = multiplicador >>> 1;
					multiplicador[64]=1;
				end
				else begin
					multiplicador = multiplicador >>> 1;
				end
            contador = contador + 6'd1;
            end
            else if(multiplicador[1]==1 && multiplicador[0]==0) begin
            multiplicador = multiplicador - multiplicando;
				if(multiplicador[64]==1'd1) begin
					multiplicador = multiplicador >>> 1;
					multiplicador[64]=1;
				end
				else begin
					multiplicador = multiplicador >>> 1;
				end
            contador = contador + 6'd1;
            end
        if (contador == 6'd33) begin
            estado = fim;
        end
        end
        fim: begin
          hi = multiplicador[64:33];
          lo = multiplicador[32:1];
          estado = espera;
        end
        endcase
    end
endmodule
