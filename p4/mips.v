`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:00:40 10/27/2022 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
wire PCsel,GRF_WE,DM_WE,DM_RE,ALU_Bsel,extsel;
wire [2:0] ALU_OP,Basel;
wire [1:0] GRF_A3sel,GRF_WDsel,compare;
wire [31:0] PC,OP,PCn,Baout,GRF_WD,RD1,RD2,data1,data2,result,address,DM_WD,DMout,offset;
wire [4:0] A1,A2,A3,reg1,reg2;
IFU ifu (
    .clk(clk), //
    .reset(reset), //
    .PCsel(PCsel), //
    .Badder(Baout), //
    .OP(OP), 
    .PCn(PCn)
    );
assign PC=PCn-4;
Controller controller (
    .IMD(OP), //
    .PCsel(PCsel), 
    .GRF_WE(GRF_WE), 
    .ALU_OP(ALU_OP), 
    .DM_WE(DM_WE), 
    .DM_RE(DM_RE), 
    .GRF_A3sel(GRF_A3sel), 
    .GRF_WDsel(GRF_WDsel), 
    .ALU_Bsel(ALU_Bsel),
	 .Basel(Basel),
	 .extsel(extsel)
    );
assign reg1=OP[20:16];
assign reg2=OP[15:11];
mux_A3 mux1 (
    .reg1(reg1),// 
    .reg2(reg2), //
    .GRF_A3sel(GRF_A3sel), //
    .A3(A3)
    );
	 
mux_grf_WD mux2 (
    .DMout(DMout), //
    .result(result), //
    .PCn(PCn), //
    .GRF_WDsel(GRF_WDsel), //
    .GRF_WD(GRF_WD)
    );

GRF grf (
    .WE(GRF_WE), //
    .reset(reset), //
    .clk(clk), //
    .A1(A1), //
    .A2(A2), //
    .A3(A3), //
	 .PC(PC),//
    .WD(GRF_WD), //
    .RD1(RD1), 
    .RD2(RD2)
    );
assign A1=OP[25:21];
assign A2=OP[20:16];
assign offset=(extsel==1)? OP[15:0]:{{16{OP[15]}},OP[15:0]};
mux_alub mux3 (
    .RD2(RD2), //
    .offset(offset),// 
    .ALU_Bsel(ALU_Bsel), 
    .data2(data2)
    );

ALU alu (
    .data1(data1), //
    .data2(data2), //
    .op(ALU_OP),// 
    .result(result), 
    .compare(compare)
    );
assign data1=RD1;

DM dm (
    .clk(clk), //
    .reset(reset),// 
    .address(address), //
    .WD(DM_WD), //
    .WE(DM_WE), //
    .RE(DM_RE), //
	 .PC(PC),//
    .Output(DMout)
    );
assign address=result;
assign DM_WD=RD2;


Badder badder (
    .PCn(PCn), //
    .IMD(OP), //
    .RF(RD1), //
    .com(compare),// 
    .Basel(Basel), //
    .Baout(Baout)
    );

endmodule
