//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Next PC calculation, considering branched 
//////////////////////////////////////////////////////////////////////////////////
module PCGen(
	input clk,
	input exe_is_branch, 	 		// Shows if instruction in EXE stage is branch
	input z_flag,					// Shows if branch is taken
	input [31:0] target_pc_in, 	 	// Branch target 
	output jump,					// Forces Fetch stage to jump to tagrget_pc				
	output [31:0] target_pc_out,	// 
	output EXE_flush,				// Determines if EXE stage must be flushed
	output DEC_flush				// Determines if DEC stage must be flushed
);

	reg EXE_flush_reg;
	always @(posedge clk) begin 
		EXE_flush_reg <= exe_is_branch;			// One-cycle delayed flush for EXE stage
	end

	assign 	jump = z_flag & exe_is_branch;		// Jump to target_pc if branch is taken and intruction in EXE is branch
	assign	EXE_flush = jump | EXE_flush_reg;	// Flush EXE stage for two cycles
	assign	DEC_flush = jump;					// Flush DEC stage 
	assign	target_pc_out = target_pc_in;		// Pass the target branch calculated in PC to FETCH

endmodule