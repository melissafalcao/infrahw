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

		
		reg[5:0] funct;
		reg [2:0]estadoatual;
		parameter estado0 = 3'd0;//estado inicial do controle
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
		
		parameter ADDI =6'd8 ;//opcode 0x8
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
		  PCwrite=1'd0;
		end

always @(posedge clock)begin
	if(estadoatual==estado0)begin
	  estadoatual=estado1;
	end
	else if (estadoatual==estado1) begin
	//pc+4 e leitura de instrucao da memoria
		PCwrite=1'd1;
		HILOWrite=0;
		MemoryAdress=3'd0;
		wr=0;
		IRwrite=1;
		RegWrite=0;
		MDR=0;
		Load=1;//escreve em A e B
		ULAa=2'd0;
		ULAb=3'd2;
		ULAcontrol=3'd1;
		PCmux=3'd5;
		ALUOUT=0;
		EPC=0;
		MULTcontrol=0;
		DIVcontrol=0;
		estadoatual=estado2;//muda estado
	end//end estado 1
	else if (estadoatual==estado2) begin
		//lï¿½ opcode e decodifica branch
		PCwrite=0;//como ï¿½ reg, ele vai ficar salvo atï¿½ entrar em outro estado onde PCwrite=1
		wr=0;//ler da memoria
		ULAa=2'd0;//pc
		ULAb=3'd4;//offset estendido
		ULAcontrol=3'd1;//soma
		IRwrite=1;//ler opcode
		RegWrite=0;//ler do banco e salvar em AeB
		Load=1;//escrever am A e B
		ALUOUT=1;//escreve branch em aluout

		estadoatual=estado3;
	end//en destado 2
	else if (estadoatual==estado3) begin
		//comeï¿½o de instrucoes, um if (ou else if)pra cada opcode, um else no final pra opcode inexistente
		if(funct==ADD && opcode==6'd0)begin
			ULAa=2'd2;
			ULAb=3'd0;
			ULAcontrol=3'd1;
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
		else if (funct==DIV && opcode==6'd0) begin
	//MELISSA MEXEU (duvida: sempre tem que ter estado4 no fim? pq por exemplo o div faz tanto sub quando desloc e entrando em uma ele vaza???)
	//ZÃ©: o div faz sub e desloc internamente, aqui a gt vai ter q fazer o controle esperar o div acabar antes de passar pro proximo estado
			MDcontrol = 1'd1;
			HILOWrite = 1'd1;
			estadoatual=estado4;
		end
		else if (funct==MULT && opcode==6'd0) begin
			MDcontrol = 1'd0;
			estadoatual=estado4;
		end
		else if (funct==JR&& opcode==6'd0) begin
			ULAa = 2'd2;
			ULAcontrol = 3'd0;
			PCmux = 3'd5;
			PCwrite = 1'd1;
			estadoatual=estado4;
		end
		else if (funct==MFHI && opcode==6'd0) begin
			WriteData = 3'd2;
			WriteReg = 2'd0;
			RegWrite = 1'd1;
			estadoatual=estado4;
		end
		else if (funct==MFLO && opcode==6'd0) begin
			WriteData = 3'd3;
			WriteReg = 2'd0;
			RegWrite = 1'd1;
			estadoatual=estado4;
		end
		else if (funct==SLL && opcode==6'd0) begin
			
			estadoatual=estado4;
		end
		else if (funct==SLLV && opcode==6'd0) begin
			
			estadoatual=estado4;
		end
		else if (funct==SLT && opcode==6'd0) begin
			
			estadoatual=estado4;
		end
		else if (funct==SRA && opcode==6'd0) begin
			
			estadoatual=estado4;
		end
		else if (funct==SRL && opcode==6'd0) begin
			
			estadoatual=estado4;
		end
		else if (funct==SUB && opcode==6'd0) begin
			ULAa=2'd2;
			ULAb=3'd0;
			ULAcontrol=3'd2;
			ALUOUT=1'd1;
			estadoatual=estado4;
		end
		else if (funct==BREAK && opcode==6'd0) begin
			
			estadoatual=estado4;
		end
		else if (funct==RTE && opcode==6'd0) begin
			
			estadoatual=estado4;
		end
		else if (opcode==ADDI) begin
			ULAa = 2'd2;
			ULAb = 3'd1;
			ULAcontrol = 3'd1;
			ALUOUT=1;
			estadoatual=estado4;
		end
		else if (opcode==ADDIU) begin
			
			estadoatual=estado4;
		end
		else if (opcode==BEQ) begin
			
			estadoatual=estado4;
		end
		else if (opcode==BNE) begin
			
			estadoatual=estado4;
		end
		else if (opcode==BLE) begin
			
			estadoatual=estado4;
		end
		else if (opcode==BGT) begin
			
			estadoatual=estado4;
		end
		else if (opcode==LB) begin
			
			estadoatual=estado4;
		end
		else if (opcode==LH) begin
			
			estadoatual=estado4;
		end
		else if (opcode==LUI) begin
			
			estadoatual=estado4;
		end
		else if (opcode==LW) begin
			
			estadoatual=estado4;
		end
		else if (opcode==SB) begin
			
			estadoatual=estado4;
		end
		else if (opcode==SH) begin
			
			estadoatual=estado4;
		end
		else if (opcode==SLTI) begin
			
			estadoatual=estado4;
		end
		else if (opcode==SW) begin
			
			estadoatual=estado4;
		end
		else if (opcode==J) begin
			
			estadoatual=estado4;
		end
		else if (opcode==JAL) begin
			
			estadoatual=estado4;
		end
		else if (opcode==INC) begin
			
			estadoatual=estado4;
		end
		else if (opcode==DEC) begin
			
			estadoatual=estado4;
		end
	end//end estado 3
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
			  estadoatual=estado1;//recomeï¿½a
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
				estadoatual=estado1;//recomeï¿½a
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
		end//AND
	///////comentario separador de opcodes







	end//end estado4
	else if (estadoatual==estado5) begin
		//um if pra cada opcode (continuacao do estado anterior)
		//pass;
	end//end estado5

end//end always

endmodule
