/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  hyperbola_radix4_ratation_monotone.v
--Project Name: cordic
--Data modified: 2015-10-16 16:37:47 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module hyperbola_radix4_ratation_monotone #(		//latency 3
	parameter	DSIZE	= 17
)(
	input						clock		,
	input [DSIZE-1:0]			IX			,//unsign +1/4<->(1+1/4)
	input signed[DSIZE-1:0]		IY			,//  sign -1/4<->(1-1/4)
	input [5:0]					rotation	,
	input [DSIZE-1:0]			K			,
	output[DSIZE-1:0]			OX          ,
	output signed[DSIZE-1:0]	OY          ,
	output[5:0]					next_rott	,
	output[DSIZE-1:0]			next_K		
);

//----->> K <<---------
localparam [DSIZE-1:0]
	K0	= 1					  * (2**(DSIZE-1)),
	K1	= 1.154700538379252	  * (2**(DSIZE-1)),
   	K2	= 1.032795558988644   * (2**(DSIZE-1)),
   	K3	= 1.007905261357939   * (2**(DSIZE-1)),
   	K4	= 1.001958865736239   * (2**(DSIZE-1)),
   	K5	= 1.000488639169156   * (2**(DSIZE-1)),
   	K6	= 1.000122092668790   * (2**(DSIZE-1)),
   	K7	= 1.000030518975180   * (2**(DSIZE-1)),
   	K8	= 1.000007629481844   * (2**(DSIZE-1)),
   	K9	= 1.000001907354090   * (2**(DSIZE-1)),
   	K10	= 1.000000476837499   * (2**(DSIZE-1)),
   	K11	= 1.000000119209311   * (2**(DSIZE-1)),
   	K12	= 1.000000029802324   * (2**(DSIZE-1)),
   	K13	= 1.000000007450581   * (2**(DSIZE-1)),
   	K14	= 1.000000001862645   * (2**(DSIZE-1)),
   	K15	= 1.000000000465661   * (2**(DSIZE-1)),
   	K16	= 1.000000000116415   * (2**(DSIZE-1)),
   	K17	= 1.000000000029104   * (2**(DSIZE-1)),
   	K18	= 1.000000000007276   * (2**(DSIZE-1)),
   	K19	= 1.000000000001819   * (2**(DSIZE-1)),
   	K20	= 1.000000000000455   * (2**(DSIZE-1));

wire [DSIZE-1:0]	kceoff [0:20];

assign		kceoff[0 ]	= K0	;
assign		kceoff[1 ]	= K1	;
assign	   	kceoff[2 ]	= K2	;
assign	   	kceoff[3 ]	= K3	;
assign	   	kceoff[4 ]	= K4	;
assign	   	kceoff[5 ]	= K5	;
assign	   	kceoff[6 ]	= K6	;
assign	   	kceoff[7 ]	= K7	;
assign	   	kceoff[8 ]	= K8	;
assign	   	kceoff[9 ]	= K9	;
assign	   	kceoff[10]	= K10	;
assign	   	kceoff[11]	= K11	;
assign	   	kceoff[12]	= K12	;
assign	   	kceoff[13]	= K13	;
assign	   	kceoff[14]	= K14	;
assign	   	kceoff[15]	= K15	;
assign	   	kceoff[16]	= K16	;
assign	   	kceoff[17]	= K17	;
assign	   	kceoff[18]	= K18	;
assign	   	kceoff[19]	= K19	;
assign	   	kceoff[20]	= K20	;

//-----<< K >>---------

