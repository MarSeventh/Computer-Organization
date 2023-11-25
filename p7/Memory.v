`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:10:27 11/07/2022 
// Design Name: 
// Module Name:    Memory 
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
module Memory(
    input clk,
	 input reset,
//pipline
    input Delay_M_i,
	 input [4:0] ExcCode_M_i,
    input [31:0] md_M_i,
    input [31:0] result_M_i,
	 input [4:0] A2_M_i,
	 input [31:0] RD2_M_i,
	 input [31:0] PCn_M_i,
	 input regWrite_M_i,
	 input [4:0] A3_M_i,
	 input [31:0] OP_M_i,
//Controller
    input DM_WE,
	 input DM_RE,
	 input [1:0] BEsel,
	 input [2:0] memory_M_osel,
	 input CP0_WE,
	 input EXLClr,
//forward
    input [31:0] W_forward,
	 input DM_datasel,
	 //from CPU.v
	 input [31:0] m_data_rdata,
	 input [5:0] HWInt,
//output
    output [31:0] md_M_o,
    output [31:0] memory_M_o,
    output [31:0] result_M_o,
	 output [31:0] PCn_M_o,
	 output regWrite_M_o,
	 output [4:0] A3_M_o,
	 output [31:0] OP_M_o,
	 output [31:0] EPC,
	 output Req,
	 //give mips
	 output [31:0] m_inst_addr, 
	 output [31:0] m_data_addr,
	 output [31:0] m_data_wdata,
	 output [3:0] m_data_byteen
    );
wire [31:0] PC,CP0Out;
assign PC=PCn_M_i-4;
//data select
wire [31:0] databe,data;
assign databe=(DM_datasel==1)? W_forward:RD2_M_i;
//address
wire [31:0] addr;
assign addr=result_M_i;
//give mips
assign m_inst_addr=PC;
assign m_data_addr=addr;
assign m_data_wdata=data;

//BE
assign m_data_byteen=(Req)? 4'b0000:
                     (DM_WE && BEsel==2'b00)?4'b1111:
                     (DM_WE && BEsel==2'b01 && addr[1]==0)?4'b0011:
							(DM_WE && BEsel==2'b01 && addr[1]==1)?4'b1100:
							(DM_WE && BEsel==2'b10 && addr[1:0]==2'b00)?4'b0001:
							(DM_WE && BEsel==2'b10 && addr[1:0]==2'b01)?4'b0010:
							(DM_WE && BEsel==2'b10 && addr[1:0]==2'b10)?4'b0100:
							(DM_WE && BEsel==2'b10 && addr[1:0]==2'b11)?4'b1000:4'b0000;
assign data=(BEsel==2'b00)?databe:
            (BEsel==2'b01)?{databe[15:0],databe[15:0]}:
            (BEsel==2'b10)?{databe[7:0],databe[7:0],databe[7:0],databe[7:0]}:databe;			
//calculate memory
assign memory_M_o=(DM_RE && memory_M_osel==3'b000)?m_data_rdata:
                  (DM_RE && memory_M_osel==3'b001 && addr[1:0]==2'b00)?m_data_rdata[7:0]:
						(DM_RE && memory_M_osel==3'b001 && addr[1:0]==2'b01)?m_data_rdata[15:8]:
						(DM_RE && memory_M_osel==3'b001 && addr[1:0]==2'b10)?m_data_rdata[23:16]:
						(DM_RE && memory_M_osel==3'b001 && addr[1:0]==2'b11)?m_data_rdata[31:24]:
						(DM_RE && memory_M_osel==3'b010 && addr[1:0]==2'b00)?{{24{m_data_rdata[7]}},m_data_rdata[7:0]}:
						(DM_RE && memory_M_osel==3'b010 && addr[1:0]==2'b01)?{{24{m_data_rdata[15]}},m_data_rdata[15:8]}:
						(DM_RE && memory_M_osel==3'b010 && addr[1:0]==2'b10)?{{24{m_data_rdata[23]}},m_data_rdata[23:16]}:
						(DM_RE && memory_M_osel==3'b010 && addr[1:0]==2'b11)?{{24{m_data_rdata[31]}},m_data_rdata[31:24]}:
						(DM_RE && memory_M_osel==3'b011 && addr[1]==0)?m_data_rdata[15:0]:
						(DM_RE && memory_M_osel==3'b011 && addr[1]==1)?m_data_rdata[31:16]:
						(DM_RE && memory_M_osel==3'b100 && addr[1]==0)?{{16{m_data_rdata[15]}},m_data_rdata[15:0]}:
						(DM_RE && memory_M_osel==3'b100 && addr[1]==1)?{{16{m_data_rdata[31]}},m_data_rdata[31:16]}:
						(memory_M_osel==3'b101)? CP0Out:0;
//pipline
assign result_M_o=result_M_i;
assign PCn_M_o=PCn_M_i;
assign regWrite_M_o=regWrite_M_i;
assign A3_M_o=A3_M_i;
assign OP_M_o=OP_M_i;
assign md_M_o=md_M_i;
//CP0
wire [4:0] CP0Add;
assign CP0Add=OP_M_i[15:11];
//assign CP0_WE=(Req)? 0:CP0_WE;
CP0 CP0 (
    .clk(clk), 
    .reset(reset), 
    .en(CP0_WE), //Controller
    .CP0Add(CP0Add), 
    .CP0In(databe), 
    .VPC(m_inst_addr), 
    .BDIn(Delay_M_i), //pipline//
    .ExcCodeIn(ExcCode_M_i), //pipline//
    .HWInt(HWInt), //from CPU module//
    .EXLClr(EXLClr),//Controller 
    .CP0Out(CP0Out),//give Write//
    .EPCOut(EPC),//give Decode 
    .Req(Req)//
    );

endmodule
