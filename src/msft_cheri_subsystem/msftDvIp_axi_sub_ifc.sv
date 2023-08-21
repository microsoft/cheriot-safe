
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


module msftDvIp_axi_sub_ifc #(
    parameter SUB_NUM=0,
    parameter AXI_MGR_ID_WIDTH=4,
    parameter AXI_SUB_ID_WIDTH=4,
    parameter AXI_ADDR_WIDTH=32,
    parameter AXI_DATA_WIDTH=32,
    parameter AXI_LEN_WIDTH=4,
    parameter AXI_USER_WIDTH=4,
    parameter MGR_ID_BITS=2,
    parameter APHASE_LEN=100,
    parameter WPHASE_LEN=50,
    parameter RPHASE_LEN=50,
    parameter BPHASE_LEN=10,
    parameter NUM_MGRS=2,
    parameter AXI_FIFO_SIZE=2
  ) (
  input                                               clk_i,
  input                                               rstn_i,

  output     [AXI_SUB_ID_WIDTH-1:0]                   awid_sub_o,
  output     [AXI_ADDR_WIDTH-1:0]                     awaddr_sub_o,
  output     [AXI_LEN_WIDTH-1:0]                      awlen_sub_o,
  output     [AXI_USER_WIDTH-1:0]                     awuser_sub_o,
  output     [3:0]                                    awregion_sub_o,
  output     [2:0]                                    awsize_sub_o,
  output     [1:0]                                    awburst_sub_o,
  output     [3:0]                                    awcache_sub_o,
  output     [1:0]                                    awlock_sub_o,
  output     [2:0]                                    awprot_sub_o,
  output     [3:0]                                    awqos_sub_o,
  output                                              awvalid_sub_o,
  input                                               awready_sub_i,

  output     [AXI_SUB_ID_WIDTH-1:0]                   wid_sub_o,
  output     [AXI_DATA_WIDTH-1:0]                     wdata_sub_o,
  output                                              wlast_sub_o,
  output     [(AXI_DATA_WIDTH/8)-1:0]                 wstrb_sub_o,
  output                                              wvalid_sub_o,
  input                                               wready_sub_i,

  input  [AXI_SUB_ID_WIDTH-1:0]                       bid_sub_i,
  input  [1:0]                                        bresp_sub_i,
  input                                               bvalid_sub_i,
  output                                              bready_sub_o, 
  
  output     [AXI_SUB_ID_WIDTH-1:0]                   arid_sub_o,
  output     [AXI_ADDR_WIDTH-1:0]                     araddr_sub_o,
  output     [AXI_LEN_WIDTH-1:0]                      arlen_sub_o,
  output     [AXI_USER_WIDTH-1:0]                     aruser_sub_o,
  output     [3:0]                                    arregion_sub_o,
  output     [2:0]                                    arsize_sub_o,
  output     [1:0]                                    arburst_sub_o,
  output     [3:0]                                    arcache_sub_o,
  output     [1:0]                                    arlock_sub_o,
  output     [2:0]                                    arprot_sub_o,
  output     [3:0]                                    arqos_sub_o,
  output                                              arvalid_sub_o,
  input                                               arready_sub_i,

  input [AXI_SUB_ID_WIDTH-1:0]                        rid_sub_i,
  input [AXI_DATA_WIDTH-1:0]                          rdata_sub_i,
  input                                               rlast_sub_i,
  input  [1:0]                                        rresp_sub_i,
  input                                               rvalid_sub_i,
  output                                              rready_sub_o,

  input [APHASE_LEN-1:0]                              awphase_i,
  input                                               awphase_valid_i,
  output                                              awphase_ready_o,

  input [WPHASE_LEN-1:0]                              wphase_i,
  input                                               wphase_valid_i,
  output                                              wphase_ready_o,

  output [BPHASE_LEN-1:0]                             bphase_o,
  output [NUM_MGRS-1:0]                               bphase_valid_o,
  input                                               bphase_ready_i,

  input [APHASE_LEN-1:0]                              arphase_i,
  input                                               arphase_valid_i,
  output                                              arphase_ready_o,

  output [RPHASE_LEN-1:0]                             rphase_o,
  output [NUM_MGRS-1:0]                               rphase_valid_o,
  input                                               rphase_ready_i
);

