//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: 
//////////////////////////////////////////////////////////////////////////////////
`include "Memory.v"

module FETCH (
	input clk,    				// Clock
	input [31:0] next_pc,  		// Next value of the PC reg
	output [31:0] curr_pc,		// Current PC
	output [31:0] instruction	// Fetched instruction
);

reg [31:0] pc;
always @(posedge clk) begin 
	pc <= next_pc;
end

Memory #(.INIT_MEM_FILE("instructioncache.init")) icache(
	.clk(clk), 
	.raddr(pc), 
	.rdata(instruction), 
	.waddr(32'b0), 
	.wdata(32'b0), 
	.wen(1'b0)
	);

assign curr_pc = pc;

endmodule