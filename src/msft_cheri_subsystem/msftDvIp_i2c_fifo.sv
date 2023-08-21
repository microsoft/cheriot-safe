
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

//========================================================
//========================================================
// FIFO Module
//========================================================
//========================================================
module msftDvIp_i2c_fifo #(
    parameter FIFO_WIDTH=8,
    parameter FIFO_DEPTH=8,
    parameter FIFO_PTR_BITS= $clog2(FIFO_DEPTH)
  )  (

  input                       clk_i,
  input                       rstn_i,
  input                       rd_i,
  input                       wr_i,
  input  [7:0]                wdata_i,
  output [7:0]                rdata_o,
  output                      full_o,
  output                      empty_o,
  output [FIFO_PTR_BITS:0]    cnt_o,
  output                      ovr_run_o,
  output                      udr_run_o
);



reg  [FIFO_WIDTH-1:0]     fifo [FIFO_DEPTH];
reg  [FIFO_PTR_BITS:0]    hp;
reg  [FIFO_PTR_BITS:0]    tp;

wire [FIFO_PTR_BITS-1:0]  tp_addr;
wire [FIFO_PTR_BITS-1:0]  hp_addr;

assign tp_addr = tp[FIFO_PTR_BITS-1:0];
assign tp_ovf  = tp[FIFO_PTR_BITS];
assign hp_addr = hp[FIFO_PTR_BITS-1:0];
assign hp_ovf  = hp[FIFO_PTR_BITS];

assign cnt_o = hp - tp;
assign empty_o = hp == tp;
assign full_o = (tp_ovf ^ hp_ovf) & (tp_addr == hp_addr);

assign rdata_o = fifo[tp_addr]; 

assign ovr_run_o = wr_i & full_o;
assign udr_run_o = rd_i & empty_o;

//========================================================
// FIFO Control
//========================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    hp <= {FIFO_PTR_BITS+1{1'b0}};
    tp <= {FIFO_PTR_BITS+1{1'b0}};
  end else begin
    if(rd_i & ~empty_o) begin
      tp <= tp + 1'b1;
    end
    if(wr_i & ~full_o) begin
      hp <= hp + 1'b1;
    end
  end
end

//========================================================
// FIFO
//========================================================
always @(posedge clk_i)
begin
  if(wr_i & ~full_o) begin
    fifo[hp_addr] <= wdata_i;
  end
end


endmodule
