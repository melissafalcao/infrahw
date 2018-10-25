//PS: LOAD ADICIONADO ONTEM A NOITE POR ZEH POIS OS REG A E B AGR TEM LOAD E TEM Q AJEITAR OS ESTADOS Q ESCREVEM EM A E B A PARTIR DE AGORA
module CONTROL(opcode, imediato, clock, reset,

				PCwrite, MemoryAdress, MemoryData, wr, SS, MDR, LS, WriteData, IRwrite,
				ShifterMux, Shifter, WriteReg, RegWrite, ULAa, ULAb,Load, ULAcontrol,
				ALUOUT, PCmux, EPC, MUX14, MDcontrol,MULTcontrol,DIVcontrol, Div0, HILOWrite, GT, LT, EG, N, ZERO, O
				);
				
		input [5:0] opcode;
		input wire clock, reset,GT,LT,EG,N,ZERO,O,Div0;//tem umas saidas do bloco da ula aqui
		input [15:0] imediato;	    
		
		output reg MULTcontrol,DIVcontrol;
		output reg PCwrite,HILOWrite,wr, MDR, IRwrite,RegWrite,Load,ALUOUT,EPC,MDcontrol, MUX14;
		output reg [2:0] PCmux,	ULAb ,	ULAcontrol	, WriteData ,Shifter , MemoryAdress;
		output reg [1:0] WriteReg,ULAa,ShifterMux , MemoryData,LS,SS ;
		
		reg[5:0] funct;
		reg [2:0]estadoatual;
		parameter estado0 = 3'd0;//estado inicial do controle
		parameter estado1 = 3'd1;
		parameter estado2 = 3'd2;
		parameter estado3 = 3'd3;
		parameter estado4 = 3'd4;
		parameter estado5 = 3'd5;
		//opcodes abaixo
		//MELISSA MEXEU
		parameter ADD = 6'd32;//funct 0x20
		parameter AND = 6'd36;//funct 0x24
		parameter DIV = 6'd26;//funct 0x1a
		parameter MULT = 6'd24;//funct 0x18
		parameter JRRS = 6'd8;//funct 0x8
		parameter MFHI = 6'd16;//funct 0x10
		parameter MFLO = 6'd18;//funct 0x12
		parameter SLL = 6'd0;//funct 0x0
		parameter SLLV = 6'd4;//funct 0x4
		parameter SLT = 6'd42;//funct 0x2a
		parameter SRA = 6'd3;//funct 0x3
		parameter SRAV = 6'd7;//funct 0x7
		parameter SRL = 6'd2;//funct 0x2
		parameter SUB = 6'd34;//funct 0x22
		parameter BREAK = 6'd13;//funct 0xd
		parameter RTE = 6'd19;//funct 0x13
		//MELISSA TERMINOU DE MEXER AQUI

		
		
		
		//etc..


		//opcodes acima
		initial begin
		  funct = imediato[5:0];
		  estadoatual = estado0;
		  PCwrite=1'd0;
		end

