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
	 input busy,
	 input start,
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
wire [5:0] OP_D_op,OP_D_func,OP_E_op,OP_E_func,OP_M_op,OP_M_func;
wire [1:0] Ex_Tnew,Me_Tnew,M_Tnew,Wr_Tnew,W_Tnew;
assign OP_D_op=OP_D[31:26];
assign OP_D_func=OP_D[5:0];
assign OP_D=OP_D_i;
assign OP_E_op=OP_E[31:26];
assign OP_E_func=OP_E[5:0];
assign OP_E=OP_E_i;
assign OP_M_op=OP_M[31:26];
assign OP_M_func=OP_M[5:0];
assign OP_M=OP_M_i;


//add instructions
wire R_D,I_D,Br_D,Ju_D,load_D,upload_D,md_D;//sorted_D
wire beq_D,bne_D,j_D,jal_D,jr_D;
wire lb_D,lh_D,sb_D,sh_D,lw_D,sw_D;
wire add_D,sub_D,and_D,or_D,slt_D,sltu_D;
wire ori_D,lui_D,addi_D,andi_D;
wire mult_D,multu_D,div_D,divu_D,mflo_D,mfhi_D,mtlo_D,mthi_D;

wire R_E,I_E,Br_E,Ju_E,load_E,upload_E,md_E;//sorted_E
wire beq_E,bne_E,j_E,jal_E,jr_E;
wire lb_E,lh_E,sb_E,sh_E,lw_E,sw_E;
wire add_E,sub_E,and_E,or_E,slt_E,sltu_E;
wire ori_E,lui_E,addi_E,andi_E;
wire mult_E,multu_E,div_E,divu_E,mflo_E,mfhi_E,mtlo_E,mthi_E;

wire R_M,I_M,Br_M,Ju_M,load_M,upload_M;//sorted_M
wire beq_M,bne_M,j_M,jal_M,jr_M;
wire lh_M,lb_M,sb_M,sh_M,lw_M,sw_M;
wire add_M,sub_M,and_M,or_M,slt_M,sltu_M;
wire ori_M,lui_M,addi_M,andi_M;

//decode instructions
      //D
