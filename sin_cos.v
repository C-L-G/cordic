/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  sin_cos.v
--Project Name: GitHub
--Data modified: 2015-09-18 17:42:58 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module sin_cos #(
	parameter	ASIZE	=	16,
	parameter	DSIZE	= 	16,
	parameter	RNUM	= 	16
)(
	input				clock 	,
	input [ASIZE-1:0]	angle   ,
	output[DSIZE-1:0]	cos		,
	output[DSIZE-1:0]	sin		
);


localparam	RSIZE	= (RNUM > 16)? 16 : RNUM;

// 0' < angle < 90'

localparam		Angle_45		= 45*2**ASIZE		/90,			//atand(1/(2**0))*2**ASIZE
				Angle_26		= 26.5651*2**ASIZE	/90,      //atand(1/(2**1))*2**ASIZE
				Angle_14		= 14.0362*2**ASIZE	/90,      //atand(1/(2**2))*2**ASIZE
				Angle_7			= 7.1250*2**ASIZE	/90,       //atand(1/(2**3))*2**ASIZE
				Angle_3			= 3.5763*2**ASIZE	/90,       //atand(1/(2**4))*2**ASIZE
				Angle_1_7899	= 1.7899*2**ASIZE	/90,       //atand(1/(2**5))*2**ASIZE
				Angle_0_8952	= 0.8952*2**ASIZE	/90,       //atand(1/(2**6))*2**ASIZE
				Angle_0_4476	= 0.4476*2**ASIZE	/90,       //atand(1/(2**7))*2**ASIZE
				Angle_0_2238	= 0.2238*2**ASIZE	/90,       //atand(1/(2**8))*2**ASIZE
				Angle_0_1119	= 0.1119*2**ASIZE	/90,
				Angle_0_0560	= 0.0560*2**ASIZE	/90,
				Angle_0_0280	= 0.0280*2**ASIZE	/90,    	
                Angle_0_0140    = 0.0140*2**ASIZE	/90,
                Angle_0_0070    = 0.0070*2**ASIZE	/90,
                Angle_0_0035    = 0.0035*2**ASIZE	/90,
                Angle_0_0017    = 0.0017*2**ASIZE	/90,
                Angle_0_0009    = 0.0009*2**ASIZE	/90;

wire [ASIZE-1:0]	ANGLE [16:0];

assign	ANGLE [ 0]	= Angle_45				;    
assign	ANGLE [ 1]	= Angle_26	            ;
assign	ANGLE [ 2]	= Angle_14	            ;
assign	ANGLE [ 3]	= Angle_7		        ;
assign	ANGLE [ 4]	= Angle_3		        ;
assign	ANGLE [ 5]	= Angle_1_7899          ;
assign	ANGLE [ 6]	= Angle_0_8952          ;
assign	ANGLE [ 7]	= Angle_0_4476          ;
assign	ANGLE [ 8]	= Angle_0_2238          ;
assign	ANGLE [ 9]	= Angle_0_1119          ;
assign	ANGLE [10]	= Angle_0_0560          ;
assign	ANGLE [11]	= Angle_0_0280          ;
assign	ANGLE [12]	= Angle_0_0140          ;
assign	ANGLE [13]	= Angle_0_0070          ;
assign	ANGLE [14]	= Angle_0_0035          ;
assign	ANGLE [15]	= Angle_0_0017          ;
assign	ANGLE [16]	= Angle_0_0009          ;


wire[ASIZE-1:0]		angle_value	[RSIZE-1:0];
wire[ASIZE-1:0]		angle_rotate_result [RSIZE-1:0];	//unsigned
reg [RSIZE-1:0]		rotation_occure;
wire[RSIZE-1:0]		shift_en;			


assign	angle_value[0] = angle;
genvar II;

generate
for(II=0;II<RSIZE;II=II+1)begin:LOOP_BLOCK
rotation #(
	.DSIZE			(ASIZE)
)rotation_inst(
	.clock			(clock						),
	.rst_n          (1'b1						),
	.idata          (angle_value[II]			),
	.comp           (ANGLE[II]					),
	.odata          (angle_rotate_result[II]	),
	.cmp_rel		(shift_en[II]				)
);

if(II != (RSIZE-1))begin
assign	angle_value[II+1]	= angle_rotate_result[II];
end
end
endgenerate

wire[DSIZE:0]	xcoords_value 	[RSIZE-1:0];
wire[DSIZE:0]	ycoords_value	[RSIZE-1:0];
wire[DSIZE:0]	x_shift_result [RSIZE-1:0];
wire[DSIZE:0]	y_shift_result [RSIZE-1:0];

assign	xcoords_value[0]	= 1'b1<<DSIZE;
assign	ycoords_value[0]	= {DSIZE{1'b0}};


generate
for (II = 0;II<RSIZE;II=II+1)begin:SHIFT_BLOCK
shift_sub #(
	.DSIZE		(DSIZE+1		),
	.SNUM 		(II				)
)shift_sub_inst(
	.clock		(clock					),
	.en			(shift_en[II]           ),
	.X			(xcoords_value[II]          ),
	.Y			(ycoords_value[II]          ),
	.Z      	(x_shift_result[II]   )
);

shift_add #(
	.DSIZE		(DSIZE+1		),
	.SNUM 		(II				)
)shift_add_inst(
	.clock		(clock					),
	.en			(shift_en[II]           ),
	.X			(ycoords_value[II]          ),
	.Y			(xcoords_value[II]          ),
	.Z      	(y_shift_result[II]   )
);

if(II != (RSIZE-1))begin
assign	ycoords_value[II+1] = y_shift_result[II];
assign	xcoords_value[II+1]	= x_shift_result[II];
end
end
endgenerate

wire[DSIZE-1:0]		cos_coeff [RSIZE-1:0];
wire[DSIZE-1:0]		cos_coeff_result [RSIZE-1:0];
assign	cos_coeff[0]	= {DSIZE{1'b1}};

generate
for(II=0;II<RSIZE;II=II+1)begin:COS_COEFF_BLOCK
collect_cos #(
	.DSIZE			(DSIZE		),
	.SEL			(II			)
)collect_cos_inst(
	.clock			(clock					),
	.en				(shift_en[II]           ),
	.X				(cos_coeff[II]          ),
	.Y      		(cos_coeff_result[II]   )
);

if(II != (RSIZE-1))begin
assign	 cos_coeff[II+1] = cos_coeff_result[II];
end
end
endgenerate


assign	cos	= x_shift_result[RSIZE-1][DSIZE-:DSIZE];
assign	sin	= y_shift_result[RSIZE-1][DSIZE-:DSIZE];

endmodule






