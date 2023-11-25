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
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
    output [31:0] macroscopic_pc, // 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数据
    output [3 :0] m_data_byteen,  // DM 字节使能信号

    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC

    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据

    output [31:0] w_inst_addr     // W 级 PC
    );
//CPU gives Bridge
wire [31:0] br_addr,br_rdata,br_wdata;
wire [3:0] br_byteen;
//Bridge and Timer
wire [31:2] Timer1_addr,Timer2_addr;
wire [31:0] Timer1_rdata,Timer2_rdata,Timer1_wdata,Timer2_wdata;
wire Timer1_en,Timer2_en;
//Timer to CPU
wire Timer1_irq,Timer2_irq;
//macroscopic_pc
assign macroscopic_pc=m_inst_addr;

CPU CPU (
    .clk(clk), 
    .reset(reset), 
    .interrupt(interrupt), 
	 .Timer1_irq(Timer1_irq),
	 .Timer2_irq(Timer2_irq),
    .macroscopic_pc(macroscopic_pc), 
    .i_inst_addr(i_inst_addr), 
    .i_inst_rdata(i_inst_rdata), 
    .m_data_addr_br(br_addr), 
    .m_data_rdata_br(br_rdata), 
    .m_data_wdata_br(br_wdata), 
    .m_data_byteen_br(br_byteen), 
    .m_inst_addr(m_inst_addr), 
    .w_grf_we(w_grf_we), 
    .w_grf_addr(w_grf_addr), 
    .w_grf_wdata(w_grf_wdata), 
    .w_inst_addr(w_inst_addr)
    );
	 


Bridge Bridge (
    .br_addr(br_addr), 
    .br_wdata(br_wdata), 
    .br_byteen(br_byteen), 
    .m_data_rdata(m_data_rdata), 
    .Timer1_rdata(Timer1_rdata), 
    .Timer2_rdata(Timer2_rdata), 
    .m_data_addr(m_data_addr), 
    .m_data_wdata(m_data_wdata), 
    .m_int_addr(m_int_addr), 
    .Timer1_addr(Timer1_addr), 
    .Timer1_wdata(Timer1_wdata), 
    .Timer2_addr(Timer2_addr), 
    .Timer2_wdata(Timer2_wdata), 
    .br_rdata(br_rdata), 
    .m_data_byteen(m_data_byteen), 
    .m_int_byteen(m_int_byteen), 
    .Timer1_en(Timer1_en), 
    .Timer2_en(Timer2_en)
    );

TC Timer1 (
    .clk(clk), 
    .reset(reset), 
    .Addr(Timer1_addr), 
    .WE(Timer1_en), 
    .Din(Timer1_wdata), 
    .Dout(Timer1_rdata), 
    .IRQ(Timer1_irq)
    );
	 
TC Timer2 (
    .clk(clk), 
    .reset(reset), 
    .Addr(Timer2_addr), 
    .WE(Timer2_en), 
    .Din(Timer2_wdata), 
    .Dout(Timer2_rdata), 
    .IRQ(Timer2_irq)
    );
endmodule
