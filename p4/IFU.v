`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:27:37 10/27/2022 
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
    input PCsel,
    input [31:0] Badder,
    output [31:0] OP,
    output [31:0] PCn
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
assign PCn=adder;
assign PCnew=(PCsel==1)? Badder:adder;
always @(posedge clk) begin
      if(reset) PC<=12288;
		else PC<=PCnew;
end
assign OP=IM[(PC-12288)>>2];
endmodule
