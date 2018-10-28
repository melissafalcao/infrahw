module UnitExtend(LT, LT32);

	input LT; 
	output reg[31:0] LT32; 
//Estende LT com 1 bit para 32 bits
always @(*)
begin  
    LT32 [31:0] <= {31'd0, LT};
end
endmodule
