module CONTROL(opcode, funct, clock, reset,

				PCwrite, MemoryAdress, MemoryData, wr, SS, MDR, LS, WriteData, IRwrite,
				ShifterMux, Shifter, SighExt, WriteReg, RegWrite, ULAa, ULAb, ULAcontrol,
				ALUOUT, PCmux, EPC, MUX14, MDcontrol, Div0, HILOWrite, 
				);
				
		input reg[5:0] opcode,funct;
		input wire clock, reset,GT,LT,EG,N,ZERO,O,Div0;//tem umas saidas do bloco da ula aqui
				    
		
	
		output reg PCwrite,HILOWrite,wr, MDR, IRwrite,RegWrite,ALUOUT,EPC,MDcontrol, MUX14;
		output reg [2:0] PCmux,	ULAb ,	ULAcontrol	, WriteData ,Shifter ,LS,SS, MemoryAdress;
		output reg [1:0] WriteReg,ULAa,ShifterMux , MemoryData ;
		
		
		reg [2:0]estadoatual;
		parameter estado0 = 3'd0;//estado inicial do controle
		parameter estado1 = 3'd1;
		parameter estado2 = 3'd2;
		parameter estado3 = 3'd3;
		parameter estado4 = 3'd4;
		parameter estado5 = 3'd5;
		//opcodes abaixo
		parameter ADD = 6'd0;//funct 0x20
		parameter AND = 6'd0//funct 0x24
		parameter SUB = 6'd0//funct 0x22
		//etc..


		//opcodes acima
		initial begin
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
		//lê opcode e decodifica branch
		PCwrite=1'd0;//como é reg, ele vai ficar salvo até entrar em outro estado onde PCwrite=1
		
		ULAa=2'd0;
		ULAb=3'd4;
		ULAcontrol=3'd1;
		RegWrite=1'd0;
		ALUOUT=1'd1;

		estadoatual=estado3;
	end
	else if (estadoatual==estado3) begin
		//começo de instrucoes, um if (ou else if)pra cada opcode, um else no final pra opcode inexistente
		if(funct==ADD and opcode==6'd0)begin
			ULAa=2'd2;
			ULAb=3'd0;
			ULAcontrol=3'd1;
			ALUOUT=1'd1;  
			estadoatual=estado4;
		end
		else if (funct==SUB and opcode==6'd0) begin
			ULAa=2'd2;
			ULAb=3'd0;
			ULAcontrol=3'd2;
			ALUOUT=1'd1;
			estadoatual=estado4;
		end
		else if (funct==AND and opcode==6'd0) begin
			ULAa=2'd2;
			ULAb=3'd0;
			ULAcontrol=3'd3;
			ALUOUT=1'd1;
			estadoatual=estado4;
		end
		/*else if condition begin
			pass
		end
		*/
	end
	else if (estadoatual==estado4) begin
		//um if pra cada opcode (continuacao do estado anterior)
		if(funct==ADD and opcode==6'd0)begin
			if(O==1) begin//overflow
			  ULAa = 2'd0;
			  ULAb = 3'd2;
			  ULAcontrol=3'd2;
			  EPC = 1'd1;
			  MemoryAdress=3'd5;
			  PCmux=3'd6;
			  estadoatual=estado1;//recomeça
			end
			else begin//not overflow
				WriteData=1'd0;
				WriteReg=1'd0;
				RegWrite=1'd1;
				estadoatual=estado1;
			end
		end//add
	///////comentario separador de opcodes	
		else if (funct==SUB and opcode==6'd0) begin
			if(O==1) begin//overflow
				ULAa = 2'd0;
				ULAb = 3'd2;
				ULAcontrol=3'd2;
				EPC = 1'd1;
				MemoryAdress=3'd5;
				PCmux=3'd6;
				estadoatual=estado1;//recomeça
			end
			else begin//not overflow
				WriteData=1'd0;
				WriteReg=1'd0;
				RegWrite=1'd1;
				estadoatual=estado1;
			end
		end//sub
	///////comentario separador de opcodes
		else if (funct==AND and opcode==6'd0) begin
			WriteData=1'd0;
			WriteReg=1'd0;
			RegWrite=1'd1;
			estadoatual=estado1;
		end//and
	///////comentario separador de opcodes







	end//end estado4
	else if (estadoatual==estado5) begin
		//um if pra cada opcode (continuacao do estado anterior)
		pass
	end//end estado5

end//end always

endmodule		