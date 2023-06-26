module id(
	input wire[31:0]  inst_i,
	input wire[31:0]  inst_addr_i,
	input wire[31:0]  op1_i,op2_i,
	output wire[31:0] inst_o, //
	output wire[31:0] inst_addr_o,//
	output wire[4:0]  rs1_addr_o, //
	output wire[4:0]  rs2_addr_o, //
	output reg[4:0]   rd_addr_o,
	output reg        ram_en_o, //directly switch to regs datain
	output reg		  ram_rw_o, 
	output reg 	      J_o,
	output reg[3:0]   flag_t_o,
	output reg[3:0]   oprt_o,
	output reg		  wen_o,
	output reg[31:0]  op1_o,
	output reg[31:0]  op2_o,
	output reg[31:0]  ram_indata_o
);
	wire[2:0]  opcode;
	wire[3:0]  func;
	wire[4:0]  rs1;
	wire[4:0]  rs2;
	wire[4:0]  rd;
	wire[19:0] imm20;
	wire[14:0] imm15;

	assign opcode = inst_i[2:0];
	assign func = inst_i[6:3];
	assign rs1 = inst_i[11:7];
	assign rs2 = inst_i[16:12];
	assign rd =  inst_i[21:17];
	assign imm20 = inst_i[31:12];
	assign imm15 = inst_i[31:17];

	assign rs1_addr_o = rs1;
	assign rs2_addr_o = rs2;
	assign inst_addr_o = inst_addr_i;
	assign inst_o = inst_i;

	always @(*) begin
		if (opcode == 3'b101) begin
			ram_indata_o = op2_i;
		end
		else begin
			ram_indata_o = 32'b0;
		end

		case(opcode)
			3'b000:  begin
				case(func[1:0])
					2'b00: begin//IMM20
						op1_o = 32'b0;
						op2_o = {{12{imm20[19]}}, imm20};
						rd_addr_o = rs1;
						ram_en_o = 0;
						ram_rw_o = 0;
						J_o = 0;
						flag_t_o = 4'b0;
						oprt_o = 4'b0;
						wen_o = 1;
					end
					2'b01: begin//IMLS
						op1_o = op1_i;
						op2_o = ({{17{1'b0}}, imm15} << 17);
						rd_addr_o = rs1;
						ram_en_o = 0;
						ram_rw_o = 0;
						J_o = 0;
						flag_t_o = 4'b0;
						oprt_o = 4'b0;
						wen_o = 1;
					end
					2'b11: begin//ADDI
						op1_o = op1_i;
						op2_o = {{17{imm15[14]}}, imm15};
						rd_addr_o = rs2;
						ram_en_o = 0;
						ram_rw_o = 0;
						J_o = 0;
						flag_t_o = 4'b0;
						oprt_o = 4'b0;
						wen_o = 1;
					end
					default: begin
						op1_o = 32'b0;
						op2_o = 32'b0;
						rd_addr_o = 5'b0;
						ram_en_o = 0;
						ram_rw_o = 0;
						J_o = 0;
						flag_t_o = 4'b0;
						oprt_o = 4'b0;
						wen_o = 0;
					end
				endcase
			end

			3'b001: begin //CAL
				op1_o = op1_i;
				op2_o = op2_i;
				rd_addr_o = rd;
				ram_en_o = 0;
				ram_rw_o = 0;
				J_o = 0;
				flag_t_o = 4'b0;
				oprt_o = func;
				wen_o = 1;
			end

			3'b010: begin 
				case(func[0]) 
					1'b0: begin //J
						op1_o = op1_i;
						op2_o = {{12{imm20[19]}}, imm20};//
						rd_addr_o = rd;//
						ram_en_o = 0;//
						ram_rw_o = 0;//
						J_o = 1;//
						flag_t_o = 4'b0;//
						oprt_o = 4'b0;//
						wen_o = 0;//
					end
					1'b1: begin //Link
						op1_o = inst_addr_i;
						op2_o = {{12{imm20[19]}}, imm20};
						rd_addr_o = rs1;
						ram_en_o = 0;
						ram_rw_o = 0;
						J_o = 0;
						flag_t_o = 4'b0;
						oprt_o = 4'b0;
						wen_o = 1;
					end
					default: begin
						op1_o = 32'b0;
						op2_o = 32'b0;
						rd_addr_o = 5'b0;
						ram_en_o = 0;
						ram_rw_o = 0;
						J_o = 0;
						flag_t_o = 4'b0;
						oprt_o = 4'b0;
						wen_o = 0;
					end
				endcase
			end

			3'b011: begin //B
				op1_o = op1_i;
				op2_o = {{12{imm20[19]}}, imm20};
				rd_addr_o = rd;
				ram_en_o = 0;
				ram_rw_o = 0;
				J_o = 0;
				flag_t_o = func;
				oprt_o = 4'b0;
				wen_o = 0;		
			end

			3'b100: begin //Load
				op1_o = op1_i; //to ramADDR
				op2_o = op2_i;
				rd_addr_o = rd; 
				ram_en_o = 1;
				ram_rw_o = 0;
				J_o = 0;
				flag_t_o = 4'b0;
				oprt_o = 4'b0;
				wen_o = 1;		
			end

			3'b101: begin //STORE
				op1_o = op1_i; //toramADDR and aluop1
				op2_o = {{17{imm15[14]}}, imm15}; //toalu op2
				rd_addr_o = rs1;
				ram_en_o = 1;
				ram_rw_o = 1;
				J_o = 0;
				flag_t_o = 4'b0;
				oprt_o = 4'b0;
				wen_o = func[0];
			end
				
			default: begin
				op1_o = 32'b0;
				op2_o = 32'b0;
				rd_addr_o = 5'b0;
				ram_en_o = 0;
				ram_rw_o = 0;
				J_o = 0;
				flag_t_o = 4'b0;
				oprt_o = 4'b0;
				wen_o = 0;
			end
		endcase

	end
	
endmodule