//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Decode stage of the processor
//////////////////////////////////////////////////////////////////////////////////
`include "RF.v"
module DEC(
	input clk,
	input nrst,
	// From FETCH
	input [31:0] instruction,	// Fetched instruction
	// From WB
	input [3:0]  wb_addr,		// WB address
	input [31:0] wb_data,		// WB data
	input wb_wen,				// WB wen
	// To EXE
	output [31:0] rs1_val,		// Value raed from RF from address rs1
	output [31:0] rs2_val,		// Value raed from RF from address rs2
	output [1:0] instr_type,	// I-type, R-type, or Branch instruction (see table below)
								// -------------------------------------------------------------------
								// | Value 		| ALU funct from | Operand #1 from | Operand #2 from |
								// -------------------------------------------------------------------
								// | 00 (R-type)| IMM[3:0]	   	 | RS1_VAL         | RS2_VAL 		 |
								// | 01 (Branch)| RD	         | RS1_VAL         | RS2_VAL		 | 
								// | 10 (I-type)| RS2	         | RS1_VAL         | IMM 			 |
								// -------------------------------------------------------------------
	output [3:0] rs2,			// RS2 portion of instrution
	output [3:0] rd,			// RD portion of instrution
	output [31:0] se_imm,		// Sign extended immediate
	output is_load,				// Shows if the instruction is load
	output is_branch,			// Shows if the instruction is branch
	output is_store,			// Shows if the instruction is store
	output needs_wb,			// Shows if the instruction needs to write-back any data to RF
	output is_computational,	// Shows if the instruction uses COMP_ALU or COND_ALU

	// To EXE for pipeline
	input [31:0] pc_in,			// PC in
	output [31:0] pc_out		// PC out
	);


wire [3:0] opcode;			// Opcode
wire [3:0] rd, rs1, rs2;	// Regs
wire [15:0] imm;			// Immediate

assign opcode 			= instruction[31:28];			//
assign rd				= instruction[27:24];			//
assign rs1				= instruction[23:20];			//
assign rs2				= instruction[19:16];			//
assign imm				= instruction[15:0];			// Immediate
assign se_imm 			= { {16{imm[15]}}, imm[15:0] };	// Sign extended immediate
assign instr_type 		= opcode[3:2];					// Instruction type
assign is_computational = ~opcode[1];					// 
assign is_load 			= opcode[3]  & opcode[0];		//
assign is_store			= !opcode[3]  & opcode[0];		// 
assign needs_wb			= ~opcode[2];					// If the instruction has to be written-back to RF
assign is_branch 		= opcode[1] & opcode[2];		// Branch
RF register_file(
	.clk(clk),
	.nrst(nrst), 
	.raddra(rs1), 
	.raddrb(rs2), 
	.waddr(wb_addr), 
	.wdata(wb_data), 
	.wen(wb_wen), 
	.douta(rs1_val),
	.doutb(rs2_val)
	);


//Pipeline signal passing
assign pc_out = pc_in;

endmodule 