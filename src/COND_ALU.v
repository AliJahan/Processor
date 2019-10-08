//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: 
//////////////////////////////////////////////////////////////////////////////////
`include "params.v"

module COND_ALU(
	input signed [31:0] opa, // First operand
	input signed [31:0] opb, // Second operand
	input [3:0] op,          // Operation
	output reg z_flag        // Zero flag
);

	always @(opa or opb or op) begin
		case( op )
			`ALU_F:     z_flag <= (opa == opb); //TODO
			`ALU_EQ:    z_flag <= (opa == opb);
			`ALU_EQZ:   z_flag <= (opa == 32'b0);
			`ALU_LT:    z_flag <= (opa < opb);
			`ALU_LTZ:   z_flag <= (opa < $signed(32'b0));
			`ALU_LTE:   z_flag <= (opa <= opb);
			`ALU_LTEZ:  z_flag <= (opa <= $signed(32'b0));
			`ALU_T:     z_flag <= (opa <= opb); //TODO
			`ALU_NE:    z_flag <= ~(opa == opb);
			`ALU_NEZ:   z_flag <= ~(opa == 32'b0);
			`ALU_GTE:   z_flag <= (opa >= opb);
			`ALU_GTEZ:  z_flag <= (opa >= $signed(32'b0));
			`ALU_GT:    z_flag <= (opa > opb);
			`ALU_GTZ:   z_flag <= (opa > $signed(32'b0));
			`ALU_LTEZ:  z_flag <= (opa <= $signed(32'b0));
			default:    z_flag <= 1'b0;
		endcase
	end
endmodule