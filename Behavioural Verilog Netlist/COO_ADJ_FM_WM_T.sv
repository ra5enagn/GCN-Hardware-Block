module COO_ADJ_FM_WM_T
	#(
		parameter ADJ_ROWS = 6,
		parameter WEIGHT_COLS = 3,
		parameter DOT_PROD_WIDTH = 16,
		COO_IN_WIDTH = $clog2(ADJ_ROWS),
		COO_IN_ROWS = 2
		)
	(
		input clk,
		input reset,
		input logic [COO_IN_WIDTH-1:0] coo_in [0:COO_IN_ROWS-1],
		input logic enable_coo_adj_fm_wm_t,
		input logic [DOT_PROD_WIDTH - 1:0] fm_wm_row_out  [0:WEIGHT_COLS-1],
		input logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_out [0:WEIGHT_COLS-1],
		output logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_row_in [0:WEIGHT_COLS-1],
		output logic [COO_IN_WIDTH-1:0] read_fm_wm_row,
		output logic [COO_IN_WIDTH-1:0] read_adj_row,
		output logic [COO_IN_WIDTH-1:0] write_adj_row
		);

	logic [DOT_PROD_WIDTH - 1:0] mul [0:WEIGHT_COLS-1];
	always_comb begin
			read_adj_row = coo_in[1]-1;
			read_fm_wm_row = coo_in [0]-1;
		for (int i = 0; i < WEIGHT_COLS; i = i + 1) begin
				mul[i] = fm_wm_adj_out[i] + fm_wm_row_out[i];
		end
	end
	always_ff @(posedge clk or posedge reset) begin
		if (reset)begin
		for (int j = 0; j< WEIGHT_COLS ; j = j+1)
			fm_wm_adj_row_in [j] <= 0;
			write_adj_row <= 0;
		end

		else if (enable_coo_adj_fm_wm_t) begin
			fm_wm_adj_row_in <= mul;
			write_adj_row <= read_adj_row;
		end
	end
//assign write_adj_row = read_adj_row;
endmodule