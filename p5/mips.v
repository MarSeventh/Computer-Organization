`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:42 11/06/2022 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
wire [31:0] memory_W_i,result_W_i,PCn8_W_i,PC_GRF_W,W_forward;
wire regWrite_W_i,W_regWrite;
wire [4:0] A3_W_i,W_A3;
wire [31:0] memory_M_o,result_M_o;
wire regWrite_M_o;
wire [4:0] A3_M_o;
wire [31:0] result_M_i,RD2_M_i;
wire [4:0] A2_M_i,A3_M_i,M_A3;
wire regWrite_M_i,M_regWrite,DM_WE,DM_RE;
wire [31:0] M_result,W_memory,result_E_o,RD2_E_o;
wire [4:0] A2_E_o,A3_E_o;
wire regWrite_E_o;
wire [1:0] GRF_WDsel;
wire [31:0] OP_F_o,OP_D_i,OP_D_o,OP_E_i,OP_E_o,OP_M_i,OP_M_o,OP_W_i;
wire E_regWrite,DM_datasel,PCsel,extsel,GRF_WE,ALU_Bsel;
wire regWrite_D_i,regWrite_D_o,regWrite_E_i;
wire [4:0] A3_D_i,A1_D_o,A2_D_o,A3_D_o,A1_E_i,A2_E_i,A3_E_i,E_A3;
wire [1:0] ALU_Asel,ALU_Brdsel,A3_D_osel,RD1_sel,RD2_sel,RD2_E_osel;
wire [2:0] Basel,ALU_OP;
wire freeze;
wire [31:0] Badder_D_o,RD1_D_o,RD2_D_o,extimm_D_o,RD1_E_i,RD2_E_i,extimm_E_i;
wire [31:0] PCn_F_o,PCn_D_i,PCn_D_o,PCn_E_i,PCn_E_o,PCn_M_i,PCn_M_o,PCn_W_i;
wire [31:0] WD_D_i;
FORWARD forward (
    .OP_D_i(OP_D_i), //
    .OP_E_i(OP_E_i), //
    .OP_M_i(OP_M_i), //
    .E_regWrite(E_regWrite),// 
    .M_regWrite(M_regWrite),// 
    .W_regWrite(W_regWrite),// 
    .E_A3(E_A3), //
    .M_A3(M_A3), //
    .W_A3(W_A3), //
    .RD1_sel(RD1_sel),// 
    .RD2_sel(RD2_sel),// 
    .ALU_Asel(ALU_Asel),// 
    .ALU_Brdsel(ALU_Brdsel),// 
    .DM_datasel(DM_datasel),//
    .RD2_E_osel(RD2_E_osel),	 
    .freeze(freeze)//
    );	 
	 
	 
	 
IFU ifu (
    .clk(clk), //
    .reset(reset), //
    .freeze(freeze), //
    .PCsel(PCsel),// 
    .Badder_D_o(Badder_D_o),// 
    .OP_F_o(OP_F_o), //
    .PCn_F_o(PCn_F_o)//
    );

D d (
    .clk(clk), //
    .reset(reset), //
	 .freeze(freeze),
    .OP_F_o(OP_F_o),// 
    .PCn_F_o(PCn_F_o),// 
    .OP_D_i(OP_D_i), //
    .PCn_D_i(PCn_D_i)//
    );
Controller ctrl_Decode (
    .IMD(OP_D_i), //
    .PCsel(PCsel),// 
    .A3_D_osel(A3_D_osel),// 
    .extsel(extsel),// 
    .Basel(Basel),// 
    .GRF_WE(GRF_WE)//
    );
Decode decode (
    .clk(clk), //
    .reset(reset), //
	 .PC_GRF_W(PC_GRF_W),//
    .OP_D_i(OP_D_i), //
    .PCn_D_i(PCn_D_i),// 
    .regWrite_D_i(regWrite_D_i),// 
    .A3_D_i(A3_D_i),// 
    .WD_D_i(WD_D_i),// 
    .RD1_sel(RD1_sel),//	 
    .RD2_sel(RD2_sel),//
    .M_result(M_result),
    .W_forward(W_forward),	 
    .A3_D_osel(A3_D_osel),// 
    .extsel(extsel),// 
    .Basel(Basel), //
    .GRF_WE(GRF_WE), //
    .Badder_D_o(Badder_D_o), //
    .RD1_D_o(RD1_D_o),// 
    .RD2_D_o(RD2_D_o), //
    .A1_D_o(A1_D_o),// 
    .A2_D_o(A2_D_o),// 
    .A3_D_o(A3_D_o), //
    .extimm_D_o(extimm_D_o),// 
    .PCn_D_o(PCn_D_o),// 
    .regWrite_D_o(regWrite_D_o),// 
    .OP_D_o(OP_D_o)//
    );
	 
E e (
    .clk(clk), //
    .reset(reset), //
    .freeze(freeze),//	 
    .A1_D_o(A1_D_o),// 
    .A2_D_o(A2_D_o), //
    .RD1_D_o(RD1_D_o),// 
    .RD2_D_o(RD2_D_o), //
    .PCn_D_o(PCn_D_o), //
    .extimm_D_o(extimm_D_o), //
    .regWrite_D_o(regWrite_D_o),// 
    .A3_D_o(A3_D_o),// 
    .OP_D_o(OP_D_o),// 
    .A1_E_i(A1_E_i),// 
    .A2_E_i(A2_E_i),// 
    .RD1_E_i(RD1_E_i),// 
    .RD2_E_i(RD2_E_i),// 
    .PCn_E_i(PCn_E_i),// 
    .extimm_E_i(extimm_E_i), //
    .regWrite_E_i(regWrite_E_i),// 
    .A3_E_i(A3_E_i),// 
    .OP_E_i(OP_E_i), //
    .E_regWrite(E_regWrite),// 
    .E_A3(E_A3)
    );
Controller ctrl_Execute (
    .IMD(OP_E_i), //
    .ALU_OP(ALU_OP),// 
    .ALU_Bsel(ALU_Bsel)//
    );
Execute execute (
    .A1_E_i(A1_E_i),// 
    .A2_E_i(A2_E_i),// 
    .RD1_E_i(RD1_E_i),// 
    .RD2_E_i(RD2_E_i),// 
    .PCn_E_i(PCn_E_i),// 
    .extimm_E_i(extimm_E_i),// 
    .regWrite_E_i(regWrite_E_i),// 
    .A3_E_i(A3_E_i), //
    .OP_E_i(OP_E_i),// 
    .ALU_OP(ALU_OP),// 
    .ALU_Bsel(ALU_Bsel),// 
    .ALU_Asel(ALU_Asel),// 
    .ALU_Brdsel(ALU_Brdsel),//
    .RD2_E_osel(RD2_E_osel),	 
    .M_result(M_result), //
    .W_forward(W_forward), //
    .result_E_o(result_E_o),// 
    .A2_E_o(A2_E_o),// 
    .RD2_E_o(RD2_E_o), //
    .PCn_E_o(PCn_E_o), //
    .regWrite_E_o(regWrite_E_o), //
    .A3_E_o(A3_E_o),// 
    .OP_E_o(OP_E_o)//
    );	

M m (
    .clk(clk), //
    .reset(reset),// 
    .result_E_o(result_E_o), //
    .A2_E_o(A2_E_o), //
    .RD2_E_o(RD2_E_o), //
    .PCn_E_o(PCn_E_o), //
    .regWrite_E_o(regWrite_E_o),// 
    .A3_E_o(A3_E_o), //
    .OP_E_o(OP_E_o), //
    .result_M_i(result_M_i), //
    .A2_M_i(A2_M_i), //
    .RD2_M_i(RD2_M_i),// 
    .PCn_M_i(PCn_M_i),// 
    .regWrite_M_i(regWrite_M_i), //
    .A3_M_i(A3_M_i),// 
    .OP_M_i(OP_M_i), //
    .M_result(M_result), //
    .M_regWrite(M_regWrite), //
    .M_A3(M_A3)//
    ); 

Controller ctrl_Memory (
    .IMD(OP_M_i),// 
    .DM_WE(DM_WE), //
    .DM_RE(DM_RE)//
    );	 
Memory memory (
    .clk(clk), //
    .reset(reset),// 
    .result_M_i(result_M_i), //
    .A2_M_i(A2_M_i), //
    .RD2_M_i(RD2_M_i), //
    .PCn_M_i(PCn_M_i), //
    .regWrite_M_i(regWrite_M_i), //
    .A3_M_i(A3_M_i), //
    .OP_M_i(OP_M_i), //
    .DM_WE(DM_WE), //
    .DM_RE(DM_RE), //
    .W_forward(W_forward),// 
    .DM_datasel(DM_datasel),// 
    .memory_M_o(memory_M_o), //
    .result_M_o(result_M_o), //
    .PCn_M_o(PCn_M_o), //
    .regWrite_M_o(regWrite_M_o),// 
    .A3_M_o(A3_M_o), //
    .OP_M_o(OP_M_o)//
    );
 
W w (
    .clk(clk), 
    .reset(reset),
    .GRF_WDsel(GRF_WDsel),	 
    .memory_M_o(memory_M_o), 
    .result_M_o(result_M_o), 
    .PCn_M_o(PCn_M_o), 
    .regWrite_M_o(regWrite_M_o), 
    .A3_M_o(A3_M_o), 
    .OP_M_o(OP_M_o), 
    .memory_W_i(memory_W_i), 
    .result_W_i(result_W_i), 
    .PCn8_W_i(PCn8_W_i), 
    .regWrite_W_i(regWrite_W_i), 
    .A3_W_i(A3_W_i), 
    .OP_W_i(OP_W_i), 
    .W_memory(W_memory),
	 .W_forward(W_forward),
    .W_regWrite(W_regWrite), 
    .W_A3(W_A3)
    );
 
Controller ctrl_Write (
    .IMD(OP_W_i),// 
    .GRF_WDsel(GRF_WDsel)//
    );
 
Write write (
    .memory_W_i(memory_W_i),// 
    .result_W_i(result_W_i),// 
    .PCn8_W_i(PCn8_W_i), //
    .regWrite_W_i(regWrite_W_i), //
    .A3_W_i(A3_W_i), //
    .OP_W_i(OP_W_i),// 
    .GRF_WDsel(GRF_WDsel), //
    .regWrite_D_i(regWrite_D_i), //
    .A3_D_i(A3_D_i), //
    .WD_D_i(WD_D_i),//
	 .PC_GRF_W(PC_GRF_W)
    );
endmodule
