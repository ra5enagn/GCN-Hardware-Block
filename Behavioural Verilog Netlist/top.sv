`include "Transformation_main.sv"
`include "comb_main.sv"
module top 
#(

    	parameter WEIGHT_COLS = 3,
	parameter ADDRESS_WIDTH = 13,
    	parameter DOT_PROD_WIDTH = 16,
    	parameter WEIGHT_WIDTH = 5,
	parameter WEIGHT_ROWS = 96,
    	parameter ADJ_ROWS = 6,
	parameter COO_IN_WIDTH = $clog2(ADJ_ROWS),
	parameter COO_IN_ROWS = 2,
	parameter COO_COLS = 6,
    	parameter COUNTER_COO_WIDTH = $clog2(COO_COLS),
	parameter FEATURE_ROWS = 6,
	parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS)
   
)	
(
	input clk,    // Clock
	input logic reset,
  	input logic start,
  	input logic [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1],
  	input logic [COO_IN_WIDTH-1:0] coo_in [0:COO_IN_ROWS-1],
  	input logic [FEATURE_WIDTH-1:0] read_row,

  	output logic done_comb,
	output logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_out [0:WEIGHT_COLS-1],
	output logic [COUNTER_COO_WIDTH-1:0] coo_address,
	output logic enable_read, 
  	output logic [ADDRESS_WIDTH -1 : 0] read_address // size 3
	
); 
	logic [COO_IN_WIDTH-1 : 0] read_address_fm_wm;  //
	logic [DOT_PROD_WIDTH-1:0] fm_wm_row_out [0:WEIGHT_COLS-1];//16X3
	logic done_tran;

	Transformation_main TM1 (.clk(clk),.reset(reset),.start(start) ,.data_in(data_in),.read_row(read_address_fm_wm),.enable_read(enable_read),.read_address(read_address),.fm_wm_row_out(fm_wm_row_out),.done(done_tran));
	comb_main CM1(.clk(clk),.reset(reset),.done_trans(done_tran),.coo_in(coo_in),.fm_wm_row_out(fm_wm_row_out),.done_comb(done_comb),.read_row_FM(read_address_fm_wm),.fm_wm_adj_out(fm_wm_adj_out),.coo_address(coo_address),.read_row(read_row));
	
endmodule