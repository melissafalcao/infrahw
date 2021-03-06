module CPU (/*nomes de todos entradas e saidas da cpu aqui*/
	input wire clock, input wire reset
);


//declarar tudo

wire [31:0]ALUOUT;
wire [31:0]Aout;
wire [31:0]Bout;
wire [31:0]EPCout;
wire [31:0]HIout;
wire [31:0]LOout;
wire [31:0]LSout;
wire [31:0]LT32;
wire [31:0]MUX10out;
wire [31:0]MUX13out;
wire [31:0]MDRout;
wire [31:0]MUX14out;
wire [31:0]MUX1out;
wire [31:0]MUX2out;
wire [31:0]MUX3out;
wire [31:0]MUX4out;
wire [31:0]MUX5out;
wire [31:0]MUX6out;
wire [31:0]MUX7out;
wire [31:0]MUX8out;
wire [31:0]MemoryOut;
wire [31:0]ReadData1;
wire [31:0]PCout;
wire [31:0]ReadData2;
wire [31:0]SSout;
wire [31:0]SLAC;
wire [31:0]Shiftout;
wire [31:0]ULAout;
wire [31:0]UlaResult;
wire [31:0]ext16_32;
wire [31:0]ext16_32_left_shifted;
wire [31:0]ext25_32;
wire [31:0]hidiv;
wire [31:0]himult;
wire [31:0]lodiv;
wire [31:0]lomult;
wire [31:0]rs;
wire [31:0]rt;

wire [25:0]concatout;

wire [15:0]imediato;

wire [5:0]opcode;

wire [4:0]MUX9out;

wire [2:0]ULAb;
wire [2:0]ULAcontrol;
wire [2:0] WriteData;
wire [2:0]MemoryAdress;
wire [2:0]PCmux;
wire [2:0]Shifter;

wire [1:0]LS;
wire [1:0]MemoryData;
wire [1:0]SS;
wire [1:0]ShifterMux;
wire [1:0]ULAa;
wire [1:0]WriteReg;

wire Div0;
wire EG;
wire EPC;
wire GT;
wire HILOWrite;
wire IRwrite;
wire LT;
wire Load;//para A e B
wire MDR;
wire MDcontrol;
wire MULTcontrol;
wire DIVcontrol;
wire MUX14;
wire Overflow;
wire Negativo;
wire PCwrite;
wire RegWrite;
wire ZERO;
wire wr;

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
			Load,
			ULAcontrol,
			ALUOUT, 
			PCmux, 
			EPC, 
			MUX14, 
			MDcontrol,
			MULTcontrol,
			DIVcontrol, 
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
MULT multi(
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
Instr_Reg IR_(//ok
			clock,
			reset,
			IRwrite,
			MemoryOut,
			opcode,
			rs,
			rt,
			imediato	
);
LoadSize LS_(//ok
			LS, 
			MDRout, 
			LSout
);
Memoria mem_(//ok
			MUX1out	,
			clock	,
			wr		,
			MUX13out	,
			MemoryOut
);
MUX1 mux1(//ok
			MemoryAdress, 
			PCout, 
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
MUX7eMUX8 mux78(//ajeitar himult e lomult apÃ³s adicionar mult div caso necessario
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
			PCout, 
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
StoreSize SS_(//ok
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
			LT		
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
Registrador EPC_(//ok
			clock		,
			reset	,
			EPC	,
			MUX14out ,
			EPCout	
);
Registrador ALUout_(//ok
			clock		,
			reset	,
			ALUOUT	,
			UlaResult ,
			ULAout	
);
Registrador MDR_(//ok
			clock		,
			reset	,
			MDR	,
			MemoryOut ,
			MDRout	
);



endmodule