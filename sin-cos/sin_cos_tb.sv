/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  sin_cos_tb.sv
--Project Name: cordic
--Data modified: 2015-09-21 14:35:34 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module sin_cos_tb;

bit		clock;

clock_rst clk_c0(
	.clock		(clock),
	.rst		(rst_n)
);

defparam clk_c0.ACTIVE = 0;
initial begin:INITIAL_CLOCK
	clk_c0.run(10 , 1000/100 ,0);		//100	
end

localparam		ASIZE	= 16,
				DSIZE	= 16,
				RNUM	= 8;

logic[ASIZE-1:0]	angle;

sin_cos #(
	.ASIZE		(ASIZE	),
	.DSIZE      (DSIZE  ),
	.RNUM	    (RNUM	)		// latency RUM + 4
)sin_cos_tan(
	.clock		(clock		),
	.angle      (angle 		),
	.sin        (           ),
	.cos        (           )
);  

logic [6:0]		angle_num;

always@(posedge clock)begin
	angle_num	= $urandom_range(0,90);
	angle		= angle_num*2**DSIZE/90;
end



endmodule
                        
