`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:17:03 11/07/2022 
// Design Name: 
// Module Name:    W 
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
module W(
    input clk,
    input reset,
	 input [1:0] GRF_WDsel, 
	 //from Memory
	 input [31:0] memory_M_o,
    input [31:0] result_M_o,
	 input [31:0] PCn_M_o,
	 input regWrite_M_o,
	 input [4:0] A3_M_o,
	 input [31:0] OP_M_o,
	 //output
	 output [31:0] memory_W_i,
    output [31:0] result_W_i,
	 output [31:0] PCn8_W_i,
	 output regWrite_W_i,
	 output [4:0] A3_W_i,
	 output [31:0] OP_W_i,
	 output [31:0] W_memory,
	 output [31:0] W_forward,
	 output W_regWrite,
	 output [4:0] W_A3
    );
reg [31:0] memory,result,PCn,OP;
reg [4:0] A3;
reg regWrite;
always @(posedge clk) begin
       if(reset) begin
		       memory<=0;
				 result<=0;
				 PCn<=0;
				 OP<=0;
				 A3<=0;
				 regWrite<=0;
		 end
		 else begin
		       memory<=memory_M_o;
				 result<=result_M_o;
				 PCn<=PCn_M_o;
				 OP<=OP_M_o;
				 A3<=A3_M_o;
				 regWrite<=regWrite_M_o;
		 end
end
assign memory_W_i=memory;
assign result_W_i=result;
assign PCn8_W_i=PCn+4;//PCn8=PCn+4
assign OP_W_i=OP;
assign A3_W_i=A3;
assign regWrite_W_i=regWrite;
assign W_memory=memory;
assign W_regWrite=regWrite;
assign W_A3=A3;
assign W_forward=(GRF_WDsel==2'b00)?memory:
              (GRF_WDsel==2'b01)?result:
				  (GRF_WDsel==2'b10)?PCn8_W_i:0;
endmodule
