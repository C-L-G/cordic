/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  rotation_X_Y.v
--Project Name: cordic
--Data modified: 2015-09-21 14:35:34 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module rotation_X_Y #(
	parameter	DSIZE	= 16,
	parameter	RNUM	= 8
)(
	input				clock		,
	input [DSIZE-1:0]	X           ,
	input [DSIZE-1:0]	Y           ,
	output[DSIZE-1:0]	X_rel       ,
	output[DSIZE-1:0]	Y_rel       ,
	output				cmp_rel
);


reg [DSIZE-1:0]	x_reg,y_reg;

wire[DSIZE-1:0]	x_shift_data	= X >> RNUM;
wire[DSIZE-1:0]	y_shift_data	= Y >> RNUM;
wire			cmp_result	;
assign			cmp_result		= !(x_shift_data > Y);

always@(posedge clock)begin
	if(cmp_result )begin
		y_reg	<= Y - x_shift_data;
		x_reg	<= X + y_shift_data;
	end else begin
		y_reg	<= Y;
		x_reg	<= X;
end end

reg 		cmp_rel_reg;

always@(posedge clock)
	cmp_rel_reg	<= cmp_result;

assign	cmp_rel	= cmp_rel_reg;
assign	X_rel	= x_reg;
assign	Y_rel	= y_reg;

endmodule











