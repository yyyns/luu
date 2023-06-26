module ram(
	input wire		  clk,
	input wire		  rst,
	input wire[31:0]  addr,
	input wire		  rw,
	input wire		  en,
	input wire[31:0]  d_in,
	output reg[31:0]  d_out
);

	reg[31:0] data[255:0];

	integer k;
	always @(posedge clk) begin
		if (~rst) begin
			// reset
			for(k = 0;k < 256;k = k + 1)begin
				data[k] <= 32'b0;
			end
		end
		else if (en & rw) begin
			data[addr[9:2]] <= d_in;
		end
	end

	always @(*) begin
		if (en) begin
			if (rw) begin
				d_out = {32{1'bz}};
			end
			else begin
				d_out = data[addr[9:2]];
			end
		end
		else begin
			d_out = {32{1'bz}};
		end
	end

endmodule