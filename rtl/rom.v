module rom(
	input wire[31:0] addr,
	output wire[31:0] inst
);

	reg[31:0] data[0:255];

	assign inst = data[addr[9:2]];
endmodule