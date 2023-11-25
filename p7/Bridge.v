`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:25:32 12/07/2022 
// Design Name: 
// Module Name:    Bridge 
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
`define DMmin 32'h0000
`define DMmax 32'h2fff
`define Timer1min 32'h7f00
`define Timer1max 32'h7f0b
`define Timer2min 32'h7f10
`define Timer2max 32'h7f1b
`define Intmin 32'h7f20
`define Intmax 32'h7f23
module Bridge(
    input [31:0] br_addr,//from CPU
    input [31:0] br_wdata,
    input [3:0] br_byteen,
	 //get data
    input [31:0] m_data_rdata,//from DM
	 input [31:0] Timer1_rdata,//from Timer1
	 input [31:0] Timer2_rdata,//from Timer2
	 //give data
    output [31:0] m_data_addr,//to DM
    output [31:0] m_data_wdata,
	 output [31:0] m_int_addr,//to interupter
	 output [31:2] Timer1_addr,//to Timer1
	 output [31:0] Timer1_wdata,
	 output [31:2] Timer2_addr,//to Timer2
	 output [31:0] Timer2_wdata,
	 //return data
    output [31:0] br_rdata,//to CPU
	 //enable signal
	 output [3:0] m_data_byteen,//to DM
	 output [3:0] m_int_byteen,//to interrupter
	 output Timer1_en,
	 output Timer2_en
    );
//give the address
assign m_data_addr=br_addr;
assign m_int_addr=br_addr;
assign Timer1_addr=br_addr[31:2];
assign Timer2_addr=br_addr[31:2];
//give the wdata
assign m_data_wdata=br_wdata;
assign Timer1_wdata=br_wdata;
assign Timer2_wdata=br_wdata;
//set the enable signal
assign m_data_byteen=(br_addr>=`DMmin && br_addr<=`DMmax)? br_byteen:0;
assign m_int_byteen=(br_addr>=`Intmin && br_addr<=`Intmax)? br_byteen:0;
assign Timer1_en=(br_addr>=`Timer1min && br_addr<=`Timer1max)? (|br_byteen):0;
assign Timer2_en=(br_addr>=`Timer2min && br_addr<=`Timer2max)? (|br_byteen):0;
//select rdata
assign br_rdata=(br_addr>=`DMmin && br_addr<=`DMmax)? m_data_rdata:
                (br_addr>=`Timer1min && br_addr<=`Timer1max)? Timer1_rdata:
					 (br_addr>=`Timer2min && br_addr<=`Timer2max)? Timer2_rdata:0;
endmodule
