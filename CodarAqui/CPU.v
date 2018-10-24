module CPU (/*nomes de todos os fios do circuito aqui*/
ALUOUT,
Aout,
Bout,
clock,
Div0,
EG,
EPC,
EPCout,
GT,
HILOWrite,
HIout,
IRwrite,
LOout,
LS,
LSout,
LT,
LT32,
Load,
MDR,
MDRout,
MDcontrol,
MULTcontrol,
MUX10out,
MUX13out,
MUX14,
MUX14out,
MUX1out,
MUX2out,
MUX3out,
MUX4out,
MUX5out,
MUX6out,
MUX7out,
MUX8out,
MUX9out,
MemoryAdress,
MemoryData,
MemoryOut,
Negativo,
Overflow,
PC,
PCmux,
PCout,
PCwrite,
ReadData1,
ReadData2,
RegWrite,
SLAC,
SS,
SSout,
Shifter,
ShifterMux,
Shiftout,
ULAa,
ULAb,
ULAcontrol,
ULAout,
UlaResult,
Wr,
WriteData,
WriteReg,
ZERO,
concatout,
ext16_32,
ext16_32_left_shifted,
ext25_32,
hidiv,
himult,
imediato,
lodiv,
lomult,
opcode,
reset,
rs,
rt,
wr
);


//declarar tudo
reg [31:0]ALUOUT;
reg [31:0]Aout;
reg [31:0]Bout;
clock;
Div0;
EG;
EPC;
reg [31:0]EPCout;
GT;
HILOWrite;
HIout;
IRwrite;
LOout;
LS;
reg [31:0]LSout;
LT;
reg [31:0]LT32;
Load;
MDR;
reg [31:0]MDRout;
MDcontrol;
MULTcontrol;
reg [31:0]MUX10out;
reg [31:0]MUX13out;
MUX14;
reg [31:0]MUX14out;
reg [31:0]MUX1out;
reg [31:0]MUX2out;
reg [31:0]MUX3out;
reg [31:0]MUX4out;
reg [31:0]MUX5out;
reg [31:0]MUX6out;
reg [31:0]MUX7out;
reg [31:0]MUX8out;
MUX9out;
MemoryAdress;
MemoryData;
reg [31:0]MemoryOut;
Negativo;
Overflow;
PC;
PCmux;
reg [31:0]PCout;
PCwrite;
reg [31:0]ReadData1;
reg [31:0]ReadData2;
RegWrite;
reg [31:0]SLAC;
SS;
reg [31:0]SSout;
Shifter;
ShifterMux;
reg [31:0]Shiftout;
ULAa;
ULAb;
ULAcontrol;
reg [31:0]ULAout;
reg [31:0]UlaResult;
Wr;
WriteData;
WriteReg;
ZERO;
concatout;
reg [31:0]ext16_32;
reg [31:0]ext16_32_left_shifted;
reg [31:0]ext25_32;
reg [31:0]hidiv;
reg [31:0]himult;
imediato;
reg [31:0]lodiv;
reg [31:0]lomult;
opcode;
reset;
reg [31:0]rs;
reg [31:0]rt;
wr;

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
			MULTcontrol,//adicionar essa variavel no CONTROL.v 
			Div0, 
			HILOWrite, 
			GT, 
			LT, 
			EG, 
			Negativo, 
			ZERO, 
			Overflow
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
DIV div_(
			clock,
			reset,
			Aout, 
			Bout, 
			hidiv, 
			lodiv, 
			Div0
);
Multi multi(
			clock, 
			reset, 
			MULTcontrol, 
			Aout, 
			Bout, 
			himult, 
			lomult
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
			clock	,
			Wr		,
			MUX13out	,
			MemoryOut	,
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
			Bout, 
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



endmodule