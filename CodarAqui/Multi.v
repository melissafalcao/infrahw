module Multi(clock, reset, comeco, a, b, hi, lo,i);

    input wire reset;
    input wire clock;
    input wire comeco;
	input [31:0] a, b;  //fazer div e multi aqui jogando a saida no hi e lo
	output reg [31:0] hi, lo; 
	output reg i;


    reg [64:0] multiplicando;
    reg [64:0] multiplicador;
    reg [4:0] contador;
    reg [1:0] estado;

    parameter espera = 2'd0;
    parameter inicial = 2'd1;
    parameter repeticao = 2'd2;
    parameter final = 2'd3;

    initial begin
        multiplicando = {65'd0};
        multiplicador = {65'd0};
        contador = {5'd0};
        estado = espera;
        hi = {32'd0};
        lo = {32'd0};
    end

            

  always @(posedge clock) begin
        if(reset == 1'b1) begin
            multiplicando = {65'd0};
            multiplicador = {65'd0};
            contador = {4'd0};
            estado = espera;
            hi = {32'd0};
            lo = {32'd0};
        end
        else if(comeco == 1'd1 && estado == espera)begin
            estado = inicial;
        end

        case (estado)
        inicial: begin
            multiplicando = {a[31:0],32'd0,1'd0};
            multiplicador = {32'd0,b[31:0],1'd0};
            contador = 5'd1;
            estado = repeticao;
        end
        repeticao: begin
            if(multiplicador[1]==0 && multiplicador[0]==0)begin
            multiplicador = (multiplicador>>>1);
            contador = contador + 1'd1;
            end
            else if(multiplicador[1]==1 && multiplicador[0]==1)begin
            multiplicador = (multiplicador>>>1);
            contador = contador + 1'd1;
            end
            else if(multiplicador[1]==0 && multiplicador[0]==1)begin
            multiplicador = multiplicador + multiplicando;
            multiplicador = (multiplicador>>>1);
            contador = contador + 1'd1;
            end
            else if(multiplicador[1]==1 && multiplicador[0]==0) begin
            multiplicador = multiplicador - multiplicando;
            multiplicador = (multiplicador>>>1);
            contador = contador + 1'd1;
            end
            if (contador == 5'd32) begin
              estado = final;
            end
        end
        final: begin
          hi = multiplicador[64:33];
          lo = multiplicador[32:1];
          estado = espera;
        end

endmodule
