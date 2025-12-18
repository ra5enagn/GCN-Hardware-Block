`include "top.sv"
`include "Argmax.sv"

module GCN
	#(

    parameter WEIGHT_COLS = 3,
	parameter ADDRESS_WIDTH = 13,
    parameter DOT_PROD_WIDTH = 16,
	parameter WEIGHT_ROWS = 96,
    parameter ADJ_ROWS = 6,
    parameter FEATURE_ROWS = 6,
	parameter COO_IN_WIDTH = $clog2(ADJ_ROWS),
	parameter COO_IN_ROWS = 2,
	parameter COO_COLS = 6,
    parameter COUNTER_COO_WIDTH = $clog2(COO_COLS),
    parameter WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS)
    )

    (
    	input logic clk,
    	input logic reset,
    	input logic start,
  		input logic [4:0] data_in [0:WEIGHT_ROWS-1],
  		input logic [COO_IN_WIDTH-1:0] coo_in [0:COO_IN_ROWS-1],

  		output logic done,
  		output logic enable_read,
		output logic [0:WEIGHT_WIDTH-1] max_addi_answer [0:FEATURE_ROWS-1],
		output logic [COUNTER_COO_WIDTH-1:0] coo_address,
		output logic [ADDRESS_WIDTH -1 : 0] read_address

    	);	
    logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_out [0:WEIGHT_COLS-1];
    logic done_comb;
    logic [FEATURE_WIDTH-1:0] read_row;


    top t1 (.clk(clk),.reset(reset),.start(start),.coo_in(coo_in),.data_in(data_in),.done_comb(done_comb),.fm_wm_adj_out(fm_wm_adj_out),.coo_address(coo_address),.enable_read(enable_read),.read_address(read_address),.read_row(read_row));
    Argmax ag1 (.clk(clk),.reset(reset),.done_comb(done_comb),.fm_wm_adj_out(fm_wm_adj_out),.done(done),.read_row(read_row),.max_addi_ans(max_addi_answer));
endmodule