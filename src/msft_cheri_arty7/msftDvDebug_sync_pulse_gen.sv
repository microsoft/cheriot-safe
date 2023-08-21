
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



module msftDvDebug_sync_pulse_gen #(
  parameter COUNTS=32
  ) (

  input         clk_i,
  input         rstn_i,
  input         start_i,
  output        pulse_o
);

reg                      pulse;
reg [$clog2(COUNTS)-1:0] pulse_cnt;

wire clk;
wire rstn;
wire start;

//================================
// Pulse Generator
//================================
always @(posedge clk or negedge rstn)
begin
  if (~rstn) begin
    pulse  <= 1'b0;
    pulse_cnt <= 'h00;
  end else begin
    if (start) begin
      pulse_cnt <= 5'h1f;
      pulse <= 1'b1;
    end else if (pulse_cnt != 5'h0) begin
      pulse_cnt <= pulse_cnt - 1'b1;
    end else begin
      pulse <= 1'b0;
    end
  end
end

assign clk = clk_i;
assign rstn = rstn_i;
assign start = start_i;
assign pulse_o = pulse;

endmodule

