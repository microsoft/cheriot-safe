// Copyright (C) Microsoft Corporation. All rights reserved.



module msftDvTb_reset #(
    parameter DELAY_CLOCKS = 100
  ) (
	input wire clk_i,
	output wire prstn_o,
	output wire srstn_o,
	output wire start_clk_o,
	output wire mem_repair_done_o,
	output wire run_stall_o,
	output wire A0Bypass_o
);

reg	por_rst_n_ff;
reg sys_rst_n_ff;
reg start_clk_ff;
reg mem_repair_done_ff;
reg run_stall_ff;
reg A0Bypass_ff;

assign prstn_o = por_rst_n_ff;
assign srstn_o = sys_rst_n_ff;
assign start_clk_o = start_clk_ff;
assign mem_repair_done_o = mem_repair_done_ff;
assign run_stall_o = run_stall_ff;
assign A0Bypass_o = A0Bypass_ff;

//==========================================
// A0 Bypass
//use like this: make sub/aragon/test/hello_world/l3/aragon/{clean,run} SIMOPTS="+SET_A0_BYPASS=1"
//==========================================
initial
begin
	A0Bypass_ff = 0;
  	if ($value$plusargs("SET_A0_BYPASS=%d",A0Bypass_ff) && A0Bypass_ff != 0 ) begin
    	$display("setting a0 bypass to 1");
  	end else begin
    	$display("setting a0 bypass to 0");
  	end
	por_rst_n_ff = 0;
	sys_rst_n_ff = 0;
	start_clk_ff = 0;
	run_stall_ff = 1;
	mem_repair_done_ff = 0;
	repeat (DELAY_CLOCKS)	@(posedge clk_i);
	por_rst_n_ff = 1;
	repeat (DELAY_CLOCKS)	@(posedge clk_i);
	start_clk_ff = 1;
	repeat (DELAY_CLOCKS)	@(posedge clk_i);
	sys_rst_n_ff = 1;
	repeat (DELAY_CLOCKS)	@(posedge clk_i);
	mem_repair_done_ff = 1;
	repeat (DELAY_CLOCKS)	@(posedge clk_i);
	run_stall_ff = 0;
end

endmodule
