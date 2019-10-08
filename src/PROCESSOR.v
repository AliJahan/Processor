//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: MPIS 5-stage processor
//////////////////////////////////////////////////////////////////////////////////
`include "FETCH.v"
`include "DEC.v"
`include "EXE.v"
`include "MEM.v"
`include "WB.v"
`include "PCGen.v"

module Processor(
		input clk,
		input nrst
	);
	parameter DCACHE_INIT_FILE = "";
	parameter ICACHE_INIT_FILE = "";
	parameter DCACHE_DUMP_FILE = "";
	//////////////////////////////////////////////////////////////////////////
	// Stages 
	//////////////////////////////////////////////////////////////////////////
	/////////////// Fetch Stage ///////////////
	reg [31:0] FETCH_branch_target;
	wire [31:0] FETCH_curr_pc;
	wire [31:0] FETCH_instruction;
	reg FETCH_is_branch;

	FETCH #(.ICACHE_INIT_FILE(ICACHE_INIT_FILE))  // Load ichache
		  fetch_u(
			.clk(clk),
			.nrst(nrst),
			.branch_target(FETCH_branch_target),
			.is_branch(FETCH_is_branch),
			.curr_pc(FETCH_curr_pc),
			.instruction(FETCH_instruction)
		  );

	/////////////// Decode Stage ///////////////
	reg [31:0] DEC_instruction;
	reg [3:0]  DEC_wb_addr;
	reg [31:0] DEC_wb_data;
	reg DEC_wb_wen;
	reg [31:0] DEC_pc_in;
	wire [31:0] DEC_rs1_val;
	wire [31:0] DEC_rs2_val;
	wire [1:0] DEC_instr_type;
	wire [3:0] DEC_rs2;
	wire [3:0] DEC_rd;
	wire [31:0] DEC_se_imm;
	wire DEC_is_load;
	wire DEC_is_store;
	wire DEC_needs_wb;
	wire DEC_is_computational;
	wire [31:0] DEC_pc_out;
	wire DEC_is_branch;
	DEC dec_u(
		.clk(clk),
		.nrst(nrst),
		.instruction(DEC_instruction),
		.wb_addr(DEC_wb_addr),
		.wb_data(DEC_wb_data),
		.wb_wen(DEC_wb_wen),
		.rs1_val(DEC_rs1_val),
		.rs2_val(DEC_rs2_val),
		.instr_type(DEC_instr_type),
		.rs2(DEC_rs2),
		.rd(DEC_rd),
		.is_branch(DEC_is_branch),
		.se_imm(DEC_se_imm),
		.is_load(DEC_is_load),
		.is_store(DEC_is_store),
		.needs_wb(DEC_needs_wb),
		.is_computational(DEC_is_computational),
		.pc_in(DEC_pc_in),
		.pc_out(DEC_pc_out)
		);

	/////////////// Execution Stage ///////////////
	reg [31:0] EXE_rs1_val;
	reg [31:0] EXE_rs2_val;
	reg [1:0] EXE_instr_type;
	reg EXE_is_computational;
	reg EXE_is_load;
	reg EXE_is_store;
	reg [3:0] EXE_rs2;
	reg [3:0] EXE_rd;
	reg [31:0] EXE_imm;
	reg [31:0] EXE_pc_in;
	wire EXE_z_flag;						
	reg EXE_needs_wb;
	reg EXE_is_branch_in;
	wire [31:0] EXE_exe_out;
	wire [31:0] EXE_pc_out;					
	wire EXE_needs_wb_out;
	wire EXE_is_store_out;
	wire [31:0] EXE_store_data;
	wire [3:0] EXE_wb_addr;
	wire EXE_is_load_out;
	wire EXE_is_branch;						

	EXE exe_u(
		.rs1_val(EXE_rs1_val),
		.rs2_val(EXE_rs2_val),
		.instr_type(EXE_instr_type),
		.is_computational(EXE_is_computational),
		.is_load(EXE_is_load),
		.is_store(EXE_is_store),
		.rs2(EXE_rs2),
		.rd(EXE_rd),
		.imm(EXE_imm),
		.z_flag(EXE_z_flag),
		.exe_out(EXE_exe_out),
		.pc_in(EXE_pc_in),
		.pc_out(EXE_pc_out),
		.needs_wb(EXE_needs_wb),
		.needs_wb_out(EXE_needs_wb_out),
		.is_store_out(EXE_is_store_out),
		.store_data(EXE_store_data),
		.is_branch_in(EXE_is_branch_in),
		.is_branch_out(EXE_is_branch),
		.wb_addr(EXE_wb_addr),
		.is_load_out(EXE_is_load_out)
		);
	/////////////// Memory Stage ///////////////
	reg [31:0] MEM_addr;
	reg [31:0] MEM_wdata;
	reg MEM_needs_wb;
	reg MEM_is_store;
	reg [3:0] MEM_wb_addr_in;
	reg MEM_is_load_in;
	wire MEM_is_load_out;
	wire [31:0] MEM_rdata;
	wire [31:0] MEM_pdata;
	wire MEM_wb_wen;
	wire [3:0] MEM_wb_addr_out;

	MEM #(
			.DCACHE_INIT_FILE(DCACHE_INIT_FILE),
			.DCACHE_DUMP_FILE(DCACHE_DUMP_FILE)
		 )	// Load dcache data
		mem_u(
		  .clk(clk),
		  .addr(MEM_addr),
		  .wdata(MEM_wdata),
		  .needs_wb(MEM_needs_wb),
		  .is_store(MEM_is_store),
		  .rdata(MEM_rdata),
		  .pdata(MEM_pdata),
		  .wb_wen(MEM_wb_wen),
		  .wb_addr_in(MEM_wb_addr_in),
		  .wb_addr_out(MEM_wb_addr_out),
		  .is_load_in(MEM_is_load_in),
		  .is_load_out(MEM_is_load_out)
		);

	/////////////// Write-back Stage ///////////////
	reg [31:0] WB_rdata;
	reg [31:0] WB_pdata;
	reg [3:0] WB_wb_addr_in;
	reg WB_needs_wb;
	reg WB_isload;
	wire [3:0] WB_wb_addr_out;
	wire [31:0] WB_dataout;
	wire WB_wen;

	WB wb_u(
		.rdata(WB_rdata),
		.pdata(WB_pdata),
		.dataout(WB_dataout),
		.is_load(WB_isload),
		.wb_addr_in(WB_wb_addr_in),
		.wb_addr_out(WB_wb_addr_out),
		.needs_wb(WB_needs_wb),
		.wen(WB_wen)
		);

	//////////////////////////////////////////////////////////////////////////
	// PC Generation, Branch target resolver, and Flush generation
	//////////////////////////////////////////////////////////////////////////
	wire PCGen_EXE_flush;
	wire PCGen_DEC_flush;
	wire PCGen_jump;
	wire [31:0] PCGen_target_pc;

	PCGen pcgen(
			.clk(clk),
			.exe_is_branch(EXE_is_branch),
			.z_flag(EXE_z_flag),
			.target_pc_in(EXE_pc_out),
			.jump(PCGen_jump),
			.target_pc_out(PCGen_target_pc),
			.EXE_flush(PCGen_EXE_flush),
			.DEC_flush(PCGen_DEC_flush)
			);

	//////////////////////////////////////////////////////////////////////////
	// Inter-stage registers 
	//////////////////////////////////////////////////////////////////////////
	always @(posedge clk) begin : FETCH
		if(!nrst) begin
			// $display("reset");
			FETCH_branch_target <= 32'b0;
			FETCH_is_branch		<= 1'b1;
		end
		else begin
			FETCH_branch_target <= PCGen_target_pc;
			FETCH_is_branch		<= PCGen_jump;
		end 
		// #1;
		// $display("\n\n----------------------------------------\nFETCH i: pc %b", FETCH_curr_pc);
		// $display("FETCH o: next pc %b", FETCH_branch_target);
		// $display("FETCH o: is_branch %b", FETCH_is_branch);
	end

	// After reset one instruction is already fetched and ready to decode
	// we must stall one cycle to prevent double issue of one instruction
	reg DEC_stall;
	always @(posedge clk)
		DEC_stall <= !nrst;

	always @(posedge clk) begin : FETCH_DEC
		if(!nrst | PCGen_DEC_flush) begin
			DEC_instruction	<= 32'b0;
			DEC_wb_addr 	<= 4'b0; 		// From WB
			DEC_wb_data 	<= 32'b0;		// From WB
			DEC_wb_wen 		<= 1'b0; 		// From WB
			DEC_pc_in 		<= 32'b0;
		end
		else begin
			if(!DEC_stall) begin
				DEC_instruction	<= FETCH_instruction;
				DEC_wb_addr 	<= WB_wb_addr_out;		// From WB
				DEC_wb_data 	<= WB_dataout;    		// From WB
				DEC_wb_wen 		<= WB_wen;        		// From WB
				DEC_pc_in 		<= FETCH_curr_pc;
			end
		end
		#1;
		// $display("DEC i: instruction %b", DEC_instruction);
		// $display("DEC i: wb_addr %b", DEC_wb_addr);
		// $display("DEC i: wb_data %b", DEC_wb_data);
		// $display("DEC i: wb_wen %b", DEC_wb_wen);
		// $display("DEC i: pc_in %b", DEC_pc_in);
		// $display("DEC o: rs1_val %b", DEC_rs1_val);
		// $display("DEC o: rs2_val %b", DEC_rs2_val);
		// $display("DEC o: instr_type %b", DEC_instr_type);
		// $display("DEC o: rs2 %b", DEC_rs2);
		// $display("DEC o: rd %b", DEC_rd);
		// $display("DEC o: se_imm %b", DEC_se_imm);
		// $display("DEC o: is_load %b", DEC_is_load);
		// $display("DEC o: is_store %b", DEC_is_store);
		// $display("DEC o: needs_wb %b", DEC_needs_wb);
		// $display("DEC o: is_computational %b", DEC_is_computational);
		// $display("DEC o: pc_out %b", DEC_pc_out);
		
	end

	always @(posedge clk) begin : DEC_EXE
		if(!nrst | PCGen_EXE_flush) begin
			EXE_rs1_val 			<= 32'b0;
			EXE_rs2_val 			<= 32'b0;
			EXE_instr_type 			<= 2'b0;
			EXE_is_computational 	<= 1'b0;
			EXE_is_load 			<= 1'b0;
			EXE_is_store 			<= 1'b0;
			EXE_rs2 				<= 4'b0;
			EXE_rd 					<= 4'b0;
			EXE_imm 				<= 32'b0;
			EXE_pc_in 				<= 32'b0;
			EXE_needs_wb 			<= 1'b0;
			EXE_is_branch_in		<= 1'b0;
		end
		else begin
			EXE_is_branch_in		<= DEC_is_branch;
			EXE_rs1_val 			<= DEC_rs1_val;
			EXE_rs2_val 			<= DEC_rs2_val;
			EXE_instr_type 			<= DEC_instr_type;
			EXE_is_computational 	<= DEC_is_computational;
			EXE_is_load 			<= DEC_is_load;
			EXE_is_store 			<= DEC_is_store;
			EXE_rs2 				<= DEC_rs2;
			EXE_rd 					<= DEC_rd;
			EXE_imm 				<= DEC_se_imm;
			EXE_pc_in 				<= DEC_pc_out;
			EXE_needs_wb 			<= DEC_needs_wb;
		end
		// #1;
		// $display("EXT i: is_branch %b",EXE_is_branch_in );
		// $display("-----\nEXT: rs1_val %b",EXE_rs1_val );
		// $display("EXT i: rs2_val %b", EXE_rs2_val);
		// $display("EXT i: instr_type %b", EXE_instr_type);
		// $display("EXT i: is_computational %b", EXE_is_computational);
		// $display("EXT i: is_load %b", EXE_is_load);
		// $display("EXT i: is_store %b", EXE_is_store);
		// $display("EXT i: rs2 %b", EXE_rs2);
		// $display("EXT i: rd %b", EXE_rd);
		// $display("EXT i: imm %b", EXE_imm);
		// $display("EXT i: pc_in %b", EXE_pc_in);
		// $display("EXT i: need_wb %b", EXE_needs_wb);
		// $display("EXT o: exe_out %b", EXE_exe_out);
		// $display("EXT o: pc_out %b", EXE_pc_out);
		// $display("EXT o: needs_wb_out %b", EXE_needs_wb_out);
		// $display("EXT o: is_store_out %b", EXE_is_store_out);
		// $display("EXT o: store_data %b", EXE_store_data);
		// $display("EXT o: wb_addr %b", EXE_wb_addr);
		
	end

	always @(posedge clk) begin : EXE_MEM
		if(!nrst) begin
			MEM_addr 		<= 32'b0;
			MEM_wdata 		<= 32'b0;
			MEM_needs_wb 	<= 1'b0;
			MEM_is_store 	<= 1'b0;
			MEM_wb_addr_in	<= 4'b0;
			MEM_is_load_in	<= 1'b0;
		end
		else begin
			MEM_addr 		<= EXE_exe_out;
			MEM_wdata 		<= EXE_store_data;
			MEM_needs_wb 	<= EXE_needs_wb_out;
			MEM_is_store 	<= EXE_is_store_out;
			MEM_wb_addr_in	<= EXE_wb_addr;
			MEM_is_load_in	<= EXE_is_load_out;
		end
		// #1;
		// $display("-----\nMEM i: addr %b", MEM_addr);
		// $display("MEM i: wdata  %b", MEM_wdata);
		// $display("MEM i: needs_wb %b", MEM_needs_wb);
		// $display("MEM i: is_store %b", MEM_is_store);
		// $display("MEM i: wb_addr_in %b", MEM_wb_addr_in);
		// $display("MEM i: is_load_in %b", MEM_is_load_in);
		// $display("MEM o: rdata %b", MEM_rdata);
		// $display("MEM o: pdata %b", MEM_pdata);
		// $display("MEM o: wb_wen %b", MEM_wb_wen);
		// $display("MEM o: wb_addr_out %b", MEM_wb_addr_out);
	end

	always @(posedge clk) begin : MEM_WB
		if(!nrst) begin
			WB_rdata 		<= 32'b0;
			WB_pdata 		<= 32'b0;
			WB_needs_wb		<= 1'b0;
			WB_wb_addr_in	<= 4'b0;
			WB_isload		<= 1'b0;
		end
		else begin 
			WB_rdata 		<= MEM_rdata;
			WB_pdata 		<= MEM_pdata;
			WB_needs_wb		<= MEM_wb_wen;
			WB_wb_addr_in	<= MEM_wb_addr_out;
			WB_isload		<= MEM_is_load_out;
		end
		// #1;
		// $display("-----\nWB i: rdata %b", WB_rdata);
		// $display("WB i: pdata  %b", WB_pdata);
		// $display("WB i: needs_wb %b",WB_needs_wb );
		// $display("WB i: wb_addr_in %b", WB_wb_addr_in);
		// $display("WB i: isload %b", WB_isload);
		// $display("WB o: wb_addr_out %b", WB_wb_addr_out);
		// $display("WB o: dataout %b", WB_dataout);
		// $display("WB o: wen %b", WB_wen);
	end

endmodule 