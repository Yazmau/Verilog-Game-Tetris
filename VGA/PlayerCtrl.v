//
//
//
//

module PlayerCtrl (
	input clk,
	input reset,
	output reg [7:0] ibeat
);
parameter BEATLEAGTH = 127;

always @(posedge clk, posedge reset) begin
	if (reset)
		ibeat <= 0;
	else if (ibeat < BEATLEAGTH) 
		ibeat <= ibeat + 1;
	else 
		ibeat <= 0;
end

endmodule