wire[DSIZE-1:0]			X;
wire signed[DSIZE-1:0]	Y;
latency #(
	.LAT		(1),
	.DSIZE		(DSIZE)
)in_x_lat_inst(
	.clk		(clock		),
	.rst_n		(1'b1		),
	.d			(IX			),
	.q			(X			)
);

latency #(
	.LAT		(1),
	.DSIZE		(DSIZE)
)in_y_lat_inst(
	.clk		(clock		),
	.rst_n		(1'b1		),
	.d			(IY			),
	.q			(Y			)
);

reg signed[DSIZE-1:0]	RX,RY;

always@(posedge clock)begin
	RX	<= IX >>> (rotation);
	if(IY[DSIZE-1])
		RY	<= -IY >> (rotation);
	else
		RY	<=  IY >> (rotation);
end

//--->> 1/2 <<------
reg	up_1_2_px_py;		//up 1/2 positive X positive Y: abs(Y) >= X/2
reg	up_1_2_px_ny; 		//up 1/2 positive x negetive Y

reg[DSIZE-2:0]			X_1_2_1;	//X 1/2 (1)
reg signed[DSIZE-2:0]	Y_1_2_1;	//Y 1/2 (1)

always@(posedge clock)begin
	up_1_2_px_py	<=  Y >= (RX/1); 
	up_1_2_px_ny	<= -Y >= (RX/1); 
	
	X_1_2_1			<= X - (RY>>>0);
	Y_1_2_1			<= Y[DSIZE-1]? Y + (RX>>>0) : Y - (RX>>>0);
end
//---<< 1/2 >>------
//--->> 1/4 <<------
reg	up_1_4_px_py;		//up 1/4 positive X positive Y: abs(Y) >= X/4
reg	up_1_4_px_ny; 		//up 1/4 positive x negetive Y

reg[DSIZE-2:0]			X_1_4_1;	//X 1/4 (1)
reg signed[DSIZE-3:0]	Y_1_4_1;	//Y 1/4 (1)

always@(posedge clock)begin:ROTT_1_4
	up_1_4_px_py	<=  Y >= (RX/2); 
	up_1_4_px_ny	<= -Y >= (RX/2); 

	X_1_4_1			<= X - (RY>>>1);
	Y_1_4_1			<= Y[DSIZE-1]? Y + (RX>>>1) : Y - (RX>>>1);
end   
//---<< 1/4 >>------   
//--->> 1/8 <<------
reg	up_1_8_px_py;		//up 1/8 positive X positive Y: abs(Y) >= X/8
reg	up_1_8_px_ny; 		//up 1/8 positive x negetive Y

reg[DSIZE-2:0]			X_1_8_1;	//X 1/8 (1)
reg signed[DSIZE-3:0]	Y_1_8_1;	//Y 1/8 (1)

always@(posedge clock)begin:ROTT_1_8
	up_1_8_px_py	<=  Y >= (RX/4); 
	up_1_8_px_ny	<= -Y >= (RX/4); 

	X_1_8_1			<= X - (RY>>>2);
	Y_1_8_1			<= Y[DSIZE-1]? Y + (RX>>>2) : Y - (RX>>>2);
end   
//---<< 1/8 >>------   
//--->> 1/16 <<------
reg	up_1_16_px_py;		//up 1/8 positive X positive Y: abs(Y) >= X/16
reg	up_1_16_px_ny; 		//up 1/8 positive x negetive Y

reg[DSIZE-2:0]	X_1_16_1;	//X 1/16 (1)
reg[DSIZE-3:0]	Y_1_16_1;	//Y 1/16 (1)

always@(posedge clock)begin:ROTT_1_16
	up_1_16_px_py	<=  Y >= (RX/8); 
	up_1_16_px_ny	<= -Y >= (RX/8); 

	X_1_16_1		<= X - (RY>>>3);
	Y_1_16_1		<= Y[DSIZE-1]? Y + (RX>>>3) : Y - (RX>>>3);
end   
//---<< 1/16 >>------  
//--->> latency <<--- 
wire[5:0]	rott_lat1;
latency #(
	.LAT		(1	),
	.DSIZE		(6	) 
)rott_lat_inst1(
	.clk		(clock		),
	.rst_n		(rst_n		),
	.d			(rotation	),
	.q			(rott_lat1	)
);

wire[5:0]	rott_lat2;
latency #(
	.LAT		(1	),
	.DSIZE		(6	) 
)rott_lat_inst2(
	.clk		(clock		),
	.rst_n		(rst_n		),
	.d			(rott_lat1	),
	.q			(rott_lat2	)
);

wire[DSIZE-1:0]	k_lat2;
latency #(
	.LAT		(2	),
	.DSIZE		(DSIZE	) 
)rott_lat_inst(
	.clk		(clock		),
	.rst_n		(rst_n		),
	.d			(K			),
	.q			(k_lat2		)
);
//---<< latency >>--- 
//--->> K ceoff <<---

