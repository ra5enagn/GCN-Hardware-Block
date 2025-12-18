module Feature_Counter
#(
	parameter FEATURE_ROWS = 6,
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS))
(
	input logic clk,
	input logic reset,
	input logic f_ctr_en,
	//input logic [COUNTER_FEATURE_WIDTH-1:0] Old_Count,
	output logic [COUNTER_FEATURE_WIDTH-1:0] New_Count
	);

logic [COUNTER_FEATURE_WIDTH-1:0] count_value; 
always_ff @(posedge clk or posedge reset)begin
	if (reset)
	count_value <= 0;
	else begin
	 	if (f_ctr_en) begin
			if (count_value == FEATURE_ROWS-1)
	 			count_value <= 0;
			else
	 		count_value <=  count_value + 1;
	 	end
	 end 
end

assign New_Count = count_value;

endmodule