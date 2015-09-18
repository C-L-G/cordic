/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  collect_cos.v
--Project Name: GitHub
--Data modified: 2015-09-18 17:42:58 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module collect_cos #(
	parameter		DSIZE	= 16,
	parameter		SEL		= 16
)(
	input				clock	,
	input				en		,
	input [DSIZE-1:0]	X		,
	output[DSIZE-1:0]	Y
);


localparam		COS_45_000		=  0.7071 * 2**DSIZE,      
                COS_26_565      =  0.8944 * 2**DSIZE,
                COS_14_036      =  0.9701 * 2**DSIZE,
                COS_7_1250      =  0.9923 * 2**DSIZE,
                COS_3_5763      =  0.9981 * 2**DSIZE,
                COS_1_7899      =  0.9995 * 2**DSIZE,
                COS_0_8952      =  0.9999 * 2**DSIZE,
                COS_0_4476      =  1.0000 * 2**DSIZE,
                COS_0_2238      =  1.0000 * 2**DSIZE,
                COS_0_1119      =  1.0000 * 2**DSIZE,
                COS_0_0560      =  1.0000 * 2**DSIZE,
                COS_0_0280      =  1.0000 * 2**DSIZE,
                COS_0_0140      =  1.0000 * 2**DSIZE,
                COS_0_0070      =  1.0000 * 2**DSIZE,
                COS_0_0035      =  1.0000 * 2**DSIZE,
                COS_0_0017      =  1.0000 * 2**DSIZE,
	            COS_0_0009	    =  1.0000 * 2**DSIZE;


wire [DSIZE:0]	cos_cf [16:0]	;

assign	cos_cf[ 0]	= COS_45_000		;
assign	cos_cf[ 1]	= COS_26_565		;
assign	cos_cf[ 2]	= COS_14_036		;
assign	cos_cf[ 3]	= COS_7_1250		;
assign	cos_cf[ 4]	= COS_3_5763		;
assign	cos_cf[ 5]	= COS_1_7899		;
assign	cos_cf[ 6]	= COS_0_8952		;
assign	cos_cf[ 7]	= COS_0_4476		;
assign	cos_cf[ 8]	= COS_0_2238		;
assign	cos_cf[ 9]	= COS_0_1119		;
assign	cos_cf[10]	= COS_0_0560		;
assign	cos_cf[11]	= COS_0_0280		;
assign	cos_cf[12]	= COS_0_0140		;
assign	cos_cf[13]	= COS_0_0070		;
assign	cos_cf[14]	= COS_0_0035		;
assign	cos_cf[15]	= COS_0_0017		;
assign	cos_cf[16]	= COS_0_0009		;

localparam [4:0]	SM = (SEL > 16)? 16 : SEL; 


reg [2*DSIZE-1:0]		mul_data;

always@(posedge clock)
	case(SM)
	5'd0	: mul_data	<= en? X * cos_cf[ 0]	: X << DSIZE ;
	5'd1    : mul_data	<= en? X * cos_cf[ 1]   : X << DSIZE ;
    5'd2    : mul_data	<= en? X * cos_cf[ 2]   : X << DSIZE ;
    5'd3    : mul_data	<= en? X * cos_cf[ 3]   : X << DSIZE ;
    5'd4    : mul_data	<= en? X * cos_cf[ 4]   : X << DSIZE ;
    5'd5    : mul_data	<= en? X * cos_cf[ 5]   : X << DSIZE ;
    5'd6    : mul_data	<= en? X * cos_cf[ 6]   : X << DSIZE ;
    5'd7    : mul_data	<= en? X * cos_cf[ 7]   : X << DSIZE ;
    5'd8    : mul_data	<= en? X * cos_cf[ 8]   : X << DSIZE ;
    5'd9    : mul_data	<= en? X * cos_cf[ 9]   : X << DSIZE ;
    5'd10   : mul_data	<= en? X * cos_cf[10]   : X << DSIZE ;
    5'd11   : mul_data	<= en? X * cos_cf[11]   : X << DSIZE ;
    5'd12   : mul_data	<= en? X * cos_cf[12]   : X << DSIZE ;
    5'd13   : mul_data	<= en? X * cos_cf[13]   : X << DSIZE ;
    5'd14   : mul_data	<= en? X * cos_cf[14]   : X << DSIZE ;
	5'd15   : mul_data	<= en? X * cos_cf[15]   : X << DSIZE ;
	5'd16   : mul_data	<= en? X * cos_cf[16]   : X << DSIZE ;  
	default : mul_data	<= X << DSIZE;
	endcase


assign	Y = mul_data[2*DSIZE-1-:DSIZE];


endmodule

