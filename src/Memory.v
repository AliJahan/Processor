//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: 
//////////////////////////////////////////////////////////////////////////////////
module MEM(
	input clk,
	input [31:0] raddr,
	output reg [31:0] rdata,
	input [31:0] waddr,
	input [31:0] wdata,
	input wen,
);

parameter INIT_MEM_FILE = "data";
parameter MEM_SIZE = 1<<32;

reg [MEM_SIZE-1:0] mem [31:0];

//Unsynthesizable /*
initial begin
	$readmemh(INIT_MEM_FILE, mem);
end
//Unsynthesizable part */
 
always @(negedge clk) begin 
	if(wen) begin
		mem[waddr] <= wdata;
	rdata <= mem[raddr];
end

endmodule 