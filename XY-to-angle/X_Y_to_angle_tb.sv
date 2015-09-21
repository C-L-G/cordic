/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  X_Y_to_angle_tb.sv
--Project Name: cordic
--Data modified: 2015-09-21 14:35:34 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module X_Y_to_angle_tb;

bit		clock;

clock_rst clk_c0(
	.clock		(clock),
	.rst		(rst_n)
);

defparam clk_c0.ACTIVE = 0;
initial begin:INITIAL_CLOCK
	clk_c0.run(10 , 1000/100 ,0);		//100	
end

localparam		ASIZE	= 8,
				DSIZE	= 8,
				RNUM	= 8;

logic[DSIZE-1:0]	X,Y;


X_Y_to_angle #(
	.DSIZE		(DSIZE		),
	.ASIZE		(ASIZE      ),
	.RNUM		(RNUM       )		//latency RNUM + 2
)X_Y_to_angle_inst(
	.clock		(clock 		),	
	.X			(X          ),
	.Y			(Y          ),
	.angle      (           )
);   

logic [6:0]		x_data,y_data;

always@(posedge clock)begin
	x_data	= $urandom_range(0,100);
	y_data	= $urandom_range(0,100);
	X		= x_data*2**DSIZE/100;
	Y		= y_data*2**DSIZE/100;
end 


endmodule

