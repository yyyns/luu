module ifetch(
	input wire[31:0]  inst_addr_i,//from pc
	input wire[31:0]  inst_i, //from rom
	output wire[31:0] inst_addr_2rom_o, //to rom
	output wire[31:0] inst_addr_2nex_o, //along pipeline
	output wire[31:0] inst_o //to if_id
);
	assign inst_addr_2rom_o = inst_addr_i;
	assign inst_addr_2nex_o = inst_addr_i;
	assign inst_o = inst_i;
endmodule