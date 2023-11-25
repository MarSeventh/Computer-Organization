`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:20 11/07/2022 
// Design Name: 
// Module Name:    Execute 
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
module Execute(
    input clk,
	 input reset,
	 input Req,
//pipline
    input Delay_E_i,
	 input [4:0] ExcCode_E_i,
    input [4:0] A1_E_i,
    input [4:0] A2_E_i,
    input [31:0] RD1_E_i,
    input [31:0] RD2_E_i,
    input [31:0] PCn_E_i,
    input [31:0] extimm_E_i,
    input regWrite_E_i,
    input [4:0] A3_E_i,
	 input [31:0] OP_E_i,
//Controller
    input [4:0] Ex_ExcCode,
    input [3:0] ALU_OP,
	 input ALU_Bsel,
//forward
    input [1:0] ALU_Asel,
	 input [1:0] ALU_Brdsel,
	 input [31:0] M_result,
	 input [31:0] W_forward,
	 input [1:0] RD2_E_osel,//
//MD
    input [2:0] md_op,
	 input start,
	 input mdsel,
	 input losel,
	 input loWE,
	 input hisel,
	 input hiWE,
//output
    //give Controller
	 output overflowa,
	 output overflows,
	 output [31:0] Ex_addr,
    //MD
    output busy,
	 output [31:0] md_E_o,
	 //
	 output Delay_E_o,
	 output [4:0] ExcCode_E_o,
    output [31:0] result_E_o,
	 output [4:0] A2_E_o,
	 output [31:0] RD2_E_o,
	 output [31:0] PCn_E_o,
	 output regWrite_E_o,
	 output [4:0] A3_E_o,
	 output [31:0] OP_E_o
    );
	 wire [31:0] A,B,Brd;
//selsect A
assign A=(ALU_Asel==2'b10)?M_result:
         (ALU_Asel==2'b01)?W_forward:RD1_E_i;
//select B
assign Brd=(ALU_Brdsel==2'b10)?M_result:
           (ALU_Brdsel==2'b01)?W_forward:RD2_E_i;
assign B=(ALU_Bsel==0)?Brd:extimm_E_i;
//ALU
assign result_E_o=(ALU_OP==4'b0000)? A+B:
                  (ALU_OP==4'b0001)? A-B:
				      (ALU_OP==4'b0010)? A|B:
				      (ALU_OP==4'b0100)? B<<16:
						(ALU_OP==4'b0101)? A&B:
						(ALU_OP==4'b0110 && $signed(A)<$signed(B))?1:
						(ALU_OP==4'b0111 && A<B)?1:0;
//MD
wire [63:0] prod;
wire [31:0] loin,hiin,loout,hiout;
reg [31:0] LO,HI;
reg [3:0] count;
initial begin
     count<=0;
	  LO<=0;
	  HI<=0;
end
assign prod=(md_op==3'b000)?$signed({{32{A[31]}},A[31:0]}*{{32{B[31]}},B[31:0]}):
            (md_op==3'b001)?A*B:
				(md_op==3'b010 && B!=0)?{$signed($signed(A)%$signed(B)),$signed($signed(A)/$signed(B))}:
				(md_op==3'b011 && B!=0)?{A%B,A/B}:0;
assign loin=(losel==1)?A:prod[31:0];
assign hiin=(hisel==1)?A:prod[63:32];
assign busy=(count==0)?0:1;
always @(posedge clk)begin
      if(count>0) count<=count-1;
end
always @(posedge clk) begin
      if(reset) LO<=0;
		else if(Req) LO<=LO;
		else if(start && (md_op==3'b000 || md_op==3'b001)) begin
		     LO<=loin;
			  count<=4'd5;
		end
		else if(start && (md_op==3'b010 || md_op==3'b011)) begin
		     LO<=loin;
			  count<=4'd10;
		end
		else if(loWE) begin
		     LO<=loin;
		end
end	
always @(posedge clk)begin
      if(reset) HI<=0;
		else if(Req) HI<=HI;
		else if(start && (md_op==3'b000 || md_op==3'b001)) begin
		     HI<=hiin;
			  count<=4'd5;
		end
		else if(start && (md_op==3'b010 || md_op==3'b011)) begin
		     HI<=hiin;
			  count<=4'd10;
		end
		else if(hiWE) begin
		     HI<=hiin;
		end
end	
assign loout=(busy)?0:LO;
assign hiout=(busy)?0:HI;
assign md_E_o=(mdsel)?hiout:loout;		
//pipline
assign A2_E_o=A2_E_i;
assign RD2_E_o=(RD2_E_osel==2'b10)?M_result:
               (RD2_E_osel==2'b01)?W_forward:RD2_E_i;
assign PCn_E_o=PCn_E_i;
assign regWrite_E_o=regWrite_E_i;
assign A3_E_o=A3_E_i;
assign OP_E_o=OP_E_i;
assign Delay_E_o=Delay_E_i;
assign ExcCode_E_o=(|ExcCode_E_i)? ExcCode_E_i:Ex_ExcCode;
//judge ExcCode
assign Ex_addr=result_E_o;
wire [32:0] tempa,temps;
assign tempa={A[31],A}+{B[31],B};
assign temps={A[31],A}-{B[31],B};
assign overflowa=(tempa[32]!=tempa[31])? 1:0;
assign overflows=(temps[32]!=temps[31])? 1:0;
endmodule
