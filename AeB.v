module AeB(ReadData1, ReadData2, A, B);

//bloco para salvar a e b 
	input [31:0]  ReadData1, ReadData2; 
	output reg [31:0]  A, B;
	
	A <= ReadData1;
	B <= ReadData2;



endmodule
