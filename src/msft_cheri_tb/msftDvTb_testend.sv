
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



module msftDvTb_testend #(
    parameter TEST_INPUTS=1,
    parameter TIMEOUT=0
  ) (
  input [TEST_INPUTS-1:0] testEnd,
  input [TEST_INPUTS-1:0] testFail,
  input                   clk
);

logic testTimeout = 0;
assign testEndEdge  = &testEnd | testTimeout;
assign testFailEdge = |testFail | testTimeout;

integer file;

always @(posedge testEndEdge)
begin
  file = $fopen("testdata.log", "w");
  $fwrite(file, "Test Start: True\n");
  repeat (100) #4ns;
  $display("**********************************************");
  if(testFailEdge) begin
    $display("RTL says FAIL (deadbeef)");
  end else begin
    $display("RTL says PASS (c001c0de)");
  end
  $display("**********************************************");

  $fwrite(file, "CLOCKS: %d\n", clks);
  $fclose(file);

  repeat (100) #4ns;
  $finish;
end

reg [63:0] cnt;

initial
begin
  cnt = TIMEOUT;
  while(cnt == 0) @(posedge clk);
  while(cnt != 0) begin
    @(posedge clk); 
    cnt -= 1'b1;
  end
  testTimeout = 1'b1;
  $display("Test Timed Out");
end

reg [63:0] clks = 64'h0000_0000_0000_0000;

always @(posedge clk)
begin
  clks <= clks + 1'b1;  
end

endmodule