`include "msftDvIp_axi_include.svh"

localparam WR_IDLE = 2'h0;
localparam WR_IN_PROGRESS = 2'h1;
localparam WR_RESP = 2'h2;

reg [1:0] wr_state;
wire awphase_ready;
wire bready_sub;
assign awphase_ready_o = awphase_ready & (wr_state == WR_IDLE);
assign bready_sub_o = bready_sub & (wr_state == WR_RESP);

//=========================================
// AXI Sub Write Address
//=========================================
ADDR_PHASE_t awphase_o;

assign awid_sub_o   = {awphase_o.mgrnum, awphase_o.id};
assign awaddr_sub_o = awphase_o.addr;
assign awlen_sub_o = awphase_o.len;
assign awsize_sub_o = awphase_o.size;
assign awburst_sub_o = awphase_o.burst;
assign awcache_sub_o = awphase_o.cache;
assign awlock_sub_o = awphase_o.lock;
assign awprot_sub_o = awphase_o.prot;
assign awqos_sub_o = awphase_o.qos;
assign awregion_sub_o = awphase_o.region;
assign awuser_sub_o = awphase_o.user;

msftDvIp_axi_fifo #(
    .FIFO_SIZE(AXI_FIFO_SIZE),
    .FIFO_DATA_WIDTH(APHASE_LEN)
  )  aw_fifo_i (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wrReq(awphase_valid_i & awphase_ready_o),
    .wrAck(awphase_ready),
    .wdata(awphase_i),
    .rdReq(awready_sub_i),
    .rdAck(awvalid_sub_o),
    .rdata(awphase_o)
);

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    wr_state <= WR_IDLE;
  end else begin
    casez(wr_state)
      WR_IDLE: begin
        if(awphase_valid_i) begin
          wr_state <= WR_IN_PROGRESS;
        end
      end
      WR_IN_PROGRESS: begin
        if(wvalid_sub_o & wready_sub_i & wlast_sub_o) begin
          wr_state <= WR_RESP;
        end
      end
      WR_RESP: begin
        if(bvalid_sub_i & bready_sub_o) begin
          wr_state <= WR_IDLE;
        end
      end
    endcase
  end

end

//=========================================
// AXI Sub Write Data
//=========================================
WDATA_PHASE_t wphase_o;
assign wid_sub_o   = wphase_o.id;
assign wdata_sub_o = wphase_o.data;
assign wlast_sub_o = wphase_o.last;
assign wstrb_sub_o = wphase_o.strb;

msftDvIp_axi_fifo #(
    .FIFO_SIZE(AXI_FIFO_SIZE),
    .FIFO_DATA_WIDTH(WPHASE_LEN)
  )  w_fifo_i (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wrReq(wphase_valid_i),
    .wrAck(wphase_ready_o),
    .wdata(wphase_i),
    .rdReq(wready_sub_i),
    .rdAck(wvalid_sub_o),
    .rdata(wphase_o)
);

//=========================================
// AXI Sub Resp Data
//=========================================
reg  bphase_valid;
RESP_PHASE_t  bphase_i;
RESP_PHASE_t  bphase_t;

assign bphase_t = bphase_o;
assign bphase_valid_o = (bphase_valid<<bphase_t.mgrnum);

assign bphase_i.id = bid_sub_i[AXI_MGR_ID_WIDTH-1:0];
assign bphase_i.resp = bresp_sub_i;
assign bphase_i.mgrnum = bid_sub_i[AXI_SUB_ID_WIDTH-1:AXI_MGR_ID_WIDTH];

msftDvIp_axi_fifo #(
    .FIFO_SIZE(AXI_FIFO_SIZE),
    .FIFO_DATA_WIDTH(BPHASE_LEN)
  )  b_fifo_i (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wrReq(bvalid_sub_i & bready_sub_o),
    .wrAck(bready_sub),
    .wdata(bphase_i),
    .rdReq(bphase_ready_i),
    .rdAck(bphase_valid),
    .rdata(bphase_o)
);

//=========================================
// AXI Sub Read  Address
//=========================================
ADDR_PHASE_t arphase_o;
reg ar_in_progress;

assign arid_sub_o   = {arphase_o.mgrnum,arphase_o.id};
assign aruser_sub_o = arphase_o.user;
assign araddr_sub_o = arphase_o.addr;
assign arlen_sub_o = arphase_o.len;
assign arsize_sub_o = arphase_o.size;
assign arburst_sub_o = arphase_o.burst;
assign arcache_sub_o = arphase_o.cache;
assign arlock_sub_o = arphase_o.lock;
assign arprot_sub_o = arphase_o.prot;
assign arqos_sub_o = arphase_o.qos;

wire arphase_ready;
assign arphase_ready_o = arphase_ready & ~ar_in_progress;

always @(posedge clk_i or negedge rstn_i) 
begin
  if(~rstn_i) begin
    ar_in_progress <= 1'b0;
  end else begin
    if(arphase_valid_i & arphase_ready_o) begin
      ar_in_progress <= 1'b1;
    end else if(rvalid_sub_i & rready_sub_o & rlast_sub_i) begin
      ar_in_progress <= 1'b0;
    end
  end
end

msftDvIp_axi_fifo #(
    .FIFO_SIZE(AXI_FIFO_SIZE),
    .FIFO_DATA_WIDTH(APHASE_LEN)
  )  ar_fifo_i (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wrReq(arphase_valid_i & arphase_ready_o),
    .wrAck(arphase_ready),
    .wdata(arphase_i),
    .rdReq(arready_sub_i),
    .rdAck(arvalid_sub_o),
    .rdata(arphase_o)
);

//=========================================
// AXI Sub Read Data
//=========================================
RDATA_PHASE_t rphase_i;
RDATA_PHASE_t rphase_t;
reg  rphase_valid;
assign rphase_t = rphase_o;
assign rphase_valid_o = (rphase_valid<<rphase_t.mgrnum);

assign rphase_i.id = rid_sub_i[AXI_MGR_ID_WIDTH-1:0];
assign rphase_i.data = rdata_sub_i;
assign rphase_i.last = rlast_sub_i;
assign rphase_i.resp = rresp_sub_i;
assign rphase_i.mgrnum = rid_sub_i[AXI_SUB_ID_WIDTH-1:AXI_MGR_ID_WIDTH];

msftDvIp_axi_fifo #(
    .FIFO_SIZE(AXI_FIFO_SIZE),
    .FIFO_DATA_WIDTH(RPHASE_LEN)
  )  r_fifo_i (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wrReq(rvalid_sub_i),
    .wrAck(rready_sub_o),
    .wdata(rphase_i),
    .rdReq(rphase_ready_i),
    .rdAck(rphase_valid),
    .rdata(rphase_o)
);

endmodule
