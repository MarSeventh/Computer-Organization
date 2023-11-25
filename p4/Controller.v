`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:37:46 10/30/2022 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
    input [31:0] IMD,
    output PCsel,
    output GRF_WE,
    output [2:0] ALU_OP,
    output DM_WE,
    output DM_RE,
    output [1:0] GRF_A3sel,
    output [1:0] GRF_WDsel,
    output ALU_Bsel,
	 output [2:0] Basel,
	 output extsel
    );
wire add,sub,ori,lw,sw,lui,beq,j,jal,jr;
assign add=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b100000)? 1:0;
assign sub=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b100010)? 1:0;
assign ori=(IMD[31:26]==6'b001101)? 1:0;
assign lw=(IMD[31:26]==6'b100011)? 1:0;
assign sw=(IMD[31:26]==6'b101011)? 1:0;
assign lui=(IMD[31:26]==6'b001111)? 1:0;
assign beq=(IMD[31:26]==6'b000100)? 1:0;
assign j=(IMD[31:26]==6'b000010)? 1:0;
assign jal=(IMD[31:26]==6'b000011)? 1:0;
assign jr=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b001000)? 1:0;

assign PCsel=(beq|j|jal|jr)? 1:0;
assign GRF_WE=(add|sub|ori|lw|lui|jal)? 1:0;
assign ALU_OP=(add|lw|sw)? 3'b000:
              (sub)? 3'b001:
				  (ori)? 3'b010:
				  (beq)? 3'b011:
				  (lui)? 3'b100:3'b000;
assign DM_WE=(sw)? 1:0;
assign DM_RE=(lw)? 1:0;
assign GRF_A3sel=(add|sub)? 2'b01:
                 (jal)? 2'b10:2'b00;
assign GRF_WDsel=(add|sub|ori|lui)? 2'b01:
                 (jal)? 2'b10:2'b00;
assign ALU_Bsel=(ori|lw|sw|lui)? 1:0;
assign Basel=(beq)? 3'b001:
             (j|jal)? 3'b010:
				 (jr)? 3'b011:3'b000;
assign extsel=(ori)?1:0;
endmodule
