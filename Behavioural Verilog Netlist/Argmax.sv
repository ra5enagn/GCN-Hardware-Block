module Argmax 
	#(parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter DOT_PROD_WIDTH = 16,
    parameter WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS)
		)
	(
	input logic clk,    // Clock
	input logic reset,  // Asynchronous reset active low
	input logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_out [0:WEIGHT_COLS-1],//the o/p from Mem of combi block
	input logic done_comb,

	output logic done,
	output logic [0:WEIGHT_WIDTH-1] max_addi_ans [0:FEATURE_ROWS-1],
	output logic [FEATURE_WIDTH-1:0] read_row
	
);

	//logic [0:WEIGHT_WIDTH-1] max;
	logic [0:WEIGHT_WIDTH-1] max_addi [0:FEATURE_ROWS-1];
	logic [0:FEATURE_WIDTH-1] count;

	always_ff @(posedge clk or posedge reset) begin
		if(reset) 
		begin
			 done = 0;
			 read_row =0;
			 count = 0;
			 for (int i = 0 ;i < FEATURE_ROWS; i = i+1) 
			 begin
			 	max_addi[i] = 0;
			 end
		end 
		else if (done_comb) begin
			if (count ==6)
				done = 1;
			else begin
			if (fm_wm_adj_out[1] > fm_wm_adj_out[0]) 
			begin
				if (fm_wm_adj_out[2] > fm_wm_adj_out[1]) 
				begin
					max_addi[count] = 2'd2;
				end
				else
					max_addi[count] = 2'd1;
			end
			else if (fm_wm_adj_out[0] > fm_wm_adj_out[2])
				max_addi[count] = 2'd0;
			else 
			begin
				max_addi[count] = 2'd2;
			end
			read_row = count + 1;
			count = read_row;
		end
		end 
	end
assign max_addi_ans = max_addi;
endmodule
