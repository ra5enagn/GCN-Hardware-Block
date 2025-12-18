module muxdata
	#(parameter DOT_PROD_WIDTH = 16,
	parameter WEIGHT_COLS = 3)
	(input logic [DOT_PROD_WIDTH - 1:0] D0 [0:WEIGHT_COLS-1], //16X3
		input logic [DOT_PROD_WIDTH - 1:0] D1 [0:WEIGHT_COLS-1], 
		input S,
		output logic [DOT_PROD_WIDTH - 1:0] Y [0:WEIGHT_COLS-1]);

assign Y=(S)?D1:D0;

endmodule

module mux
	#(parameter FEATURE_ROWS = 6,
parameter WIDTH = $clog2(FEATURE_ROWS)
	)
	(input logic [WIDTH - 1:0] D0 ,
		input logic [WIDTH - 1:0] D1 , 
		input S,
		output logic [WIDTH - 1:0] Y );

assign Y=(S)?D1:D0;

endmodule