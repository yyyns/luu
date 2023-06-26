module tb;
	
	reg[31:0] inst;
	
	initial begin
		#32;
		inst = 32'b00000000000001000010000010000001;
	end

	id id_insc(
		.inst_i      (inst),
		.inst_addr_i (~inst),
		.op1_i		 (inst + 32'd114514),
		.op2_i 		 (inst + 32'd1919),
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
//双击 
//run 100ns