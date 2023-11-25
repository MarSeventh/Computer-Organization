`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:20:59 11/07/2022 
// Design Name: 
// Module Name:    Decode 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Decode(
    input clk,
    input reset,
	 //pipline
    input [31:0] OP_D_i,//from Fetch
    input [31:0] PCn_D_i,
    input regWrite_D_i,//from Write
    input [4:0] A3_D_i,
    input [31:0] WD_D_i,
	 input [31:0] PC_GRF_W,
	 //forward
    input [1:0] RD1_sel,
    input [1:0] RD2_sel,
	 input [31:0] M_result,//new
	 input [31:0] W_forward,//new
	 //Controller
    input [1:0] A3_D_osel,
    input extsel,
    input [2:0] Basel,
	 input GRF_WE,
	 //output
    output [31:0] Badder_D_o,
    output [31:0] RD1_D_o,
    output [31:0] RD2_D_o,
    output [4:0] A1_D_o,
    output [4:0] A2_D_o,
    output [4:0] A3_D_o,
    output [31:0] extimm_D_o,
    output [31:0] PCn_D_o,
    output regWrite_D_o,
	 output [31:0] OP_D_o
    );
wire [4:0] A1,A2;
assign A1=OP_D_i[25:21];
assign A2=OP_D_i[20:16];
wire [31:0] PC;
assign PC=PCn_D_i-4;
//pipeline
assign A1_D_o=A1;
assign A2_D_o=A2;
assign A3_D_o=(A3_D_osel==2'b10)?31:
              (A3_D_osel==2'b01)?OP_D_i[15:11]:OP_D_i[20:16];
assign PCn_D_o=PCn_D_i;	
assign regWrite_D_o=GRF_WE;	
assign OP_D_o=OP_D_i;		  
//GRF
reg [31:0] grf [0:31]; //grf[32]
integer i;
always @(posedge clk) begin
       if(reset) begin
		        for(i=0;i<32;i=i+1) grf[i]=0;
		 end
		 else begin
		        if(regWrite_D_i==1 && (A3_D_i>=1) && (A3_D_i<=31)) begin
				  $display ("%d@%h: $%d <= %h",$time, PC_GRF_W, A3_D_i, WD_D_i);
				  grf[A3_D_i]<=WD_D_i;
				  end
		 end
end
//forward
assign RD1_D_o=(RD1_sel==2'b10)?M_result:
               (RD1_sel==2'b01)?W_forward:grf[A1];          
assign RD2_D_o=(RD2_sel==2'b10)?M_result:
               (RD2_sel==2'b01)?W_forward:grf[A2];
//cmp
wire [31:0] cmp1,cmp2;
assign cmp1=RD1_D_o;
assign cmp2=RD2_D_o;
wire equ,bgt,blt,bge,ble;
assign equ=(cmp1==cmp2)? 1:0;
assign bgt=(cmp1>cmp2)? 1:0;
assign blt=(cmp1<cmp2)? 1:0;
assign bge=(cmp1>=cmp2)? 1:0;
assign ble=(cmp1<=cmp2)? 1:0;
//ext 1:zero 0:sign
assign extimm_D_o=(extsel==1)? OP_D_i[15:0]:{{16{OP_D_i[15]}},OP_D_i[15:0]};
//Badder
assign Badder_D_o=(Basel==3'b000)? PCn_D_i+4:
             (Basel==3'b001 && equ==1)? PCn_D_i+({{16{OP_D_i[15]}},OP_D_i[15:0]}<<2):
             (Basel==3'b001 && equ!=1)? PCn_D_i+4:
             (Basel==3'b010)? {PC[31:28],OP_D_i[25:0],{2{1'b0}}}:
             (Basel==3'b011)? RD1_D_o:PCn_D_i+4;				 


endmodule
