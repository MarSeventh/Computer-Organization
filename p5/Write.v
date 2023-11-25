`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:37:03 11/08/2022 
// Design Name: 
// Module Name:    Write 
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
module Write(
//from W
    input [31:0] memory_W_i,
    input [31:0] result_W_i,
	 input [31:0] PCn8_W_i,
	 input regWrite_W_i,
	 input [4:0] A3_W_i,
	 input [31:0] OP_W_i,
//Controller
    input [1:0] GRF_WDsel,
//output
    output regWrite_D_i,
	 output [4:0] A3_D_i,
    output [31:0] WD_D_i,
	 output [31:0] PC_GRF_W
    );
assign regWrite_D_i=regWrite_W_i;
assign A3_D_i=A3_W_i;
assign WD_D_i=(GRF_WDsel==2'b00)?memory_W_i:
              (GRF_WDsel==2'b01)?result_W_i:
				  (GRF_WDsel==2'b10)?PCn8_W_i:0;
              
assign PC_GRF_W=PCn8_W_i-8;
endmodule
