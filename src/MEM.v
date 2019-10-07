//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Memory stage 
//////////////////////////////////////////////////////////////////////////////////
`include "Memory.v"

module MEM (
	input clk,    			// Clock
	input [31:0] addr,		// Address to/from which the data is written/read  (LW/SW)
	input [31:0] wdata,		// The data to be written, EXE output (SW)
	input needs_wb,			// If the instruction needs WB
	input is_store,			// 
	input [3:0] wb_addr_in,	//
	output [31:0] rdata,	// The data which are read from data cache
	output [31:0] pdata,	// The data from EXE output
	input [3:0] wb_addr_out,	//
	output wb_wen			// If the data are gonna be written in RF

);

Memory #(.INIT_MEM_FILE("datacache.init")) dcache(
	.clk(clk),
	.raddr(addr),
	.rdata(rdata),
	.waddr(addr),
	.wdata(wdata),
	.wen(is_store)
	);

//Pipeline signal passing
assign wb_wen 		= needs_wb;	
assign pdata 		= wdata;		// Bypass data to WB stage if it is not load
assign wb_addr_out 	= wb_addr_in;
endmodule