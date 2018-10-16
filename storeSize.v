module storeSize(SS, MDRout, B, SSout);

	input [1:0] SS; //olhar quantos bits sao 2 ou 1
	input [31:0] B, MDRout;
	output [31:0] SSout;

		//ajeitar
	assign SSout = ((!SS) ? { MDRout[31:8], B[7:0] } : { MDRout[31:16], B[15:0] });

endmodule
