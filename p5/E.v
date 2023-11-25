`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:15 11/07/2022 
// Design Name: 
// Module Name:    E 
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
module E(
    input clk,
    input reset,
    input freeze,
    input [4:0] A1_D_o,
    input [4:0] A2_D_o,
    input [31:0] RD1_D_o,
    input [31:0] RD2_D_o,
    input [31:0] PCn_D_o,
    input [31:0] extimm_D_o,
    input regWrite_D_o,
    input [4:0] A3_D_o,
	 input [31:0] OP_D_o,
    output [4:0] A1_E_i,
    output [4:0] A2_E_i,
    output [31:0] RD1_E_i,
    output [31:0] RD2_E_i,
    output [31:0] PCn_E_i,
    output [31:0] extimm_E_i,
    output regWrite_E_i,
    output [4:0] A3_E_i,
	 output [31:0] OP_E_i,
	 output E_regWrite,
	 output [4:0] E_A3
    );
reg [4:0] A1,A2,A3;
reg [31:0] RD1,RD2,PCn,extimm,OP;
reg regWrite;
always @(posedge clk) begin
      if(reset|freeze) begin
		A1<=0;
		A2<=0;
		A3<=0;
		RD1<=0;
		RD2<=0;
		PCn<=0;
		extimm<=0;
		OP<=0;
		regWrite<=0;
		end
		else begin
		A1<=A1_D_o;
		A2<=A2_D_o;
		A3<=A3_D_o;
		RD1<=RD1_D_o;
		RD2<=RD2_D_o;
		PCn<=PCn_D_o;
		extimm<=extimm_D_o;
		OP<=OP_D_o;
		regWrite<=regWrite_D_o;
		end
end
assign A1_E_i=A1;
assign A2_E_i=A2;
assign A3_E_i=A3;
assign RD1_E_i=RD1;
assign RD2_E_i=RD2;
assign PCn_E_i=PCn;
assign extimm_E_i=extimm;
assign OP_E_i=OP;
assign regWrite_E_i=regWrite;
assign E_regWrite=regWrite;
assign E_A3=A3_E_i;
endmodule
