`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:20 11/07/2022 
// Design Name: 
// Module Name:    Execute 
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
module Execute(
//pipline
    input [4:0] A1_E_i,
    input [4:0] A2_E_i,
    input [31:0] RD1_E_i,
    input [31:0] RD2_E_i,
    input [31:0] PCn_E_i,
    input [31:0] extimm_E_i,
    input regWrite_E_i,
    input [4:0] A3_E_i,
	 input [31:0] OP_E_i,
//Controller
    input [2:0] ALU_OP,
	 input ALU_Bsel,
//forward
    input [1:0] ALU_Asel,
	 input [1:0] ALU_Brdsel,
	 input [31:0] M_result,
	 input [31:0] W_forward,
	 input [1:0] RD2_E_osel,//
//output
    output [31:0] result_E_o,
	 output [4:0] A2_E_o,
	 output [31:0] RD2_E_o,
	 output [31:0] PCn_E_o,
	 output regWrite_E_o,
	 output [4:0] A3_E_o,
	 output [31:0] OP_E_o
    );
	 wire [31:0] A,B,Brd;
//selsect A
assign A=(ALU_Asel==2'b10)?M_result:
         (ALU_Asel==2'b01)?W_forward:RD1_E_i;
//select B
assign Brd=(ALU_Brdsel==2'b10)?M_result:
           (ALU_Brdsel==2'b01)?W_forward:RD2_E_i;
assign B=(ALU_Bsel==0)?Brd:extimm_E_i;
//ALU
assign result_E_o=(ALU_OP==3'b000)? A+B:
                  (ALU_OP==3'b001)? A-B:
				      (ALU_OP==3'b010)? A|B:
				      (ALU_OP==3'b100)? B<<16:0;
//pipline
assign A2_E_o=A2_E_i;
assign RD2_E_o=(RD2_E_osel==2'b10)?M_result:
               (RD2_E_osel==2'b01)?W_forward:RD2_E_i;
assign PCn_E_o=PCn_E_i;
assign regWrite_E_o=regWrite_E_i;
assign A3_E_o=A3_E_i;
assign OP_E_o=OP_E_i;
endmodule
