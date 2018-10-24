module CPU (/*nomes de todos os fios do circuito aqui*/);
input wire clock, reset;

CONTROL control_(
			opcode, 
			imediato, 
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
CONCAT concat_(//ok
			rs, 
			rt, 
			imediato, 
			concatout
);
Banco_reg Bancoreg_(//ok
			clock,
			reset,		
			RegWrite,	
			rs,	
			rt,	
			MUX3out,//writedata	
			MUX2out,//data_in 	
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
Instr_Reg IR(//ok
			clock,
			reset,
			IRwrite,
			MemoryOut,
			opcode,
			rs,
			rt,
			imediato	
);
LoadSize LS(//ok
			LS, 
			MDRout, 
			LSout
);
Memoria mem(//ok
			MUX1out	,
			Clock	,
			Wr		,
			MUX13out	,
			MemoryOut	,
);
Multi multi(
			a, 
			b, 
			A, 
			B, 
			himult, 
			lomult,
			i
);
MUX1 mux1(//ok
			MemoryAdress, 
			PC, 
			UlaResult, 
			ext16_32, 
			ULAout, 
			ext25_32, 
			MUX1out
);
MUX2 mux2(//ok
			WriteData, 
			ULAout, 
			LSout, 
			HIout, 
			LOout, 
			Shiftout, 
			LT32, 
			MUX2out
);
MUX3 mux3(//ok
			WriteReg, 
			imediato, 
			rt,
			MUX3out
);
MUX4 mux4(//ok
			ULAa, 
			PCout, 
			MDRout, 
			Aout, 
			MUX4out
);
MUX5 mux5(//ok
			ULAb, 
			Bout, 
			ext16_32, 
			ext16_32_left_shifted, 
			MUX5out
);
MUX6 mux6(//ok
			PCmux, 
			Aout, 
			ULAout, 
			SLAC, 
			EPCout, 
			MDRout, 
			UlaResult, 
			MemoryOut, 
			MUX6out
);
MUX7eMUX8 mux78(//ajeitar himult e lomult após adicionar mult div caso necessario
			MDcontrol, 
			himult, 
			hidiv, 
			lomult, 
			lodiv, 
			MUX7out, 
			MUX8out
);
MUX9eMUX10 mux910(//ok
			ShifterMux, 
			Aout,
			Bout, 
			imediato, 
			MUX9out, 
			MUX10out
);
MUX13 mux13(//ok
			MemoryData, 
			SSout, 
			ext16_32, 
			UlaResult, 
			MUX13out
);
MUX14 mux14(//ok
			MUX14, 
			UlaResult, 
			LSout, 
			MUX14out
);
RegDesloc desloc(//ok
			clock		,
			reset	,
			Shifter 	,
			MUX9out	,
			MUX10out ,
			Shiftout	
);
ShiftLeft2 SL2(//ok
			ext16_32, 
			ext16_32_left_shifted
);
ShiftLeft2Concat shiftconcat(//ok
			concatout, 
			PC, 
			SLAC
);
SignExtend signextend(//ok
			concatout, 
			ext25_32
);
SignExtend16_32 signext16_32(//ok
			imediato,  
			ext16_32
);
StoreSize SS(//ok
			SS, 
			MDRout, 
			B, 
			SSout
);
ula32 ula(//ok
			MUX4out ,
			MUX5out ,
			ULAcontrol,
			UlaResult ,
			Overflow 	,
			Negativo	,
			ZERO			,
			EG		,
			GT		,
			LT		,
);
UnitExtend UE(//ok
			LT, 
			LT32
);
Registrador A(//ok
			clock		,
			reset	,
			Load	,
			ReadData1 ,
			Aout	
);
Registrador B(//ok
			clock		,
			reset	,
			Load	,
			ReadData2 ,
			Bout	
);
Registrador PC(//ok
			clock		,
			reset	,
			PCwrite	,
			MUX6out ,
			PCout	
);
Registrador EPC(//ok
			clock		,
			reset	,
			EPC	,
			MUX14out ,
			EPCout	
);
Registrador ALUout(//ok
			clock		,
			reset	,
			ALUOUT	,
			UlaResult ,
			EPCout	
);
Registrador MDR(//ok
			clock		,
			reset	,
			MDR	,
			MemoryOut ,
			MDRout	
);
Registrador HI(//ok
			clock		,
			reset	,
			HILOWrite	,
			MUX7out ,
			HIout	
);
Registrador LO(//ok
			clock		,
			reset	,
			HILOWrite	,
			MUX8out ,
			LOout	
);



endmodule