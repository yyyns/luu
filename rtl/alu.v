module alu(
	input wire		  clk,
	input wire 		  rst,
	input wire[31:0]  op1,
	input wire[31:0]  op2,
	input wire[3:0]   oprt,
	input wire  	  en,
	output reg[31:0]  res,
	output reg[10:0]  flag //0N 1Z 2C 3V

);
	wire[31:0] add1;
	wire[32:0] neg_op2, add_res;
	reg[32:0] add2;
	assign neg_op2 = (~op2 + 32'b1);
	assign add1 = op1;
	assign add_res = add1 + add2; 
	always @(*) begin
		case(oprt)
			4'b0000: begin //ADD
				add2 = op2;
			end
			4'b0001: begin //SUB
				add2 = neg_op2[31:0];
			end
			default: add2 = op2;
		endcase
		case(oprt)
			4'b0000: begin //ADD
				res = en ? add_res[31:0] : {32{1'bz}};
			end
			4'b0001: begin //SUB
				res = en ? add_res[31:0] : {32{1'bz}};
			end
			4'b0100: begin
				res = en ? op1 >> op2 : {32{1'bz}};
			end
			4'b0101: begin
				res = en ? op1 << op2 : {32{1'bz}};
			end
			4'b0110: begin
				res = en ? op1 & op2 : {32{1'bz}};
			end
			4'b0111: begin
				res = en ? op1 | op2 : {32{1'bz}};
			end
			4'b1000: begin
				res = en ? ~op1 : {32{1'bz}};
			end
			4'b1001: begin
				res = en ? op1 >>> op2 : {32{1'bz}};
			end
			4'b1010: begin
				res = en ? op1 ^ op2 : {32{1'bz}};
			end
			4'b1011: begin
				res = en ? op1 && op2 : {32{1'bz}};
			end
			4'b1100: begin
				res = en ? op1 || op2 : {32{1'bz}};
			end
			4'b1101: begin
				res = en ? !op1 : {32{1'bz}};
			end
			default: begin
				add2 = op2;
				res = en ? 32'h80000000 : {32{1'bz}};
			end
		endcase
	end
	
	
	always @(posedge clk) begin
		if (~rst) begin
			flag <= 11'b0; // reset
		end
		else begin
			/*
			N:结果为负则为1
			Z:结果为0则为1
			C:产生进位为1
			V:add1/2符号相同且res变号 为1
			*/
			flag[0] <= res[31];
			flag[1] <= &(~res);
			flag[2] <= add_res[32];
			flag[3] <= (~(add1[31] ^ add2[31])) & (res[31] ^ add1[31]);
			flag[10:4] <= 7'b0;
		end
	end

endmodule