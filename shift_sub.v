/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  shift_sub.v
--Project Name: cordic
--Data modified: 2015-09-21 10:51:22 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module shift_sub #(
	parameter	DSIZE	= 16,
	parameter	SNUM
)(
	input				clock	,
	input				en		,
	input [DSIZE-1:0]	X		,
	input [DSIZE-1:0]	Y		,
	output[DSIZE-1:0]	Z
);

reg [DSIZE:0]	data;

always@(posedge clock)
	if(en)	data	<= X - (Y>>SNUM);
	else	data	<= X;

assign	Z	= data[DSIZE]? {DSIZE{1'b0}} : data[DSIZE-1:0];

endmodule

