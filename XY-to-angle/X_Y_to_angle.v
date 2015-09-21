/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  X_Y_to_angle.v
--Project Name: cordic
--Data modified: 2015-09-21 14:35:34 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module X_Y_to_angle #(
	parameter	DSIZE	= 16,
	parameter	ASIZE	= 16,
	parameter	RNUM	= 8
)(
	input				clock 		,
	input [DSIZE-1:0]	X			,
	input [DSIZE-1:0]	Y			,
	output[ASIZE-1:0]	angle		,
	output[6:0]			real_angle
);  
  
localparam	RSIZE	= (RNUM > 16)? 16 : RNUM;

wire[DSIZE-0:0]		rot_y 		[RSIZE-1:0]	;
wire[DSIZE-0:0]		rot_y_rel	[RSIZE-1:0]	;
wire[RSIZE-1:0]		shift_en				;
wire[DSIZE-0:0]		rot_x		[RSIZE-1:0]	;
wire[DSIZE-0:0]		rot_x_rel	[RSIZE-1:0]	;


assign	rot_y[0]	= Y;
assign	rot_x[0]	= X;

genvar II;
generate
for(II=0;II<RSIZE;II=II+1)begin:LOOP_BLOCK
rotation_X_Y #(
	.DSIZE		(DSIZE+1	),
	.RNUM		(II         )
)rotation_X_Y_inst(
	.clock		(clock			),
	.X          (rot_x[II]      ),
	.Y          (rot_y[II]      ),
	.X_rel      (rot_x_rel[II]  ),
	.Y_rel      (rot_y_rel[II]  ),
	.cmp_rel    (shift_en[II]   )
);

if(II != (RSIZE-1))begin
assign	rot_y[II+1]	= rot_y_rel[II];
assign	rot_x[II+1]	= rot_x_rel[II];
end
end
endgenerate


wire[ASIZE-1:0]	angle_value		[RSIZE-1:0];
wire[ASIZE-1:0]	angle_rel_value	[RSIZE-1:0];

assign	angle_value[0]	=  {ASIZE{1'b0}};

generate                              
for(II=0;II<RSIZE;II=II+1)begin       
rotation_angle #(                     
	.ASIZE		(ASIZE		),                     
	.RNUM		(II	        )  	        
)rotation_angle_inst(                 
	.clock		(clock 				),
	.en			(shift_en[II]		),
	.angle		(angle_value[II]	),
	.angle_rel	(angle_rel_value[II]) 
);	                                 
if(II != (RSIZE-1))begin
assign	angle_value[II+1]	= angle_rel_value[II];
end
end
endgenerate

assign	angle	= angle_rel_value[RSIZE-1];

wire [ASIZE+7-1:0]	real_angle_mul;
assign	real_angle_mul	=  angle * 90;

assign	real_angle	= real_angle_mul[ASIZE+7-1-:7];

endmodule


 
