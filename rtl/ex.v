`define N flags_i[0]
`define Z flags_i[1]
`define C flags_i[2]
`define V flags_i[3]

`define NV flag_t[0]
`define NE flag_t[1]
`define CS flag_t[2]
`define CC flag_t[3]
`define MI flag_t[4]
`define PL flag_t[5]
`define VS flag_t[6]
`define VC flag_t[7]
`define HI flag_t[8]
`define LS flag_t[9]
`define GE flag_t[10]
`define LT flag_t[11]
`define GT flag_t[12]
`define LE flag_t[13]
`define EQ flag_t[14]
`define AL flag_t[15]

module ex(
	input wire[4:0]   rd_addr_i,
	input wire        ram_en_i, //directly switch to regs datain
	input wire		  ram_rw_i, 
	input wire 	  	  J_i,
	input wire[3:0]   flag_t_i,
	input wire[3:0]   oprt_i,
	input wire		  wen_i,
	input wire[31:0]  op1_i,
	input wire[31:0]  op2_i, 
	input wire[31:0]  ram_indata_i,

	input wire[10:0]  flags_i, //from ALU
	input wire[31:0]  res_i, //from ALU
	input wire[31:0]  ram_data_i, //from ram

	output wire[31:0] pc_addr_set_o, //to pc
	output reg		  pc_set_o, //to pc
	output reg 	  	  flush_o, //to if_id & id_ex  low:flush

	output wire  	  regs_wen_o,
	output wire[4:0]  regs_rd_o,
	output wire[31:0] regs_rd_data_o,

	output wire[3:0]  alu_oprt_o, //to alu
 	output wire[31:0] alu_op1_o, //to alu
	output wire[31:0] alu_op2_o, //to alu
	output wire  	  alu_en_o,

	output wire 	  ram_en_o,
	output wire[31:0] ram_addr_o, //to ram
	output wire  	  ram_rw_o, //to ram
	output wire[31:0] ram_data_o //to ram

);
	wire[15:0] flag_t;
	//flags_i[10:0] --> flag_t[15:0]用于给flag_t_i在B索引
	assign flag_t[7:0] = {~`V,`V,~`N,`N,~`C,`C,~`Z,1'b0};
	assign `HI = `C & (~`Z);
	assign `LS = ~`HI;
	assign `LT = `N ^ `V;
	assign `GE = ~`LT;
	assign `LE = `Z | (`N ^ `V);
	assign `GT = ~`LE;
	assign `AL = 1;
	assign `EQ = `Z;


	assign pc_addr_set_o = res_i;
	always @(*) begin
		if(J_i) begin //J
			pc_set_o = 1'b1;
			flush_o = 1'b0;
		end
		else if(~(&(~flag_t_i)) && flag_t[flag_t_i]) begin //B
			pc_set_o = 1'b1;
			flush_o = 1'b0;
		end
		else begin
			pc_set_o = 1'b0;
			flush_o = 1'b1;
		end

		
	end
	

	assign regs_wen_o = wen_i;
	assign regs_rd_o = rd_addr_i;
	

	assign alu_op1_o = op1_i;
	assign alu_op2_o = op2_i;
	assign alu_oprt_o = oprt_i;
	assign alu_en_o = ~ram_en_o | ram_rw_o;

	assign ram_en_o = ram_en_i;
	assign ram_rw_o = ram_rw_i;
	assign ram_addr_o = op1_i;
	assign ram_data_o = ram_indata_i;
	/*
		if(ram_en_i) begin
			regs_rd_data_o = ram_data_i;
		end
		else begin
			regs_rd_data_o = res_i;
		end
	*/

	assign regs_rd_data_o = res_i;
	assign regs_rd_data_o = ram_data_i;

endmodule