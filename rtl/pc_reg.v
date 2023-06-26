module pc(
	input wire       clk,
	input wire       rst,
	input wire		 set,
	input wire[31:0] set_pc,
	output reg[31:0] pc_o
);

	always @(posedge clk) begin
		if (~rst) begin
			pc_o <= 32'b0; // reset
		end
		else if(set) begin
			pc_o <= set_pc;
		end
		else begin
			pc_o <= pc_o + 32'd4;
		end
	end
endmodule