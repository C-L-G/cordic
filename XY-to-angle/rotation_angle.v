/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  rotation_angle.v
--Project Name: cordic
--Data modified: 2015-09-21 14:35:34 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module rotation_angle #(
	parameter	ASIZE	= 16,
	parameter	RNUM	= 8
)(
	input				clock		,
	input				en			,
	input [ASIZE-1:0]	angle		,
	output[ASIZE-1:0]	angle_rel	
);

localparam	Angle_45		= 45*2**     (1*ASIZE)	/90,
            Angle_26		= 26.5651*2**(1*ASIZE)	/90,
            Angle_14		= 14.0362*2**(1*ASIZE)	/90,
            Angle_7			= 7.1250*2** (1*ASIZE)	/90,
            Angle_3			= 3.5763*2** (1*ASIZE)	/90,
            Angle_1_7899	= 1.7899*2** (1*ASIZE)	/90,
            Angle_0_8952	= 0.8952*2** (1*ASIZE)	/90,
            Angle_0_4476	= 0.4476*2** (1*ASIZE)	/90,
            Angle_0_2238	= 0.2238*2** (1*ASIZE)	/90,
            Angle_0_1119	= 0.1119*2** (1*ASIZE)	/90,
            Angle_0_0560	= 0.0560*2** (1*ASIZE)	/90,
            Angle_0_0280	= 0.0280*2** (1*ASIZE)	/90,
            Angle_0_0140    = 0.0140*2** (1*ASIZE)	/90,
            Angle_0_0070    = 0.0070*2** (1*ASIZE)	/90,
            Angle_0_0035    = 0.0035*2** (1*ASIZE)	/90,
            Angle_0_0017    = 0.0017*2** (1*ASIZE)	/90,
            Angle_0_0009    = 0.0009*2** (1*ASIZE)	/90;

localparam	RSEL	= (RNUM > 16)? 16 : RNUM; 

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

reg [ASIZE-1:0]		angle_reg;

always@(posedge clock)
	angle_reg	<= en? angle + ANGLE[RSEL] : angle;


assign	angle_rel	= angle_reg;

endmodule

