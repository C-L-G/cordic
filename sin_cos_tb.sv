/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  sin_cos_tb.sv
--Project Name: GitHub
--Data modified: 2015-09-18 17:42:58 +0800
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

sin_cos #(
	.ASIZE		(8		),
	.DSIZE      (8		),
	.RNUM	    (8		)
)sin_cos_tan(
	.clock		(clock		),
	.angle      (70*256/90  ),
	.sin        (           ),
	.cos        (           )
);  



endmodule
                        
