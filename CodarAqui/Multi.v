module Multi(a, b, A, B, hi, lo,i);

	input [31:0] a, b;  //fazer div e multi aqui jogando a saida no hi e lo
	output reg [31:0] hi, lo; 
	output reg i;


    output reg [64:0] A;
	output reg [64:0] B;

    initial begin
        A[64:0] <= {a[31:0],32'd0,1'd0};
        B[64:0] <= {32'd0,b[31:0],1'd0};
        
    end
   
  always @(*) begin
    
      for (i = 0; i<32 ; i=i+1) begin
        if(B[1]==0 && B[0]==0)begin
          B = (B>>>1);
        end
        else if(B[1]==1 && B[0]==1)begin
          B = (b>>>B);
        end
        else if(B[1]==0 && B[0]==1)begin
          B = B + A;
          B = (B>>>1);
        end
        else if(B[1]==1 && B[0]==0) begin
          B = B - A;
          B = (B>>>1);
        end
      end
      hi = B[64:33];
      lo = B[32:1];
end


endmodule
