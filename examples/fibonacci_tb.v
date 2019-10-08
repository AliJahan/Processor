//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Testbench for running fibonancci code
//////////////////////////////////////////////////////////////////////////////////
`include "PROCESSOR.v"

module fibonancci_tb;

reg clk;
reg nrst;

Processor #(
			 .DCACHE_INIT_FILE("../examples/fibonacci_data"), 
			 .ICACHE_INIT_FILE("../examples/fibonacci_code.asm"),
			 .DCACHE_DUMP_FILE("../examples/fibonacci_dcache")
		   )
		   processor(
					 .clk(clk), 
					 .nrst(nrst)
		   			);

// Initializations
initial
begin
	clk <= 1'b0;
	nrst <= 1'b0;
	# 20;
	nrst <= 1'b1;
	repeat(100000) @(posedge clk);
	$finish;
end

// Clock Generation
always begin 
	#5 clk <= ~clk;
end 

endmodule 