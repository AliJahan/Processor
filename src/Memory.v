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

parameter MEM_INIT_FILE = "";
parameter MEM_DUMP_FILE = "";
parameter MEM_SIZE 		= 1<<16;

reg [31:0] mem [0:MEM_SIZE-1];

// //Unsynthesizable part /*
initial begin
	$readmemb(MEM_INIT_FILE, mem);
end
// //Unsynthesizable part */
 
always @(negedge clk) begin 
	if(wen) begin
        $display("Memory: value\t%d\thas been written to address\t%d\tat\t%0t", wdata, waddr, $time); // Unsynthesizable, just for simulation purposes
		                                                                                              // will be removed by synthesis tool
		mem[waddr] <= wdata;
		#1 $writememb(MEM_DUMP_FILE,mem, 0, 1023);  // Unsynthesizable, just for simulation purposes
		                                            // will be removed by synthesis tool
	end
end

always @(negedge clk) begin 
	rdata <= mem[raddr];
end

endmodule 