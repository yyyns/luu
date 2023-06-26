module soc(
	input wire clk,
	input wire rst
);
	wire[31:0] ifetch_rom_addr;
	wire[31:0] rom_ifetch_inst;
	wire[31:0] pc_ifetch_addr;

	wire[31:0] ifetch_ifid_addr;
	wire[31:0] ifetch_ifid_inst;

	wire[31:0] ifid_id_inst;
	wire[31:0] ifid_id_addr;

	wire[4:0]  id_regs_rs1_addr;
	wire[4:0]  id_regs_rs2_addr;
	wire[31:0] regs_id_op1;
	wire[31:0] regs_id_op2;

	wire       id_idex_ram_en, id_idex_ram_rw, id_idex_J, id_idex_wen;
	wire[3:0]  id_idex_flag, id_idex_oprt;
	wire[4:0]  id_idex_rd_addr;
	wire[31:0] id_idex_op1, id_idex_op2, id_idex_ram_ind;
	
	wire       idex_ex_ram_en, idex_ex_ram_rw, idex_ex_J, idex_ex_wen;
	wire[3:0]  idex_ex_flag, idex_ex_oprt;
	wire[4:0]  idex_ex_rd_addr;
	wire[31:0] idex_ex_op1, idex_ex_op2, idex_ex_ram_ind;

	wire	   ex_flush, ex_pc_set;
	wire[31:0] ex_pc_addr;
	wire  	   ex_ram_en;
	wire 	   ex_ram_rw;
	wire[31:0] ex_ram_addr, ex_ram_data, ram_ex_data;

	wire[31:0] ex_regs_rd_data;
	wire[4:0]  ex_regs_rd_addr;
	wire 	   ex_regs_wen;

	wire  	   ex_alu_en;
	wire[3:0]  ex_alu_oprt;
	wire[31:0] ex_alu_op1, ex_alu_op2, alu_ex_res;
	wire[10:0] alu_ex_flag;

	rom rom_insc(
		.addr(ifetch_rom_addr),
		.inst(rom_ifetch_inst)
	);
	pc pc_insc(
		.clk   (clk),
		.rst   (rst),
		.set   (ex_pc_set),
		.set_pc(ex_pc_addr),
		.pc_o  (pc_ifetch_addr)
	);

	ifetch ifetch_insc(
		.inst_addr_i	 (pc_ifetch_addr), //from pc
		.inst_i 		 (rom_ifetch_inst), //from rom
		.inst_addr_2rom_o(ifetch_rom_addr), //to rom
		.inst_addr_2nex_o(ifetch_ifid_addr), //along pipeline
		.inst_o 		 (ifetch_ifid_inst) //to if_id
	);

	if_id if_id_insc(
		.clk 		(clk),
		.rst 		(rst & ex_flush),
		.inst_i 	(ifetch_ifid_inst), //from if stored
		.inst_addr_i(ifetch_ifid_addr), //from if stored
		.inst_o 	(ifid_id_inst), //to id
		.inst_addr_o(ifid_id_addr) //to id
	);

	id id_insc(
		.inst_i      (ifid_id_inst),
		.inst_addr_i (ifid_id_addr),
		.op1_i		 (regs_id_op1),
		.op2_i 		 (regs_id_op2),
		.inst_o 	 (), //
		.inst_addr_o (),//
		.rs1_addr_o  (id_regs_rs1_addr), //
		.rs2_addr_o  (id_regs_rs2_addr), //
		.rd_addr_o   (id_idex_rd_addr),
		.ram_en_o    (id_idex_ram_en), //directly switch to regs datain
		.ram_rw_o    (id_idex_ram_rw), 
		.J_o  	  	 (id_idex_J),
		.flag_t_o 	 (id_idex_flag),
		.oprt_o 	 (id_idex_oprt),
		.wen_o 		 (id_idex_wen),
		.op1_o		 (id_idex_op1),
		.op2_o		 (id_idex_op2),
		.ram_indata_o(id_idex_ram_ind)
	);

	id_ex id_ex_insc(
		.clk 	   (clk),
		.rst 	   (rst & ex_flush),

		.rd_addr_i (id_idex_rd_addr),
		.ram_en_i  (id_idex_ram_en), //directly switch to regs datain
		.ram_rw_i  (id_idex_ram_rw), 
		.J_i	   (id_idex_J),
		.flag_t_i  (id_idex_flag),
		.oprt_i    (id_idex_oprt),
		.wen_i	   (id_idex_wen),
		.op1_i	   (id_idex_op1),
		.op2_i	   (id_idex_op2),
		.ram_ind_i (id_idex_ram_ind),

		.rd_addr_o (idex_ex_rd_addr),
		.ram_en_o  (idex_ex_ram_en), //directly switch to regs datain
		.ram_rw_o  (idex_ex_ram_rw), 
		.J_o       (idex_ex_J),
		.flag_t_o  (idex_ex_flag),
		.oprt_o    (idex_ex_oprt),
		.wen_o     (idex_ex_wen),
		.op1_o     (idex_ex_op1),
		.op2_o     (idex_ex_op2),
		.ram_ind_o (idex_ex_ram_ind)
	);

	ex ex_insc(
		.rd_addr_i     (idex_ex_rd_addr),
		.ram_en_i      (idex_ex_ram_en), //directly switch to regs datain
		.ram_rw_i      (idex_ex_ram_rw), 
		.J_i   	  	   (idex_ex_J),
		.flag_t_i      (idex_ex_flag),
		.oprt_i        (idex_ex_oprt),
		.wen_i         (idex_ex_wen),
		.op1_i         (idex_ex_op1),
		.op2_i         (idex_ex_op2), 
		.ram_indata_i  (idex_ex_ram_ind),

		.flags_i       (alu_ex_flag), //from ALU
		.res_i         (alu_ex_res), //from ALU
		.ram_data_i    (ram_ex_data), //from ram

		.pc_addr_set_o (ex_pc_addr), //to pc
		.pc_set_o      (ex_pc_set), //to pc
		.flush_o       (ex_flush), //to if_id & id_ex  low:flush

		.regs_wen_o    (ex_regs_wen),
		.regs_rd_o 	   (ex_regs_rd_addr),
		.regs_rd_data_o(ex_regs_rd_data),

		.alu_oprt_o    (ex_alu_oprt), //to alu
	 	.alu_op1_o     (ex_alu_op1), //to alu
		.alu_op2_o     (ex_alu_op2), //to alu
		.alu_en_o 	   (ex_alu_en),

		.ram_en_o      (ex_ram_en),
		.ram_addr_o    (ex_ram_addr), //to ram
		.ram_rw_o      (ex_ram_rw), //to ram
		.ram_data_o    (ex_ram_data) //to ram

	);
	regs regs_insc(
		.clk  	   (clk),
		.rst  	   (rst),
		.rs1_i     (id_regs_rs1_addr),
		.rs2_i     (id_regs_rs2_addr),
		.rd_i      (ex_regs_rd_addr),
		.wen_i     (ex_regs_wen),
		.rd_data_i (ex_regs_rd_data),
		.op1_o 	   (regs_id_op1),
		.op2_o 	   (regs_id_op2)
	);

	alu alu_insc(
		.clk  (clk),
		.rst  (rst),
		.op1  (ex_alu_op1),
		.op2  (ex_alu_op2),
		.oprt (ex_alu_oprt),
		.en   (ex_alu_en),
		.res  (alu_ex_res),
		.flag (alu_ex_flag) //0N 1Z 2C 3V
	);

	ram ram_insc(
		.clk 	(clk),
		.rst 	(rst),
		.addr   (ex_ram_addr),
		.rw     (ex_ram_rw),
		.en     (ex_ram_en),
		.d_in   (ex_ram_data),
		.d_out  (ram_ex_data)
	);

endmodule