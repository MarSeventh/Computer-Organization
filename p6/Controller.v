`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:04 11/08/2022 
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
	 //controller signal
	 output PCsel,
	        //IFU
	 output [1:0] A3_D_osel,
    output extsel,
    output [2:0] Basel,
	 output GRF_WE,
	        //Decode
	 output [3:0] ALU_OP,
	 output ALU_Bsel,
	        //ALU
	 output DM_WE,
	 output DM_RE,
	 output [1:0] BEsel,
	 output [2:0] memory_M_osel,
           //MD
    output [2:0] md_op,
    output start,
    output mdsel,
    output losel,
    output loWE,
    output hisel,
    output hiWE,	 
	        //Memory
	 output [1:0] GRF_WDsel
	        //Write
    );
//Controller
//add instructions
wire add,sub,and_,or_,slt,sltu,lui;
wire addi,andi,ori;
wire lb,lh,lw,sb,sh,sw;
wire mult,multu,div,divu,mfhi,mflo,mthi,mtlo;
wire beq,bne,j,jal,jr;
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
assign and_=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b100100)? 1:0;
assign or_=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b100101)?1:0;
assign slt=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b101010)?1:0;
assign sltu=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b101011)?1:0;
assign addi=(IMD[31:26]==6'b001000)?1:0;
assign andi=(IMD[31:26]==6'b001100)?1:0;
assign lb=(IMD[31:26]==6'b100000)?1:0;
assign lh=(IMD[31:26]==6'b100001)?1:0;
assign sb=(IMD[31:26]==6'b101000)?1:0;
assign sh=(IMD[31:26]==6'b101001)?1:0;
assign mult=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b011000)?1:0;
assign multu=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b011001)?1:0;
assign div=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b011010)?1:0;
assign divu=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b011011)?1:0;
assign mfhi=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b010000)?1:0;
assign mflo=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b010010)?1:0;
assign mthi=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b010001)?1:0;
assign mtlo=(IMD[31:26]==6'b000000 && IMD[5:0]==6'b010011)?1:0;
assign bne=(IMD[31:26]==6'b000101)?1:0;

//sort the instructions
wire load,upload,R,I,Br;
assign load=lw|lh|lb;
assign upload=sw|sh|sb;
assign R=add|sub|and_|or_|slt|sltu;
assign I=addi|andi|ori|lui;
assign Br=beq|bne;

//change controller signal
assign PCsel=(Br|j|jal|jr)? 1:0;
assign GRF_WE=(R|I|jal|load|mfhi|mflo)? 1:0;
assign ALU_OP=(addi|add|load|upload)? 4'b0000:
              (sub)? 4'b0001:
				  (ori|or_)? 4'b0010:
				  (lui)? 4'b0100:
				  (and_|andi)? 4'b0101:
				  (slt)? 4'b0110:
				  (sltu)? 4'b0111:0;
assign DM_WE=(upload)? 1:0;
assign DM_RE=(load)? 1:0;
assign A3_D_osel=(R|mfhi|mflo)? 2'b01:
                 (jal)? 2'b10:2'b00;
assign GRF_WDsel=(R|I)? 2'b01:
                 (jal)? 2'b10:
					  (mfhi|mflo)?2'b11:0;
assign ALU_Bsel=(I|load|upload)? 1:0;
assign Basel=(beq)? 3'b001:
             (j|jal)? 3'b010:
				 (jr)? 3'b011:
				 (bne)? 3'b100:3'b000;
assign extsel=(ori|andi)?1:0;
assign BEsel=(sh)?2'b01:
             (sb)?2'b10:2'b00;
assign memory_M_osel=(lb)?3'b010:
                     (lh)?3'b100:3'b000;
assign md_op=(mult)?3'b000:
             (multu)?3'b001:
				 (div)?3'b010:
				 (divu)?3'b011:3'b000;
assign start=(mult|multu|div|divu)?1:0;
assign mdsel=(mfhi)?1:0;
assign losel=(mtlo)?1:0;
assign hisel=(mthi)?1:0;
assign loWE=(mtlo)?1:0;
assign hiWE=(mthi)?1:0;
endmodule
