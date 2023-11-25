`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:54:25 11/07/2022 
// Design Name: 
// Module Name:    M 
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
module M(
    input clk,
	 input reset,
//pipline
    input [31:0] result_E_o,
	 input [4:0] A2_E_o,
	 input [31:0] RD2_E_o,
	 input [31:0] PCn_E_o,
	 input regWrite_E_o,
	 input [4:0] A3_E_o,
	 input [31:0] OP_E_o,
//output
	 output [31:0] result_M_i,
	 output [4:0] A2_M_i,
	 output [31:0] RD2_M_i,
	 output [31:0] PCn_M_i,
	 output regWrite_M_i,
	 output [4:0] A3_M_i,
	 output [31:0] OP_M_i,
    output [31:0] M_result,
    output M_regWrite,
    output [4:0] M_A3	 
    );
reg [31:0] result,PCn,OP,RD2;
reg [4:0] A2,A3;
reg regWrite;

always @(posedge clk) begin
      if(reset) begin
		      result<=0;
				PCn<=0;
				OP<=0;
				A2<=0;
				A3<=0;
				RD2<=0;
				regWrite<=0;
		end
		else begin
		      result<=result_E_o;
				PCn<=PCn_E_o;
				OP<=OP_E_o;
				A2<=A2_E_o;
				A3<=A3_E_o;
				RD2<=RD2_E_o;
				regWrite<=regWrite_E_o;
		end
end
assign result_M_i=result;
assign PCn_M_i=PCn;
assign OP_M_i=OP;
assign A2_M_i=A2;
assign A3_M_i=A3;
assign RD2_M_i=RD2;
assign regWrite_M_i=regWrite;
assign M_result=result;
assign M_regWrite=regWrite;
assign M_A3=A3_M_i;
endmodule
