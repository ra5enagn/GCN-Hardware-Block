module Combi_FSM
	#(parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter DOT_PROD_WIDTH = 16,
    parameter WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter COO_COLS = 6,
    parameter COUNTER_COO_WIDTH = $clog2(COO_COLS)
)
    (
    	input logic clk,
    	input logic reset,
    	input logic done_trans,
    	input logic [COUNTER_COO_WIDTH-1:0] coo_count_in,
    	output logic done_comb,
    	output logic [COUNTER_COO_WIDTH-1:0] coo_address,
    	output logic enable_coo_adj_fm_wm,
    	output logic enable_coo_adj_fm_wm_t,
    	output logic en_counter_coo,
    	output logic wr_en

    	);

typedef enum logic [2:0] {
	START,
    GATHER1,
    STORE1,
	GATHER2,
	STORE2,
	DONE
  } state_c;

state_c current,next;

always_ff @(posedge clk or posedge reset)
	if (reset)
      current <= START;
    else
      current <= next;
  always_comb begin
	case (current)
  	START : begin
  		enable_coo_adj_fm_wm = 1'b0;
  		enable_coo_adj_fm_wm_t = 1'b0;
  		wr_en = 1'b0;
  		done_comb = 1'b0;
  		en_counter_coo = 1'b0;
  	if (done_trans) begin
			next = GATHER1;
		end 
		else begin 
			next = START;
		end 
        	
      end
      GATHER1 : begin

		enable_coo_adj_fm_wm = 1'b1;
  		enable_coo_adj_fm_wm_t = 1'b0;
  		wr_en = 1'b0;
  		done_comb = 1'b0;
  		en_counter_coo = 1'b0;
  		next = STORE1;
      end
      STORE1 : begin
      	enable_coo_adj_fm_wm = 1'b0;
  		enable_coo_adj_fm_wm_t = 1'b0;
  		wr_en = 1'b1;
  		done_comb = 1'b0;
  		en_counter_coo = 1'b0;
		next = GATHER2;
      end

      GATHER2: begin
      	enable_coo_adj_fm_wm = 1'b0;
  		enable_coo_adj_fm_wm_t = 1'b1;
  		wr_en = 1'b0;
  		done_comb = 1'b0;
  		en_counter_coo = 1'b0; 
		next = STORE2; 		
      end
		STORE2: begin
      	enable_coo_adj_fm_wm = 1'b0;
  		enable_coo_adj_fm_wm_t = 1'b1;
  		wr_en = 1'b1;
  		done_comb = 1'b0;
  		en_counter_coo = 1'b1;
  		if (coo_count_in >= COO_COLS - 1) begin
  			next = DONE;
  		end
  		else begin
  			next = GATHER1;
  		end	
		end

      DONE: begin
      	enable_coo_adj_fm_wm = 1'b0;
  		enable_coo_adj_fm_wm_t = 1'b0;
  		wr_en = 1'b0;
  		done_comb = 1'b1;
  		en_counter_coo = 1'b0;
  		next = DONE;
      end
  	endcase
  end

  assign coo_address  = coo_count_in;

endmodule