always @(posedge clock)begin
	if(estadoatual==estado0)begin
	  estadoatual=estado1;
	end
	else if (estadoatual==estado1) begin
	//pc+4 e leitura de instrucao
		PCwrite=1'd1;
		MemoryAdress=3'd0;
		wr=1'd0;
		ULAa=2'd0;
		ULAb=3'd2;
		ULAcontrol=3'd1;
		PCmux=3'd5;
		estadoatual=estado2;//muda estado
	end
	else if (estadoatual==estado2) begin
		//l� opcode e decodifica branch
		PCwrite=1'd0;//como � reg, ele vai ficar salvo at� entrar em outro estado onde PCwrite=1
		
		ULAa=2'd0;
		ULAb=3'd4;
		ULAcontrol=3'd1;
		RegWrite=1'd0;
		ALUOUT=1'd1;

		estadoatual=estado3;
	end
	else if (estadoatual==estado3) begin
		//come�o de instrucoes, um if (ou else if)pra cada opcode, um else no final pra opcode inexistente
		if(funct==ADD && opcode==6'd0)begin
			ULAa=2'd2;
			ULAb=3'd0;
			ULAcontrol=3'd1;
			ALUOUT=1'd1;  
			estadoatual=estado4;
		end
		else if (funct==SUB && opcode==6'd0) begin
			ULAa=2'd2;
			ULAb=3'd0;
			ULAcontrol=3'd2;
			ALUOUT=1'd1;
			estadoatual=estado4;
		end
		else if (funct==AND && opcode==6'd0) begin
			ULAa=2'd2;
			ULAb=3'd0;
			ULAcontrol=3'd3;
			ALUOUT=1'd1;
			estadoatual=estado4;
		end
	//MELISSA MEXEU (duvida: sempre tem que ter estado4 no fim? pq por exemplo o div faz tanto sub quando desloc e entrando em uma ele vaza???)
		else if (funct==MULT && opcode==6'd0) begin
			MDcontrol = 1'd0;
			estadoatual=estado4;
		end
		else if (funct==DIV && opcode==6'd0) begin
			MDcontrol = 1'd1;
			HILOWrite = 1'd1;
			estadoatual=estado4;
		end
		else if (funct==DIV && opcode==6'd0) begin
			MDcontrol = 1'd1;
			HILOWrite = 1'd1;
			estadoatual=estado4;
		end
		else if (funct==MFHI&& opcode==6'd0) begin
			WriteData = 3'd2;
			WriteReg = 2'd0;
			RegWrite = 1'd1;
			estadoatual=estado4;
		end
		else if (funct==MFLO&& opcode==6'd0) begin
			WriteData = 3'd3;
			WriteReg = 2'd0;
			RegWrite = 1'd1;
			estadoatual=estado4;
		end
		else if (funct==JRRS&& opcode==6'd0) begin
			ULAa = 2'd2;
			ULAcontrol = 3'd0;
			PCmux = 3'd5;
			PCwrite = 1'd1;
			estadoatual=estado4;
		end
		else if (funct==SLL&& opcode==6'd0) begin
			//PULEI PQ LUCAS É LOUCO
			ShifterMux = 2'd1;
			//Shifter = 3'd//ver isso aqui depois
			estadoatual=estado4;
		end
		/*output reg PCwrite,HILOWrite,wr, MDR, IRwrite,RegWrite,ALUOUT,EPC,MDcontrol, MUX14;
		output reg [2:0] PCmux,	ULAb ,	ULAcontrol	, WriteData ,Shifter , MemoryAdress;
		output reg [1:0] WriteReg,ULAa,ShifterMux , MemoryData,LS,SS ; */

	//MELISSA TERMINOU DE MEXER AQUI
		/*else if condition begin
			pass
		end
		*/
	end
	else if (estadoatual==estado4) begin
		//um if pra cada opcode (continuacao do estado anterior)
		if(funct==ADD && opcode==6'd0)begin
			if(O==1) begin//overflow
			  ULAa = 2'd0;
			  ULAb = 3'd2;
			  ULAcontrol=3'd2;
			  EPC = 1'd1;
			  MemoryAdress=3'd5;
			  PCmux=3'd6;
			  estadoatual=estado1;//recome�a
			end
			else begin//not overflow
				WriteData=1'd0;
				WriteReg=1'd0;
				RegWrite=1'd1;
				estadoatual=estado1;
			end
		end//add
	///////comentario separador de opcodes	
		else if (funct==SUB && opcode==6'd0) begin
			if(O==1) begin//overflow
				ULAa = 2'd0;
				ULAb = 3'd2;
				ULAcontrol=3'd2;
				EPC = 1'd1;
				MemoryAdress=3'd5;
				PCmux=3'd6;
				estadoatual=estado1;//recome�a
			end
			else begin//not overflow
				WriteData=1'd0;
				WriteReg=1'd0;
				RegWrite=1'd1;
				estadoatual=estado1;
			end
		end//sub
	///////comentario separador de opcodes
		else if (funct==AND && opcode==6'd0) begin
			WriteData=1'd0;
			WriteReg=1'd0;
			RegWrite=1'd1;
			estadoatual=estado1;
		end//&&
	///////comentario separador de opcodes







	end//end estado4
	else if (estadoatual==estado5) begin
		//um if pra cada opcode (continuacao do estado anterior)
		//pass;
	end//end estado5

end//end always

endmodule
