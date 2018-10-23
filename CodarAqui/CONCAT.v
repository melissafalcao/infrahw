//FUNCIONANDO
module CONCAT (rs, rt, imediato, concatout);

//concaternar rs,rt e imediato
  input [4:0] rs;
  input [4:0] rt;
  input [15:0] imediato;
  output reg [25:0] concatout;

always @(*)
begin
  concatout[25:0] <= {rs[4:0], rt[4:0], imediato[15:0]};
end


endmodule
