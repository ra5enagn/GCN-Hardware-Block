module Weight_Counter
#(
	parameter WEIGHT_COLS = 3,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS))
(
	input logic clk,
	input logic reset,
	input logic w_ctr_en,
	output logic [COUNTER_WEIGHT_WIDTH-1:0] New_Count
	);

logic [COUNTER_WEIGHT_WIDTH-1:0] count_value; 
always_ff @(posedge clk or posedge reset)begin
	if (reset)
	count_value <= 0;
	else begin
	 	if (w_ctr_en) begin
	 		if (count_value == WEIGHT_COLS-1)
	 			count_value <= 0;
			else
	 			count_value <=  count_value + 1;

	 	end
	 end 
end
assign New_Count = count_value;
endmodule