assign add_D=(OP_D_op==6'b000000 && OP_D_func==6'b100000)? 1:0;
assign sub_D=(OP_D_op==6'b000000 && OP_D_func==6'b100010)? 1:0;
assign ori_D=(OP_D_op==6'b001101)? 1:0;
assign lw_D=(OP_D_op==6'b100011)? 1:0;
assign sw_D=(OP_D_op==6'b101011)? 1:0;
assign lui_D=(OP_D_op==6'b001111)? 1:0;
assign beq_D=(OP_D_op==6'b000100)? 1:0;
assign j_D=(OP_D_op==6'b000010)? 1:0;
assign jal_D=(OP_D_op==6'b000011)? 1:0;
assign jr_D=(OP_D_op==6'b000000 && OP_D_func==6'b001000)? 1:0;
assign lb_D=(OP_D_op==6'b100000)?1:0;
assign lh_D=(OP_D_op==6'b100001)?1:0;
assign sb_D=(OP_D_op==6'b101000)?1:0;
assign sh_D=(OP_D_op==6'b101001)?1:0;
assign and_D=(OP_D_op==6'b000000 && OP_D_func==6'b100100)?1:0;
assign or_D=(OP_D_op==6'b000000 && OP_D_func==6'b100101)?1:0;
assign slt_D=(OP_D_op==6'b000000 && OP_D_func==6'b101010)?1:0;
assign sltu_D=(OP_D_op==6'b000000 && OP_D_func==6'b101011)?1:0;
assign addi_D=(OP_D_op==6'b001000)?1:0;
assign andi_D=(OP_D_op==6'b001100)?1:0;
assign bne_D=(OP_D_op==6'b000101)?1:0;
assign mult_D=(OP_D_op==6'b000000 && OP_D_func==6'b011000)?1:0;
assign multu_D=(OP_D_op==6'b000000 && OP_D_func==6'b011001)?1:0;
assign div_D=(OP_D_op==6'b000000 && OP_D_func==6'b011010)?1:0;
assign divu_D=(OP_D_op==6'b000000 && OP_D_func==6'b011011)?1:0;
assign mfhi_D=(OP_D_op==6'b000000 && OP_D_func==6'b010000)?1:0;
assign mflo_D=(OP_D_op==6'b000000 && OP_D_func==6'b010010)?1:0;
assign mthi_D=(OP_D_op==6'b000000 && OP_D_func==6'b010001)?1:0;
assign mtlo_D=(OP_D_op==6'b000000 && OP_D_func==6'b010011)?1:0;


assign md_D=mult_D|multu_D|div_D|divu_D|mflo_D|mfhi_D|mtlo_D|mthi_D;
assign R_D=add_D|sub_D|and_D|or_D|slt_D|sltu_D;
assign I_D=ori_D|addi_D|andi_D;
assign Br_D=beq_D|bne_D;
assign Ju_D=j_D|jal_D;
assign load_D=lw_D|lh_D|lb_D;
assign upload_D=sw_D|sh_D|sb_D;

      //E
assign add_E=(OP_E_op==6'b000000 && OP_E_func==6'b100000)? 1:0;
assign sub_E=(OP_E_op==6'b000000 && OP_E_func==6'b100010)? 1:0;
assign ori_E=(OP_E_op==6'b001101)? 1:0;
assign lw_E=(OP_E_op==6'b100011)? 1:0;
assign sw_E=(OP_E_op==6'b101011)? 1:0;
assign lui_E=(OP_E_op==6'b001111)? 1:0;
assign beq_E=(OP_E_op==6'b000100)? 1:0;
assign j_E=(OP_E_op==6'b000010)? 1:0;
assign jal_E=(OP_E_op==6'b000011)? 1:0;
assign jr_E=(OP_E_op==6'b000000 && OP_E_func==6'b001000)? 1:0;
assign lb_E=(OP_E_op==6'b100000)?1:0;
assign lh_E=(OP_E_op==6'b100001)?1:0;
assign sb_E=(OP_E_op==6'b101000)?1:0;
assign sh_E=(OP_E_op==6'b101001)?1:0;
assign and_E=(OP_E_op==6'b000000 && OP_E_func==6'b100100)?1:0;
assign or_E=(OP_E_op==6'b000000 && OP_E_func==6'b100101)?1:0;
assign slt_E=(OP_E_op==6'b000000 && OP_E_func==6'b101010)?1:0;
assign sltu_E=(OP_E_op==6'b000000 && OP_E_func==6'b101011)?1:0;
assign addi_E=(OP_E_op==6'b001000)?1:0;
assign andi_E=(OP_E_op==6'b001100)?1:0;
assign bne_E=(OP_E_op==6'b000101)?1:0;
assign mult_E=(OP_E_op==6'b000000 && OP_E_func==6'b011000)?1:0;
assign multu_E=(OP_E_op==6'b000000 && OP_E_func==6'b011001)?1:0;
assign div_E=(OP_E_op==6'b000000 && OP_E_func==6'b011010)?1:0;
assign divu_E=(OP_E_op==6'b000000 && OP_E_func==6'b011011)?1:0;
assign mfhi_E=(OP_E_op==6'b000000 && OP_E_func==6'b010000)?1:0;
assign mflo_E=(OP_E_op==6'b000000 && OP_E_func==6'b010010)?1:0;
assign mthi_E=(OP_E_op==6'b000000 && OP_E_func==6'b010001)?1:0;
assign mtlo_E=(OP_E_op==6'b000000 && OP_E_func==6'b010011)?1:0;

assign md_E=mult_E|multu_E|div_E|divu_E|mflo_E|mfhi_E|mtlo_E|mthi_E;
assign R_E=add_E|sub_E|and_E|or_E|slt_E|sltu_E;
assign I_E=ori_E|andi_E|addi_E;
assign Br_E=beq_E|bne_E;
assign Ju_E=j_E|jal_E;
assign load_E=lw_E|lb_E|lh_E;
assign upload_E=sw_E|sh_E|sb_E;

      //M
assign add_M=(OP_M_op==6'b000000 && OP_M_func==6'b100000)? 1:0;
assign sub_M=(OP_M_op==6'b000000 && OP_M_func==6'b100010)? 1:0;
assign ori_M=(OP_M_op==6'b001101)? 1:0;
assign lw_M=(OP_M_op==6'b100011)? 1:0;
assign sw_M=(OP_M_op==6'b101011)? 1:0;
assign lui_M=(OP_M_op==6'b001111)? 1:0;
assign beq_M=(OP_M_op==6'b000100)? 1:0;
assign j_M=(OP_M_op==6'b000010)? 1:0;
assign jal_M=(OP_M_op==6'b000011)? 1:0;
assign jr_M=(OP_M_op==6'b000000 && OP_M_func==6'b001000)? 1:0;
assign lb_M=(OP_M_op==6'b100000)?1:0;
assign lh_M=(OP_M_op==6'b100001)?1:0;
assign sb_M=(OP_M_op==6'b101000)?1:0;
assign sh_M=(OP_M_op==6'b101001)?1:0;
assign and_M=(OP_M_op==6'b000000 && OP_M_func==6'b100100)?1:0;
assign or_M=(OP_M_op==6'b000000 && OP_M_func==6'b100101)?1:0;
assign slt_M=(OP_M_op==6'b000000 && OP_M_func==6'b101010)?1:0;
assign sltu_M=(OP_M_op==6'b000000 && OP_M_func==6'b101011)?1:0;
assign addi_M=(OP_M_op==6'b001000)?1:0;
assign andi_M=(OP_M_op==6'b001100)?1:0;
assign bne_M=(OP_M_op==6'b000101)? 1:0;

assign R_M=add_M|sub_M|and_M|or_M|slt_M|sltu_M;
assign I_M=ori_M|andi_M|addi_M;
assign Br_M=beq_M|bne_M;
assign Ju_M=j_M|jal_M;
assign load_M=lw_M|lh_M|lb_M;
assign upload_M=sw_M|sh_M|sb_M;
//stall
wire [1:0] rs_Tuse,rt_Tuse;
wire rs_stall,rt_stall;
      //change
assign rs_Tuse=(Br_D|jr_D)?2'b00:
               (R_D|I_D|load_D|upload_D|mult_D|multu_D|div_D|divu_D|mtlo_D|mthi_D)?2'b01:2'b11;
assign rt_Tuse=(Br_D)?2'b00:
               (R_D|mult_D|multu_D|div_D|divu_D)?2'b01:
					(upload_D)?2'b10:2'b11;
		//
assign rs_stall=((OP_D[25:21]==E_A3 && E_A3!=0 && rs_Tuse<Ex_Tnew && E_regWrite==1) || (OP_D[25:21]==M_A3 && M_A3!=0 && M_regWrite==1 && rs_Tuse<Me_Tnew))?1:0;
assign rt_stall=((OP_D[20:16]==E_A3 && E_A3!=0 && rt_Tuse<Ex_Tnew && E_regWrite==1) || (OP_D[20:16]==M_A3 && M_A3!=0 && M_regWrite==1 && rt_Tuse<Me_Tnew))?1:0;
assign freeze=rs_stall|rt_stall|((start|busy)&md_D);
//calculate Execute_Tnew

assign Ex_Tnew=(R_E|I_E|lui_E|mflo_E|mfhi_E)?2'b01:
               (load_E|jal_E)?2'b10:2'b00;

//calculate Me_Tnew
                
assign Me_Tnew=(load_M|jal_M)?2'b01:2'b00;   
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
