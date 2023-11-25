`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:37:34 12/08/2022 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
    input clk,
    input reset,
    input en,
    input [4:0] CP0Add,
    input [31:0] CP0In,
    input [31:0] VPC,//PC
    input BDIn,
    input [4:0] ExcCodeIn,
    input [5:0] HWInt,
    input EXLClr,
    output [31:0] CP0Out,
    output [31:0] EPCOut,
    output Req
    );
parameter SR=5'd12,Cause=5'd13,EPC=5'd14;
reg [31:0] CP[12:14];
wire [4:0] ExcCode;
assign ExcCode=(|HWInt)?5'd0:ExcCodeIn;
wire error;
assign error=(|ExcCodeIn) | (CP[SR][0] & (~CP[SR][1])  & ((CP[SR][15]&HWInt[5]) | (CP[SR][14]&HWInt[4]) | (CP[SR][13]&HWInt[3]) | (CP[SR][12]&HWInt[2]) | (CP[SR][11]&HWInt[1]) | (CP[SR][10]&HWInt[0])));
//initial
initial begin
CP[SR]<=0;
CP[Cause]<=0;
CP[EPC]<=0;
end
//write registers
always @(posedge clk) begin
       if(reset) begin
		       CP[SR]<=0;
             CP[Cause]<=0;
             CP[EPC]<=0;
		 end
		 else begin
		       if(en & ~error) begin
		             CP[CP0Add]<=CP0In;
		       end
				 //SR//////////////////////////
				    //IM CP[SR][15:10]
                //EXL CP[SR][1]
		       if(error) CP[SR][1]<=1;
				 if(EXLClr) CP[SR][1]<=0;
		          //IE CP[SR][0]
				 
				 //Cause///////////////////////
				    //BD CP[Cause][31]
				 if(error) CP[Cause][31]<=BDIn;
				    //IP CP[Cause][15:10]
				 CP[Cause][15:10]<=HWInt;
				    //ExcCode CP[Cause][6:2]
				 if(error) CP[Cause][6:2]<=ExcCode;
				 
				 //EPC////////////////////////
				 if(error) begin
				       if(BDIn) CP[EPC]<=VPC-4;
				       else CP[EPC]<=VPC;
				 end
		 end
end

//Output
assign CP0Out=CP[CP0Add];
assign EPCOut=CP[EPC];
assign Req=	error;	  
	     
endmodule
