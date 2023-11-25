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
    input PCsel,
    input [31:0] Badder_D_o,
    output [31:0] OP_F_o,
    output [31:0] PCn_F_o
    );
wire [31:0] adder;//adder
wire [31:0] PCnew;
reg [31:0] PC;//PC register
reg [31:0] IM [0:4095];//IM 32bit*4096
initial begin
      PC=32'h00003000;
		$readmemh("code.txt",IM);
end
assign adder=PC+4;
assign PCn_F_o=adder;
assign PCnew=(PCsel==1)? Badder_D_o:adder;
always @(posedge clk) begin
      if(reset) PC<=12288;
		else if(freeze) PC<=PC;
		else PC<=PCnew;
end
assign OP_F_o=IM[(PC-12288)>>2];

endmodule
