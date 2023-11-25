`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:38:20 11/07/2022 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
    input clk,
    input reset,
	 input freeze,
	 input Req,
    input PCsel,
    input [31:0] Badder_D_o,
	 //from mips
	 input [31:0] i_inst_rdata,
	 //output
	 output [4:0] ExcCode_F_o,
    output [31:0] OP_F_o,
    output [31:0] PCn_F_o,
	 //give mips
	 output [31:0] i_inst_addr
    );
wire [31:0] adder;//adder
wire [31:0] PCnew;
reg [31:0] PC;//PC register

assign i_inst_addr=PC;
assign adder=PC+4;
assign PCn_F_o=adder;
assign PCnew=(PCsel==1)? Badder_D_o:adder;
always @(posedge clk) begin
      if(reset) PC<=12288;
		else if(Req) PC<=32'h4180;
		else if(freeze) PC<=PC;
		else PC<=PCnew;
end
assign OP_F_o=(|ExcCode_F_o)? 32'b0:i_inst_rdata;
assign ExcCode_F_o=((PC[1:0]!=2'b00) || PC<32'h3000 || PC>32'h6ffc)? 5'd4:0;
endmodule
