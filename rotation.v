/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  rotation.v
--Project Name: cordic
--Data modified: 2015-09-21 10:51:22 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module rotation #(
	parameter DSIZE		= 16
)(
	input				clock,
	input				rst_n,
	input [DSIZE-1:0]	idata,
	input [DSIZE-1:0]	comp,
	output[DSIZE-1:0]	odata,
	output				cmp_rel			// not smaller : 1'b1 ; not : 1'b0
);

reg [DSIZE-1:0]	data_reg;

always@(posedge clock,negedge rst_n)
	if(~rst_n)	data_reg	<= {DSIZE{1'b0}};
	else begin
		if(comp > idata)
				data_reg	<= idata;
		else	data_reg	<= idata - comp;
	end   

reg 			cmp_reg;
always@(posedge clock)
	cmp_reg		<= !(comp > idata);

assign	odata	= data_reg;
assign	cmp_rel	= cmp_reg;

endmodule

