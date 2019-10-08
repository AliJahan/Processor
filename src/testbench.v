//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Testbench
//////////////////////////////////////////////////////////////////////////////////
`include "PROCESSOR.v"

module testbench;

reg clk;
reg nrst;
Processor p(.clk(clk), .nrst(nrst));

initial
begin
	clk <= 1'b0;
	nrst <= 1'b0;
	# 20;
	nrst <= 1'b1;
	repeat(500) @(posedge clk);
	$finish;
end

always begin 
	#5 clk <= ~clk;
end 

endmodule 