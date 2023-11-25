`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:12:58 10/30/2022 
// Design Name: 
// Module Name:    Badder 
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
module Badder(
    input [31:0] PCn,
    input [31:0] IMD,
	 input [31:0] RF,
    input [1:0] com,
	 input [2:0] Basel,
    output [31:0] Baout
    );
wire [31:0] PC=PCn-4;
assign Baout=(Basel==3'b000)? PCn:
             (Basel==3'b001 && com==2'b00)? PCn+({{16{IMD[15]}},IMD[15:0]}<<2):
             (Basel==3'b001 && com!=2'b00)? PCn:
             (Basel==3'b010)? {PC[31:28],IMD[25:0],{2{1'b0}}}:
             (Basel==3'b011)? RF:PCn;				 

endmodule
