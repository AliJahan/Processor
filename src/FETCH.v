//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: 
//////////////////////////////////////////////////////////////////////////////////
`include "Memory.v"

module FETCH (
	input clk,                  // Clock
	input nrst,                 // Active-low reset
	input [31:0] branch_target, // Branch target calculated by ALU
	input is_branch,            // Shows if FETCH must update PC with branch_target
	output [31:0] curr_pc,      // Current PC passed to pipeline (DEC is next)
	output [31:0] instruction   // Fetched instruction	passed to DEC
);
	parameter ICACHE_INIT_FILE = "";

	// Synchronous PC update (either +1 or jump to branch target)
	reg [31:0] pc;
	always @(posedge clk) begin 
		if(!nrst)                    // Reset
			pc <= 32'b0;
		else begin
			if(is_branch)            // Jump
				pc <= branch_target;
			else                     // Fetch next instruction
				pc <= pc + 1;
		end
	end

	// Instruction cache
	Memory #(.MEM_INIT_FILE(ICACHE_INIT_FILE)) icache(
		.clk(clk), 
		.raddr(pc), 
		.rdata(instruction), 
		.waddr(32'b0), 
		.wdata(32'b0), 
		.wen(1'b0)
		);

	// Pass PC to pipeline
	assign curr_pc = pc;

endmodule