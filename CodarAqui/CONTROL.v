//PS: LOAD ADICIONADO ONTEM A NOITE POR ZEH POIS OS REG A E B AGR TEM LOAD E TEM Q AJEITAR OS ESTADOS Q ESCREVEM EM A E B A PARTIR DE AGORA
module CONTROL(opcode, imediato, clock, reset,

				PCwrite, MemoryAdress, MemoryData, wr, SS, MDR, LS, WriteData, IRwrite,
				ShifterMux, Shifter, WriteReg,RegWrite, ULAa, ULAb,Load, ULAcontrol,
				ALUOUT, PCmux, EPC, MUX14, MDcontrol,MULTcontrol,DIVcontrol, Div0, HILOWrite, GT, LT, EG, N, ZERO, O
				);
				
		input [5:0] opcode;
		input wire clock, reset, GT, LT, EG, N, ZERO, O, Div0; //tem umas saidas do bloco da ula aqui
		input [15:0] imediato;	    
		
		output reg MULTcontrol,DIVcontrol;
		output reg PCwrite,HILOWrite,wr, MDR, IRwrite,RegWrite,Load,ALUOUT,EPC,MDcontrol, MUX14;
		output reg [2:0] PCmux,	ULAb ,	ULAcontrol	, WriteData ,Shifter , MemoryAdress;
		output reg [1:0] WriteReg,ULAa,ShifterMux , MemoryData,LS,SS ;
		
		//setar esses sinais de escrita em todo estado
		/*
		
		PCwrite=0;//para nao escrever no PC
		HILOWrite=0;//para nao escrever no HILO
		wr=0;//para nao escrever na memoria
		MDR=0;//para nao escrever no MDR
		IRwrite=0;//para nao carrregar nova instrucao
		RegWrite=0;//para nao escrever no banco de reg
		Load=0;//para nao escrever em A e B
		ALUOUT=0;//para nao escrver no aluout
		EPC=0;//para nao escrever no EPC
		MULTcontrol=0;//para nao ativar o mult
		DIVcontrol=0;//para nao ativar o div
		
		*/
		
		reg [5:0] funct;
		reg [2:0] estadoatual;
		parameter estado0 = 3'd0; //estado inicial do controle
		parameter estado1 = 3'd1;
		parameter estado2 = 3'd2;
		parameter estado3 = 3'd3;
		parameter estado4 = 3'd4;
		parameter estado5 = 3'd5;
		//opcodes abaixo
	
		
		parameter ADD = 6'd32;//funct 0x20
		parameter AND = 6'd36;//funct 0x24
		parameter DIV = 6'd26;//funct 0x1a
		parameter MULT = 6'd24;//funct 0x18
		parameter JR = 6'd8;//funct 0x8
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
		
		parameter ADDI = 6'd8 ;//opcode 0x8
		parameter ADDIU = 6'd9 ;//opcode 0x9
		parameter BEQ = 6'd4;//opcode 0x4
		parameter BNE = 6'd5;//opcode 0x5
		parameter BLE = 6'd6;//opcode 0x6
		parameter BGT = 6'd7;//opcode 0x7
		parameter LB = 6'd32;//opcode 0x20
		parameter LH = 6'd33;//opcode 0x21
		parameter LUI = 6'd15;//opcode 0xf
		parameter LW = 6'd35;//opcode 0x23
		parameter SB = 6'd40;//opcode 0x28
		parameter SH = 6'd41;//opcode 0x29
		parameter SLTI = 6'd10;//opcode 0xa
		parameter SW = 6'd43;//opcode 0x2b
		parameter J = 6'd2;//opcode 0x2
		parameter JAL = 6'd3;//opcode 0x3
		parameter INC = 6'd16;//opcode 0x10
		parameter DEC = 6'd17;//opcode 0x11

		//opcodes acima
		initial begin
		  	funct = imediato[5:0];
		  	estadoatual = estado0;
		 	
		end

