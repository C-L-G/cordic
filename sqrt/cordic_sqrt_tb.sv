/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  cordic_sqrt_tb.sv
--Project Name: sqrt
--Data modified: 2015-10-19 10:37:36 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module cordic_sqrt_tb;

logic	clock;
logic	rst_n;

clock_rst_verb #(
	.ACTIVE		(0		),	
	.FreqM		(100	)
)clock_rst_verb_inst(
	.clock		(clock	),
	.rst_x		(rst_n	)
);

parameter	DSIZE	= 16;
logic[DSIZE-1:0]	D;
logic[DSIZE-1:0]	Q;

cordic_sqrt #(
	.DSIZE		(DSIZE		)
)cordic_sqrt_inst(
	.clock		(clock 		),
	.rst_n  	(rst_n		),
	.d      	(D			),
	.q          (Q			)
);

real rd,rq;

always@(D,Q)begin
	rd	= 1.00*D/2**DSIZE;
	rq	= 1.00*Q/2**DSIZE;
end

real t = 0.9;
initial begin
	wait(rst_n);
	repeat(2)
		@(posedge clock);
	//@(posedge clock);
	//	D	= 0.6*2**DSIZE;
	//@(posedge clock);
	//	D	= 0.5*2**DSIZE;
	//@(posedge clock);
	//	D	= 0.4*2**DSIZE;
	//@(posedge clock);
	//	D	= 0.3*2**DSIZE;
	repeat(9)begin
		@(posedge clock);
		D	= t*2**DSIZE;
		t = t - 0.1;
	end
end

endmodule