reg [DSIZE-1:0]	K_c[4:1];
always@(posedge clock)begin
	K_c[4]	<= kceoff[rott_lat1+0];
	K_c[3]	<= kceoff[rott_lat1+1];
	K_c[2]	<= kceoff[rott_lat1+2];
	K_c[1]	<= kceoff[rott_lat1+3]; 
end
	
		

reg 		Y_sign;
always@(posedge clock)
	Y_sign	<= Y[DSIZE-1];

reg signed[DSIZE-1:0]		oy_reg;
reg	[DSIZE-1:0]				ox_reg;
reg [5:0]					n_r;
reg	[DSIZE*2-1:0]			ok_reg;

always@(posedge clock)begin
	if(~Y_sign)begin	//positive Y
		casex({up_1_2_px_py,up_1_4_px_py,up_1_8_px_py,up_1_16_px_py})
		4'b1xxx:begin
			ox_reg	<= X_1_2_1;
			oy_reg	<= Y_1_2_1;
			n_r		<= rott_lat2+6'd1;
			ok_reg	<= k_lat2*K_c[4];
		end
		4'b01xx:begin
			ox_reg	<= X_1_4_1;
			oy_reg	<= Y_1_4_1;
			n_r		<= rott_lat2+6'd2;
			ok_reg	<= k_lat2*K_c[3];
		end
		4'b001x:begin
			ox_reg	<= X_1_8_1;
			oy_reg	<= Y_1_8_1;
			n_r		<= rott_lat2+6'd3;
			ok_reg	<= k_lat2*K_c[2];
		end
		4'b0001:begin
			ox_reg	<= X_1_16_1;
			oy_reg	<= Y_1_16_1;
			n_r		<= rott_lat2+6'd4;
			ok_reg	<= k_lat2*K_c[1];
		end
		4'b0000:begin
			ox_reg	<= X;
			oy_reg	<= Y;
			n_r		<= rott_lat2+6'd5;
			ok_reg	<= k_lat2*K0;
		end
		default:begin
			ox_reg	<= X;
			oy_reg	<= Y;
			n_r		<= rott_lat2+6'd5;
			ok_reg	<= k_lat2*K0;
		end
		endcase
	end else begin
		casex({up_1_2_px_ny,up_1_4_px_ny,up_1_8_px_ny,up_1_16_px_ny})
		4'b1xxx:begin
			ox_reg	<= X_1_2_1;
			oy_reg	<= {Y_1_2_1[DSIZE-2],Y_1_2_1};
			n_r		<= rott_lat2+6'd1;
			ok_reg	<= k_lat2*K_c[4];
		end
		4'b01xx:begin
			ox_reg	<= X_1_4_1;
			oy_reg	<= {{2{Y_1_4_1[DSIZE-3]}},Y_1_4_1};
			n_r		<= rott_lat2+6'd2;
			ok_reg	<= k_lat2*K_c[3];
		end
		4'b001x:begin
			ox_reg	<= X_1_8_1;
			oy_reg	<= {{2{Y_1_8_1[DSIZE-3]}},Y_1_8_1};
			n_r		<= rott_lat2+6'd3;
			ok_reg	<= k_lat2*K_c[2];
		end
		4'b0001:begin
			ox_reg	<= X_1_16_1;
			oy_reg	<= {{2{Y_1_16_1[DSIZE-3]}},Y_1_16_1};
			n_r		<= rott_lat2+6'd4;
			ok_reg	<= k_lat2*K_c[1];
		end
		4'b0000:begin
			ox_reg	<= X;
			oy_reg	<= Y;
			n_r		<= rott_lat2+6'd5;
			ok_reg	<= k_lat2*K0;
		end
		default:begin
			ox_reg	<= X;
			oy_reg	<= Y;
			n_r		<= rott_lat2+6'd5;
			ok_reg	<= k_lat2*K0;
		end
		endcase
end end

assign	OX			= ox_reg;
assign	OY			= oy_reg;
assign	next_rott	= n_r;
assign	next_K		= ok_reg[DSIZE-1+:DSIZE];

endmodule


   
   
   
   
   
   
