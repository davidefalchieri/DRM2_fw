///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: epcs_rx_intf.v
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
module epcs_rx_intf( clk, rstn, rxdin, rxvali, rxdout, rxvalo );
input clk;
input rstn;
input [19:0] rxdin;
input rxvali;
output reg [19:0] rxdout;
output reg rxvalo;

reg [19:0] rxdin_l, rxdin_l2;
reg rxval_l, rxval_l2;


always @(negedge clk or negedge rstn)
  if (!rstn)
  begin
    rxdin_l <= 20'd0;    
    rxval_l <= 1'b0;
  end
  else
  begin
   rxdin_l <= rxdin;
   rxval_l <= rxvali;
  end

always @(posedge clk or negedge rstn)
  if (!rstn)
  begin
    rxdin_l2 <= 20'd0;    
    rxval_l2 <= 1'b0;
  end
  else
  begin
   rxdin_l2 <= rxdin_l;
   rxval_l2 <= rxval_l;
  end

always @(posedge clk or negedge rstn)
  if (!rstn)
  begin
    rxdout <= 20'd0;    
    rxvalo <= 1'b0;
  end
  else
  begin
   rxdout <= rxdin_l2;
   rxvalo <= rxval_l2;
  end


   
endmodule

