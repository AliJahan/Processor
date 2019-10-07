//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Write-back stage 
//////////////////////////////////////////////////////////////////////////////////
module WB (
	input [31:0] rdata,		// The data which are read from data cache
	input [31:0] pdata,		// The data from EXE output
	input [3:0] wb_addr_in,	// Register address to which the data is going to be written
	input needs_wb,	   		// If the data are gonna be written in RF
	output [31:0] dataout,	// The data selected for WB to RF
	output [3:0] wb_addr_out,// Register address to which the data is going to be written
	output wen 		   		// Write enable signal to be passed to RF
);

assign dataout 		= needs_wb ? rdata : pdata; // wb_wen=1 means the instruction needs wb
assign wen 			= needs_wb;	
assign wb_addr_out 	= wb_addr_in;

endmodule