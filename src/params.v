//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: ALU Macros
//////////////////////////////////////////////////////////////////////////////////
`define ALU_ADD		4'b0000
`define ALU_SUB		4'b0001
`define ALU_AND 	4'b0100
`define ALU_OR 		4'b0101
`define ALU_XOR 	4'b0110
`define ALU_NAND 	4'b1100
`define ALU_NOR 	4'b1101
`define ALU_NXOR 	4'b1110
`define ALU_MVHI	4'b1011

`define ALU_F 		4'b0000
`define ALU_EQ 		4'b0001
`define ALU_EQZ		4'b0101
`define ALU_LT 		4'b0010
`define ALU_LTZ		4'b0110
`define ALU_LTE		4'b0011
`define ALU_LTEZ	4'b0111
`define ALU_T 		4'b1000
`define ALU_NE		4'b1001
`define ALU_NEZ		4'b1101
`define ALU_GTE 	4'b1010
`define ALU_GTEZ 	4'b1110
`define ALU_GT 		4'b1011

`define ALU_LTE		4'b0111
`define ALU_GTZ		4'b1111