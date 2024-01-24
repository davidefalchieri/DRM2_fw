///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: epcs_tx_intf.v
// File history:
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//
// Description: 
//
// <Description here>
//
// Targeted device: <Family::IGLOO2> <Die::M2GL010T> <Package::400 VF>
// Author: <Name>
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module epcs_tx_intf( clk, rstn, txvali, txdin, txvalo, txdout );
input clk, rstn;
input [19:0] txdin;
input txvali;
output reg txvalo;
output reg [19:0] txdout;

reg [19:0] txdin_p;
reg txval_p;

always @(posedge clk or negedge rstn)
  if (!rstn)
  begin
    txdin_p <= 20'd0;    
    txval_p <= 1'b0;
  end
  else
  begin
   txdin_p <= txdin;
   txval_p <= txvali;
  end

always @(posedge clk or negedge rstn)
  if (!rstn)
  begin
    txdout <= 20'd0;    
    txvalo <= 1'b0;
  end
  else
  begin
   txdout <= txdin_p;
   txvalo <= txval_p;
  end

   
endmodule

