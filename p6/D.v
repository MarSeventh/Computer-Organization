`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:54:03 11/06/2022 
// Design Name: 
// Module Name:    D 
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
module D(
    input clk,
    input reset,
	 input freeze,
    input [31:0] OP_F_o,
    input [31:0] PCn_F_o,
    output [31:0] OP_D_i,
    output [31:0] PCn_D_i   
    );
reg [31:0] r_OP;
reg [31:0] r_PCn;
always @(posedge clk)begin
      if(reset) begin
		      r_OP<=0;
				r_PCn<=0;
		end
		else if(freeze) begin
		      r_OP<=r_OP;
				r_PCn<=r_PCn;
		end
		else begin
		      r_OP<=OP_F_o;
				r_PCn<=PCn_F_o;
		end
end

assign OP_D_i=r_OP;
assign PCn_D_i=r_PCn;
endmodule
