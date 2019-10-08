//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Write-back stage 
//////////////////////////////////////////////////////////////////////////////////
module WB (
	input [31:0] rdata,        // The data which are read from data cache
	input [31:0] pdata,        // The data from EXE output
	input [3:0] wb_addr_in,    // Register address to which the data is going to be written
	input is_load,             // If the data are gonna be written in RF
	input needs_wb,            // If the data are gonna be written in RF
	output [31:0] dataout,     // The data selected for WB to RF
	output [3:0] wb_addr_out,  // Register address to which the data is going to be written
	output wen                 // Write enable signal to be passed to RF
);

assign dataout 		= is_load ? rdata : pdata;  // If instruction is load, use read data to wb to RF
assign wen 			= needs_wb;                 // 
assign wb_addr_out 	= wb_addr_in;               // Register to which the data are going to be written

endmodule