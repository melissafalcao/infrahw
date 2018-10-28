//FUNCIONANDO
module MUX9eMUX10(ShifterMux, A, B, imediato, mux9out, mux10out);

	input [1:0] ShifterMux; 
	input [31:0] A, B; 
	input [15:0] imediato; //extender imediato se sinal=2
	output reg[31:0]  mux10out;
	output reg[4:0] mux9out; 
//QUANDO FOR CODAR ESSE, LEMBRAR Q UMA DAS SAIDAS DO MUX10 eh O VALOR 5'd16 (conferir no diagrama dos fios nomeados, tah junto com o deslocamento box)
//Deslocamento box é o RegDesloc q foi fornecido, nao precisamos codar ele

always @(*)
begin
    case (ShifterMux)
        2'b00: begin
            mux9out[4:0] <= B[4:0];//esse é o endB, o bloco GetEndOfB é desnecessário
			mux10out[31:0] <= A[31:0];
        end
        2'b01: begin
        	mux9out[4:0] <= imediato[4:0];//shamt= imediato[4:0], o bloco GetShamt tbm é desnecessário
			mux10out[31:0] <= B[31:0];
        end
        2'b10: begin
			mux9out[4:0] <= 5'd16;
			mux10out[31:0] <={16'd0 , imediato[15:0]};//extendendo imediato
        end
    endcase
end
endmodule
