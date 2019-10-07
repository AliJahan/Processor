//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Write-back stage 
//////////////////////////////////////////////////////////////////////////////////
module WB (
	input [31:0] rdata,		// The data which are read from data cache
	input [31:0] pdata,		// The data from EXE output
	input [31:0] dataout,	// The data selected for WB to RF
	input needs_wb,	   		// If the data are gonna be written in RF
	output wen 		   		// Write enable signal to be passed to RF
);

assign dataout = needs_wb ? rdata : pdata; // wb_wen=1 means the instruction needs wb
assign wen = needs_wb;	

endmodule