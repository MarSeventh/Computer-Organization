`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:16:40 11/08/2022 
// Design Name: 
// Module Name:    FORWARD 
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
module FORWARD(
	 //forward input
	 input [31:0] OP_D_i,
	 input [31:0] OP_E_i,
	 input [31:0] OP_M_i,
	 input E_regWrite,
	 input M_regWrite,
	 input W_regWrite,
	 input [4:0] E_A3,
	 input [4:0] M_A3,
	 input [4:0] W_A3,
	 //forward signal
	 output [1:0] RD1_sel,
	 output [1:0] RD2_sel,
	 output [1:0] ALU_Asel,
	 output [1:0] ALU_Brdsel,
	 output DM_datasel,
	 output [1:0] RD2_E_osel,
	 //stop signal
	 output freeze
    );
wire [31:0] OP_D,OP_E,OP_M;
wire [1:0] Ex_Tnew,Me_Tnew,M_Tnew,Wr_Tnew,W_Tnew;
assign OP_D=OP_D_i;
assign OP_E=OP_E_i;
assign OP_M=OP_M_i;

wire R_D,I_D,Br_D,Ju_D;
wire R_E,I_E,Br_E,Ju_E;
wire R_M,I_M,Br_M,Ju_M;
//change
wire add_D,sub_D,ori_D,lw_D,sw_D,lui_D,beq_D,j_D,jal_D,jr_D;
wire add_E,sub_E,ori_E,lw_E,sw_E,lui_E,beq_E,j_E,jal_E,jr_E;
wire add_M,sub_M,ori_M,lw_M,sw_M,lui_M,beq_M,j_M,jal_M,jr_M;

assign add_D=(OP_D[31:26]==6'b000000 && OP_D[5:0]==6'b100000)? 1:0;
assign sub_D=(OP_D[31:26]==6'b000000 && OP_D[5:0]==6'b100010)? 1:0;
assign ori_D=(OP_D[31:26]==6'b001101)? 1:0;
assign lw_D=(OP_D[31:26]==6'b100011)? 1:0;
assign sw_D=(OP_D[31:26]==6'b101011)? 1:0;
assign lui_D=(OP_D[31:26]==6'b001111)? 1:0;
assign beq_D=(OP_D[31:26]==6'b000100)? 1:0;
assign j_D=(OP_D[31:26]==6'b000010)? 1:0;
assign jal_D=(OP_D[31:26]==6'b000011)? 1:0;
assign jr_D=(OP_D[31:26]==6'b000000 && OP_D[5:0]==6'b001000)? 1:0;
assign R_D=add_D|sub_D;
assign I_D=ori_D|lui_D;
assign Br_D=beq_D;
assign Ju_D=j_D|jal_D;



assign add_E=(OP_E[31:26]==6'b000000 && OP_E[5:0]==6'b100000)? 1:0;
assign sub_E=(OP_E[31:26]==6'b000000 && OP_E[5:0]==6'b100010)? 1:0;
assign ori_E=(OP_E[31:26]==6'b001101)? 1:0;
assign lw_E=(OP_E[31:26]==6'b100011)? 1:0;
assign sw_E=(OP_E[31:26]==6'b101011)? 1:0;
assign lui_E=(OP_E[31:26]==6'b001111)? 1:0;
assign beq_E=(OP_E[31:26]==6'b000100)? 1:0;
assign j_E=(OP_E[31:26]==6'b000010)? 1:0;
assign jal_E=(OP_E[31:26]==6'b000011)? 1:0;
assign jr_E=(OP_E[31:26]==6'b000000 && OP_E[5:0]==6'b001000)? 1:0;
assign R_E=add_E|sub_E;
assign I_E=ori_E|lui_E;
assign Br_E=beq_E;
assign Ju_E=j_E|jal_E;


assign add_M=(OP_M[31:26]==6'b000000 && OP_M[5:0]==6'b100000)? 1:0;
assign sub_M=(OP_M[31:26]==6'b000000 && OP_M[5:0]==6'b100010)? 1:0;
assign ori_M=(OP_M[31:26]==6'b001101)? 1:0;
assign lw_M=(OP_M[31:26]==6'b100011)? 1:0;
assign sw_M=(OP_M[31:26]==6'b101011)? 1:0;
assign lui_M=(OP_M[31:26]==6'b001111)? 1:0;
assign beq_M=(OP_M[31:26]==6'b000100)? 1:0;
assign j_M=(OP_M[31:26]==6'b000010)? 1:0;
assign jal_M=(OP_M[31:26]==6'b000011)? 1:0;
assign jr_M=(OP_M[31:26]==6'b000000 && OP_M[5:0]==6'b001000)? 1:0;
assign R_M=add_M|sub_M;
assign I_M=ori_M|lui_M;
assign Br_M=beq_M;
assign Ju_M=j_M|jal_M;


//stall     
wire [1:0] rs_Tuse,rt_Tuse;
wire rs_stall,rt_stall;
     //change
assign rs_Tuse=(Br_D|jr_D)?2'b00:
               (R_D|I_D|lw_D|sw_D)?2'b01:2'b11;
assign rt_Tuse=(Br_D)?2'b00:
               (R_D)?2'b01:
					(sw_D)?2'b10:2'b11;
	  //
assign rs_stall=((OP_D[25:21]==E_A3 && E_A3!=0 && rs_Tuse<Ex_Tnew && E_regWrite==1) || (OP_D[25:21]==M_A3 && M_A3!=0 && M_regWrite==1 && rs_Tuse<Me_Tnew))?1:0;
assign rt_stall=((OP_D[20:16]==E_A3 && E_A3!=0 && rt_Tuse<Ex_Tnew && E_regWrite==1) || (OP_D[20:16]==M_A3 && M_A3!=0 && M_regWrite==1 && rt_Tuse<Me_Tnew))?1:0;
assign freeze=rs_stall|rt_stall;

//calculate Execute_Tnew
                  
assign Ex_Tnew=(R_E|I_E)?2'b01:
               (lw_E|jal_E)?2'b10:2'b00;

//calculate Me_Tnew
                   
assign Me_Tnew=(lw_M|jal_M)?2'b01:2'b00;   
assign M_Tnew=Me_Tnew;	
 
//calculate Wr_Tnew

assign Wr_Tnew=2'b00;
assign W_Tnew=Wr_Tnew;

//forward controller
assign RD1_sel=(OP_D[25:21]==M_A3 && M_A3!=0 && M_regWrite==1 && M_Tnew==0)?2'b10:
               (OP_D[25:21]==W_A3 && W_A3!=0 && W_regWrite==1)?2'b01:2'b00;              
assign RD2_sel=(OP_D[20:16]==M_A3 && M_A3!=0 && M_regWrite==1 && M_Tnew==0)?2'b10:
               (OP_D[20:16]==W_A3 && W_A3!=0 && W_regWrite==1)?2'b01:2'b00;             
assign ALU_Asel=(OP_E[25:21]==M_A3 && M_A3!=0 && M_Tnew==0 && M_regWrite==1)?2'b10:
                (OP_E[25:21]==W_A3 && W_A3!=0 && W_Tnew==0 && W_regWrite==1)?2'b01:2'b00;
assign ALU_Brdsel=(OP_E[20:16]==M_A3 && M_A3!=0 && M_Tnew==0 && M_regWrite==1)?2'b10:
                  (OP_E[20:16]==W_A3 && W_A3!=0 && W_Tnew==0 && W_regWrite==1)?2'b01:2'b00;
assign DM_datasel=(OP_M[20:16]==W_A3 && W_A3!=0 && W_Tnew==0 && W_regWrite==1)?1:0;
assign RD2_E_osel=(OP_E[20:16]==M_A3 && M_A3!=0 && M_Tnew==0 && M_regWrite==1)?2'b10:
                  (OP_E[20:16]==W_A3 && W_A3!=0 && W_Tnew==0 && W_regWrite==1)?2'b01:2'b00;
endmodule
