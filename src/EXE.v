//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: 
//////////////////////////////////////////////////////////////////////////////////
`include "COMP_ALU.v"
`include "COND_ALU.v"

module EXE (

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

	// To WB for pipeline
	input is_branch_in,			// If the instruction is branch (in)
	output is_branch_out, 		// if the instruction is branch (out)
	input [31:0] pc_in,			// PC in
	output [31:0] pc_out,		// PC out
	input needs_wb,  			// Shows if the instruction needs write-back in
	output needs_wb_out,		// Shows if the instruction needs write-back out
	output is_store_out,		// Shows if the instruction is store (used in memory LD/SW)
	output [31:0] store_data,	// To be written in Memory in SW instructions
	output [3:0] wb_addr,		// To be written in RF in WB
	output is_load_out			// To be written in RF in WB
);

wire [31:0] alu_op1;
reg [31:0] alu_op2;
reg [3:0] alu_opcode;

wire [31:0] alu_out;
wire select_imm;

// The first operand of ALU is fixed
assign alu_op1 = rs1_val;							

// For load/store & I-type & JAL instructions, imm is the sconed operand of the ALU
assign select_imm = instr_type[1] | is_load | is_store; 	

//MUX for selecting ALUs' Operands
always @(select_imm or imm or rs2 or rd or rs1_val or rs2_val) begin
	case(select_imm)
		1'b0: alu_op2    <= rs2_val;
		1'b1: alu_op2    <= imm;
	endcase
end

//MUX for selecting ALUs' Operation and Operands
always @(instr_type or imm or rs2 or rd or rs1_val or rs2_val) begin
	case(instr_type)
		2'b00: begin
			alu_opcode <= imm[3:0];
		end
		2'b01: begin
			alu_opcode <= rd;
		end
		2'b10: begin
			alu_opcode <= rs2;
		end
		default: begin
			alu_opcode <= 4'b0;
		end
	endcase
end

//Computational operations ALU
COMP_ALU comp_alu(
	.opa(alu_op1), 	// First operand
	.opb(alu_op2), 	// Second operand
	.op(alu_opcode),// Operation
	.res(alu_out)	// Result
	);

//Conditional operations ALU
COND_ALU cond_alu(
	.opa(alu_op1), 	// First operand
	.opb(alu_op2), 	// Second operand
	.op(alu_opcode),// Operation
	.z_flag(z_flag)	// Zero flag
	);

//MUX for selecting EXE output
assign exe_out = is_computational ? alu_out : {31'b0,z_flag};


//Pipeline signal passing
assign is_store_out = is_store;
assign is_load_out  = is_load;
assign needs_wb_out = needs_wb;
assign store_data 	= rs2_val;
assign wb_addr		= rd;
assign pc_out 		= pc_in+imm;
assign is_load_out	= is_load;
assign is_branch_out= is_branch_in;

endmodule