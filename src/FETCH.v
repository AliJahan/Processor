//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: 
//////////////////////////////////////////////////////////////////////////////////
`include "Memory.v"

module FETCH (
	input clk,   				// Clock
	input nrst,					// Active-low reset
	input [31:0] branch_target,	// Branch target calculated by ALU
	// input [31:0] next_pc,  	// Next value of the PC reg
	input is_branch,
	output [31:0] curr_pc,		// Current PC
	output [31:0] instruction	// Fetched instruction
);

reg [31:0] pc;
always @(posedge clk) begin 
	if(!nrst)
		pc <= 32'b0;
	else begin
		if(is_branch)
			pc <= branch_target;
		else
			pc <= pc + 1;
	end
end

Memory #(.INIT_MEM_FILE("../Assembler/assembly_program.init")) icache(
	.clk(clk), 
	.raddr(pc), 
	.rdata(instruction), 
	.waddr(32'b0), 
	.wdata(32'b0), 
	.wen(1'b0)
	);

assign curr_pc = pc;

endmodule