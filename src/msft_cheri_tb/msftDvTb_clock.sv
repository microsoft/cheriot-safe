
// =====================================================
// Copyright (c) Microsoft Corporation.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//    http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =====================================================




module msftDvTb_clock(

	output wire clk_o,
	output wire ctl_clk_o,
	input wire en_i
);
	parameter FREQUENCY=25000000;
	parameter realtime PERIOD = 1000000000.0ns/FREQUENCY;
	realtime period_var = PERIOD;
	
  int cpu0_clock;
  initial begin
    if ($value$plusargs("CPU0_CLOCK_OVERRIDE=%d",cpu0_clock)) begin
      $display("CPU0_CLOCK_OVERRIDE=%d",cpu0_clock);
      period_var = 1000000000.0ns/cpu0_clock;
    end
  end

	reg int_clk;

	assign clk_o = int_clk;
	assign ctl_clk_o = int_clk & en_i;

	initial
	begin
  		int_clk <= 0;
  		forever #(period_var/2) int_clk  = ~int_clk;
	end

endmodule

