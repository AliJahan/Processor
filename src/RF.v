//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Dual port register file - 2 reads and one write at the same time
//////////////////////////////////////////////////////////////////////////////////
module RF(
	input clk,				// Clock
	input [3:0] raddra, 	// Read address port #1
	input [3:0] raddrb, 	// Read address port #2
	input [3:0] waddr, 		// Write address port 
	input [31:0] wdata, 	// Write data port
	input wen, 				// Write enable
	output reg [31:0] douta,// Data read output port #1
	output reg [31:0] doutb	// Data read output port #2
);

	// Register file storage
	reg [31:0] registers[15:0];

	// Synchornous write to RF
	always @(posedge clk) begin
	    if (wen)
	        registers[waddr] <= wdata;
	end

	// Synchronous read from RF
	always @(posedge clk) begin
	    douta <= registers[raddra];
	    doutb <= registers[raddrb];
	end

endmodule