module tb;
	
	reg clk;
	reg rst;

	always #10 clk = ~clk;
	initial begin
		#30;
		clk <= 1'b1;
		rst <= 1'b0;
		#30;
		rst <= 1'b1;
	end

	initial begin
		$readmemb("rom_data.txt", tb.soc_insc.rom_insc.data); //精确到变量
	end

	

	soc soc_insc(
		.clk(clk),
		.rst(rst)
	);

endmodule
//双击 
//run 100ns
//vsim -debugdb -vopt work.tb