module if_id(
	input wire 		 clk,
	input wire 		 rst,
	input wire[31:0] inst_i,
	input wire[31:0] inst_addr_i,
	output reg[31:0] inst_o,
	output reg[31:0] inst_addr_o
);
	always @(posedge clk) begin
		if (~rst) begin
			inst_o <= 32'b0;
			inst_addr_o <= 32'b0;
		end
		else begin
			inst_o <= inst_i;
			inst_addr_o <= inst_addr_i; 
		end
	end
endmodule