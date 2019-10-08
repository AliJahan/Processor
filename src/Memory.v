//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: 
//////////////////////////////////////////////////////////////////////////////////
module Memory(
	input clk,
	input [31:0] raddr,
	output reg [31:0] rdata,
	input [31:0] waddr,
	input [31:0] wdata,
	input wen
);

parameter INIT_MEM_FILE = "data";
parameter EXE_MEM_FILE = "cache_dump";
parameter MEM_SIZE = 1<<32;

reg [31:0] mem [0:MEM_SIZE>>10-1];

// //Unsynthesizable /*
initial begin
	$display("Memory loaded %s", INIT_MEM_FILE);
	$readmemb(INIT_MEM_FILE, mem);
end
// //Unsynthesizable part */
 
always @(negedge clk) begin 
	if(wen) begin
        $display("Memory: value\t%d\thas been written to address\t%d\tat\t%0t", wdata, waddr, $time);
        $writememb(EXE_MEM_FILE,mem, 0, 1023);
		mem[waddr] <= wdata;
	end
end

always @(negedge clk) begin 
	rdata <= mem[raddr];
end

endmodule 