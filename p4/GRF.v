`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:16:39 10/28/2022 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input WE,
    input reset,
    input clk,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
	 input [31:0] PC,
    output [31:0] RD1,
    output [31:0] RD2
    );
reg [31:0] grf [0:31]; //grf[32]
integer i;
always @(posedge clk) begin
       if(reset) begin
		        for(i=0;i<32;i=i+1) grf[i]=0;
		 end
		 else begin
		        if(WE && (A3>=1) && (A3<=31)) begin
				  $display ("@%h: $%d <= %h", PC, A3, WD);
				  grf[A3]<=WD;
				  end
		 end
end
assign RD1=grf[A1];
assign RD2=grf[A2];
endmodule
