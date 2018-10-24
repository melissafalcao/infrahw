module CPU (/*nomes de todos os fios do circuito aqui*/);

CONTROL control_(
			opcode, 
			funct, 
			clock, 
			reset,
			PCwrite, 
			MemoryAdress, 
			MemoryData, 
			wr, 
			SS, 
			MDR, 
			LS, 
			WriteData, 
			IRwrite,
			ShifterMux, 
			Shifter, 
			WriteReg, 
			RegWrite, 
			ULAa, 
			ULAb, 
			ULAcontrol,
			ALUOUT, 
			PCmux, 
			EPC, 
			MUX14, 
			MDcontrol, 
			Div0, 
			HILOWrite, 
			GT, 
			LT, 
			EG, 
			N, 
			ZERO, 
			O
);
CONCAT concat_(
			rs, 
			rt, 
			imediato, 
			concatout
);
Banco_reg Bancoreg_(
			clock,
			reset,		
			RegWrite,	
			ReadReg1,	
			ReadReg2,	
			WriteReg,	
			WriteData, 	
			ReadData1,	
			ReadData2	
);
DIV div_(
			clock,
			reset,
			A, 
			B, 
			hidiv, 
			lodiv, 
			Div0
);
Instr_Reg IR(
			clock		,
			reset		,
			Load_ir		,
			Entrada		,
			Instr31_26	,
			Instr25_21	,
			Instr20_16	,
			Instr15_0	
);
LoadSize LS(
			LS, 
			MDRout, 
			LSout
);
Memoria mem(
			Address	,
			Clock	,
			Wr		,
			Datain	,
			Dataout	,
);
Multi multi(
			a, 
			b, 
			A, 
			B, 
			hi, 
			lo,
			i
);
MUX1 mux1(
			MemoryAdress, 
			PC, 
			ulaResult, 
			ext16_32, 
			ULAout, 
			ext25_32, 
			MUX1out
);
MUX2 mux2(
			WriteData, 
			ULAout, 
			LSout, 
			HIout, 
			LOout, 
			Shiftout, 
			LT32, 
			MUX2out
);
MUX3 mux3(
			WriteReg, 
			imediato, 
			rt,
			MUX3out
);
MUX4 mux4(
			ULAa, 
			pc, 
			mdr, 
			a, 
			MUX4out
);
MUX5 mux5(
			ULAb, 
			B, 
			ext16_32, 
			ext16_32_left_shifted, 
			MUX5out
);
MUX6 mux6(
			PCmux, 
			A, 
			ULAout, 
			SLAC, 
			EPCout, 
			MDRout, 
			ULAresult, 
			Mem, 
			MUX6out
);
MUX7eMUX8 mux78(
			MDcontrol, 
			himult, 
			hidiv, 
			lomult, 
			lodiv, 
			mux7out, 
			mux8out
);
MUX9eMUX10 mux910(
			ShifterMux, 
			A,
			B, 
			imediato, 
			mux9out, 
			mux10out
);
MUX13 mux13(
			MemoryData, 
			SSout, 
			ext16_32, 
			ulaResult, 
			MUX13out
);
MUX14 mux14(
			MUX14, 
			ulaResult, 
			LSout, 
			MUX14out
);
RegDesloc desloc(
			Clk		,
			Reset	,
			Shift 	,
			N		,
			Entrada ,
			Saida	
);
ShiftLeft2 SL2(
			ext16_32, 
			ext16_32_left_shifted
);
ShiftLeft2Concat shiftconcat(
			concatout, 
			PC, 
			SLAC
);
SignExtend signextend(
			concatout, 
			ext25_32
);
SignExtend16_32 signext16_32(
			imediato,  
			ext16_32
);
StoreSize SS(
			SS, 
			MDRout, 
			B, 
			SSout
);
ula32 ula(
			A 			,
			B 			,
			Seletor 	,
			S 			,
			Overflow 	,
			Negativo	,
			z			,
			Igual		,
			Maior		,
			Menor		,
);
UnitExtend UE(
			LT, 
			LT32
);
Registrador A(
			Clk		,
			Reset	,
			Load	,
			Entrada ,
			Saida	
);
Registrador B(
			Clk		,
			Reset	,
			Load	,
			Entrada ,
			Saida	
);
Registrador PC(
			Clk		,
			Reset	,
			Load	,
			Entrada ,
			Saida	
);
Registrador EPC(
			Clk		,
			Reset	,
			Load	,
			Entrada ,
			Saida	
);
Registrador ALUout(
			Clk		,
			Reset	,
			Load	,
			Entrada ,
			Saida	
);
Registrador MDR(
			Clk		,
			Reset	,
			Load	,
			Entrada ,
			Saida	
);
Registrador HI(
			Clk		,
			Reset	,
			Load	,
			Entrada ,
			Saida	
);
Registrador LO(
			Clk		,
			Reset	,
			Load	,
			Entrada ,
			Saida	
);



endmodule