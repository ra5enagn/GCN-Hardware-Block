`include "Combi_FSM.sv"
`include "COO_ADJ_FM_WM.sv"
`include "Matrix_FM_WM_ADJ_Memory.sv"
`include "COO_ADJ_FM_WM_T.sv"
`include "COO_COUNTER_IN.sv"
`include "mux.sv"
module comb_main
	#(
	parameter FEATURE_ROWS = 6,
    	parameter WEIGHT_COLS = 3,
    	parameter DOT_PROD_WIDTH = 16,
	parameter WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    	parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    	parameter ADJ_ROWS = 6,
	parameter COO_IN_WIDTH = $clog2(ADJ_ROWS),
	parameter COO_IN_ROWS = 2,
	parameter COO_COLS = 6,
    parameter COUNTER_COO_WIDTH = $clog2(COO_COLS))
(
	input logic clk,
	input logic reset,
	input logic done_trans,
	input logic [COO_IN_WIDTH-1:0] coo_in [0:COO_IN_ROWS-1],
	input logic [DOT_PROD_WIDTH - 1:0] fm_wm_row_out  [0:WEIGHT_COLS-1],

	output logic done_comb,
	input logic [COO_IN_WIDTH-1:0] read_row,
	output logic [COO_IN_WIDTH-1:0]read_row_FM,
	output logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_out [0:WEIGHT_COLS-1],
	output logic [COUNTER_COO_WIDTH-1:0] coo_address

  );
logic [COUNTER_COO_WIDTH-1:0] coo_count_in;
logic enable_coo_adj_fm_wm;
logic enable_coo_adj_fm_wm_t;
logic en_counter_coo;
logic wr_en;
logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_row_in [0:WEIGHT_COLS-1];
logic [DOT_PROD_WIDTH - 1:0] temp1 [0:WEIGHT_COLS-1];
logic [DOT_PROD_WIDTH - 1:0] temp2 [0:WEIGHT_COLS-1];
logic [COO_IN_WIDTH-1:0] read_fm1;
logic [COO_IN_WIDTH-1:0] read_fm2;
logic [COO_IN_WIDTH-1:0] read_adj_fm1;
logic [COO_IN_WIDTH-1:0] read_adj_fm2;
logic [COO_IN_WIDTH-1:0] read_row_internal1;
logic [COO_IN_WIDTH-1:0] read_row_internal2;
logic [COO_IN_WIDTH-1:0] write_temp1;
logic [COO_IN_WIDTH-1:0] write_temp2;
logic [COO_IN_WIDTH-1:0] write_row;
//logic [COO_IN_WIDTH - 1:0] read_fm_wm_adj_row_in;

COO_ADJ_FM_WM CAFW1 (.clk(clk),.reset(reset),.coo_in(coo_in),.enable_coo_adj_fm_wm(enable_coo_adj_fm_wm),.fm_wm_adj_out(fm_wm_adj_out),.fm_wm_row_out(fm_wm_row_out),.fm_wm_adj_row_in(temp1),.read_fm_wm_row(read_fm1),.read_adj_row(read_adj_fm1),.write_adj_row(write_temp1));
COO_ADJ_FM_WM_T CAFWT1 (.clk(clk),.reset(reset),.coo_in(coo_in),.enable_coo_adj_fm_wm_t(enable_coo_adj_fm_wm_t),.fm_wm_adj_out(fm_wm_adj_out),.fm_wm_row_out(fm_wm_row_out),.fm_wm_adj_row_in(temp2),.read_fm_wm_row(read_fm2),.read_adj_row(read_adj_fm2),.write_adj_row(write_temp2));
Combi_FSM CFSM1 (.clk(clk),.reset(reset),.done_trans(done_trans),.coo_count_in(coo_count_in),.done_comb(done_comb),.coo_address(coo_address),.enable_coo_adj_fm_wm(enable_coo_adj_fm_wm),.enable_coo_adj_fm_wm_t(enable_coo_adj_fm_wm_t),.en_counter_coo(en_counter_coo),.wr_en(wr_en));
COO_COUNTER_IN CCI1 (.clk(clk),.reset(reset),.en_counter_coo(en_counter_coo),.New_Count(coo_count_in));
muxdata md1 (.D0(temp1),.D1(temp2),.S (enable_coo_adj_fm_wm_t),.Y (fm_wm_adj_row_in));//writing the output
mux m1 (.D0(read_fm1), .D1(read_fm2), .S (enable_coo_adj_fm_wm_t),.Y (read_row_FM));//read in location from fm_WM
mux m2 (.D0(read_adj_fm1), .D1(read_adj_fm2), .S (enable_coo_adj_fm_wm_t),.Y (read_row_internal1)); // read in location from adj matrix
mux m3  (.D0(write_temp1), .D1(write_temp2), .S (enable_coo_adj_fm_wm_t),.Y (write_row)); // write in location from adj matrix
mux m4 (.D0(read_row_internal1),.D1(read_row),.S(done_comb),.Y(read_row_internal2));
Matrix_FM_WM_ADJ_Memory MFWAM1 (.clk(clk), .rst(reset),.write_row(write_row),.read_row(read_row_internal2),.wr_en(wr_en),.fm_wm_adj_out(fm_wm_adj_out), .fm_wm_adj_row_in(fm_wm_adj_row_in));

endmodule