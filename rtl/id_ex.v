module id_ex(
	input wire 	 	  clk,
	input wire  	  rst,

	input wire[4:0]   rd_addr_i,
	input wire        ram_en_i, //directly switch to regs datain
	input wire		  ram_rw_i, 
	input wire 	  	  J_i,
	input wire[3:0]   flag_t_i,
	input wire[3:0]   oprt_i,
	input wire		  wen_i,
	input wire[31:0]  op1_i,
	input wire[31:0]  op2_i,
	input wire[31:0]  ram_ind_i,

	output reg[4:0]   rd_addr_o,
	output reg        ram_en_o, //directly switch to regs datain
	output reg		  ram_rw_o, 
	output reg 	  	  J_o,
	output reg[3:0]   flag_t_o,
	output reg[3:0]   oprt_o,
	output reg		  wen_o,
	output reg[31:0]  op1_o,
	output reg[31:0]  op2_o,
	output reg[31:0]  ram_ind_o
);

	always @(posedge clk) begin
		if (~rst) begin // reset
			rd_addr_o <= 5'b0;
			ram_en_o <= 1'b0; //directly switch to regs datai 
			ram_rw_o <= 1'b0; 
			J_o <= 1'b0;
			flag_t_o <= 4'b0;
			oprt_o <= 4'b0;
			wen_o <= 1'b0;
			op1_o <= 32'b0;
			op2_o <= 32'b0;
			ram_ind_o <= 32'b0;
		end
		else begin
			rd_addr_o <= rd_addr_i;
			ram_en_o <= ram_en_i; //directly switch to regs datai 
			ram_rw_o <= ram_rw_i; 
			J_o <= J_i;
			flag_t_o <= flag_t_i;
			oprt_o <= oprt_i;
			wen_o <= wen_i;
			op1_o <= op1_i;
			op2_o <= op2_i;
			ram_ind_o <= ram_ind_i;
		end
	end

endmodule