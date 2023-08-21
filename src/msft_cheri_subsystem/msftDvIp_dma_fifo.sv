
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



module msftDvIp_dma_fifo #(
    parameter FIFO_BYTES=16
  )  (
  input                 clk_i,
  input                 rstn_i,

  input                 rstn_fifo_i,

  input                 rvalid_i,
  output                rready_o,
  input [31:0]          rdata_i,
  input [2:0]           rsize_i,
  input [1:0]           rladdr_i,

  input                 wvalid_i,
  output                wready_o,
  input [2:0]           wsize_i,
  input [1:0]           wladdr_i,
  output reg [31:0]     wdata_o,
  output reg [3:0]      wstrb_o
 );
 
//==========================================
// Registers and Wires
//==========================================
parameter FIFO_PTR_WIDTH = $clog2(FIFO_BYTES)+1;

reg  [7:0] fifo [FIFO_BYTES-1:0];
reg  [FIFO_PTR_WIDTH-1:0] hptr;
reg  [FIFO_PTR_WIDTH-1:0] tptr;
wire [FIFO_PTR_WIDTH-1:0] fifo_bytes;
wire [FIFO_PTR_WIDTH-1:0] fifo_space;

wire [FIFO_PTR_WIDTH-2:0] shptr = hptr[FIFO_PTR_WIDTH-2:0];
wire [FIFO_PTR_WIDTH-2:0] stptr = tptr[FIFO_PTR_WIDTH-2:0];

wire [2:0] rdTxSize = {3'b001}<<rsize_i;
wire [2:0] wrTxSize = {3'b001}<<wsize_i;

assign fifo_equ   =  hptr[FIFO_PTR_WIDTH-2:0] == tptr[FIFO_PTR_WIDTH-2:0];
assign fifo_full  = (hptr[FIFO_PTR_WIDTH-1] ^  tptr[FIFO_PTR_WIDTH-1]) & fifo_equ;
assign fifo_empty = (hptr[FIFO_PTR_WIDTH-1] == tptr[FIFO_PTR_WIDTH-1]) & fifo_equ ;
assign fifo_bytes =  hptr[FIFO_PTR_WIDTH-1:0] - tptr[FIFO_PTR_WIDTH-1:0];
assign fifo_space = {1'b1,{FIFO_PTR_WIDTH-1{1'b0}}} - fifo_bytes;

assign rready_o = fifo_space >= rdTxSize;
assign wready_o = (fifo_bytes >= wrTxSize) & (~fifo_empty);

always @*
begin
  casez(wsize_i)
    2'h0: begin
      casez(wladdr_i)
        2'h0: begin wdata_o = {24'h0000_00, fifo[stptr]};        wstrb_o = 4'h1; end
        2'h1: begin wdata_o = {16'h0000, fifo[stptr], 8'h00};    wstrb_o = 4'h2; end
        2'h2: begin wdata_o = {8'h00, fifo[stptr], 16'h0000};    wstrb_o = 4'h4; end
        2'h3: begin wdata_o = {fifo[stptr], 24'h00_0000};        wstrb_o = 4'h8; end
      endcase
    end
    2'h1: begin
      casez(wladdr_i[1])
        1'b0: begin wdata_o = {16'h0000, fifo[stptr+1], fifo[stptr]}; wstrb_o = 4'h3; end
        1'b1: begin wdata_o = {fifo[stptr+1], fifo[stptr], 16'h0000}; wstrb_o = 4'hc; end
      endcase
    end
    2'h2: begin
      wdata_o = {fifo[stptr+3], fifo[stptr+2], fifo[stptr+1], fifo[stptr]};
      wstrb_o = 4'hf;
    end
    default: begin
      wdata_o = {fifo[stptr+3], fifo[stptr+2], fifo[stptr+1], fifo[stptr]};
      wstrb_o = 4'hf;
    end
  endcase
end

//==========================================
// DMA Fifo read/write
//==========================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    hptr <= {FIFO_PTR_WIDTH{1'b0}};
    tptr <= {FIFO_PTR_WIDTH{1'b0}};
  end else if(~rstn_fifo_i) begin
    hptr <= {FIFO_PTR_WIDTH{1'b0}};
    tptr <= {FIFO_PTR_WIDTH{1'b0}};
  end else begin
    if(rvalid_i & rready_o) begin
      hptr <= hptr + rdTxSize;
    end
    if(wvalid_i & wready_o) begin
      tptr <= tptr + wrTxSize;
    end
  end
end

//==========================================
// DMA Fifo Write
//==========================================
always @(posedge clk_i)
begin
  if(rvalid_i & rready_o) begin
    casez(rsize_i) 
      3'h0: 
        casez(rladdr_i)
          2'h0: fifo[shptr]  = rdata_i[7:0];
          2'h1: fifo[shptr]  = rdata_i[15:8];
          2'h2: fifo[shptr]  = rdata_i[23:16];
          2'h3: fifo[shptr]  = rdata_i[31:24];
        endcase
      3'h1: begin
        fifo[shptr]   = (rladdr_i[1])? rdata_i[23:16]: rdata_i[7:0];
        fifo[shptr+1] = (rladdr_i[1])? rdata_i[31:24]: rdata_i[15:8];
      end
      3'h2: begin
        fifo[shptr]   = rdata_i[7:0];
        fifo[shptr+1] = rdata_i[15:8];
        fifo[shptr+2] = rdata_i[23:16];
        fifo[shptr+3] = rdata_i[31:24];
      end
      default: begin
        fifo[shptr]   = rdata_i[7:0];
        fifo[shptr+1] = rdata_i[15:8];
        fifo[shptr+2] = rdata_i[23:16];
        fifo[shptr+3] = rdata_i[31:24];
      end
    endcase
  end
end

endmodule
