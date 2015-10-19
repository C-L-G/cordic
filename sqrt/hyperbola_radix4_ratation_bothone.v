/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  hyperbola_radix4_ratation_bothone.v
--Project Name: sqrt
--Data modified: 2015-10-19 10:37:36 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module hyperbola_radix4_ratation_bothone #(
	parameter	DSIZE	= 17
)(
	input						clock		,
	input [DSIZE-1:0]			IX			,//unsign +1/4<->(1+1/4)
	input signed[DSIZE-1:0]		IY			,//  sign -1/4<->(1-1/4)
	input [5:0]					rotation	,
	input [DSIZE-1:0]			K			,
	output[DSIZE-1:0]			OX          ,
	output signed[DSIZE-1:0]	OY          ,
	output [5:0]				next_rott	,
	output[DSIZE-1:0]			next_K
);


//--->> ANCHOR <<---------
reg [DSIZE-2:0]	Y_abs;
always@(posedge clock)begin
	Y_abs	<= IY[DSIZE-1]? -IY : IY;
end

reg	[DSIZE-1:0]	RX_lat1;

always@(posedge clock)
	RX_lat1	<= IX >>> rotation;

reg[DSIZE-1:0]	X_1_2_A;
reg[DSIZE-1:0]	X_1_4_A;
reg[DSIZE-1:0]	X_1_8_A;
reg[DSIZE-1:0]	X_1_16_A;

always@(posedge clock)begin
	X_1_2_A	<= Y_abs - (RX_lat1>>>0);
	X_1_4_A	<= Y_abs - (RX_lat1>>>1);
	X_1_8_A	<= Y_abs - (RX_lat1>>>2);
	X_1_16_A<= Y_abs - (RX_lat1>>>3);
end

reg[DSIZE-2:0]	ABS_X_1_2_A;
reg[DSIZE-2:0]	ABS_X_1_4_A;
reg[DSIZE-2:0]	ABS_X_1_8_A;
reg[DSIZE-2:0]	ABS_X_1_16_A; 

always@(posedge clock)begin
	ABS_X_1_2_A		<= X_1_2_A	[DSIZE-1]? (2**(DSIZE-1))-X_1_2_A 	[DSIZE-2:0] : X_1_2_A	[DSIZE-2:0];		
	ABS_X_1_4_A     <= X_1_4_A	[DSIZE-1]? (2**(DSIZE-1))-X_1_4_A	[DSIZE-2:0] : X_1_4_A	[DSIZE-2:0];
	ABS_X_1_8_A     <= X_1_8_A	[DSIZE-1]? (2**(DSIZE-1))-X_1_8_A	[DSIZE-2:0] : X_1_8_A	[DSIZE-2:0];
	ABS_X_1_16_A    <= X_1_16_A [DSIZE-1]? (2**(DSIZE-1))-X_1_16_A  [DSIZE-2:0] : X_1_16_A  [DSIZE-2:0];
end

reg [5:0]	cmp_x_n;

always@(posedge clock)begin
	cmp_x_n[5]	<= ABS_X_1_2_A <= ABS_X_1_4_A;
	cmp_x_n[4]	<= ABS_X_1_2_A <= ABS_X_1_8_A;
	cmp_x_n[3]	<= ABS_X_1_2_A <= ABS_X_1_16_A;
	cmp_x_n[2]	<= ABS_X_1_4_A <= ABS_X_1_8_A;
	cmp_x_n[1]	<= ABS_X_1_4_A <= ABS_X_1_16_A;
	cmp_x_n[0]	<= ABS_X_1_8_A <= ABS_X_1_16_A;
