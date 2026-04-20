module COO_COUNTER_IN
#(
	parameter COO_COLS = 6,
    parameter COUNTER_COO_WIDTH = $clog2(COO_COLS))
(
	input logic clk,
	input logic reset,
	input logic en_counter_coo,
	output logic [COUNTER_COO_WIDTH-1:0] New_Count
	);

logic [COUNTER_COO_WIDTH-1:0] count_value; 
always_ff @(posedge clk or posedge reset)begin
	if (reset)
	count_value <= 0;
	else begin
	 	if (en_counter_coo) begin
	 			count_value <=  count_value + 1;
	 	end
	 end 
end
assign New_Count = count_value;
endmodule