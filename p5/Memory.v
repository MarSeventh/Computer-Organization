`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:10:27 11/07/2022 
// Design Name: 
// Module Name:    Memory 
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
module Memory(
    input clk,
	 input reset,
//pipline
    input [31:0] result_M_i,
	 input [4:0] A2_M_i,
	 input [31:0] RD2_M_i,
	 input [31:0] PCn_M_i,
	 input regWrite_M_i,
	 input [4:0] A3_M_i,
	 input [31:0] OP_M_i,
//Controller
    input DM_WE,
	 input DM_RE,
//forward
    input [31:0] W_forward,
	 input DM_datasel,
//output
    output [31:0] memory_M_o,
    output [31:0] result_M_o,
	 output [31:0] PCn_M_o,
	 output regWrite_M_o,
	 output [4:0] A3_M_o,
	 output [31:0] OP_M_o
    );
wire [31:0] PC;
assign PC=PCn_M_i-4;
//data select
wire [31:0] data;
assign data=(DM_datasel==1)? W_forward:RD2_M_i;
//address
wire [31:0] addr;
assign addr=result_M_i;
//DM
reg [31:0] DM [0:3071];//ram 
integer i;
always @(posedge clk) begin
       if(reset) begin
		        for(i=0;i<=3071;i=i+1)
				  DM[i]=0;
		 end
		 else begin
		        if(DM_WE) begin
				       $display ("%d@%h: *%h <= %h", $time,PC, addr, data);
				       DM[addr>>2]<=data;
				  end
		 end
end
assign memory_M_o=(DM_RE)? DM[addr>>2]:0;
//pipline
assign result_M_o=result_M_i;
assign PCn_M_o=PCn_M_i;
assign regWrite_M_o=regWrite_M_i;
assign A3_M_o=A3_M_i;
assign OP_M_o=OP_M_i;
endmodule
