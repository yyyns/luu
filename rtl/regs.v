module regs(
	input wire 		  clk,
	input wire 		  rst,
	input wire[4:0]   rs1_i,
	input wire[4:0]   rs2_i,
	input wire[4:0]   rd_i,
	input wire 		  wen_i,
	input wire[31:0]  rd_data_i,
	output reg[31:0]  op1_o,
	output reg[31:0]  op2_o
);

	reg[31:0] registers[31:0];
	integer i;
	always @(posedge clk) begin
		if (!rst) begin
			for(i = 0;i < 32;i = i + 1) begin // reset
				registers[i] <= 32'b0;
			end
		end
		else begin
			if(wen_i) begin
				registers[rd_i] <= rd_data_i;
			end
		end
	end

	always @(*) begin
		if(rs1_i == 5'b0) begin
			op1_o = 32'b0;
		end
		else if(wen_i && (rs1_i == rd_i) ) begin
			op1_o = rd_data_i;
		end
		else begin
			op1_o = registers[rs1_i];
		end

		if(rs2_i == 5'b0) begin
			op2_o = 32'b0;
		end
		else if(wen_i && (rs2_i == rd_i) ) begin
			op2_o = rd_data_i; 
		end
		else begin
			op2_o = registers[rs2_i];
		end
	end
endmodule