end
//---<< ANCHOR >>---------
//--->> LATENCY <<--------
wire[DSIZE-1:0]			X_lat3;
wire signed[DSIZE-1:0]	Y_lat3;
latency #(
	.LAT		(3),
	.DSIZE		(DSIZE)
)X_lat_inst(
	.clk		(clock		),
	.rst_n		(1'b1		),
	.d			(IX			),
	.q			(X_lat3		)
);

latency #(
	.LAT		(3),
	.DSIZE		(DSIZE)
)Y_lat_inst(
	.clk		(clock		),
	.rst_n		(1'b1		),
	.d			(IY			),
	.q			(Y_lat3		)
);

wire[DSIZE-1:0]			X_lat4;
wire signed[DSIZE-1:0]	Y_lat4;

latency #(
	.LAT		(1),
	.DSIZE		(DSIZE)
)X_lat4_inst(
	.clk		(clock		),
	.rst_n		(1'b1		),
	.d			(X_lat3		),
	.q			(X_lat4		)
);

latency #(
	.LAT		(1),
	.DSIZE		(DSIZE)
)Y_lat4_inst(
	.clk		(clock		),
	.rst_n		(1'b1		),
	.d			(Y_lat3		),
	.q			(Y_lat4		)
);

wire [5:0]	rott_lat4;
wire [5:0]	rott_lat3;

latency #(
	.LAT		(3),
	.DSIZE		(6)
)R_lat4_int(
	.clk		(clock		),
	.rst_n		(1'b1		),
	.d			(rotation	),
	.q			(rott_lat3	)
);

latency #(
	.LAT		(1),
	.DSIZE		(6)
)R_lat4_inst(
	.clk		(clock		),
	.rst_n		(1'b1		),
	.d			(rott_lat3	),
	.q			(rott_lat4	)
);

reg [DSIZE-1:0]	RX,RY;

always@(posedge clock)begin
	RX	<= X_lat3 >>> rott_lat3;
	if(Y_lat3[DSIZE-1])
		RY	<= -Y_lat3 >> rott_lat3;
	else
		RY	<=  Y_lat3 >> rott_lat3;
end

wire[DSIZE-1:0]	K_lat4;

latency #(
	.LAT		(4),
	.DSIZE		(DSIZE)
)K_lat4_int(
	.clk		(clock		),
	.rst_n		(1'b1		),
	.d			(K			),
	.q			(K_lat4		)
);
//---<< LATENCY >>--------
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

reg [DSIZE-1:0]	K_c[4:1];
always@(posedge clock)begin
	K_c[4]	<= kceoff[rott_lat3+0];
	K_c[3]	<= kceoff[rott_lat3+1];
	K_c[2]	<= kceoff[rott_lat3+2];
	K_c[1]	<= kceoff[rott_lat3+3]; 
end

//-----<< K >>---------
//--->> ROTATION <<-------
reg	[DSIZE-1:0]			x_reg,y_reg;
reg	[5:0]				n_r;
reg	[DSIZE*2-1:0]		ok_reg;

always@(posedge clock)begin
	casex(cmp_x_n)
	6'b111xxx:begin
		x_reg	<= X_lat4 - (RY>>>0);
		y_reg	<= Y_lat4[DSIZE-1]? Y_lat4 + (RX>>>0) : Y_lat4 - (RX>>>0);
		n_r		<= rott_lat4 + 6'd1;
		ok_reg	<= K_lat4 * K_c[4];
	end
	6'b0xx11x:begin
		x_reg	<= X_lat4 - (RY>>>1);
		y_reg	<= Y_lat4[DSIZE-1]? Y_lat4 + (RX>>>1) : Y_lat4 - (RX>>>1);
		n_r		<= rott_lat4 + 6'd2;
		ok_reg	<= K_lat4 * K_c[3];
	end
	6'bx0x0x1:begin
		x_reg	<= X_lat4 - (RY>>>2);
		y_reg	<= Y_lat4[DSIZE-1]? Y_lat4 + (RX>>>2) : Y_lat4 - (RX>>>2);
		n_r		<= rott_lat4 + 6'd3;
		ok_reg	<= K_lat4 * K_c[2];
	end
	6'bxx0x00:begin
		x_reg	<= X_lat4 - (RY>>>3);
		y_reg	<= Y_lat4[DSIZE-1]? Y_lat4 + (RX>>>3) : Y_lat4 - (RX>>>3);
		n_r		<= rott_lat4 + 6'd4;
		ok_reg	<= K_lat4 * K_c[1];
	end
	default:begin
		x_reg	<= X_lat4;
		y_reg	<= Y_lat4;
		n_r		<= rott_lat4 + 6'd5;
		ok_reg	<= K_lat4 * K0;
	end
	endcase
end

//---<< ROTATION >>-------

assign	OX			= x_reg;
assign	OY			= y_reg;
assign	next_rott	= n_r;
assign	next_K		= ok_reg[DSIZE-1+:DSIZE];

endmodule


   
   
   
   
   
   
