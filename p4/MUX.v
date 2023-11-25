`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:48:31 10/30/2022 
// Design Name: 
// Module Name:    MUX 
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
module mux_A3(
    input [4:0] reg1,
	 input [4:0] reg2,
	 input [1:0] GRF_A3sel,
	 output [4:0] A3
    );
assign A3=(GRF_A3sel==2'b00)? reg1:
          (GRF_A3sel==2'b01)? reg2:
			 (GRF_A3sel==2'b10)? 5'b11111:0;

endmodule

module mux_grf_WD(
    input [31:0] DMout,
	 input [31:0] result,
	 input [31:0] PCn,
	 input [1:0] GRF_WDsel,
	 output [31:0] GRF_WD
    );
assign GRF_WD=(GRF_WDsel==2'b00)? DMout:
              (GRF_WDsel==2'b01)? result:
				  (GRF_WDsel==2'b10)? PCn:0;
endmodule

module mux_alub(
    input [31:0] RD2,
	 input [31:0] offset,
	 input ALU_Bsel,
	 output [31:0] data2
    );
assign data2=(ALU_Bsel==0)? RD2:offset;
endmodule 