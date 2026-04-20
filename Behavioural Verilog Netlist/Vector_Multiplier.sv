module Vector_Multiplier 
  #(parameter WEIGHT_ROWS = 96,
    parameter WEIGHT_WIDTH = 5,
    parameter DOT_PROD_WIDTH = 16
    )
(

	input logic clk,
	input logic reset,	
	input logic en_fw, // Scratchpad Enable
	input logic en_r, // write enable for MAtrix_FM_WM_Memory
	input logic [WEIGHT_WIDTH-1:0] w_sp [0:WEIGHT_ROWS-1],  // Data from Scratchpad
	input wire [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1], // Feature Data from input
	output logic [DOT_PROD_WIDTH - 1:0] fm_wm_in
);

//logic [DOT_PROD_WIDTH - 1:0] mult_out [0:WEIGHT_ROWS-1];
logic [DOT_PROD_WIDTH - 1:0] multi21;
logic [DOT_PROD_WIDTH - 1:0] multi212 [WEIGHT_ROWS-1:0];
logic [DOT_PROD_WIDTH - 1:0] pp [WEIGHT_ROWS-1:0];
integer j;
always_comb begin
    for(j=0;j<WEIGHT_ROWS;j=j+1) begin
         pp[j] = (w_sp[j]*data_in[j]);
    end
    multi212[0] = pp[0];
    for(j=1;j<WEIGHT_ROWS;j=j+1) begin
         multi212[j] = multi212[j-1] + pp[j];
    end
end

	always @(posedge clk or posedge reset) begin
		if(reset) begin
			 multi21 = 0;
			end
	else if (en_r == 1'b1 && en_fw == 1'b1)
	begin
		multi21 = multi212[WEIGHT_ROWS-1];
	end
end
assign fm_wm_in = multi21;

endmodule
