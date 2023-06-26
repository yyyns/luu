module test_id(
	input wire clk,
	input wire rst
);
	id id_insc(
		.inst_i      (),
		.inst_addr_i (),
		.op1_i		 (),
		.op2_i 		 (),
		.inst_o 	 (), //
		.inst_addr_o (),//
		.rs1_addr_o  (), //
		.rs2_addr_o  (), //
		.rd_addr_o   (),
		.ram_en_o    (), //directly switch to regs datain
		.ram_rw_o    (), 
		.J_o  	  	 (),
		.flag_t_o 	 (),
		.oprt_o 	 (),
		.wen_o 		 (),
		.op1_o		 (),
		.op2_o		 (),
		.ram_indata_o()
	);



endmodule