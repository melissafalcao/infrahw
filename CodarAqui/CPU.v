module CPU (/*nomes dos fios do circuito aqui*/);

CONTROL control_(
    opcode, funct, clock, reset,

				PCwrite, MemoryAdress, MemoryData, wr, SS, MDR, LS, WriteData, IRwrite,
				ShifterMux, Shifter, WriteReg, RegWrite, ULAa, ULAb, ULAcontrol,
				ALUOUT, PCmux, EPC, MUX14, MDcontrol, Div0, HILOWrite, GT, LT, EG, N, ZERO, O
);

CONCAT concat_(
    rs, rt, imediato, concatout
);
Banco_reg Bancoreg_(

);
DIV div_(

);
Instr_Reg IR(

);
LoadSize LS(

);
Memoria mem(

);
Multi multi(

);
MUX1 mux1(

);
MUX2 mux2(

);
MUX3 mux3(

);
MUX4 mux4(

);
MUX5 mux5(

);
MUX6 mux6(

);
MUX7eMUX8 mux78(

);
MUX9eMUX10 mux910(

);
MUX13 mux13(

);
MUX14 mux14(

);
RegDesloc desloc(

);
ShiftLeft2 SL2(

);
ShiftLeft2Concat shiftconcat(

);
SignExtend signextend(

);
SignExtend16_32 signext16_32(

);
StoreSize SS(

);
ula32 ula(

);
UnitExtend UE(

);



endmodule