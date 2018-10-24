module MULTI(a, b, hi, lo,i);

	input [31:0] a, b;  //fazer div e multi aqui jogando a saida no hi e lo
	output [31:0] hi, lo; 
  output reg i;


    interger multiplicando[64:0];
    interger multiplicador[64:0];

    initial begin
        multiplicando[64:0] = {a[31:0],32'd0,1'd0};
        multiplicador[64:0] = {32'd0,b[31:0],1'd0};
        
    end
    
    
      for (i = 0; i<32 ; i+1) begin
        if(multiplicador[1]==0 && multiplicador[0]==0)begin
          multiplicador = (multiplicador>>>1);
        end
        else if(multiplicador[1]==1 && multiplicador[0]==1)begin
          multiplicador = (b>>>multiplicador);
        end
        else if(multiplicador[1]==0 && multiplicador[0]==1)begin
          multiplicador = multiplicador + multiplicando;
          multiplicador = (multiplicador>>>1);
        end
        else if(multiplicador[1]==1 && multiplicador[0]==0) begin
          multiplicador = multiplicador - multiplicando;
          multiplicador = (multiplicador>>>1);
        end
      end
      hi = multiplicador[64:33];
      lo = multiplicador[32:1];
    


endmodule