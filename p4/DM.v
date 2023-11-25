`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:28:37 10/28/2022 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input clk,
    input reset,
    input [31:0] address,
    input [31:0] WD,
    input WE,
    input RE,
	 input [31:0] PC,
    output [31:0] Output
    );
reg [31:0] DM [0:3071];//ram 
integer i;
always @(posedge clk) begin
       if(reset) begin
		        for(i=0;i<=3071;i=i+1)
				  DM[i]=0;
		 end
		 else begin
		        if(WE) begin
				       $display ("@%h: *%h <= %h", PC, address, WD);
				       DM[address>>2]<=WD;
				  end
		 end
end
assign Output=(RE)? DM[address>>2]:0;
endmodule
