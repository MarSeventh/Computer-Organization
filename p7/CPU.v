`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:57:25 12/07/2022 
// Design Name: 
// Module Name:    CPU 
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
module CPU(
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
	 input Timer1_irq,             //Timer1 int
	 input Timer2_irq,             //Timer2 int
    output [31:0] macroscopic_pc, // 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr_br,    // DM 读写地址
    input  [31:0] m_data_rdata_br,   // DM 读取数据
    output [31:0] m_data_wdata_br,   // DM 待写入数据
    output [3 :0] m_data_byteen_br,  // DM 字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC

    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据

    output [31:0] w_inst_addr     // W 级 PC
    );
assign macroscopic_pc=m_inst_addr;
//Interrupt
wire [5:0] HWInt;
assign HWInt={3'b0,interrupt,Timer2_irq,Timer1_irq};
//MD
wire [2:0] md_op;
wire start,mdsel,losel,loWE,hisel,hiWE,busy;
wire [31:0] md_E_o,md_M_i,md_M_o,md_W_i;
wire [1:0] GRF_WD_Msel;
//ExcCode
wire [4:0] ExcCode_F_o,ExcCode_D_i,ExcCode_D_o,ExcCode_E_i,ExcCode_E_o,ExcCode_M_i;
wire [4:0] De_ExcCode,Ex_ExcCode;
wire overflowa,overflows;
wire [31:0] Ex_addr;
wire [31:0] EPC;
//Controller
wire [1:0] BEsel;
wire [2:0] memory_M_osel;
//
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
wire [2:0] Basel;
wire [3:0] ALU_OP;
wire freeze;
wire [31:0] Badder_D_o,RD1_D_o,RD2_D_o,extimm_D_o,RD1_E_i,RD2_E_i,extimm_E_i;
wire [31:0] PCn_F_o,PCn_D_i,PCn_D_o,PCn_E_i,PCn_E_o,PCn_M_i,PCn_M_o,PCn_W_i;
wire [31:0] WD_D_i;
FORWARD forward (
    .busy(busy),
	 .start(start),
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
	 .Req(Req),
    .freeze(freeze), //
    .PCsel(PCsel),// 
    .Badder_D_o(Badder_D_o),// 
	 .ExcCode_F_o(ExcCode_F_o),
	 //from mips
	 .i_inst_rdata(i_inst_rdata),
	 //
    .OP_F_o(OP_F_o), //
    .PCn_F_o(PCn_F_o),
	 //give mips
	 .i_inst_addr(i_inst_addr)
    );

D d (
    .clk(clk), //
    .reset(reset), //
	 .Req(Req),
	 .freeze(freeze),
	 .brclr(brclr),
	 .Delay_F_o(Delay_F_o),
	 .ExcCode_F_o(ExcCode_F_o),
    .OP_F_o(OP_F_o),// 
    .PCn_F_o(PCn_F_o),// 
	 .Delay_D_i(Delay_D_i),
	 .ExcCode_D_i(ExcCode_D_i),
    .OP_D_i(OP_D_i), //
    .PCn_D_i(PCn_D_i)//
    );
Controller ctrl_Decode (
    .IMD(OP_D_i), //
    .PCsel(PCsel),// 
    .A3_D_osel(A3_D_osel),// 
    .extsel(extsel),// 
    .Basel(Basel),// 
    .GRF_WE(GRF_WE),
	 .Delay(Delay_F_o),//
	 .De_ExcCode(De_ExcCode),
	 .brclr(brclr)
    );
Decode decode (
    .clk(clk), //
    .reset(reset), //
	 .Delay_D_i(Delay_D_i),
	 .Delay_D_o(Delay_D_o),
	 .ExcCode_D_i(ExcCode_D_i),
	 .ExcCode_D_o(ExcCode_D_o),
	 .De_ExcCode(De_ExcCode),
	 //.OP_W_i(OP_W_i),
	 .PC_GRF_W(PC_GRF_W),//
    .OP_D_i(OP_D_i), //
    .PCn_D_i(PCn_D_i),// 
	 .EPC(EPC),
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
    .OP_D_o(OP_D_o),//
	 //give mips
	 .w_grf_we(w_grf_we),
	 .w_grf_addr(w_grf_addr),
	 .w_grf_wdata(w_grf_wdata),
	 .w_inst_addr(w_inst_addr)
    );
	 
E e (
    .clk(clk), //
    .reset(reset), //
	 .Req(Req),
    .freeze(freeze),//	 
	 .Delay_D_o(Delay_D_o),
	 .ExcCode_D_o(ExcCode_D_o),
    .A1_D_o(A1_D_o),// 
    .A2_D_o(A2_D_o), //
    .RD1_D_o(RD1_D_o),// 
    .RD2_D_o(RD2_D_o), //
    .PCn_D_o(PCn_D_o), //
    .extimm_D_o(extimm_D_o), //
    .regWrite_D_o(regWrite_D_o),// 
    .A3_D_o(A3_D_o),// 
    .OP_D_o(OP_D_o),// 
	 .Delay_E_i(Delay_E_i),
	 .ExcCode_E_i(ExcCode_E_i),
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
	 .Ex_addr(Ex_addr),
	 .overflowa(overflowa),
	 .overflows(overflows),
	 .Ex_ExcCode(Ex_ExcCode),
    .ALU_OP(ALU_OP),// 
    .ALU_Bsel(ALU_Bsel),//
	 //MD
	 .md_op(md_op),
	 .start(start),
	 .mdsel(mdsel),
	 .losel(losel),
	 .loWE(loWE),
	 .hisel(hisel),
	 .hiWE(hiWE)
    );
Execute execute (
    .clk(clk),
	 .reset(reset),
	 .Req(Req),
	 .Delay_E_i(Delay_E_i),
	 .Delay_E_o(Delay_E_o),
	 .ExcCode_E_i(ExcCode_E_i),
	 .ExcCode_E_o(ExcCode_E_o),
	 .Ex_ExcCode(Ex_ExcCode),
	 .overflowa(overflowa),
	 .overflows(overflows),
	 .Ex_addr(Ex_addr),
//MD
    //in
	 .md_op(md_op),
	 .start(start),
	 .mdsel(mdsel),
	 .losel(losel),
	 .loWE(loWE),
	 .hisel(hisel),
	 .hiWE(hiWE),
	 //out
	 .busy(busy),
	 .md_E_o(md_E_o),
	 //
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
	 .Req(Req),
	 .Delay_E_o(Delay_E_o),
	 .ExcCode_E_o(ExcCode_E_o),
	 .GRF_WDsel(GRF_WD_Msel),
	 .md_E_o(md_E_o),
    .result_E_o(result_E_o), //
    .A2_E_o(A2_E_o), //
    .RD2_E_o(RD2_E_o), //
    .PCn_E_o(PCn_E_o), //
    .regWrite_E_o(regWrite_E_o),// 
    .A3_E_o(A3_E_o), //
    .OP_E_o(OP_E_o), //
	 .Delay_M_i(Delay_M_i),
	 .ExcCode_M_i(ExcCode_M_i),
    .result_M_i(result_M_i), //
    .A2_M_i(A2_M_i), //
    .RD2_M_i(RD2_M_i),// 
    .PCn_M_i(PCn_M_i),// 
    .regWrite_M_i(regWrite_M_i), //
    .A3_M_i(A3_M_i),// 
    .OP_M_i(OP_M_i), //
    .M_result(M_result), //
	 .md_M_i(md_M_i),
    .M_regWrite(M_regWrite), //
    .M_A3(M_A3)//
    ); 

Controller ctrl_Memory (
    .IMD(OP_M_i),// 
    .DM_WE(DM_WE), //
    .DM_RE(DM_RE),//
	 .BEsel(BEsel),
	 .GRF_WDsel(GRF_WD_Msel),
	 .memory_M_osel(memory_M_osel),
	 .CP0_WE(CP0_WE),
	 .EXLClr(EXLClr)
    );	 
Memory memory (
    .clk(clk), //
    .reset(reset),//
    .Delay_M_i(Delay_M_i),	
    .ExcCode_M_i(ExcCode_M_i),	 
	 .md_M_i(md_M_i),
    .result_M_i(result_M_i), //
    .A2_M_i(A2_M_i), //
    .RD2_M_i(RD2_M_i), //
    .PCn_M_i(PCn_M_i), //
    .regWrite_M_i(regWrite_M_i), //
    .A3_M_i(A3_M_i), //
    .OP_M_i(OP_M_i), //
	 //Controller
    .DM_WE(DM_WE), //
    .DM_RE(DM_RE), //
	 .BEsel(BEsel),
	 .memory_M_osel(memory_M_osel),
	 .CP0_WE(CP0_WE),
	 .EXLClr(EXLClr),
	 //from mips
	 .m_data_rdata(m_data_rdata_br),
	 .HWInt(HWInt),
	 //
    .W_forward(W_forward),// 
    .DM_datasel(DM_datasel),// 
    .memory_M_o(memory_M_o), //
    .result_M_o(result_M_o), //
    .PCn_M_o(PCn_M_o), //
	 .md_M_o(md_M_o),
    .regWrite_M_o(regWrite_M_o),// 
    .A3_M_o(A3_M_o), //
    .OP_M_o(OP_M_o),//
	 .EPC(EPC),
	 .Req(Req),
	 //give mips
	 .m_inst_addr(m_inst_addr),
	 //give bridge
	 .m_data_addr(m_data_addr_br),
	 .m_data_wdata(m_data_wdata_br),
	 .m_data_byteen(m_data_byteen_br)
    );
 
W w (
    .clk(clk), 
    .reset(reset),
	 .Req(Req),
	 .md_M_o(md_M_o),
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
	 .md_W_i(md_W_i),
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
	 .md_W_i(md_W_i),
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
