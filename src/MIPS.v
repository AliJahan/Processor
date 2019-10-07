//////////////////////////////////////////////////////////////////////////////////
// Author: Ali Jahan
// Description: 
//////////////////////////////////////////////////////////////////////////////////
`include "FETCH.v"
`include "DEC.v"
`include "EXE.v"
`include "MEM.v"
`include "WB.v"

module MIPS(
	wire clk,
	wire [31:0] pc
	);

//////////////////////////////////////////////////////////////////////////
// Stages 
//////////////////////////////////////////////////////////////////////////
/////////////// Fetch Stage ///////////////
reg [31:0] FETCH_next_pc;
wire [31:0] FETCH_curr_pc;
wire [31:0] FETCH_instruction;

FETCH fetch_u(
	.clk(clk),
	.next_pc(FETCH_next_pc),
	.curr_pc(FETCH_curr_pc),
	.instruction(FETCH_instruction)
);

/////////////// Decode Stage ///////////////
reg [31:0] DEC_instruction;
reg [3:0]  DEC_wb_addr;
reg [31:0] DEC_wb_data;
reg DEC_wb_wen;
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
reg [31:0] DEC_pc_in;
wire [31:0] DEC_pc_out;

DEC dec_u(
	.clk(clk),
	.instruction(DEC_instruction),
	.wb_addr(DEC_wb_addr),
	.wb_data(DEC_wb_data),
	.wb_wen(DEC_wb_wen),
	.rs1_val(DEC_rs1_val),
	.rs2_val(DEC_rs2_val),
	.instr_type(DEC_instr_type),
	.rs2(DEC_rs2),
	.rd(DEC_rd),
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
wire EXE_z_flag;						//Not Used
wire [31:0] EXE_exe_out;
reg [31:0] EXE_pc_in;
wire [31:0] EXE_pc_out;					//Not Used
reg EXE_needs_wb;
wire EXE_needs_wb_out;
wire EXE_is_store_out;
wire [31:0] EXE_store_data;
wire [3:0] EXE_wb_addr;

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
	.wb_addr(EXE_wb_addr)
	);

/////////////// Memory Stage ///////////////
reg [31:0] MEM_addr;
reg [31:0] MEM_wdata;
reg MEM_needs_wb;
reg MEM_is_store;
wire [31:0] MEM_rdata;
wire [31:0] MEM_pdata;
wire MEM_wb_wen;
reg [3:0] MEM_wb_addr_in;
wire [3:0] MEM_wb_addr_out;

MEM mem_u(
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
	);

/////////////// Write-back Stage ///////////////
reg [31:0] WB_rdata;
reg [31:0] WB_pdata;
reg [3:0] WB_wb_addr_in;
reg WB_needs_wb;
wire [3:0] WB_wb_addr_out;
wire [31:0] WB_dataout;
wire WB_wen;

WB wb_u(
	.rdata(WB_rdata),
	.pdata(WB_pdata),
	.dataout(WB_dataout),
	.wb_addr_in(WB_wb_addr_in),
	.wb_addr_out(WB_wb_addr_out),
	.needs_wb(WB_needs_wb),
	.wen(WB_wen)
	);

//////////////////////////////////////////////////////////////////////////
// Inter-stage registers 
//////////////////////////////////////////////////////////////////////////
always @(posedge clk) begin : FETCH
	FETCH_next_pc <= pc;	
end

always @(posedge clk) begin : FETCH_DEC
	DEC_instruction	<= FETCH_instruction;
	DEC_wb_addr 	<= WB_wb_addr_out;		// From WB
	DEC_wb_data 	<= WB_dataout;			// From WB
	DEC_wb_wen 		<= WB_wen;				// From WB
	DEC_pc_in; 		<= FETCH_curr_pc;
end

always @(posedge clk) begin : DEC_EXE
	EXE_rs1_val 			<= DEC_rs1_val
	EXE_rs2_val 			<= DEC_rs2_val;
	EXE_instr_type 			<= DEC_instr_type;
	EXE_is_computational 	<= DEC_is_computational;
	EXE_is_load 			<= DEC_is_load;
	EXE_is_store 			<= DEC_is_store;
	EXE_rs2 				<= DEC_rs2;
	EXE_rd 					<= DEC_rd;
	EXE_imm 				<= DEC_se_imm;
	EXE_pc_in 				<= DEC_pc_out 
	EXE_needs_wb 			<= DEC_needs_wb;
end

always @(posedge clk) begin : EXE_MEM
	MEM_addr 		<= EXE_exe_out;
	MEM_wdata 		<= EXE_store_data;
	MEM_needs_wb 	<= EXE_needs_wb_out;
	MEM_is_store 	<= EXE_is_store_out;
	MEM_wb_addr_in	<= EXE_wb_addr;
end

always @(posedge clk) begin : MEM_WB
	WB_rdata 		<= MEM_rdata;
	WB_pdata 		<= MEM_pdata;
	WB_needs_wb		<= MEM_wb_wen;
	WB_wb_addr_in	<= MEM_wb_addr_out;
end

endmodule 