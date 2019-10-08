//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: Dual port register file - 2 reads and one write at the same time
//////////////////////////////////////////////////////////////////////////////////
module RF(
	input clk,				// Clock
	input nrst,
	input [3:0] raddra, 	// Read address port #1
	input [3:0] raddrb, 	// Read address port #2
	input [3:0] waddr, 		// Write address port 
	input [31:0] wdata, 	// Write data port
	input wen, 				// Write enable
	output reg [31:0] douta,// Data read output port #1
	output reg [31:0] doutb	// Data read output port #2
);

	// Register file storage
	reg [31:0] registers [0:15];
	integer i;
	// Synchornous write to RF
	always @(negedge clk) begin
		if (!nrst) begin
			for(i=0;i<16;i = i+1)
				registers[i] <= 32'b0;
		end 
	    else begin
	    	if (wen) begin
		        $display("RF: value\t%d\thas been written to address\t%d\tat\t%0t", wdata, waddr, $time);
		        registers[waddr] <= wdata;
	    	end
	    end

	end

	// Synchronous read from RF
	always @(negedge clk) begin
	    douta <= registers[raddra];
	    doutb <= registers[raddrb];
	end

endmodule