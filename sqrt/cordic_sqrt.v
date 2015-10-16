/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  cordic_sqrt.v
--Project Name: cordic
--Data modified: 2015-10-16 16:37:47 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module cordic_sqrt #(
	parameter	DSIZE	= 16
)(
	input				clock	,
	input				rst_n   ,
	input [DSIZE-1:0]	d       ,
	output[DSIZE-1:0]	q       
);

reg [DSIZE:0]		X0;		//+1/4<->1+1/4	
reg	[DSIZE:0]		Y0;		//-1/4<->1-1/4

always@(posedge clock,negedge rst_n)begin
	if(~rst_n)begin
		X0	<= {(DSIZE+2){1'b0}};
		Y0	<= {(DSIZE+1){1'b0}};
	end else begin
		X0	<= d + ((2**DSIZE)/4);
		Y0	<= d - ((2**DSIZE)/4);
end end

wire[DSIZE:0]	X			[4:0];
wire[DSIZE:0]	Y			[4:0];
wire[5:0]		rott		[4:0];
wire[DSIZE:0]	K			[4:0];
assign	rott[0]	= 6'd1;
assign	X[0]	= X0;
assign	Y[0]	= Y0;
assign	K[0]	= 2**DSIZE;

hyperbola_radix4_ratation_monotone #(
	.DSIZE		(DSIZE+1		)
)hyperbola_radix4_ratation_inst1(
/*	input				*/	.clock		(clock			),
/*	input [DSIZE-1:0]	*/	.IX			(X   [0]		),	//unsign +1/4<->(1+1/4)
/*	input [DSIZE-1:0]	*/	.IY			(Y   [0]		),	//  sign -1/4<->(1-1/4)
/*	input [5:0]			*/	.rotation	(rott[0]		),
/*	input [DSIZE-1:0]	*/	.K			(K   [0]		),
/*	output[DSIZE-1:0]	*/	.OX         (X   [1]     	),
/*	output[DSIZE-1:0]	*/	.OY         (Y   [1]     	),
/*	output[5:0]			*/	.next_rott	(rott[1]		),
/*	output[DSIZE-1:0]	*/	.next_K		(K   [1]		)
);

hyperbola_radix4_ratation_monotone #(
	.DSIZE		(DSIZE+1		)
)hyperbola_radix4_ratation_inst2(
/*	input				*/	.clock		(clock			),
/*	input [DSIZE-1:0]	*/	.IX			(X   [1]		),	//unsign +1/4<->(1+1/4)
/*	input [DSIZE-1:0]	*/	.IY			(Y   [1]		),	//  sign -1/4<->(1-1/4)
/*	input [5:0]			*/	.rotation	(rott[1]		),
/*	input [DSIZE-1:0]	*/	.K			(K   [1]		),
/*	output[DSIZE-1:0]	*/	.OX         (X   [2]     	),
/*	output[DSIZE-1:0]	*/	.OY         (Y   [2]     	),
/*	output[5:0]			*/	.next_rott	(rott[2]		),
/*	output[DSIZE-1:0]	*/	.next_K		(K   [2]		)
);

hyperbola_radix4_ratation_monotone #(
	.DSIZE		(DSIZE+1		)
)hyperbola_radix4_ratation_inst3(
/*	input				*/	.clock		(clock			),
/*	input [DSIZE-1:0]	*/	.IX			(X   [2]		),	//unsign +1/4<->(1+1/4)
/*	input [DSIZE-1:0]	*/	.IY			(Y   [2]		),	//  sign -1/4<->(1-1/4)
/*	input [5:0]			*/	.rotation	(rott[2]		),
/*	input [DSIZE-1:0]	*/	.K			(K   [2]		),
/*	output[DSIZE-1:0]	*/	.OX         (X   [3]     	),
/*	output[DSIZE-1:0]	*/	.OY         (Y   [3]     	),
/*	output[5:0]			*/	.next_rott	(rott[3]		),
/*	output[DSIZE-1:0]	*/	.next_K		(K   [3]		)
);

hyperbola_radix4_ratation_monotone #(
	.DSIZE		(DSIZE+1		)
)hyperbola_radix4_ratation_inst4(
/*	input				*/	.clock		(clock			),
/*	input [DSIZE-1:0]	*/	.IX			(X   [3]		),	//unsign +1/4<->(1+1/4)
/*	input [DSIZE-1:0]	*/	.IY			(Y   [3]		),	//  sign -1/4<->(1-1/4)
/*	input [5:0]			*/	.rotation	(rott[3]		),
/*	input [DSIZE-1:0]	*/	.K			(K   [3]		),
/*	output[DSIZE-1:0]	*/	.OX         (X   [4]     	),
/*	output[DSIZE-1:0]	*/	.OY         (Y   [4]     	),
/*	output[5:0]			*/	.next_rott	(rott[4]		),
/*	output[DSIZE-1:0]	*/	.next_K		(K   [4]		)
);

wire [DSIZE*2+1:0]	mul_result;
assign	mul_result = X[4] * K[4];

reg [DSIZE-1:0]		Q_reg;

always@(posedge clock)
	Q_reg	<= mul_result[(DSIZE)+:DSIZE];

assign	q	= Q_reg;

endmodule






