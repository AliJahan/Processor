//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: 
//////////////////////////////////////////////////////////////////////////////////
`include "FETCH.v"
`include "DEC.v"
`include "EXE.v"
`include "MEM.v"
`include "WB.v"

module MPIS(
	input clk,
	input nrst
	);
	
wire [31:0] next_pc,  		// Next value of the PC reg
wire [31:0] curr_pc,		// Current PC
wire [31:0] instruction	// Fetched instruction

FETCH fetch_u(
	.clk(),    				// Clock
	.nrst(),					// Active-low reset
	.next_pc(),  		// Next value of the PC reg
	.curr_pc(),		// Current PC
	.instruction()	// Fetched instruction
);

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
output is_store,			// Shows if the instruction is store
output needs_wb,			// Shows if the instruction needs to write-back any data to RF
output is_computational,	// Shows if the instruction uses COMP_ALU or COND_ALU

// To EXE for pipeline
input [31:0] pc_in,			// PC in
output [31:0] pc_out,		// PC out

DEC dec_u(
	.clk(),
	.instruction(),
	.wb_addr(),
	.wb_data(),
	.wb_wen(),
	.rs1_val(),
	.rs2_val(),
	.instr_type(),
	.rs2(),
	.rd(),
	.se_imm(),
	.is_load(),
	.is_store(),
	.needs_wb(),
	.is_computational(),
	.pc_in(),
	.pc_out()
	);

	// From DEC
	input [31:0] rs1_val,		// (RS1)
	input [31:0] rs2_val,		// (RS2)
	input [1:0] instr_type,		// I-type, R-type, or Branch instruction
								// -------------------------------------------------------------------
								// | Value 		| ALU funct from | Operand #1 from | Operand #2 from |
								// -------------------------------------------------------------------
								// | 00 (R-type)  | IMM[3:0]	 | RS1_VAL         | RS2_VAL 		 |
								// | 01 (Branch)  | RD   	     | RS1_VAL         | RS2_VAL		 | 
								// | 10 (I-type)  | RS2	         | RS1_VAL         | IMM             |
								// -------------------------------------------------------------------
	input is_computational,		// Shows if the instruction uses COMP_ALU or COND_ALU
	input is_load,				// Shows if the instruction is load
	input is_store,				// Shows if the instruction is store
	input [3:0] rs2,			// RS2 portion of instrution
	input [3:0] rd,				// RD portion of instrution
	input [31:0] imm,			// Sign extended Immediate

	// To WB and PC system
	output z_flag,				// If the checked condition is true
	output [31:0] exe_out,		// Output of EXE stage, can be branch target or result of calculations

	// To WB for pipeline 		//TODO Is this one necessary? 
	input [31:0] pc_in,			// PC in
	output [31:0] pc_out,		// PC out
	input needs_wb  			// Shows if the instruction needs write-back in
	output needs_wb_out			// Shows if the instruction needs write-back out
	output is_store_out			// Shows if the instruction is store (used in memory LD/SW)

EXE exe_u(
	.rs1_val(),
	.rs2_val(),
	.instr_type(),
	.is_computational(),
	.is_load(),
	.is_store(),
	.rs2(),
	.rd(),
	.imm(),
	.z_flag(),
	.exe_out(),
	.pc_in(),
	.pc_out(),
	.needs_wb(),
	.needs_wb_out(),
	.is_store_out()
	);


	input clk,    			// Clock
	input [31:0] addr,		// Address to/from which the data is written/read  (LW/SW)
	input [31:0] wdata,		// The data to be written, EXE output (SW)
	input needs_wb,			// If the instruction needs WB
	input is_store,			// 
	output [31:0] rdata,	// The data which are read from data cache
	output [31:0] pdata,	// The data from EXE output
	output wb_wen			// If the data are gonna be written in RF

MEM mem_u(
	.clk(),
	.addr(),
	.wdata(),
	.needs_wb(),
	.is_store(),
	.rdata(),
	.pdata(),
	.wb_wen()
	);

	input [31:0] rdata,		// The data which are read from data cache
	input [31:0] pdata,		// The data from EXE output
	input [31:0] dataout,	// The data selected for WB to RF
	input needs_wb,	   		// If the data are gonna be written in RF
	output wen 		   		// Write enable signal to be passed to RF

WB wb_u(
	.rdata(),
	.pdata(),
	.dataout(),
	.needs_wb(),
	.wen()
	);

endmodule 