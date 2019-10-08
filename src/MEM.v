//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Memory stage 
//////////////////////////////////////////////////////////////////////////////////

module MEM (
	input clk,    				// Clock
	input [31:0] addr,			// Address to/from which the data is written/read  (LW/SW)
	input [31:0] wdata,			// The data to be written, EXE output (SW)
	input needs_wb,				// If the instruction needs WB
	input is_store,				// 
	input is_load_in,			// 
	input [3:0] wb_addr_in,		//
	output [31:0] rdata,		// The data which are read from data cache
	output [31:0] pdata,		// The data from EXE output
	output [3:0] wb_addr_out,	//
	output wb_wen,				// If the data are gonna be written in RF
	output is_load_out			// 

);
parameter DCACHE_INIT_FILE = "";
parameter DCACHE_DUMP_FILE = "";

Memory #(
			.MEM_INIT_FILE(DCACHE_INIT_FILE),
			.MEM_DUMP_FILE(DCACHE_DUMP_FILE)
		) 
		dcache(
			.clk(clk),
			.raddr(addr),
			.rdata(rdata),
			.waddr(addr),
			.wdata(wdata),
			.wen(is_store)
		);

//Pipeline signal passing
assign wb_wen 		= needs_wb;	
assign pdata 		= addr;		// Bypass data to WB stage if it is not load
assign wb_addr_out 	= wb_addr_in;
assign is_load_out	= is_load_in;
endmodule