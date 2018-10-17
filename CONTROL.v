module CONTROL(opcode, funct, clock, reset,

				PCwrite, MemoryAdress, MemoryData, wr, SS, MDR, LS, WriteData, IRwrite,
				ShifterMux, Shifter, SighExt, WriteReg, RegWrite, ULAa, ULAb, ULAcontrol,
				ALUOUT, PCmux, EPC, MUX14, MDcontrol, Div0, HILOWrite, 
				);
				
		input [5:0] opcode;
		input clock, reset
		output PCwrite, MemoryAdress, MemoryData, wr, SS, MDR, LS, WriteData, IRwrite,
				ShifterMux, Shifter, SighExt, WriteReg, RegWrite, ULAa, ULAb, ULAcontrol,
				ALUOUT, PCmux, EPC, MUX14, MDcontrol, Div0, HILOWrite;
				//
endmodule		