always @(posedge clock)begin
	case(estadoatual)
		estado0: begin
			PCwrite=0;//para nao escrever no PC
			HILOWrite=0;//para nao escrever no HILO
			wr=0;//para nao escrever na memoria
			MDR=0;//para nao escrever no MDR
			IRwrite=0;//para nao carrregar nova instrucao
			RegWrite=0;//para nao escrever no banco de reg
			Load=0;//para nao escrever em A e B
			ALUOUT=0;//para nao escrver no aluout
			EPC=0;//para nao escrever no EPC
			MULTcontrol=0;//para nao ativar o mult
			DIVcontrol=0;//para nao ativar o div
		  	estadoatual=estado1;
		end//end estado 0
		estado1: begin
		//pc+4 e leitura de instrucao da memoria
			Load=0;//nao escreve em A e B
			MemoryAdress=3'd0;
			ALUOUT=0;
			EPC=0;
			HILOWrite=0;
			MULTcontrol=0;
			DIVcontrol=0;
			wr=0;
			RegWrite=0;
			MDR=0;
			ULAcontrol=3'd1;
			ULAa=2'd0;
			ULAb=3'd2;
			PCwrite=1'd1;
			PCmux=3'd5;
			IRwrite=1;
			estadoatual=estado2;//muda estado
		end//end estado 1
		estado2: begin
		//lÃ¯Â¿Â½ opcode e decodifica branch
			PCwrite=0;//como Ã¯Â¿Â½ reg, ele vai ficar salvo atÃ¯Â¿Â½ entrar em outro estado onde PCwrite=1
			wr=0;//ler da memoria
			ULAa=2'd0;//pc
			ULAb=3'd4;//offset estendido
			ULAcontrol=3'd1;//soma
			IRwrite=1;//ler opcode
			RegWrite=0;//ler do banco e salvar em AeB
			Load=1;//escrever am A e B
			ALUOUT=1;//escreve branch em aluout
			estadoatual=estado3;
		end//end estado 2
		estado3: begin
		//comeÃ¯Â¿Â½o de instrucoes, um if (ou else if)pra cada opcode, um else no final pra opcode inexistente
			if(funct==ADD && opcode==6'd0)begin
				PCwrite=0;//para nao escrever no PC
				HILOWrite=0;//para nao escrever no HILO
				wr=0;//para nao escrever na memoria
				MDR=0;//para nao escrever no MDR
				IRwrite=0;//para nao carrregar nova instrucao
				RegWrite=0;//para nao escrever no banco de reg
				Load=0;//para nao escrever em A e B
				EPC=0;//para nao escrever no EPC
				MULTcontrol=0;//para nao ativar o mult
				DIVcontrol=0;//para nao ativar o div
				ULAa=2'd2;
				ULAb=3'd0;
				ULAcontrol=3'd1;
				ALUOUT=1'd1;
				estadoatual=estado4;
			end
			else if (funct==AND && opcode==6'd0) begin
				PCwrite=0;//para nao escrever no PC
				HILOWrite=0;//para nao escrever no HILO
				wr=0;//para nao escrever na memoria
				MDR=0;//para nao escrever no MDR
				IRwrite=0;//para nao carrregar nova instrucao
				RegWrite=0;//para nao escrever no banco de reg
				Load=0;//para nao escrever em A e B
				EPC=0;//para nao escrever no EPC
				MULTcontrol=0;//para nao ativar o mult
				DIVcontrol=0;//para nao ativar o div
				ULAa=2'd2;
				ULAb=3'd0;
				ULAcontrol=3'd3;
				ALUOUT=1'd1;
				estadoatual=estado4;
			end
			else if (funct==DIV && opcode==6'd0) begin
			//MELISSA MEXEU (duvida: sempre tem que ter estado4 no fim? pq por exemplo o div faz tanto sub quando desloc e entrando em uma ele vaza???)
			//ZÃƒÂ©: o div faz sub e desloc internamente, aqui a gt vai ter q fazer o controle esperar o div acabar antes de passar pro proximo estado
				PCwrite=0;//para nao escrever no PC
				wr=0;//para nao escrever na memoria
				MDR=0;//para nao escrever no MDR
				IRwrite=0;//para nao carrregar nova instrucao
				RegWrite=0;//para nao escrever no banco de reg
				Load=0;//para nao escrever em A e B
				ALUOUT=0;//para nao escrver no aluout
				EPC=0;//para nao escrever no EPC
				MULTcontrol=0;//para nao ativar o mult
				DIVcontrol=0;//para nao ativar o div
				MDcontrol = 1'd1;
				HILOWrite = 1'd1;
				estadoatual=estado0;
			end
			else if (funct==MULT && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				MDcontrol = 1'd0;
				estadoatual=estado0;
			end
			else if (funct==JR&& opcode==6'd0) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa = 2'd2;
				ULAcontrol = 3'd0;
				PCmux = 3'd5;
				PCwrite = 1'd1;
				estadoatual=estado0;
			end
			else if (funct==MFHI && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				WriteData = 3'd2;
				WriteReg = 2'd0;
				RegWrite = 1'd1;
				estadoatual=estado0;
			end
			else if (funct==MFLO && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				WriteData = 3'd3;
				WriteReg = 2'd0;
				RegWrite = 1'd1;
				estadoatual=estado0;
			end
			else if (funct==SLL && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				Shifter = 3'd1;
				ShifterMux = 2'd1;
				estadoatual=estado4;
			end
			else if (funct==SLLV && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ShifterMux = 2'd0;
				Shifter = 3'd1;
				estadoatual=estado4;
			end
			else if (funct==SRAV && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ShifterMux = 2'd0;
				Shifter = 3'd1;
				estadoatual=estado4;
			end
			else if (funct==SLT && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa = 2'd2;
				ULAb = 3'd0;
				ULAcontrol = 3'd7;
				WriteData = 3'd5;
				WriteReg = 2'd0;
				RegWrite = 1'd1; 
				estadoatual=estado0;
			end
			else if (funct==SRA && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				Shifter = 3'd1;
				ShifterMux = 2'd1;
				estadoatual=estado4;
			end
			else if (funct==SRL && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				Shifter = 3'd1;
				ShifterMux = 2'd1;
				estadoatual=estado4;
			end
			else if (funct==SUB && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa=2'd2;
				ULAb=3'd0;
				ULAcontrol=3'd2;
				ALUOUT=1'd1;
				estadoatual=estado4;
			end
			else if (funct==BREAK && opcode==6'd0) begin
				HILOWrite=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa =2'd0;
				ULAb= 3'd2;
				ULAcontrol =3'd2;
				PCmux =3'd1;
				PCwrite =1'd1;
				IRwrite =1'd0;
				RegWrite= 1'd0;
				wr=1'd0;
				estadoatual=estado0;
			end
			else if (funct==RTE && opcode==6'd0) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				PCwrite = 1'd1;
				PCmux = 3'd3;
				estadoatual=estado0;
			end
			else if (opcode==ADDI) begin
				ULAa = 2'd2;
				ULAb = 3'd1;
				ULAcontrol = 3'd1;
				ALUOUT=1;
				PCwrite=0;//para nao escrever no PC
				HILOWrite=0;//para nao escrever no HILO
				wr=0;//para nao escrever na memoria
				MDR=0;//para nao escrever no MDR
				IRwrite=0;//para nao carrregar nova instrucao
				RegWrite=0;//para nao escrever no banco de reg
				Load=0;//para nao escrever em A e B
				ALUOUT=0;//para nao escrver no aluout
				EPC=0;//para nao escrever no EPC
				MULTcontrol=0;//para nao ativar o mult
				DIVcontrol=0;//para nao ativar o div
				estadoatual=estado4;
			end
			else if (opcode==ADDIU) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAb = 3'd1;
				ULAa = 2'd2;
				ULAcontrol = 3'd1;
				ALUOUT =1'd1;
				estadoatual=estado4;
			end
			else if (opcode==BEQ) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa = 2'd2;
				ULAb = 3'd0;
				ULAcontrol = 3'd7;
				estadoatual=estado4;
			end
			else if (opcode==BNE) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa = 2'd2;
				ULAb = 3'd0;
				ULAcontrol = 3'd7;
				estadoatual=estado4;
			end
			else if (opcode==BLE) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa = 2'd2;
				ULAb = 3'd0;
				ULAcontrol = 3'd7;
				estadoatual=estado4;
			end
			else if (opcode==BGT) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa = 2'd2;
				ULAb = 3'd0;
				ULAcontrol = 3'd7;
				estadoatual=estado4;
			end
			else if (opcode==LB) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAb = 3'd1;
				ULAa = 2'd2;
				ULAcontrol=3'd1;
				IRwrite = 1'd0;
				PCwrite = 1'd0;
				MemoryAdress=3'd1;
				MDR=1'd1;
				estadoatual=estado4;
			end
			else if (opcode==LH) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAb = 3'd1;
				ULAa = 2'd2;
				ULAcontrol=3'd1;
				IRwrite = 1'd0;
				PCwrite = 1'd0;
				MemoryAdress =3'd1;
				MDR=1'd1;
				estadoatual=estado4;
			end
			else if (opcode==LUI) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ShifterMux = 2'd2;
				Shifter = 3'd1;
				estadoatual=estado4;
			end
			else if (opcode==LW) begin
				HILOWrite=0;
				wr=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAb = 3'd1;
				ULAa = 2'd2;
				ULAcontrol=3'd1;
				IRwrite = 1'd0;
				PCwrite = 1'd0;
				MemoryAdress=3'd1;
				MDR=1'd1;
				estadoatual=estado4;
			end
			else if (opcode==SB) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa = 2'd2;
				ULAb = 3'd1;
				ULAcontrol=3'd1;
				PCwrite = 1'd0;
				ALUOUT = 1'd1;
				estadoatual=estado4;
			end
			else if (opcode==SH) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa = 2'd2;
				ULAb = 3'd1;
				ULAcontrol=3'd1;
				PCwrite = 1'd0;
				ALUOUT = 1'd1;
				estadoatual=estado4;
			end
			else if (opcode==SLTI) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa=2'd2;
				ULAb = 3'd1;
				ULAcontrol = 3'd7;
				WriteData = 3'd5;
				WriteReg = 2'd1;
				RegWrite = 1'd1;
				estadoatual=estado0;
			end
			else if (opcode==SW) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa = 2'd2;
				ULAb = 3'd1;
				ULAcontrol=3'd1;
				PCwrite = 1'd0;
				ALUOUT = 1'd1;
				estadoatual=estado4;
			end
			else if (opcode==J) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				PCwrite = 1'd1;
				PCmux = 3'd2;
				estadoatual=estado0;
			end
			else if (opcode==JAL) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				PCwrite = 1'd0;
				ULAa = 2'd2;
				ULAcontrol = 3'd0;
				ALUOUT=1'd1;
				estadoatual=estado4;
			end
			else if (opcode==INC) begin
				PCwrite=0;
				HILOWrite=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				wr=1'd0;
				MemoryAdress=3'd7;
				MDR=1'd1;
				estadoatual=estado4;
			end
			else if (opcode==DEC) begin
				PCwrite=0;
				HILOWrite=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				wr=1'd0;
				MemoryAdress=3'd7;
				MDR=1'd1;
				estadoatual=estado4;
			end
		end//end estado 3
		estado4: begin
		//um if pra cada opcode (continuacao do estado anterior)
			if(funct==ADD && opcode==6'd0)begin
				if(O==1) begin//overflow
					ULAa = 2'd0;
					ULAb = 3'd2;
					ULAcontrol=3'd2;
					EPC = 1'd1;
					MemoryAdress=3'd5;
					PCmux=3'd6;
					estadoatual=estado0;//recomeÃ¯Â¿Â½a
				end
				else begin//not overflow
					WriteData=3'd0;
					WriteReg=2'd1;
					RegWrite=1'd1;
					estadoatual=estado0;
				end
			end//add
			///////comentario separador de opcodes	
			else if (funct==SUB && opcode==6'd0) begin
				if(O==1) begin//overflow	
					PCwrite=0;
					HILOWrite=0;
					wr=0;
					MDR=0;
					IRwrite=0;
					RegWrite=0;
					Load=0;
					ALUOUT=0;
					MULTcontrol=0;
					DIVcontrol=0;
					ULAa = 2'd0;
					ULAb = 3'd2;
					ULAcontrol=3'd2;
					EPC = 1'd1;
					MemoryAdress=3'd5;
					PCmux=3'd6;
					estadoatual=estado0;//recomeÃ¯Â¿Â½a
				end
				else begin//not overflow
					PCwrite=0;
					HILOWrite=0;
					wr=0;
					MDR=0;
					IRwrite=0;
					Load=0;
					ALUOUT=0;
					EPC=0;
					MULTcontrol=0;
					DIVcontrol=0;
					WriteData=3'd0;
					WriteReg=1'd0;
					RegWrite=1'd1;
					estadoatual=estado0;
				end
			end//sub
			///////comentario separador de opcodes
			else if (funct==AND && opcode==6'd0) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				WriteData=3'd0;
				WriteReg=1'd0;
				RegWrite=1'd1;
				estadoatual=estado0;
			end//AND
			///////comentario separador de opcodes
			else if (opcode==ADDI) begin
				WriteData=3'd0;
				WriteReg=2'd1;
				RegWrite=1;
				PCwrite=0;//para nao escrever no PC
				HILOWrite=0;//para nao escrever no HILO
				wr=0;//para nao escrever na memoria
				MDR=0;//para nao escrever no MDR
				IRwrite=0;//para nao carrregar nova instrucao
				Load=0;//para nao escrever em A e B
				ALUOUT=0;//para nao escrver no aluout
				EPC=0;//para nao escrever no EPC
				MULTcontrol=0;//para nao ativar o mult
				DIVcontrol=0;//para nao ativar o div
				estadoatual=estado0;
			///////comentario separador de opcodes
			end//ADDI
			else if ((opcode == ADD) || (opcode == AND) || (opcode == SUB)) begin	
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				WriteData = 3'd0;
				WriteReg = 2'd0;
				RegWrite = 1'd1;
				estadoatual=estado5;
			end//ADD
			///////comentario separador de opcodes
			else if (opcode == SLL) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ShifterMux = 2'd1;
				Shifter = 3'd2;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == SRA) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ShifterMux = 2'd1;
				Shifter = 3'd4;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == SRL) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ShifterMux = 2'd1;
				Shifter = 3'd3;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if ((opcode == SW) ||  (opcode == SH) || (opcode == SB)) begin // VERIFICAR SE EXISTEM
				PCwrite=0;
				HILOWrite=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				MemoryAdress = 3'd3;
				wr= 1'd0;
				MDR=1'd1;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == SLLV) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ShifterMux = 2'd0;
				Shifter = 3'd2;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == SRAV) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ShifterMux = 2'd0;
				Shifter = 3'd3;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == LW) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				WriteData = 3'd1;
				WriteReg = 2'd1;
				RegWrite = 1'd1;
				LS = 2'd2;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == LH) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				WriteData = 3'd1;
				WriteReg = 2'd1;
				RegWrite = 1'd1;
				LS = 2'd1;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == LB) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				WriteData = 3'd1;
				WriteReg = 2'd1;
				RegWrite = 1'd1;
				LS = 2'd0;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == JAL) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				PCwrite = 1'd1;
				PCmux = 3'd2;
				WriteReg = 2'd2;
				RegWrite = 1'd1;
				WriteData = 3'd0;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if ((opcode == ADDI) || (opcode == ADDIU)) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				WriteReg = 2'd1;
				WriteData = 3'd0;
				RegWrite = 1'd1;
				estadoatual=estado5;
			end
			//falta beq bne
			else if ((opcode==BEQ && EG==1) || (opcode==BNE && EG==0)) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				PCmux = 3'd1;
				PCwrite = 1'd1;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if ((opcode==BGT && GT==1) || (opcode==BLE && GT==0)) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				PCmux = 3'd1;
				PCwrite = 1'd1;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if ((opcode==BEQ && EG==1) || (opcode==BNE && EG==0)) begin
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				PCmux = 3'd1;
				PCwrite = 1'd1;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == LUI) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				Shifter = 3'd2;
				WriteData = 3'd4;
				RegWrite = 1'd1;
				WriteReg = 2'd1;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == INC) begin
				PCwrite=0;
				HILOWrite=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa=2'd1;
				ULAb=3'd3;	
				ULAcontrol=3'd1;
				wr=1'd1;
				MemoryData=2'd2;
				estadoatual=estado5;
			end
			///////comentario separador de opcodes
			else if (opcode == DEC) begin
				PCwrite=0;
				HILOWrite=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				ULAa=2'd1;
				ULAb=3'd3;	
				ULAcontrol=3'd2;
				wr=1'd1;
				MemoryData=2'd2;
			end
		end//end estado4
		estado5: begin
		//um if pra cada opcode (continuacao do estado anterior)
		//pass??
			if ((opcode == SLL) || (opcode == SRA) || (opcode == SRL)) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				WriteData = 3'd4;
				WriteReg = 2'd0;
				RegWrite = 1'd1;
				estadoatual=estado0;
			end
			///////comentario separador de opcodes
			else if (opcode == SW) begin 
				PCwrite=0;
				HILOWrite=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				SS = 2'd2;
				MemoryAdress = 3'd3;
				MemoryData = 2'd0;
				wr = 1'd1;
				estadoatual=estado0;
			end
			///////comentario separador de opcodes
			else if (opcode == SH) begin
				PCwrite=0;
				HILOWrite=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				SS = 2'd1;
				MemoryAdress = 3'd3;
				MemoryData = 2'd0;
				wr = 1'd1;
				estadoatual=estado0;
			end
			///////comentario separador de opcodes
			else if (opcode == SB) begin 
				PCwrite=0;
				HILOWrite=0;
				MDR=0;
				IRwrite=0;
				RegWrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				SS = 2'd0;
				MemoryAdress = 3'd3;
				MemoryData = 2'd0;
				wr = 1'd1;
				estadoatual=estado0;
			end
			///////comentario separador de opcodes
			else if ((opcode == SLLV) || (opcode == SRAV)) begin
				PCwrite=0;
				HILOWrite=0;
				wr=0;
				MDR=0;
				IRwrite=0;
				Load=0;
				ALUOUT=0;
				EPC=0;
				MULTcontrol=0;
				DIVcontrol=0;
				WriteData=3'd4;
				WriteReg = 2'd0;
				RegWrite = 1'd1;
				estadoatual=estado0;
			end
		estadoatual=estado0;
		end//end estado5
	end//end always

endmodule
