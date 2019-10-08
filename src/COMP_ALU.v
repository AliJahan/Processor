//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: For mathematical and bitwise operations, called Computational ALU
//////////////////////////////////////////////////////////////////////////////////
`include "params.v"

module COMP_ALU(
	input signed [31:0] opa, 	 // First operand
	input signed [31:0] opb, 	 // Second operand
	input [3:0] op, 			 // Operation
	output reg signed [31:0] res // Result
);

	always @(opa or opb or op) begin
		case( op )
            `ALU_ADD:   res <= opa + opb;
            `ALU_SUB:   res <= opa - opb;
			`ALU_AND: 	res <= opa & opb;
			`ALU_OR:  	res <= opa | opb;
			`ALU_XOR: 	res <= opa ^ opb;
			`ALU_NAND: 	res <= opa ~& opb;
			`ALU_NOR: 	res <= opa ~| opb;
			`ALU_NXOR: 	res <= opa ~^ opb;
			`ALU_MVHI:	res <= {opb[15:0], 16'b0};
			default: res <= 32'h00000000;
		endcase
	end

endmodule