`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:10:05 10/28/2022 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] data1,
    input [31:0] data2,
    input [2:0] op,
    output [31:0] result,
    output [1:0] compare
    );
assign result=(op==3'b000)? data1+data2:
              (op==3'b001)? data1-data2:
				  (op==3'b010)? data1|data2:
				  (op==3'b100)? data2<<16:0;
assign compare=(data1==data2)? 2'b00:
               (data1<data2)? 2'b01:
					(data1>data2)? 2'b10:0;
endmodule
