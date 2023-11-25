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
	 input Req,
	 input freeze,
    input [31:0] OP_F_o,
    input [31:0] PCn_F_o,
	 input brclr,
	 input Delay_F_o,//from Ctrl_D
	 input [4:0] ExcCode_F_o,
    output [31:0] OP_D_i,
    output [31:0] PCn_D_i,
    output Delay_D_i,
    output [4:0] ExcCode_D_i	 
    );
reg [31:0] r_OP;
reg [31:0] r_PCn;
reg Delay;
reg [4:0] ExcCode;
always @(posedge clk)begin
      if(reset) begin
		      r_OP<=0;
				r_PCn<=0;
				Delay<=0;
				ExcCode<=0;
		end
		else if(Req)begin
		      r_OP<=0;
				r_PCn<=0;
				Delay<=0;
				ExcCode<=0;
		end
		else if(freeze) begin
		      r_OP<=r_OP;
				r_PCn<=r_PCn;
				Delay<=Delay;
				ExcCode<=ExcCode;
		end
		else if(brclr) begin
		      r_OP<=0;
				r_PCn<=0;
				Delay<=0;
				ExcCode<=0;
		end
		else begin
		      r_OP<=OP_F_o;
				r_PCn<=PCn_F_o;
				Delay<=Delay_F_o;
				ExcCode<=ExcCode_F_o;
		end
end

assign OP_D_i=r_OP;
assign PCn_D_i=r_PCn;
assign Delay_D_i=Delay;
assign ExcCode_D_i=ExcCode;
endmodule
