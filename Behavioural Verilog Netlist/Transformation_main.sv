`include "Transformation_FSM.sv"
`include "Scratch_Pad.sv"
`include "Feature_Counter.sv"
`include "Weight_Counter.sv"
`include "Vector_Multiplier.sv"
`include "Matrix_FM_WM_Memory.sv"

module Transformation_main
	#(parameter FEATURE_COLS = 96,
    parameter WEIGHT_ROWS = 96,
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter FEATURE_WIDTH = 5,
    parameter WEIGHT_WIDTH = 5,
    parameter DOT_PROD_WIDTH = 16,
    parameter ADDRESS_WIDTH = 13,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS)
    )
(
  input logic clk,
  input logic reset,
  input logic start,
  input logic [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1],
  input logic [COUNTER_FEATURE_WIDTH-1 : 0] read_row,


  output logic enable_read, 
  output logic [ADDRESS_WIDTH-1 : 0] read_address,
  output logic [DOT_PROD_WIDTH-1:0] fm_wm_row_out [0:WEIGHT_COLS-1], // 16 X 3
  output logic done
);

  logic enable_write_fm_wm_prod;
  logic enable_write;
  logic enable_scratch_pad;
  logic enable_weight_counter;
  logic enable_feature_counter;
  logic read_feature_or_weight;
  logic [COUNTER_WEIGHT_WIDTH-1:0] weight_count;
  logic [COUNTER_FEATURE_WIDTH-1:0] feature_count;

logic [WEIGHT_WIDTH-1:0] temp1 [0:WEIGHT_ROWS-1];
//logic [WEIGHT_WIDTH-1:0] weight_col_out [0:WEIGHT_ROWS-1]
logic [DOT_PROD_WIDTH-1:0] temp2;
//logic [DOT_PROD_WIDTH-1:0] temp3;

Transformation_FSM TF1 (.clk(clk),.reset(reset),.weight_count(weight_count),.feature_count(feature_count),.start(start),.enable_write_fm_wm_prod(enable_write_fm_wm_prod),.enable_read(enable_read),.enable_write(enable_write),.enable_scratch_pad(enable_scratch_pad),.enable_weight_counter(enable_weight_counter),.enable_feature_counter(enable_feature_counter),.read_feature_or_weight(read_feature_or_weight),.done(done));
Scratch_Pad SP1 (.clk(clk),.reset(reset),.write_enable(enable_scratch_pad),.weight_col_in(data_in),.weight_col_out(temp1));
Vector_Multiplier VM1 (.clk(clk),.reset(reset),.en_r(enable_read),.en_fw(read_feature_or_weight),.w_sp(temp1),.data_in(data_in),.fm_wm_in(temp2));
Feature_Counter FC1 (.clk(clk),.reset(reset),.f_ctr_en(enable_feature_counter),.New_Count(feature_count));
Weight_Counter WC1 (.clk(clk),.reset(reset),.w_ctr_en(enable_weight_counter),.New_Count(weight_count));
Matrix_FM_WM_Memory MF1 (.clk(clk), .rst(reset), .write_row(feature_count), .write_col(weight_count), .read_row (read_row), .wr_en(enable_write_fm_wm_prod), .fm_wm_in(temp2), .fm_wm_row_out(fm_wm_row_out));

always_comb begin
  if (reset)
    read_address <= 0;
  else if (read_feature_or_weight)
    read_address <= feature_count + 13'h200;
    else 
      read_address <= weight_count;
end
//temp3 and temp 4 goes Comb output
endmodule