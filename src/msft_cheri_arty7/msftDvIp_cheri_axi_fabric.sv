
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


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvIp_cheri_axi_fabric Definition
// ==================================================
module msftDvIp_cheri_axi_fabric #(
    parameter NUM_MGRS = 2,
    parameter NUM_SUBS = 4,
    parameter MGR_ID_BITS = 1,
    parameter AXI_MGR_ID_WIDTH = 4,
    parameter AXI_SUB_ID_WIDTH = 5,
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 32,
    parameter AXI_LEN_WIDTH = 8,
    parameter AXI_USER_WIDTH = 12,
    parameter AXI_FIFO_SIZE = 2,
    parameter AXI_LOCK_WIDTH = 1,
    parameter APHASE_LEN = (AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22),
    parameter WPHASE_LEN = (AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+(AXI_DATA_WIDTH/8)+MGR_ID_BITS+1),
    parameter RPHASE_LEN = (AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+MGR_ID_BITS+3),
    parameter BPHASE_LEN = (AXI_MGR_ID_WIDTH+MGR_ID_BITS+2)
  ) (
  input                                      clk_i,
  input                                      rstn_i,
  input  [AXI_MGR_ID_WIDTH-1:0]              arid_cpu_m_i,
  input  [AXI_ADDR_WIDTH-1:0]                araddr_cpu_m_i,
  input  [AXI_LEN_WIDTH-1:0]                 arlen_cpu_m_i,
  input  [AXI_USER_WIDTH-1:0]                aruser_cpu_m_i,
  input  [3:0]                               arregion_cpu_m_i,
  input  [2:0]                               arsize_cpu_m_i,
  input  [1:0]                               arburst_cpu_m_i,
  input  [3:0]                               arcache_cpu_m_i,
  input  [1:0]                               arlock_cpu_m_i,
  input  [2:0]                               arprot_cpu_m_i,
  input  [3:0]                               arqos_cpu_m_i,
  input                                      arvalid_cpu_m_i,
  output                                     arready_cpu_m_o,
  output [AXI_MGR_ID_WIDTH-1:0]              rid_cpu_m_o,
  output [AXI_DATA_WIDTH-1:0]                rdata_cpu_m_o,
  output                                     rlast_cpu_m_o,
  output [1:0]                               rresp_cpu_m_o,
  output                                     rvalid_cpu_m_o,
  input                                      rready_cpu_m_i,
  input  [AXI_MGR_ID_WIDTH-1:0]              awid_cpu_m_i,
  input  [AXI_ADDR_WIDTH-1:0]                awaddr_cpu_m_i,
  input  [AXI_LEN_WIDTH-1:0]                 awlen_cpu_m_i,
  input  [AXI_USER_WIDTH-1:0]                awuser_cpu_m_i,
  input  [3:0]                               awregion_cpu_m_i,
  input  [2:0]                               awsize_cpu_m_i,
  input  [1:0]                               awburst_cpu_m_i,
  input  [3:0]                               awcache_cpu_m_i,
  input  [1:0]                               awlock_cpu_m_i,
  input  [2:0]                               awprot_cpu_m_i,
  input  [3:0]                               awqos_cpu_m_i,
  input                                      awvalid_cpu_m_i,
  output                                     awready_cpu_m_o,
  input  [AXI_MGR_ID_WIDTH-1:0]              wid_cpu_m_i,
  input  [AXI_DATA_WIDTH-1:0]                wdata_cpu_m_i,
  input                                      wlast_cpu_m_i,
  input  [AXI_DATA_WIDTH/8-1:0]              wstrb_cpu_m_i,
  input                                      wvalid_cpu_m_i,
  output                                     wready_cpu_m_o,
  output [AXI_MGR_ID_WIDTH-1:0]              bid_cpu_m_o,
  output [1:0]                               bresp_cpu_m_o,
  output                                     bvalid_cpu_m_o,
  input                                      bready_cpu_m_i,
  input  [AXI_MGR_ID_WIDTH-1:0]              arid_dma_m_i,
  input  [AXI_ADDR_WIDTH-1:0]                araddr_dma_m_i,
  input  [AXI_LEN_WIDTH-1:0]                 arlen_dma_m_i,
  input  [AXI_USER_WIDTH-1:0]                aruser_dma_m_i,
  input  [3:0]                               arregion_dma_m_i,
  input  [2:0]                               arsize_dma_m_i,
  input  [1:0]                               arburst_dma_m_i,
  input  [3:0]                               arcache_dma_m_i,
  input  [1:0]                               arlock_dma_m_i,
  input  [2:0]                               arprot_dma_m_i,
  input  [3:0]                               arqos_dma_m_i,
  input                                      arvalid_dma_m_i,
  output                                     arready_dma_m_o,
  output [AXI_MGR_ID_WIDTH-1:0]              rid_dma_m_o,
  output [AXI_DATA_WIDTH-1:0]                rdata_dma_m_o,
  output                                     rlast_dma_m_o,
  output [1:0]                               rresp_dma_m_o,
  output                                     rvalid_dma_m_o,
  input                                      rready_dma_m_i,
  input  [AXI_MGR_ID_WIDTH-1:0]              awid_dma_m_i,
  input  [AXI_ADDR_WIDTH-1:0]                awaddr_dma_m_i,
  input  [AXI_LEN_WIDTH-1:0]                 awlen_dma_m_i,
  input  [AXI_USER_WIDTH-1:0]                awuser_dma_m_i,
  input  [3:0]                               awregion_dma_m_i,
  input  [2:0]                               awsize_dma_m_i,
  input  [1:0]                               awburst_dma_m_i,
  input  [3:0]                               awcache_dma_m_i,
  input  [1:0]                               awlock_dma_m_i,
  input  [2:0]                               awprot_dma_m_i,
  input  [3:0]                               awqos_dma_m_i,
  input                                      awvalid_dma_m_i,
  output                                     awready_dma_m_o,
  input  [AXI_MGR_ID_WIDTH-1:0]              wid_dma_m_i,
  input  [AXI_DATA_WIDTH-1:0]                wdata_dma_m_i,
  input                                      wlast_dma_m_i,
  input  [AXI_DATA_WIDTH/8-1:0]              wstrb_dma_m_i,
  input                                      wvalid_dma_m_i,
  output                                     wready_dma_m_o,
  output [AXI_MGR_ID_WIDTH-1:0]              bid_dma_m_o,
  output [1:0]                               bresp_dma_m_o,
  output                                     bvalid_dma_m_o,
  input                                      bready_dma_m_i,
  output [AXI_SUB_ID_WIDTH-1:0]              arid_dmb_s_o,
  output [AXI_ADDR_WIDTH-1:0]                araddr_dmb_s_o,
  output [AXI_LEN_WIDTH-1:0]                 arlen_dmb_s_o,
  output [AXI_USER_WIDTH-1:0]                aruser_dmb_s_o,
  output [3:0]                               arregion_dmb_s_o,
  output [2:0]                               arsize_dmb_s_o,
  output [1:0]                               arburst_dmb_s_o,
  output [3:0]                               arcache_dmb_s_o,
  output [1:0]                               arlock_dmb_s_o,
  output [2:0]                               arprot_dmb_s_o,
  output [3:0]                               arqos_dmb_s_o,
  output                                     arvalid_dmb_s_o,
  input                                      arready_dmb_s_i,
  input  [AXI_SUB_ID_WIDTH-1:0]              rid_dmb_s_i,
  input  [AXI_DATA_WIDTH-1:0]                rdata_dmb_s_i,
  input                                      rlast_dmb_s_i,
  input  [1:0]                               rresp_dmb_s_i,
  input                                      rvalid_dmb_s_i,
  output                                     rready_dmb_s_o,
  output [AXI_SUB_ID_WIDTH-1:0]              awid_dmb_s_o,
  output [AXI_ADDR_WIDTH-1:0]                awaddr_dmb_s_o,
  output [AXI_LEN_WIDTH-1:0]                 awlen_dmb_s_o,
  output [AXI_USER_WIDTH-1:0]                awuser_dmb_s_o,
  output [3:0]                               awregion_dmb_s_o,
  output [2:0]                               awsize_dmb_s_o,
  output [1:0]                               awburst_dmb_s_o,
  output [3:0]                               awcache_dmb_s_o,
  output [1:0]                               awlock_dmb_s_o,
  output [2:0]                               awprot_dmb_s_o,
  output [3:0]                               awqos_dmb_s_o,
  output                                     awvalid_dmb_s_o,
  input                                      awready_dmb_s_i,
  output [AXI_SUB_ID_WIDTH-1:0]              wid_dmb_s_o,
  output [AXI_DATA_WIDTH-1:0]                wdata_dmb_s_o,
  output                                     wlast_dmb_s_o,
  output [AXI_DATA_WIDTH/8-1:0]              wstrb_dmb_s_o,
  output                                     wvalid_dmb_s_o,
  input                                      wready_dmb_s_i,
  input  [AXI_SUB_ID_WIDTH-1:0]              bid_dmb_s_i,
  input  [1:0]                               bresp_dmb_s_i,
  input                                      bvalid_dmb_s_i,
  output                                     bready_dmb_s_o,
  output [AXI_SUB_ID_WIDTH-1:0]              arid_periph_s_o,
  output [AXI_ADDR_WIDTH-1:0]                araddr_periph_s_o,
  output [AXI_LEN_WIDTH-1:0]                 arlen_periph_s_o,
  output [AXI_USER_WIDTH-1:0]                aruser_periph_s_o,
  output [3:0]                               arregion_periph_s_o,
  output [2:0]                               arsize_periph_s_o,
  output [1:0]                               arburst_periph_s_o,
  output [3:0]                               arcache_periph_s_o,
  output [1:0]                               arlock_periph_s_o,
  output [2:0]                               arprot_periph_s_o,
  output [3:0]                               arqos_periph_s_o,
  output                                     arvalid_periph_s_o,
  input                                      arready_periph_s_i,
  input  [AXI_SUB_ID_WIDTH-1:0]              rid_periph_s_i,
  input  [AXI_DATA_WIDTH-1:0]                rdata_periph_s_i,
  input                                      rlast_periph_s_i,
  input  [1:0]                               rresp_periph_s_i,
  input                                      rvalid_periph_s_i,
  output                                     rready_periph_s_o,
  output [AXI_SUB_ID_WIDTH-1:0]              awid_periph_s_o,
  output [AXI_ADDR_WIDTH-1:0]                awaddr_periph_s_o,
  output [AXI_LEN_WIDTH-1:0]                 awlen_periph_s_o,
  output [AXI_USER_WIDTH-1:0]                awuser_periph_s_o,
  output [3:0]                               awregion_periph_s_o,
  output [2:0]                               awsize_periph_s_o,
  output [1:0]                               awburst_periph_s_o,
  output [3:0]                               awcache_periph_s_o,
  output [1:0]                               awlock_periph_s_o,
  output [2:0]                               awprot_periph_s_o,
  output [3:0]                               awqos_periph_s_o,
  output                                     awvalid_periph_s_o,
  input                                      awready_periph_s_i,
  output [AXI_SUB_ID_WIDTH-1:0]              wid_periph_s_o,
  output [AXI_DATA_WIDTH-1:0]                wdata_periph_s_o,
  output                                     wlast_periph_s_o,
  output [AXI_DATA_WIDTH/8-1:0]              wstrb_periph_s_o,
  output                                     wvalid_periph_s_o,
  input                                      wready_periph_s_i,
  input  [AXI_SUB_ID_WIDTH-1:0]              bid_periph_s_i,
  input  [1:0]                               bresp_periph_s_i,
  input                                      bvalid_periph_s_i,
  output                                     bready_periph_s_o,
  output [AXI_SUB_ID_WIDTH-1:0]              arid_sram_m_o,
  output [AXI_ADDR_WIDTH-1:0]                araddr_sram_m_o,
  output [AXI_LEN_WIDTH-1:0]                 arlen_sram_m_o,
  output [AXI_USER_WIDTH-1:0]                aruser_sram_m_o,
  output [3:0]                               arregion_sram_m_o,
  output [2:0]                               arsize_sram_m_o,
  output [1:0]                               arburst_sram_m_o,
  output [3:0]                               arcache_sram_m_o,
  output [1:0]                               arlock_sram_m_o,
  output [2:0]                               arprot_sram_m_o,
  output [3:0]                               arqos_sram_m_o,
  output                                     arvalid_sram_m_o,
  input                                      arready_sram_m_i,
  input  [AXI_SUB_ID_WIDTH-1:0]              rid_sram_m_i,
  input  [AXI_DATA_WIDTH-1:0]                rdata_sram_m_i,
  input                                      rlast_sram_m_i,
  input  [1:0]                               rresp_sram_m_i,
  input                                      rvalid_sram_m_i,
  output                                     rready_sram_m_o,
  output [AXI_SUB_ID_WIDTH-1:0]              awid_sram_m_o,
  output [AXI_ADDR_WIDTH-1:0]                awaddr_sram_m_o,
  output [AXI_LEN_WIDTH-1:0]                 awlen_sram_m_o,
  output [AXI_USER_WIDTH-1:0]                awuser_sram_m_o,
  output [3:0]                               awregion_sram_m_o,
  output [2:0]                               awsize_sram_m_o,
  output [1:0]                               awburst_sram_m_o,
  output [3:0]                               awcache_sram_m_o,
  output [1:0]                               awlock_sram_m_o,
  output [2:0]                               awprot_sram_m_o,
  output [3:0]                               awqos_sram_m_o,
  output                                     awvalid_sram_m_o,
  input                                      awready_sram_m_i,
  output [AXI_SUB_ID_WIDTH-1:0]              wid_sram_m_o,
  output [AXI_DATA_WIDTH-1:0]                wdata_sram_m_o,
  output                                     wlast_sram_m_o,
  output [AXI_DATA_WIDTH/8-1:0]              wstrb_sram_m_o,
  output                                     wvalid_sram_m_o,
  input                                      wready_sram_m_i,
  input  [AXI_SUB_ID_WIDTH-1:0]              bid_sram_m_i,
  input  [1:0]                               bresp_sram_m_i,
  input                                      bvalid_sram_m_i,
  output                                     bready_sram_m_o
);

// ==================================================
// Internal Wire Signals
// ==================================================
wire                                     clk;
wire                                     rstn;
wire [AXI_MGR_ID_WIDTH-1:0]              arid_cpu_m;
wire [AXI_ADDR_WIDTH-1:0]                araddr_cpu_m;
wire [AXI_LEN_WIDTH-1:0]                 arlen_cpu_m;
wire [AXI_USER_WIDTH-1:0]                aruser_cpu_m;
wire [3:0]                               arregion_cpu_m;
wire [2:0]                               arsize_cpu_m;
wire [1:0]                               arburst_cpu_m;
wire [3:0]                               arcache_cpu_m;
wire [1:0]                               arlock_cpu_m;
wire [2:0]                               arprot_cpu_m;
wire [3:0]                               arqos_cpu_m;
wire                                     arvalid_cpu_m;
wire                                     arready_cpu_m;
wire [AXI_MGR_ID_WIDTH-1:0]              rid_cpu_m;
wire [AXI_DATA_WIDTH-1:0]                rdata_cpu_m;
wire                                     rlast_cpu_m;
wire [1:0]                               rresp_cpu_m;
wire                                     rvalid_cpu_m;
wire                                     rready_cpu_m;
wire [AXI_MGR_ID_WIDTH-1:0]              awid_cpu_m;
wire [AXI_ADDR_WIDTH-1:0]                awaddr_cpu_m;
wire [AXI_LEN_WIDTH-1:0]                 awlen_cpu_m;
wire [AXI_USER_WIDTH-1:0]                awuser_cpu_m;
wire [3:0]                               awregion_cpu_m;
wire [2:0]                               awsize_cpu_m;
wire [1:0]                               awburst_cpu_m;
wire [3:0]                               awcache_cpu_m;
wire [1:0]                               awlock_cpu_m;
wire [2:0]                               awprot_cpu_m;
wire [3:0]                               awqos_cpu_m;
wire                                     awvalid_cpu_m;
wire                                     awready_cpu_m;
wire [AXI_MGR_ID_WIDTH-1:0]              wid_cpu_m;
wire [AXI_DATA_WIDTH-1:0]                wdata_cpu_m;
wire                                     wlast_cpu_m;
wire [AXI_DATA_WIDTH/8-1:0]              wstrb_cpu_m;
wire                                     wvalid_cpu_m;
wire                                     wready_cpu_m;
wire [AXI_MGR_ID_WIDTH-1:0]              bid_cpu_m;
wire [1:0]                               bresp_cpu_m;
wire                                     bvalid_cpu_m;
wire                                     bready_cpu_m;
wire [AXI_MGR_ID_WIDTH-1:0]              arid_dma_m;
wire [AXI_ADDR_WIDTH-1:0]                araddr_dma_m;
wire [AXI_LEN_WIDTH-1:0]                 arlen_dma_m;
wire [AXI_USER_WIDTH-1:0]                aruser_dma_m;
wire [3:0]                               arregion_dma_m;
wire [2:0]                               arsize_dma_m;
wire [1:0]                               arburst_dma_m;
wire [3:0]                               arcache_dma_m;
wire [1:0]                               arlock_dma_m;
wire [2:0]                               arprot_dma_m;
wire [3:0]                               arqos_dma_m;
wire                                     arvalid_dma_m;
wire                                     arready_dma_m;
wire [AXI_MGR_ID_WIDTH-1:0]              rid_dma_m;
wire [AXI_DATA_WIDTH-1:0]                rdata_dma_m;
wire                                     rlast_dma_m;
wire [1:0]                               rresp_dma_m;
wire                                     rvalid_dma_m;
wire                                     rready_dma_m;
wire [AXI_MGR_ID_WIDTH-1:0]              awid_dma_m;
wire [AXI_ADDR_WIDTH-1:0]                awaddr_dma_m;
wire [AXI_LEN_WIDTH-1:0]                 awlen_dma_m;
wire [AXI_USER_WIDTH-1:0]                awuser_dma_m;
wire [3:0]                               awregion_dma_m;
wire [2:0]                               awsize_dma_m;
wire [1:0]                               awburst_dma_m;
wire [3:0]                               awcache_dma_m;
wire [1:0]                               awlock_dma_m;
wire [2:0]                               awprot_dma_m;
wire [3:0]                               awqos_dma_m;
wire                                     awvalid_dma_m;
wire                                     awready_dma_m;
wire [AXI_MGR_ID_WIDTH-1:0]              wid_dma_m;
wire [AXI_DATA_WIDTH-1:0]                wdata_dma_m;
wire                                     wlast_dma_m;
wire [AXI_DATA_WIDTH/8-1:0]              wstrb_dma_m;
wire                                     wvalid_dma_m;
wire                                     wready_dma_m;
wire [AXI_MGR_ID_WIDTH-1:0]              bid_dma_m;
wire [1:0]                               bresp_dma_m;
wire                                     bvalid_dma_m;
wire                                     bready_dma_m;
wire [AXI_SUB_ID_WIDTH-1:0]              arid_dmb_s;
wire [AXI_ADDR_WIDTH-1:0]                araddr_dmb_s;
wire [AXI_LEN_WIDTH-1:0]                 arlen_dmb_s;
wire [AXI_USER_WIDTH-1:0]                aruser_dmb_s;
wire [3:0]                               arregion_dmb_s;
wire [2:0]                               arsize_dmb_s;
wire [1:0]                               arburst_dmb_s;
wire [3:0]                               arcache_dmb_s;
wire [1:0]                               arlock_dmb_s;
wire [2:0]                               arprot_dmb_s;
wire [3:0]                               arqos_dmb_s;
wire                                     arvalid_dmb_s;
wire                                     arready_dmb_s;
wire [AXI_SUB_ID_WIDTH-1:0]              rid_dmb_s;
wire [AXI_DATA_WIDTH-1:0]                rdata_dmb_s;
wire                                     rlast_dmb_s;
wire [1:0]                               rresp_dmb_s;
wire                                     rvalid_dmb_s;
wire                                     rready_dmb_s;
wire [AXI_SUB_ID_WIDTH-1:0]              awid_dmb_s;
wire [AXI_ADDR_WIDTH-1:0]                awaddr_dmb_s;
wire [AXI_LEN_WIDTH-1:0]                 awlen_dmb_s;
wire [AXI_USER_WIDTH-1:0]                awuser_dmb_s;
wire [3:0]                               awregion_dmb_s;
wire [2:0]                               awsize_dmb_s;
wire [1:0]                               awburst_dmb_s;
wire [3:0]                               awcache_dmb_s;
wire [1:0]                               awlock_dmb_s;
wire [2:0]                               awprot_dmb_s;
wire [3:0]                               awqos_dmb_s;
wire                                     awvalid_dmb_s;
wire                                     awready_dmb_s;
wire [AXI_SUB_ID_WIDTH-1:0]              wid_dmb_s;
wire [AXI_DATA_WIDTH-1:0]                wdata_dmb_s;
wire                                     wlast_dmb_s;
wire [AXI_DATA_WIDTH/8-1:0]              wstrb_dmb_s;
wire                                     wvalid_dmb_s;
wire                                     wready_dmb_s;
wire [AXI_SUB_ID_WIDTH-1:0]              bid_dmb_s;
wire [1:0]                               bresp_dmb_s;
wire                                     bvalid_dmb_s;
wire                                     bready_dmb_s;
wire [AXI_SUB_ID_WIDTH-1:0]              arid_periph_s;
wire [AXI_ADDR_WIDTH-1:0]                araddr_periph_s;
wire [AXI_LEN_WIDTH-1:0]                 arlen_periph_s;
wire [AXI_USER_WIDTH-1:0]                aruser_periph_s;
wire [3:0]                               arregion_periph_s;
wire [2:0]                               arsize_periph_s;
wire [1:0]                               arburst_periph_s;
wire [3:0]                               arcache_periph_s;
wire [1:0]                               arlock_periph_s;
wire [2:0]                               arprot_periph_s;
wire [3:0]                               arqos_periph_s;
wire                                     arvalid_periph_s;
wire                                     arready_periph_s;
wire [AXI_SUB_ID_WIDTH-1:0]              rid_periph_s;
wire [AXI_DATA_WIDTH-1:0]                rdata_periph_s;
wire                                     rlast_periph_s;
wire [1:0]                               rresp_periph_s;
wire                                     rvalid_periph_s;
wire                                     rready_periph_s;
wire [AXI_SUB_ID_WIDTH-1:0]              awid_periph_s;
wire [AXI_ADDR_WIDTH-1:0]                awaddr_periph_s;
wire [AXI_LEN_WIDTH-1:0]                 awlen_periph_s;
wire [AXI_USER_WIDTH-1:0]                awuser_periph_s;
wire [3:0]                               awregion_periph_s;
wire [2:0]                               awsize_periph_s;
wire [1:0]                               awburst_periph_s;
wire [3:0]                               awcache_periph_s;
wire [1:0]                               awlock_periph_s;
wire [2:0]                               awprot_periph_s;
wire [3:0]                               awqos_periph_s;
wire                                     awvalid_periph_s;
wire                                     awready_periph_s;
wire [AXI_SUB_ID_WIDTH-1:0]              wid_periph_s;
wire [AXI_DATA_WIDTH-1:0]                wdata_periph_s;
wire                                     wlast_periph_s;
wire [AXI_DATA_WIDTH/8-1:0]              wstrb_periph_s;
wire                                     wvalid_periph_s;
wire                                     wready_periph_s;
wire [AXI_SUB_ID_WIDTH-1:0]              bid_periph_s;
wire [1:0]                               bresp_periph_s;
wire                                     bvalid_periph_s;
wire                                     bready_periph_s;
wire [AXI_SUB_ID_WIDTH-1:0]              arid_sram_m;
wire [AXI_ADDR_WIDTH-1:0]                araddr_sram_m;
wire [AXI_LEN_WIDTH-1:0]                 arlen_sram_m;
wire [AXI_USER_WIDTH-1:0]                aruser_sram_m;
wire [3:0]                               arregion_sram_m;
wire [2:0]                               arsize_sram_m;
wire [1:0]                               arburst_sram_m;
wire [3:0]                               arcache_sram_m;
wire [1:0]                               arlock_sram_m;
wire [2:0]                               arprot_sram_m;
wire [3:0]                               arqos_sram_m;
wire                                     arvalid_sram_m;
wire                                     arready_sram_m;
wire [AXI_SUB_ID_WIDTH-1:0]              rid_sram_m;
wire [AXI_DATA_WIDTH-1:0]                rdata_sram_m;
wire                                     rlast_sram_m;
wire [1:0]                               rresp_sram_m;
wire                                     rvalid_sram_m;
wire                                     rready_sram_m;
wire [AXI_SUB_ID_WIDTH-1:0]              awid_sram_m;
wire [AXI_ADDR_WIDTH-1:0]                awaddr_sram_m;
wire [AXI_LEN_WIDTH-1:0]                 awlen_sram_m;
wire [AXI_USER_WIDTH-1:0]                awuser_sram_m;
wire [3:0]                               awregion_sram_m;
wire [2:0]                               awsize_sram_m;
wire [1:0]                               awburst_sram_m;
wire [3:0]                               awcache_sram_m;
wire [1:0]                               awlock_sram_m;
wire [2:0]                               awprot_sram_m;
wire [3:0]                               awqos_sram_m;
wire                                     awvalid_sram_m;
wire                                     awready_sram_m;
wire [AXI_SUB_ID_WIDTH-1:0]              wid_sram_m;
wire [AXI_DATA_WIDTH-1:0]                wdata_sram_m;
wire                                     wlast_sram_m;
wire [AXI_DATA_WIDTH/8-1:0]              wstrb_sram_m;
wire                                     wvalid_sram_m;
wire                                     wready_sram_m;
wire [AXI_SUB_ID_WIDTH-1:0]              bid_sram_m;
wire [1:0]                               bresp_sram_m;
wire                                     bvalid_sram_m;
wire                                     bready_sram_m;

// ==================================================
// Pre Code Insertion
// ==================================================

// ==================================================
// Instance axi_mgr0_cpu_m wire definitions
// ==================================================
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] awphase_mgr0;
wire [4-1:0]                             awphase_valid_mgr0;
wire                                     awphase_ready_mgr0;
wire [32-1:0]                            awphase_addr_mgr0;
wire [4-1:0]                             awphase_decode_mgr0;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+(AXI_DATA_WIDTH/8)+MGR_ID_BITS+1)-1:0] wphase_mgr0;
wire [4-1:0]                             wphase_valid_mgr0;
wire                                     wphase_ready_mgr0;
wire [(AXI_MGR_ID_WIDTH+MGR_ID_BITS+2)-1:0] bphase_mgr0;
wire                                     bphase_valid_mgr0;
wire                                     bphase_ready_mgr0;
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] arphase_mgr0;
wire [4-1:0]                             arphase_valid_mgr0;
wire                                     arphase_ready_mgr0;
wire [32-1:0]                            arphase_addr_mgr0;
wire [4-1:0]                             arphase_decode_mgr0;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+MGR_ID_BITS+3)-1:0] rphase_mgr0;
wire                                     rphase_valid_mgr0;
wire                                     rphase_ready_mgr0;

// ==================================================
// Instance axi_addr_decode_mgr0 wire definitions
// ==================================================

// ==================================================
// Instance axi_sub_mux_sub0 wire definitions
// ==================================================
wire [1:0]                               awphase_ready_from_sub0;
wire [1:0]                               wphase_ready_from_sub0;
wire [1:0]                               arphase_ready_from_sub0;
wire [1:0]                               awphase_ready_from_sub1;
wire [1:0]                               wphase_ready_from_sub1;
wire [1:0]                               arphase_ready_from_sub1;
wire [1:0]                               awphase_ready_from_sub2;
wire [1:0]                               wphase_ready_from_sub2;
wire [1:0]                               arphase_ready_from_sub2;
wire [1:0]                               awphase_ready_from_sub3;
wire [1:0]                               wphase_ready_from_sub3;
wire [1:0]                               arphase_ready_from_sub3;
wire [3:0]                               rphase_ready_from_mgr0;
wire [3:0]                               bphase_ready_from_mgr0;
wire [1:0]                               bphase_valid_sub0;
wire [1:0]                               rphase_valid_sub0;
wire [1:0]                               bphase_valid_sub1;
wire [1:0]                               rphase_valid_sub1;
wire [1:0]                               bphase_valid_sub2;
wire [1:0]                               rphase_valid_sub2;
wire [1:0]                               bphase_valid_sub3;
wire [1:0]                               rphase_valid_sub3;
wire [(AXI_MGR_ID_WIDTH+MGR_ID_BITS+2)-1:0] bphase_sub0;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+MGR_ID_BITS+3)-1:0] rphase_sub0;
wire [(AXI_MGR_ID_WIDTH+MGR_ID_BITS+2)-1:0] bphase_sub1;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+MGR_ID_BITS+3)-1:0] rphase_sub1;
wire [(AXI_MGR_ID_WIDTH+MGR_ID_BITS+2)-1:0] bphase_sub2;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+MGR_ID_BITS+3)-1:0] rphase_sub2;
wire [(AXI_MGR_ID_WIDTH+MGR_ID_BITS+2)-1:0] bphase_sub3;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+MGR_ID_BITS+3)-1:0] rphase_sub3;

// ==================================================
// Instance axi_mgr1_dma_m wire definitions
// ==================================================
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] awphase_mgr1;
wire [4-1:0]                             awphase_valid_mgr1;
wire                                     awphase_ready_mgr1;
wire [32-1:0]                            awphase_addr_mgr1;
wire [4-1:0]                             awphase_decode_mgr1;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+(AXI_DATA_WIDTH/8)+MGR_ID_BITS+1)-1:0] wphase_mgr1;
wire [4-1:0]                             wphase_valid_mgr1;
wire                                     wphase_ready_mgr1;
wire [(AXI_MGR_ID_WIDTH+MGR_ID_BITS+2)-1:0] bphase_mgr1;
wire                                     bphase_valid_mgr1;
wire                                     bphase_ready_mgr1;
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] arphase_mgr1;
wire [4-1:0]                             arphase_valid_mgr1;
wire                                     arphase_ready_mgr1;
wire [32-1:0]                            arphase_addr_mgr1;
wire [4-1:0]                             arphase_decode_mgr1;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+MGR_ID_BITS+3)-1:0] rphase_mgr1;
wire                                     rphase_valid_mgr1;
wire                                     rphase_ready_mgr1;

// ==================================================
// Instance axi_addr_decode_mgr1 wire definitions
// ==================================================

// ==================================================
// Instance axi_sub_mux_sub1 wire definitions
// ==================================================
wire [3:0]                               rphase_ready_from_mgr1;
wire [3:0]                               bphase_ready_from_mgr1;

// ==================================================
// Instance axi_sub0_dmb_s wire definitions
// ==================================================
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] awphase_sub0;
wire                                     awphase_valid_sub0;
wire                                     awphase_ready_sub0;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+(AXI_DATA_WIDTH/8)+MGR_ID_BITS+1)-1:0] wphase_sub0;
wire                                     wphase_valid_sub0;
wire                                     wphase_ready_sub0;
wire                                     bphase_ready_sub0;
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] arphase_sub0;
wire                                     arphase_valid_sub0;
wire                                     arphase_ready_sub0;
wire                                     rphase_ready_sub0;

// ==================================================
// Instance axi_mgr_mux_sub0 wire definitions
// ==================================================

// ==================================================
// Instance axi_sub1_periph_s wire definitions
// ==================================================
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] awphase_sub1;
wire                                     awphase_valid_sub1;
wire                                     awphase_ready_sub1;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+(AXI_DATA_WIDTH/8)+MGR_ID_BITS+1)-1:0] wphase_sub1;
wire                                     wphase_valid_sub1;
wire                                     wphase_ready_sub1;
wire                                     bphase_ready_sub1;
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] arphase_sub1;
wire                                     arphase_valid_sub1;
wire                                     arphase_ready_sub1;
wire                                     rphase_ready_sub1;

// ==================================================
// Instance axi_mgr_mux_sub1 wire definitions
// ==================================================

// ==================================================
// Instance axi_sub2_sram_m wire definitions
// ==================================================
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] awphase_sub2;
wire                                     awphase_valid_sub2;
wire                                     awphase_ready_sub2;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+(AXI_DATA_WIDTH/8)+MGR_ID_BITS+1)-1:0] wphase_sub2;
wire                                     wphase_valid_sub2;
wire                                     wphase_ready_sub2;
wire                                     bphase_ready_sub2;
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] arphase_sub2;
wire                                     arphase_valid_sub2;
wire                                     arphase_ready_sub2;
wire                                     rphase_ready_sub2;

// ==================================================
// Instance axi_mgr_mux_sub2 wire definitions
// ==================================================

// ==================================================
// Instance axi_sub3_def wire definitions
// ==================================================
wire [5-1:0]                             awid_def;
wire [32-1:0]                            awaddr_def;
wire [8-1:0]                             awlen_def;
wire [12-1:0]                            awuser_def;
wire [3:0]                               awregion_def;
wire [2:0]                               awsize_def;
wire [1:0]                               awburst_def;
wire [3:0]                               awcache_def;
wire [1:0]                               awlock_def;
wire [2:0]                               awprot_def;
wire [3:0]                               awqos_def;
wire                                     awvalid_def;
wire                                     awready_def;
wire [5-1:0]                             wid_def;
wire [32-1:0]                            wdata_def;
wire                                     wlast_def;
wire [(32/8)-1:0]                        wstrb_def;
wire                                     wvalid_def;
wire                                     wready_def;
wire [5-1:0]                             bid_def;
wire [1:0]                               bresp_def;
wire                                     bvalid_def;
wire                                     bready_def;
wire [5-1:0]                             arid_def;
wire [32-1:0]                            araddr_def;
wire [8-1:0]                             arlen_def;
wire [12-1:0]                            aruser_def;
wire [3:0]                               arregion_def;
wire [2:0]                               arsize_def;
wire [1:0]                               arburst_def;
wire [3:0]                               arcache_def;
wire [1:0]                               arlock_def;
wire [2:0]                               arprot_def;
wire [3:0]                               arqos_def;
wire                                     arvalid_def;
wire                                     arready_def;
wire [5-1:0]                             rid_def;
wire [32-1:0]                            rdata_def;
wire                                     rlast_def;
wire [1:0]                               rresp_def;
wire                                     rvalid_def;
wire                                     rready_def;
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] awphase_sub3;
wire                                     awphase_valid_sub3;
wire                                     awphase_ready_sub3;
wire [(AXI_MGR_ID_WIDTH+AXI_DATA_WIDTH+(AXI_DATA_WIDTH/8)+MGR_ID_BITS+1)-1:0] wphase_sub3;
wire                                     wphase_valid_sub3;
wire                                     wphase_ready_sub3;
wire                                     bphase_ready_sub3;
wire [(AXI_MGR_ID_WIDTH+AXI_ADDR_WIDTH+AXI_LEN_WIDTH+MGR_ID_BITS+AXI_USER_WIDTH+22)-1:0] arphase_sub3;
wire                                     arphase_valid_sub3;
wire                                     arphase_ready_sub3;
wire                                     rphase_ready_sub3;

// ==================================================
// Instance axi_mgr_mux_sub3 wire definitions
// ==================================================

// ==================================================
// Instance axi_def_sub wire definitions
// ==================================================

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_mgr0_cpu_m
// ==================================================
msftDvIp_axi_mgr_ifc #(
  .MGR_ID_BITS(1),
  .MGR_NUM(0),
  .NUM_SUBS(NUM_SUBS),
  .AXI_MGR_ID_WIDTH(AXI_MGR_ID_WIDTH),
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
  .AXI_LEN_WIDTH(AXI_LEN_WIDTH),
  .AXI_USER_WIDTH(AXI_USER_WIDTH),
  .AXI_FIFO_SIZE(AXI_FIFO_SIZE),
  .APHASE_LEN(APHASE_LEN),
  .WPHASE_LEN(WPHASE_LEN),
  .RPHASE_LEN(RPHASE_LEN),
  .BPHASE_LEN(BPHASE_LEN)
  ) axi_mgr0_cpu_m_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .awid_mgr_i                    ( awid_cpu_m                               ),
  .awaddr_mgr_i                  ( awaddr_cpu_m                             ),
  .awlen_mgr_i                   ( awlen_cpu_m                              ),
  .awuser_mgr_i                  ( awuser_cpu_m                             ),
  .awregion_mgr_i                ( awregion_cpu_m                           ),
  .awsize_mgr_i                  ( awsize_cpu_m                             ),
  .awburst_mgr_i                 ( awburst_cpu_m                            ),
  .awcache_mgr_i                 ( awcache_cpu_m                            ),
  .awlock_mgr_i                  ( awlock_cpu_m                             ),
  .awprot_mgr_i                  ( awprot_cpu_m                             ),
  .awqos_mgr_i                   ( awqos_cpu_m                              ),
  .awvalid_mgr_i                 ( awvalid_cpu_m                            ),
  .awready_mgr_o                 ( awready_cpu_m                            ),
  .wid_mgr_i                     ( wid_cpu_m                                ),
  .wdata_mgr_i                   ( wdata_cpu_m                              ),
  .wstrb_mgr_i                   ( wstrb_cpu_m                              ),
  .wlast_mgr_i                   ( wlast_cpu_m                              ),
  .wvalid_mgr_i                  ( wvalid_cpu_m                             ),
  .wready_mgr_o                  ( wready_cpu_m                             ),
  .bid_mgr_o                     ( bid_cpu_m                                ),
  .bresp_mgr_o                   ( bresp_cpu_m                              ),
  .bvalid_mgr_o                  ( bvalid_cpu_m                             ),
  .bready_mgr_i                  ( bready_cpu_m                             ),
  .arid_mgr_i                    ( arid_cpu_m                               ),
  .araddr_mgr_i                  ( araddr_cpu_m                             ),
  .arlen_mgr_i                   ( arlen_cpu_m                              ),
  .aruser_mgr_i                  ( aruser_cpu_m                             ),
  .arregion_mgr_i                ( arregion_cpu_m                           ),
  .arsize_mgr_i                  ( arsize_cpu_m                             ),
  .arburst_mgr_i                 ( arburst_cpu_m                            ),
  .arcache_mgr_i                 ( arcache_cpu_m                            ),
  .arlock_mgr_i                  ( arlock_cpu_m                             ),
  .arprot_mgr_i                  ( arprot_cpu_m                             ),
  .arqos_mgr_i                   ( arqos_cpu_m                              ),
  .arvalid_mgr_i                 ( arvalid_cpu_m                            ),
  .arready_mgr_o                 ( arready_cpu_m                            ),
  .rid_mgr_o                     ( rid_cpu_m                                ),
  .rdata_mgr_o                   ( rdata_cpu_m                              ),
  .rlast_mgr_o                   ( rlast_cpu_m                              ),
  .rresp_mgr_o                   ( rresp_cpu_m                              ),
  .rvalid_mgr_o                  ( rvalid_cpu_m                             ),
  .rready_mgr_i                  ( rready_cpu_m                             ),
  .awphase_o                     ( awphase_mgr0                             ),
  .awphase_valid_o               ( awphase_valid_mgr0                       ),
  .awphase_ready_i               ( awphase_ready_mgr0                       ),
  .awphase_addr_o                ( awphase_addr_mgr0                        ),
  .awphase_decode_i              ( awphase_decode_mgr0                      ),
  .wphase_o                      ( wphase_mgr0                              ),
  .wphase_valid_o                ( wphase_valid_mgr0                        ),
  .wphase_ready_i                ( wphase_ready_mgr0                        ),
  .bphase_i                      ( bphase_mgr0                              ),
  .bphase_valid_i                ( bphase_valid_mgr0                        ),
  .bphase_ready_o                ( bphase_ready_mgr0                        ),
  .arphase_o                     ( arphase_mgr0                             ),
  .arphase_valid_o               ( arphase_valid_mgr0                       ),
  .arphase_ready_i               ( arphase_ready_mgr0                       ),
  .arphase_addr_o                ( arphase_addr_mgr0                        ),
  .arphase_decode_i              ( arphase_decode_mgr0                      ),
  .rphase_i                      ( rphase_mgr0                              ),
  .rphase_valid_i                ( rphase_valid_mgr0                        ),
  .rphase_ready_o                ( rphase_ready_mgr0                        )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_addr_decode_mgr0
// ==================================================
msftDvIp_msftDvIp_cheri_axi_fabric_addr_decode #(
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .ENABLE_SUB0(2'h3),
  .ENABLE_SUB1(2'h3),
  .ENABLE_SUB2(2'h3)
  ) axi_addr_decode_mgr0_i (
  .awphase_addr_mgr_i            ( awphase_addr_mgr0                        ),
  .arphase_addr_mgr_i            ( arphase_addr_mgr0                        ),
  .awphase_decode_mgr_o          ( awphase_decode_mgr0                      ),
  .arphase_decode_mgr_o          ( arphase_decode_mgr0                      )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_sub_mux_sub0
// ==================================================
msftDvIp_msftDvIp_cheri_axi_fabric_sub_mux #(
  .RPHASE_LEN(RPHASE_LEN),
  .BPHASE_LEN(BPHASE_LEN),
  .MGR_NUM(0)
  ) axi_sub_mux_sub0_i (
  .clk                           ( clk                                      ),
  .rstn                          ( rstn                                     ),
  .awphase_ready_from_sub0_i     ( awphase_ready_from_sub0                  ),
  .wphase_ready_from_sub0_i      ( wphase_ready_from_sub0                   ),
  .arphase_ready_from_sub0_i     ( arphase_ready_from_sub0                  ),
  .awphase_ready_from_sub1_i     ( awphase_ready_from_sub1                  ),
  .wphase_ready_from_sub1_i      ( wphase_ready_from_sub1                   ),
  .arphase_ready_from_sub1_i     ( arphase_ready_from_sub1                  ),
  .awphase_ready_from_sub2_i     ( awphase_ready_from_sub2                  ),
  .wphase_ready_from_sub2_i      ( wphase_ready_from_sub2                   ),
  .arphase_ready_from_sub2_i     ( arphase_ready_from_sub2                  ),
  .awphase_ready_from_sub3_i     ( awphase_ready_from_sub3                  ),
  .wphase_ready_from_sub3_i      ( wphase_ready_from_sub3                   ),
  .arphase_ready_from_sub3_i     ( arphase_ready_from_sub3                  ),
  .awphase_ready_mgr_o           ( awphase_ready_mgr0                       ),
  .wphase_ready_mgr_o            ( wphase_ready_mgr0                        ),
  .arphase_ready_mgr_o           ( arphase_ready_mgr0                       ),
  .rphase_ready_mgr_i            ( rphase_ready_mgr0                        ),
  .bphase_ready_mgr_i            ( bphase_ready_mgr0                        ),
  .rphase_ready_from_mgr_o       ( rphase_ready_from_mgr0                   ),
  .bphase_ready_from_mgr_o       ( bphase_ready_from_mgr0                   ),
  .bphase_valid_sub0_i           ( bphase_valid_sub0                        ),
  .rphase_valid_sub0_i           ( rphase_valid_sub0                        ),
  .bphase_valid_sub1_i           ( bphase_valid_sub1                        ),
  .rphase_valid_sub1_i           ( rphase_valid_sub1                        ),
  .bphase_valid_sub2_i           ( bphase_valid_sub2                        ),
  .rphase_valid_sub2_i           ( rphase_valid_sub2                        ),
  .bphase_valid_sub3_i           ( bphase_valid_sub3                        ),
  .rphase_valid_sub3_i           ( rphase_valid_sub3                        ),
  .bphase_valid_mgr_o            ( bphase_valid_mgr0                        ),
  .rphase_valid_mgr_o            ( rphase_valid_mgr0                        ),
  .bphase_sub0_i                 ( bphase_sub0                              ),
  .rphase_sub0_i                 ( rphase_sub0                              ),
  .bphase_sub1_i                 ( bphase_sub1                              ),
  .rphase_sub1_i                 ( rphase_sub1                              ),
  .bphase_sub2_i                 ( bphase_sub2                              ),
  .rphase_sub2_i                 ( rphase_sub2                              ),
  .bphase_sub3_i                 ( bphase_sub3                              ),
  .rphase_sub3_i                 ( rphase_sub3                              ),
  .bphase_mgr_o                  ( bphase_mgr0                              ),
  .rphase_mgr_o                  ( rphase_mgr0                              )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_mgr1_dma_m
// ==================================================
msftDvIp_axi_mgr_ifc #(
  .MGR_ID_BITS(1),
  .MGR_NUM(1),
  .NUM_SUBS(NUM_SUBS),
  .AXI_MGR_ID_WIDTH(AXI_MGR_ID_WIDTH),
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
  .AXI_LEN_WIDTH(AXI_LEN_WIDTH),
  .AXI_USER_WIDTH(AXI_USER_WIDTH),
  .AXI_FIFO_SIZE(AXI_FIFO_SIZE),
  .APHASE_LEN(APHASE_LEN),
  .WPHASE_LEN(WPHASE_LEN),
  .RPHASE_LEN(RPHASE_LEN),
  .BPHASE_LEN(BPHASE_LEN)
  ) axi_mgr1_dma_m_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .awid_mgr_i                    ( awid_dma_m                               ),
  .awaddr_mgr_i                  ( awaddr_dma_m                             ),
  .awlen_mgr_i                   ( awlen_dma_m                              ),
  .awuser_mgr_i                  ( awuser_dma_m                             ),
  .awregion_mgr_i                ( awregion_dma_m                           ),
  .awsize_mgr_i                  ( awsize_dma_m                             ),
  .awburst_mgr_i                 ( awburst_dma_m                            ),
  .awcache_mgr_i                 ( awcache_dma_m                            ),
  .awlock_mgr_i                  ( awlock_dma_m                             ),
  .awprot_mgr_i                  ( awprot_dma_m                             ),
  .awqos_mgr_i                   ( awqos_dma_m                              ),
  .awvalid_mgr_i                 ( awvalid_dma_m                            ),
  .awready_mgr_o                 ( awready_dma_m                            ),
  .wid_mgr_i                     ( wid_dma_m                                ),
  .wdata_mgr_i                   ( wdata_dma_m                              ),
  .wstrb_mgr_i                   ( wstrb_dma_m                              ),
  .wlast_mgr_i                   ( wlast_dma_m                              ),
  .wvalid_mgr_i                  ( wvalid_dma_m                             ),
  .wready_mgr_o                  ( wready_dma_m                             ),
  .bid_mgr_o                     ( bid_dma_m                                ),
  .bresp_mgr_o                   ( bresp_dma_m                              ),
  .bvalid_mgr_o                  ( bvalid_dma_m                             ),
  .bready_mgr_i                  ( bready_dma_m                             ),
  .arid_mgr_i                    ( arid_dma_m                               ),
  .araddr_mgr_i                  ( araddr_dma_m                             ),
  .arlen_mgr_i                   ( arlen_dma_m                              ),
  .aruser_mgr_i                  ( aruser_dma_m                             ),
  .arregion_mgr_i                ( arregion_dma_m                           ),
  .arsize_mgr_i                  ( arsize_dma_m                             ),
  .arburst_mgr_i                 ( arburst_dma_m                            ),
  .arcache_mgr_i                 ( arcache_dma_m                            ),
  .arlock_mgr_i                  ( arlock_dma_m                             ),
  .arprot_mgr_i                  ( arprot_dma_m                             ),
  .arqos_mgr_i                   ( arqos_dma_m                              ),
  .arvalid_mgr_i                 ( arvalid_dma_m                            ),
  .arready_mgr_o                 ( arready_dma_m                            ),
  .rid_mgr_o                     ( rid_dma_m                                ),
  .rdata_mgr_o                   ( rdata_dma_m                              ),
  .rlast_mgr_o                   ( rlast_dma_m                              ),
  .rresp_mgr_o                   ( rresp_dma_m                              ),
  .rvalid_mgr_o                  ( rvalid_dma_m                             ),
  .rready_mgr_i                  ( rready_dma_m                             ),
  .awphase_o                     ( awphase_mgr1                             ),
  .awphase_valid_o               ( awphase_valid_mgr1                       ),
  .awphase_ready_i               ( awphase_ready_mgr1                       ),
  .awphase_addr_o                ( awphase_addr_mgr1                        ),
  .awphase_decode_i              ( awphase_decode_mgr1                      ),
  .wphase_o                      ( wphase_mgr1                              ),
  .wphase_valid_o                ( wphase_valid_mgr1                        ),
  .wphase_ready_i                ( wphase_ready_mgr1                        ),
  .bphase_i                      ( bphase_mgr1                              ),
  .bphase_valid_i                ( bphase_valid_mgr1                        ),
  .bphase_ready_o                ( bphase_ready_mgr1                        ),
  .arphase_o                     ( arphase_mgr1                             ),
  .arphase_valid_o               ( arphase_valid_mgr1                       ),
  .arphase_ready_i               ( arphase_ready_mgr1                       ),
  .arphase_addr_o                ( arphase_addr_mgr1                        ),
  .arphase_decode_i              ( arphase_decode_mgr1                      ),
  .rphase_i                      ( rphase_mgr1                              ),
  .rphase_valid_i                ( rphase_valid_mgr1                        ),
  .rphase_ready_o                ( rphase_ready_mgr1                        )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_addr_decode_mgr1
// ==================================================
msftDvIp_msftDvIp_cheri_axi_fabric_addr_decode #(
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .ENABLE_SUB0(2'h3),
  .ENABLE_SUB1(2'h3),
  .ENABLE_SUB2(2'h3)
  ) axi_addr_decode_mgr1_i (
  .awphase_addr_mgr_i            ( awphase_addr_mgr1                        ),
  .arphase_addr_mgr_i            ( arphase_addr_mgr1                        ),
  .awphase_decode_mgr_o          ( awphase_decode_mgr1                      ),
  .arphase_decode_mgr_o          ( arphase_decode_mgr1                      )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_sub_mux_sub1
// ==================================================
msftDvIp_msftDvIp_cheri_axi_fabric_sub_mux #(
  .RPHASE_LEN(RPHASE_LEN),
  .BPHASE_LEN(BPHASE_LEN),
  .MGR_NUM(1)
  ) axi_sub_mux_sub1_i (
  .clk                           ( clk                                      ),
  .rstn                          ( rstn                                     ),
  .awphase_ready_from_sub0_i     ( awphase_ready_from_sub0                  ),
  .wphase_ready_from_sub0_i      ( wphase_ready_from_sub0                   ),
  .arphase_ready_from_sub0_i     ( arphase_ready_from_sub0                  ),
  .awphase_ready_from_sub1_i     ( awphase_ready_from_sub1                  ),
  .wphase_ready_from_sub1_i      ( wphase_ready_from_sub1                   ),
  .arphase_ready_from_sub1_i     ( arphase_ready_from_sub1                  ),
  .awphase_ready_from_sub2_i     ( awphase_ready_from_sub2                  ),
  .wphase_ready_from_sub2_i      ( wphase_ready_from_sub2                   ),
  .arphase_ready_from_sub2_i     ( arphase_ready_from_sub2                  ),
  .awphase_ready_from_sub3_i     ( awphase_ready_from_sub3                  ),
  .wphase_ready_from_sub3_i      ( wphase_ready_from_sub3                   ),
  .arphase_ready_from_sub3_i     ( arphase_ready_from_sub3                  ),
  .awphase_ready_mgr_o           ( awphase_ready_mgr1                       ),
  .wphase_ready_mgr_o            ( wphase_ready_mgr1                        ),
  .arphase_ready_mgr_o           ( arphase_ready_mgr1                       ),
  .rphase_ready_mgr_i            ( rphase_ready_mgr1                        ),
  .bphase_ready_mgr_i            ( bphase_ready_mgr1                        ),
  .rphase_ready_from_mgr_o       ( rphase_ready_from_mgr1                   ),
  .bphase_ready_from_mgr_o       ( bphase_ready_from_mgr1                   ),
  .bphase_valid_sub0_i           ( bphase_valid_sub0                        ),
  .rphase_valid_sub0_i           ( rphase_valid_sub0                        ),
  .bphase_valid_sub1_i           ( bphase_valid_sub1                        ),
  .rphase_valid_sub1_i           ( rphase_valid_sub1                        ),
  .bphase_valid_sub2_i           ( bphase_valid_sub2                        ),
  .rphase_valid_sub2_i           ( rphase_valid_sub2                        ),
  .bphase_valid_sub3_i           ( bphase_valid_sub3                        ),
  .rphase_valid_sub3_i           ( rphase_valid_sub3                        ),
  .bphase_valid_mgr_o            ( bphase_valid_mgr1                        ),
  .rphase_valid_mgr_o            ( rphase_valid_mgr1                        ),
  .bphase_sub0_i                 ( bphase_sub0                              ),
  .rphase_sub0_i                 ( rphase_sub0                              ),
  .bphase_sub1_i                 ( bphase_sub1                              ),
  .rphase_sub1_i                 ( rphase_sub1                              ),
  .bphase_sub2_i                 ( bphase_sub2                              ),
  .rphase_sub2_i                 ( rphase_sub2                              ),
  .bphase_sub3_i                 ( bphase_sub3                              ),
  .rphase_sub3_i                 ( rphase_sub3                              ),
  .bphase_mgr_o                  ( bphase_mgr1                              ),
  .rphase_mgr_o                  ( rphase_mgr1                              )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_sub0_dmb_s
// ==================================================
msftDvIp_axi_sub_ifc #(
  .SUB_NUM(0),
  .NUM_MGRS(2),
  .AXI_SUB_ID_WIDTH(AXI_SUB_ID_WIDTH),
  .AXI_MGR_ID_WIDTH(AXI_MGR_ID_WIDTH),
  .MGR_ID_BITS(1),
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
  .AXI_LEN_WIDTH(AXI_LEN_WIDTH),
  .AXI_USER_WIDTH(AXI_USER_WIDTH),
  .AXI_FIFO_SIZE(AXI_FIFO_SIZE),
  .APHASE_LEN(APHASE_LEN),
  .WPHASE_LEN(WPHASE_LEN),
  .RPHASE_LEN(RPHASE_LEN),
  .BPHASE_LEN(BPHASE_LEN)
  ) axi_sub0_dmb_s_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .awid_sub_o                    ( awid_dmb_s                               ),
  .awaddr_sub_o                  ( awaddr_dmb_s                             ),
  .awlen_sub_o                   ( awlen_dmb_s                              ),
  .awuser_sub_o                  ( awuser_dmb_s                             ),
  .awregion_sub_o                ( awregion_dmb_s                           ),
  .awsize_sub_o                  ( awsize_dmb_s                             ),
  .awburst_sub_o                 ( awburst_dmb_s                            ),
  .awcache_sub_o                 ( awcache_dmb_s                            ),
  .awlock_sub_o                  ( awlock_dmb_s                             ),
  .awprot_sub_o                  ( awprot_dmb_s                             ),
  .awqos_sub_o                   ( awqos_dmb_s                              ),
  .awvalid_sub_o                 ( awvalid_dmb_s                            ),
  .awready_sub_i                 ( awready_dmb_s                            ),
  .wid_sub_o                     ( wid_dmb_s                                ),
  .wdata_sub_o                   ( wdata_dmb_s                              ),
  .wlast_sub_o                   ( wlast_dmb_s                              ),
  .wstrb_sub_o                   ( wstrb_dmb_s                              ),
  .wvalid_sub_o                  ( wvalid_dmb_s                             ),
  .wready_sub_i                  ( wready_dmb_s                             ),
  .bid_sub_i                     ( bid_dmb_s                                ),
  .bresp_sub_i                   ( bresp_dmb_s                              ),
  .bvalid_sub_i                  ( bvalid_dmb_s                             ),
  .bready_sub_o                  ( bready_dmb_s                             ),
  .arid_sub_o                    ( arid_dmb_s                               ),
  .araddr_sub_o                  ( araddr_dmb_s                             ),
  .arlen_sub_o                   ( arlen_dmb_s                              ),
  .aruser_sub_o                  ( aruser_dmb_s                             ),
  .arregion_sub_o                ( arregion_dmb_s                           ),
  .arsize_sub_o                  ( arsize_dmb_s                             ),
  .arburst_sub_o                 ( arburst_dmb_s                            ),
  .arcache_sub_o                 ( arcache_dmb_s                            ),
  .arlock_sub_o                  ( arlock_dmb_s                             ),
  .arprot_sub_o                  ( arprot_dmb_s                             ),
  .arqos_sub_o                   ( arqos_dmb_s                              ),
  .arvalid_sub_o                 ( arvalid_dmb_s                            ),
  .arready_sub_i                 ( arready_dmb_s                            ),
  .rid_sub_i                     ( rid_dmb_s                                ),
  .rdata_sub_i                   ( rdata_dmb_s                              ),
  .rlast_sub_i                   ( rlast_dmb_s                              ),
  .rresp_sub_i                   ( rresp_dmb_s                              ),
  .rvalid_sub_i                  ( rvalid_dmb_s                             ),
  .rready_sub_o                  ( rready_dmb_s                             ),
  .awphase_i                     ( awphase_sub0                             ),
  .awphase_valid_i               ( awphase_valid_sub0                       ),
  .awphase_ready_o               ( awphase_ready_sub0                       ),
  .wphase_i                      ( wphase_sub0                              ),
  .wphase_valid_i                ( wphase_valid_sub0                        ),
  .wphase_ready_o                ( wphase_ready_sub0                        ),
  .bphase_o                      ( bphase_sub0                              ),
  .bphase_valid_o                ( bphase_valid_sub0                        ),
  .bphase_ready_i                ( bphase_ready_sub0                        ),
  .arphase_i                     ( arphase_sub0                             ),
  .arphase_valid_i               ( arphase_valid_sub0                       ),
  .arphase_ready_o               ( arphase_ready_sub0                       ),
  .rphase_o                      ( rphase_sub0                              ),
  .rphase_valid_o                ( rphase_valid_sub0                        ),
  .rphase_ready_i                ( rphase_ready_sub0                        )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_mgr_mux_sub0
// ==================================================
msftDvIp_msftDvIp_cheri_axi_fabric_mgr_mux #(
  .APHASE_LEN(APHASE_LEN),
  .WPHASE_LEN(WPHASE_LEN),
  .SUB_NUM(0)
  ) axi_mgr_mux_sub0_i (
  .awphase_ready_sub_i           ( awphase_ready_sub0                       ),
  .wphase_ready_sub_i            ( wphase_ready_sub0                        ),
  .arphase_ready_sub_i           ( arphase_ready_sub0                       ),
  .awphase_valid_mgr0_i          ( awphase_valid_mgr0                       ),
  .wphase_valid_mgr0_i           ( wphase_valid_mgr0                        ),
  .arphase_valid_mgr0_i          ( arphase_valid_mgr0                       ),
  .awphase_valid_mgr1_i          ( awphase_valid_mgr1                       ),
  .wphase_valid_mgr1_i           ( wphase_valid_mgr1                        ),
  .arphase_valid_mgr1_i          ( arphase_valid_mgr1                       ),
  .awphase_mgr0_i                ( awphase_mgr0                             ),
  .wphase_mgr0_i                 ( wphase_mgr0                              ),
  .arphase_mgr0_i                ( arphase_mgr0                             ),
  .awphase_mgr1_i                ( awphase_mgr1                             ),
  .wphase_mgr1_i                 ( wphase_mgr1                              ),
  .arphase_mgr1_i                ( arphase_mgr1                             ),
  .awphase_ready_from_sub_o      ( awphase_ready_from_sub0                  ),
  .wphase_ready_from_sub_o       ( wphase_ready_from_sub0                   ),
  .arphase_ready_from_sub_o      ( arphase_ready_from_sub0                  ),
  .rphase_ready_from_mgr0_i      ( rphase_ready_from_mgr0                   ),
  .bphase_ready_from_mgr0_i      ( bphase_ready_from_mgr0                   ),
  .rphase_ready_from_mgr1_i      ( rphase_ready_from_mgr1                   ),
  .bphase_ready_from_mgr1_i      ( bphase_ready_from_mgr1                   ),
  .awphase_valid_sub_o           ( awphase_valid_sub0                       ),
  .wphase_valid_sub_o            ( wphase_valid_sub0                        ),
  .arphase_valid_sub_o           ( arphase_valid_sub0                       ),
  .awphase_sub_o                 ( awphase_sub0                             ),
  .wphase_sub_o                  ( wphase_sub0                              ),
  .arphase_sub_o                 ( arphase_sub0                             ),
  .rphase_ready_sub_o            ( rphase_ready_sub0                        ),
  .bphase_ready_sub_o            ( bphase_ready_sub0                        )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_sub1_periph_s
// ==================================================
msftDvIp_axi_sub_ifc #(
  .SUB_NUM(1),
  .NUM_MGRS(2),
  .AXI_SUB_ID_WIDTH(AXI_SUB_ID_WIDTH),
  .AXI_MGR_ID_WIDTH(AXI_MGR_ID_WIDTH),
  .MGR_ID_BITS(1),
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
  .AXI_LEN_WIDTH(AXI_LEN_WIDTH),
  .AXI_USER_WIDTH(AXI_USER_WIDTH),
  .AXI_FIFO_SIZE(AXI_FIFO_SIZE),
  .APHASE_LEN(APHASE_LEN),
  .WPHASE_LEN(WPHASE_LEN),
  .RPHASE_LEN(RPHASE_LEN),
  .BPHASE_LEN(BPHASE_LEN)
  ) axi_sub1_periph_s_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .awid_sub_o                    ( awid_periph_s                            ),
  .awaddr_sub_o                  ( awaddr_periph_s                          ),
  .awlen_sub_o                   ( awlen_periph_s                           ),
  .awuser_sub_o                  ( awuser_periph_s                          ),
  .awregion_sub_o                ( awregion_periph_s                        ),
  .awsize_sub_o                  ( awsize_periph_s                          ),
  .awburst_sub_o                 ( awburst_periph_s                         ),
  .awcache_sub_o                 ( awcache_periph_s                         ),
  .awlock_sub_o                  ( awlock_periph_s                          ),
  .awprot_sub_o                  ( awprot_periph_s                          ),
  .awqos_sub_o                   ( awqos_periph_s                           ),
  .awvalid_sub_o                 ( awvalid_periph_s                         ),
  .awready_sub_i                 ( awready_periph_s                         ),
  .wid_sub_o                     ( wid_periph_s                             ),
  .wdata_sub_o                   ( wdata_periph_s                           ),
  .wlast_sub_o                   ( wlast_periph_s                           ),
  .wstrb_sub_o                   ( wstrb_periph_s                           ),
  .wvalid_sub_o                  ( wvalid_periph_s                          ),
  .wready_sub_i                  ( wready_periph_s                          ),
  .bid_sub_i                     ( bid_periph_s                             ),
  .bresp_sub_i                   ( bresp_periph_s                           ),
  .bvalid_sub_i                  ( bvalid_periph_s                          ),
  .bready_sub_o                  ( bready_periph_s                          ),
  .arid_sub_o                    ( arid_periph_s                            ),
  .araddr_sub_o                  ( araddr_periph_s                          ),
  .arlen_sub_o                   ( arlen_periph_s                           ),
  .aruser_sub_o                  ( aruser_periph_s                          ),
  .arregion_sub_o                ( arregion_periph_s                        ),
  .arsize_sub_o                  ( arsize_periph_s                          ),
  .arburst_sub_o                 ( arburst_periph_s                         ),
  .arcache_sub_o                 ( arcache_periph_s                         ),
  .arlock_sub_o                  ( arlock_periph_s                          ),
  .arprot_sub_o                  ( arprot_periph_s                          ),
  .arqos_sub_o                   ( arqos_periph_s                           ),
  .arvalid_sub_o                 ( arvalid_periph_s                         ),
  .arready_sub_i                 ( arready_periph_s                         ),
  .rid_sub_i                     ( rid_periph_s                             ),
  .rdata_sub_i                   ( rdata_periph_s                           ),
  .rlast_sub_i                   ( rlast_periph_s                           ),
  .rresp_sub_i                   ( rresp_periph_s                           ),
  .rvalid_sub_i                  ( rvalid_periph_s                          ),
  .rready_sub_o                  ( rready_periph_s                          ),
  .awphase_i                     ( awphase_sub1                             ),
  .awphase_valid_i               ( awphase_valid_sub1                       ),
  .awphase_ready_o               ( awphase_ready_sub1                       ),
  .wphase_i                      ( wphase_sub1                              ),
  .wphase_valid_i                ( wphase_valid_sub1                        ),
  .wphase_ready_o                ( wphase_ready_sub1                        ),
  .bphase_o                      ( bphase_sub1                              ),
  .bphase_valid_o                ( bphase_valid_sub1                        ),
  .bphase_ready_i                ( bphase_ready_sub1                        ),
  .arphase_i                     ( arphase_sub1                             ),
  .arphase_valid_i               ( arphase_valid_sub1                       ),
  .arphase_ready_o               ( arphase_ready_sub1                       ),
  .rphase_o                      ( rphase_sub1                              ),
  .rphase_valid_o                ( rphase_valid_sub1                        ),
  .rphase_ready_i                ( rphase_ready_sub1                        )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_mgr_mux_sub1
// ==================================================
msftDvIp_msftDvIp_cheri_axi_fabric_mgr_mux #(
  .APHASE_LEN(APHASE_LEN),
  .WPHASE_LEN(WPHASE_LEN),
  .SUB_NUM(1)
  ) axi_mgr_mux_sub1_i (
  .awphase_ready_sub_i           ( awphase_ready_sub1                       ),
  .wphase_ready_sub_i            ( wphase_ready_sub1                        ),
  .arphase_ready_sub_i           ( arphase_ready_sub1                       ),
  .awphase_valid_mgr0_i          ( awphase_valid_mgr0                       ),
  .wphase_valid_mgr0_i           ( wphase_valid_mgr0                        ),
  .arphase_valid_mgr0_i          ( arphase_valid_mgr0                       ),
  .awphase_valid_mgr1_i          ( awphase_valid_mgr1                       ),
  .wphase_valid_mgr1_i           ( wphase_valid_mgr1                        ),
  .arphase_valid_mgr1_i          ( arphase_valid_mgr1                       ),
  .awphase_mgr0_i                ( awphase_mgr0                             ),
  .wphase_mgr0_i                 ( wphase_mgr0                              ),
  .arphase_mgr0_i                ( arphase_mgr0                             ),
  .awphase_mgr1_i                ( awphase_mgr1                             ),
  .wphase_mgr1_i                 ( wphase_mgr1                              ),
  .arphase_mgr1_i                ( arphase_mgr1                             ),
  .awphase_ready_from_sub_o      ( awphase_ready_from_sub1                  ),
  .wphase_ready_from_sub_o       ( wphase_ready_from_sub1                   ),
  .arphase_ready_from_sub_o      ( arphase_ready_from_sub1                  ),
  .rphase_ready_from_mgr0_i      ( rphase_ready_from_mgr0                   ),
  .bphase_ready_from_mgr0_i      ( bphase_ready_from_mgr0                   ),
  .rphase_ready_from_mgr1_i      ( rphase_ready_from_mgr1                   ),
  .bphase_ready_from_mgr1_i      ( bphase_ready_from_mgr1                   ),
  .awphase_valid_sub_o           ( awphase_valid_sub1                       ),
  .wphase_valid_sub_o            ( wphase_valid_sub1                        ),
  .arphase_valid_sub_o           ( arphase_valid_sub1                       ),
  .awphase_sub_o                 ( awphase_sub1                             ),
  .wphase_sub_o                  ( wphase_sub1                              ),
  .arphase_sub_o                 ( arphase_sub1                             ),
  .rphase_ready_sub_o            ( rphase_ready_sub1                        ),
  .bphase_ready_sub_o            ( bphase_ready_sub1                        )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_sub2_sram_m
// ==================================================
msftDvIp_axi_sub_ifc #(
  .SUB_NUM(2),
  .NUM_MGRS(2),
  .AXI_SUB_ID_WIDTH(AXI_SUB_ID_WIDTH),
  .AXI_MGR_ID_WIDTH(AXI_MGR_ID_WIDTH),
  .MGR_ID_BITS(1),
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
  .AXI_LEN_WIDTH(AXI_LEN_WIDTH),
  .AXI_USER_WIDTH(AXI_USER_WIDTH),
  .AXI_FIFO_SIZE(AXI_FIFO_SIZE),
  .APHASE_LEN(APHASE_LEN),
  .WPHASE_LEN(WPHASE_LEN),
  .RPHASE_LEN(RPHASE_LEN),
  .BPHASE_LEN(BPHASE_LEN)
  ) axi_sub2_sram_m_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .awid_sub_o                    ( awid_sram_m                              ),
  .awaddr_sub_o                  ( awaddr_sram_m                            ),
  .awlen_sub_o                   ( awlen_sram_m                             ),
  .awuser_sub_o                  ( awuser_sram_m                            ),
  .awregion_sub_o                ( awregion_sram_m                          ),
  .awsize_sub_o                  ( awsize_sram_m                            ),
  .awburst_sub_o                 ( awburst_sram_m                           ),
  .awcache_sub_o                 ( awcache_sram_m                           ),
  .awlock_sub_o                  ( awlock_sram_m                            ),
  .awprot_sub_o                  ( awprot_sram_m                            ),
  .awqos_sub_o                   ( awqos_sram_m                             ),
  .awvalid_sub_o                 ( awvalid_sram_m                           ),
  .awready_sub_i                 ( awready_sram_m                           ),
  .wid_sub_o                     ( wid_sram_m                               ),
  .wdata_sub_o                   ( wdata_sram_m                             ),
  .wlast_sub_o                   ( wlast_sram_m                             ),
  .wstrb_sub_o                   ( wstrb_sram_m                             ),
  .wvalid_sub_o                  ( wvalid_sram_m                            ),
  .wready_sub_i                  ( wready_sram_m                            ),
  .bid_sub_i                     ( bid_sram_m                               ),
  .bresp_sub_i                   ( bresp_sram_m                             ),
  .bvalid_sub_i                  ( bvalid_sram_m                            ),
  .bready_sub_o                  ( bready_sram_m                            ),
  .arid_sub_o                    ( arid_sram_m                              ),
  .araddr_sub_o                  ( araddr_sram_m                            ),
  .arlen_sub_o                   ( arlen_sram_m                             ),
  .aruser_sub_o                  ( aruser_sram_m                            ),
  .arregion_sub_o                ( arregion_sram_m                          ),
  .arsize_sub_o                  ( arsize_sram_m                            ),
  .arburst_sub_o                 ( arburst_sram_m                           ),
  .arcache_sub_o                 ( arcache_sram_m                           ),
  .arlock_sub_o                  ( arlock_sram_m                            ),
  .arprot_sub_o                  ( arprot_sram_m                            ),
  .arqos_sub_o                   ( arqos_sram_m                             ),
  .arvalid_sub_o                 ( arvalid_sram_m                           ),
  .arready_sub_i                 ( arready_sram_m                           ),
  .rid_sub_i                     ( rid_sram_m                               ),
  .rdata_sub_i                   ( rdata_sram_m                             ),
  .rlast_sub_i                   ( rlast_sram_m                             ),
  .rresp_sub_i                   ( rresp_sram_m                             ),
  .rvalid_sub_i                  ( rvalid_sram_m                            ),
  .rready_sub_o                  ( rready_sram_m                            ),
  .awphase_i                     ( awphase_sub2                             ),
  .awphase_valid_i               ( awphase_valid_sub2                       ),
  .awphase_ready_o               ( awphase_ready_sub2                       ),
  .wphase_i                      ( wphase_sub2                              ),
  .wphase_valid_i                ( wphase_valid_sub2                        ),
  .wphase_ready_o                ( wphase_ready_sub2                        ),
  .bphase_o                      ( bphase_sub2                              ),
  .bphase_valid_o                ( bphase_valid_sub2                        ),
  .bphase_ready_i                ( bphase_ready_sub2                        ),
  .arphase_i                     ( arphase_sub2                             ),
  .arphase_valid_i               ( arphase_valid_sub2                       ),
  .arphase_ready_o               ( arphase_ready_sub2                       ),
  .rphase_o                      ( rphase_sub2                              ),
  .rphase_valid_o                ( rphase_valid_sub2                        ),
  .rphase_ready_i                ( rphase_ready_sub2                        )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_mgr_mux_sub2
// ==================================================
msftDvIp_msftDvIp_cheri_axi_fabric_mgr_mux #(
  .APHASE_LEN(APHASE_LEN),
  .WPHASE_LEN(WPHASE_LEN),
  .SUB_NUM(2)
  ) axi_mgr_mux_sub2_i (
  .awphase_ready_sub_i           ( awphase_ready_sub2                       ),
  .wphase_ready_sub_i            ( wphase_ready_sub2                        ),
  .arphase_ready_sub_i           ( arphase_ready_sub2                       ),
  .awphase_valid_mgr0_i          ( awphase_valid_mgr0                       ),
  .wphase_valid_mgr0_i           ( wphase_valid_mgr0                        ),
  .arphase_valid_mgr0_i          ( arphase_valid_mgr0                       ),
  .awphase_valid_mgr1_i          ( awphase_valid_mgr1                       ),
  .wphase_valid_mgr1_i           ( wphase_valid_mgr1                        ),
  .arphase_valid_mgr1_i          ( arphase_valid_mgr1                       ),
  .awphase_mgr0_i                ( awphase_mgr0                             ),
  .wphase_mgr0_i                 ( wphase_mgr0                              ),
  .arphase_mgr0_i                ( arphase_mgr0                             ),
  .awphase_mgr1_i                ( awphase_mgr1                             ),
  .wphase_mgr1_i                 ( wphase_mgr1                              ),
  .arphase_mgr1_i                ( arphase_mgr1                             ),
  .awphase_ready_from_sub_o      ( awphase_ready_from_sub2                  ),
  .wphase_ready_from_sub_o       ( wphase_ready_from_sub2                   ),
  .arphase_ready_from_sub_o      ( arphase_ready_from_sub2                  ),
  .rphase_ready_from_mgr0_i      ( rphase_ready_from_mgr0                   ),
  .bphase_ready_from_mgr0_i      ( bphase_ready_from_mgr0                   ),
  .rphase_ready_from_mgr1_i      ( rphase_ready_from_mgr1                   ),
  .bphase_ready_from_mgr1_i      ( bphase_ready_from_mgr1                   ),
  .awphase_valid_sub_o           ( awphase_valid_sub2                       ),
  .wphase_valid_sub_o            ( wphase_valid_sub2                        ),
  .arphase_valid_sub_o           ( arphase_valid_sub2                       ),
  .awphase_sub_o                 ( awphase_sub2                             ),
  .wphase_sub_o                  ( wphase_sub2                              ),
  .arphase_sub_o                 ( arphase_sub2                             ),
  .rphase_ready_sub_o            ( rphase_ready_sub2                        ),
  .bphase_ready_sub_o            ( bphase_ready_sub2                        )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_sub3_def
// ==================================================
msftDvIp_axi_sub_ifc #(
  .SUB_NUM(3),
  .NUM_MGRS(2),
  .AXI_SUB_ID_WIDTH(AXI_SUB_ID_WIDTH),
  .AXI_MGR_ID_WIDTH(AXI_MGR_ID_WIDTH),
  .MGR_ID_BITS(1),
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
  .AXI_LEN_WIDTH(AXI_LEN_WIDTH),
  .AXI_USER_WIDTH(AXI_USER_WIDTH),
  .AXI_FIFO_SIZE(AXI_FIFO_SIZE),
  .APHASE_LEN(APHASE_LEN),
  .WPHASE_LEN(WPHASE_LEN),
  .RPHASE_LEN(RPHASE_LEN),
  .BPHASE_LEN(BPHASE_LEN)
  ) axi_sub3_def_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .awid_sub_o                    ( awid_def                                 ),
  .awaddr_sub_o                  ( awaddr_def                               ),
  .awlen_sub_o                   ( awlen_def                                ),
  .awuser_sub_o                  ( awuser_def                               ),
  .awregion_sub_o                ( awregion_def                             ),
  .awsize_sub_o                  ( awsize_def                               ),
  .awburst_sub_o                 ( awburst_def                              ),
  .awcache_sub_o                 ( awcache_def                              ),
  .awlock_sub_o                  ( awlock_def                               ),
  .awprot_sub_o                  ( awprot_def                               ),
  .awqos_sub_o                   ( awqos_def                                ),
  .awvalid_sub_o                 ( awvalid_def                              ),
  .awready_sub_i                 ( awready_def                              ),
  .wid_sub_o                     ( wid_def                                  ),
  .wdata_sub_o                   ( wdata_def                                ),
  .wlast_sub_o                   ( wlast_def                                ),
  .wstrb_sub_o                   ( wstrb_def                                ),
  .wvalid_sub_o                  ( wvalid_def                               ),
  .wready_sub_i                  ( wready_def                               ),
  .bid_sub_i                     ( bid_def                                  ),
  .bresp_sub_i                   ( bresp_def                                ),
  .bvalid_sub_i                  ( bvalid_def                               ),
  .bready_sub_o                  ( bready_def                               ),
  .arid_sub_o                    ( arid_def                                 ),
  .araddr_sub_o                  ( araddr_def                               ),
  .arlen_sub_o                   ( arlen_def                                ),
  .aruser_sub_o                  ( aruser_def                               ),
  .arregion_sub_o                ( arregion_def                             ),
  .arsize_sub_o                  ( arsize_def                               ),
  .arburst_sub_o                 ( arburst_def                              ),
  .arcache_sub_o                 ( arcache_def                              ),
  .arlock_sub_o                  ( arlock_def                               ),
  .arprot_sub_o                  ( arprot_def                               ),
  .arqos_sub_o                   ( arqos_def                                ),
  .arvalid_sub_o                 ( arvalid_def                              ),
  .arready_sub_i                 ( arready_def                              ),
  .rid_sub_i                     ( rid_def                                  ),
  .rdata_sub_i                   ( rdata_def                                ),
  .rlast_sub_i                   ( rlast_def                                ),
  .rresp_sub_i                   ( rresp_def                                ),
  .rvalid_sub_i                  ( rvalid_def                               ),
  .rready_sub_o                  ( rready_def                               ),
  .awphase_i                     ( awphase_sub3                             ),
  .awphase_valid_i               ( awphase_valid_sub3                       ),
  .awphase_ready_o               ( awphase_ready_sub3                       ),
  .wphase_i                      ( wphase_sub3                              ),
  .wphase_valid_i                ( wphase_valid_sub3                        ),
  .wphase_ready_o                ( wphase_ready_sub3                        ),
  .bphase_o                      ( bphase_sub3                              ),
  .bphase_valid_o                ( bphase_valid_sub3                        ),
  .bphase_ready_i                ( bphase_ready_sub3                        ),
  .arphase_i                     ( arphase_sub3                             ),
  .arphase_valid_i               ( arphase_valid_sub3                       ),
  .arphase_ready_o               ( arphase_ready_sub3                       ),
  .rphase_o                      ( rphase_sub3                              ),
  .rphase_valid_o                ( rphase_valid_sub3                        ),
  .rphase_ready_i                ( rphase_ready_sub3                        )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_mgr_mux_sub3
// ==================================================
msftDvIp_msftDvIp_cheri_axi_fabric_mgr_mux #(
  .APHASE_LEN(APHASE_LEN),
  .WPHASE_LEN(WPHASE_LEN),
  .SUB_NUM(3)
  ) axi_mgr_mux_sub3_i (
  .awphase_ready_sub_i           ( awphase_ready_sub3                       ),
  .wphase_ready_sub_i            ( wphase_ready_sub3                        ),
  .arphase_ready_sub_i           ( arphase_ready_sub3                       ),
  .awphase_valid_mgr0_i          ( awphase_valid_mgr0                       ),
  .wphase_valid_mgr0_i           ( wphase_valid_mgr0                        ),
  .arphase_valid_mgr0_i          ( arphase_valid_mgr0                       ),
  .awphase_valid_mgr1_i          ( awphase_valid_mgr1                       ),
  .wphase_valid_mgr1_i           ( wphase_valid_mgr1                        ),
  .arphase_valid_mgr1_i          ( arphase_valid_mgr1                       ),
  .awphase_mgr0_i                ( awphase_mgr0                             ),
  .wphase_mgr0_i                 ( wphase_mgr0                              ),
  .arphase_mgr0_i                ( arphase_mgr0                             ),
  .awphase_mgr1_i                ( awphase_mgr1                             ),
  .wphase_mgr1_i                 ( wphase_mgr1                              ),
  .arphase_mgr1_i                ( arphase_mgr1                             ),
  .awphase_ready_from_sub_o      ( awphase_ready_from_sub3                  ),
  .wphase_ready_from_sub_o       ( wphase_ready_from_sub3                   ),
  .arphase_ready_from_sub_o      ( arphase_ready_from_sub3                  ),
  .rphase_ready_from_mgr0_i      ( rphase_ready_from_mgr0                   ),
  .bphase_ready_from_mgr0_i      ( bphase_ready_from_mgr0                   ),
  .rphase_ready_from_mgr1_i      ( rphase_ready_from_mgr1                   ),
  .bphase_ready_from_mgr1_i      ( bphase_ready_from_mgr1                   ),
  .awphase_valid_sub_o           ( awphase_valid_sub3                       ),
  .wphase_valid_sub_o            ( wphase_valid_sub3                        ),
  .arphase_valid_sub_o           ( arphase_valid_sub3                       ),
  .awphase_sub_o                 ( awphase_sub3                             ),
  .wphase_sub_o                  ( wphase_sub3                              ),
  .arphase_sub_o                 ( arphase_sub3                             ),
  .rphase_ready_sub_o            ( rphase_ready_sub3                        ),
  .bphase_ready_sub_o            ( bphase_ready_sub3                        )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance axi_def_sub
// ==================================================
msftDvIp_axi_def_sub #(
  .AXI_SUB_ID_WIDTH(AXI_SUB_ID_WIDTH),
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
  .AXI_LEN_WIDTH(AXI_LEN_WIDTH)
  ) axi_def_sub_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .awid_sub_i                    ( awid_def                                 ),
  .awaddr_sub_i                  ( awaddr_def                               ),
  .awlen_sub_i                   ( awlen_def                                ),
  .awsize_sub_i                  ( awsize_def                               ),
  .awburst_sub_i                 ( awburst_def                              ),
  .awcache_sub_i                 ( awcache_def                              ),
  .awlock_sub_i                  ( awlock_def                               ),
  .awprot_sub_i                  ( awprot_def                               ),
  .awqos_sub_i                   ( awqos_def                                ),
  .awvalid_sub_i                 ( awvalid_def                              ),
  .awready_sub_o                 ( awready_def                              ),
  .wid_sub_i                     ( wid_def                                  ),
  .wdata_sub_i                   ( wdata_def                                ),
  .wlast_sub_i                   ( wlast_def                                ),
  .wstrb_sub_i                   ( wstrb_def                                ),
  .wvalid_sub_i                  ( wvalid_def                               ),
  .wready_sub_o                  ( wready_def                               ),
  .bid_sub_o                     ( bid_def                                  ),
  .bresp_sub_o                   ( bresp_def                                ),
  .bvalid_sub_o                  ( bvalid_def                               ),
  .bready_sub_i                  ( bready_def                               ),
  .arid_sub_i                    ( arid_def                                 ),
  .araddr_sub_i                  ( araddr_def                               ),
  .arlen_sub_i                   ( arlen_def                                ),
  .arsize_sub_i                  ( arsize_def                               ),
  .arburst_sub_i                 ( arburst_def                              ),
  .arcache_sub_i                 ( arcache_def                              ),
  .arlock_sub_i                  ( arlock_def                               ),
  .arprot_sub_i                  ( arprot_def                               ),
  .arqos_sub_i                   ( arqos_def                                ),
  .arvalid_sub_i                 ( arvalid_def                              ),
  .arready_sub_o                 ( arready_def                              ),
  .rid_sub_o                     ( rid_def                                  ),
  .rdata_sub_o                   ( rdata_def                                ),
  .rlast_sub_o                   ( rlast_def                                ),
  .rresp_sub_o                   ( rresp_def                                ),
  .rvalid_sub_o                  ( rvalid_def                               ),
  .rready_sub_i                  ( rready_def                               )
);


// ==================================================
//  Connect IO Pins
// ==================================================
assign clk = clk_i;
assign rstn = rstn_i;
assign arid_cpu_m = arid_cpu_m_i;
assign araddr_cpu_m = araddr_cpu_m_i;
assign arlen_cpu_m = arlen_cpu_m_i;
assign aruser_cpu_m = aruser_cpu_m_i;
assign arregion_cpu_m = arregion_cpu_m_i;
assign arsize_cpu_m = arsize_cpu_m_i;
assign arburst_cpu_m = arburst_cpu_m_i;
assign arcache_cpu_m = arcache_cpu_m_i;
assign arlock_cpu_m = arlock_cpu_m_i;
assign arprot_cpu_m = arprot_cpu_m_i;
assign arqos_cpu_m = arqos_cpu_m_i;
assign arvalid_cpu_m = arvalid_cpu_m_i;
assign arready_cpu_m_o = arready_cpu_m;
assign rid_cpu_m_o = rid_cpu_m;
assign rdata_cpu_m_o = rdata_cpu_m;
assign rlast_cpu_m_o = rlast_cpu_m;
assign rresp_cpu_m_o = rresp_cpu_m;
assign rvalid_cpu_m_o = rvalid_cpu_m;
assign rready_cpu_m = rready_cpu_m_i;
assign awid_cpu_m = awid_cpu_m_i;
assign awaddr_cpu_m = awaddr_cpu_m_i;
assign awlen_cpu_m = awlen_cpu_m_i;
assign awuser_cpu_m = awuser_cpu_m_i;
assign awregion_cpu_m = awregion_cpu_m_i;
assign awsize_cpu_m = awsize_cpu_m_i;
assign awburst_cpu_m = awburst_cpu_m_i;
assign awcache_cpu_m = awcache_cpu_m_i;
assign awlock_cpu_m = awlock_cpu_m_i;
assign awprot_cpu_m = awprot_cpu_m_i;
assign awqos_cpu_m = awqos_cpu_m_i;
assign awvalid_cpu_m = awvalid_cpu_m_i;
assign awready_cpu_m_o = awready_cpu_m;
assign wid_cpu_m = wid_cpu_m_i;
assign wdata_cpu_m = wdata_cpu_m_i;
assign wlast_cpu_m = wlast_cpu_m_i;
assign wstrb_cpu_m = wstrb_cpu_m_i;
assign wvalid_cpu_m = wvalid_cpu_m_i;
assign wready_cpu_m_o = wready_cpu_m;
assign bid_cpu_m_o = bid_cpu_m;
assign bresp_cpu_m_o = bresp_cpu_m;
assign bvalid_cpu_m_o = bvalid_cpu_m;
assign bready_cpu_m = bready_cpu_m_i;
assign arid_dma_m = arid_dma_m_i;
assign araddr_dma_m = araddr_dma_m_i;
assign arlen_dma_m = arlen_dma_m_i;
assign aruser_dma_m = aruser_dma_m_i;
assign arregion_dma_m = arregion_dma_m_i;
assign arsize_dma_m = arsize_dma_m_i;
assign arburst_dma_m = arburst_dma_m_i;
assign arcache_dma_m = arcache_dma_m_i;
assign arlock_dma_m = arlock_dma_m_i;
assign arprot_dma_m = arprot_dma_m_i;
assign arqos_dma_m = arqos_dma_m_i;
assign arvalid_dma_m = arvalid_dma_m_i;
assign arready_dma_m_o = arready_dma_m;
assign rid_dma_m_o = rid_dma_m;
assign rdata_dma_m_o = rdata_dma_m;
assign rlast_dma_m_o = rlast_dma_m;
assign rresp_dma_m_o = rresp_dma_m;
assign rvalid_dma_m_o = rvalid_dma_m;
assign rready_dma_m = rready_dma_m_i;
assign awid_dma_m = awid_dma_m_i;
assign awaddr_dma_m = awaddr_dma_m_i;
assign awlen_dma_m = awlen_dma_m_i;
assign awuser_dma_m = awuser_dma_m_i;
assign awregion_dma_m = awregion_dma_m_i;
assign awsize_dma_m = awsize_dma_m_i;
assign awburst_dma_m = awburst_dma_m_i;
assign awcache_dma_m = awcache_dma_m_i;
assign awlock_dma_m = awlock_dma_m_i;
assign awprot_dma_m = awprot_dma_m_i;
assign awqos_dma_m = awqos_dma_m_i;
assign awvalid_dma_m = awvalid_dma_m_i;
assign awready_dma_m_o = awready_dma_m;
assign wid_dma_m = wid_dma_m_i;
assign wdata_dma_m = wdata_dma_m_i;
assign wlast_dma_m = wlast_dma_m_i;
assign wstrb_dma_m = wstrb_dma_m_i;
assign wvalid_dma_m = wvalid_dma_m_i;
assign wready_dma_m_o = wready_dma_m;
assign bid_dma_m_o = bid_dma_m;
assign bresp_dma_m_o = bresp_dma_m;
assign bvalid_dma_m_o = bvalid_dma_m;
assign bready_dma_m = bready_dma_m_i;
assign arid_dmb_s_o = arid_dmb_s;
assign araddr_dmb_s_o = araddr_dmb_s;
assign arlen_dmb_s_o = arlen_dmb_s;
assign aruser_dmb_s_o = aruser_dmb_s;
assign arregion_dmb_s_o = arregion_dmb_s;
assign arsize_dmb_s_o = arsize_dmb_s;
assign arburst_dmb_s_o = arburst_dmb_s;
assign arcache_dmb_s_o = arcache_dmb_s;
assign arlock_dmb_s_o = arlock_dmb_s;
assign arprot_dmb_s_o = arprot_dmb_s;
assign arqos_dmb_s_o = arqos_dmb_s;
assign arvalid_dmb_s_o = arvalid_dmb_s;
assign arready_dmb_s = arready_dmb_s_i;
assign rid_dmb_s = rid_dmb_s_i;
assign rdata_dmb_s = rdata_dmb_s_i;
assign rlast_dmb_s = rlast_dmb_s_i;
assign rresp_dmb_s = rresp_dmb_s_i;
assign rvalid_dmb_s = rvalid_dmb_s_i;
assign rready_dmb_s_o = rready_dmb_s;
assign awid_dmb_s_o = awid_dmb_s;
assign awaddr_dmb_s_o = awaddr_dmb_s;
assign awlen_dmb_s_o = awlen_dmb_s;
assign awuser_dmb_s_o = awuser_dmb_s;
assign awregion_dmb_s_o = awregion_dmb_s;
assign awsize_dmb_s_o = awsize_dmb_s;
assign awburst_dmb_s_o = awburst_dmb_s;
assign awcache_dmb_s_o = awcache_dmb_s;
assign awlock_dmb_s_o = awlock_dmb_s;
assign awprot_dmb_s_o = awprot_dmb_s;
assign awqos_dmb_s_o = awqos_dmb_s;
assign awvalid_dmb_s_o = awvalid_dmb_s;
assign awready_dmb_s = awready_dmb_s_i;
assign wid_dmb_s_o = wid_dmb_s;
assign wdata_dmb_s_o = wdata_dmb_s;
assign wlast_dmb_s_o = wlast_dmb_s;
assign wstrb_dmb_s_o = wstrb_dmb_s;
assign wvalid_dmb_s_o = wvalid_dmb_s;
assign wready_dmb_s = wready_dmb_s_i;
assign bid_dmb_s = bid_dmb_s_i;
assign bresp_dmb_s = bresp_dmb_s_i;
assign bvalid_dmb_s = bvalid_dmb_s_i;
assign bready_dmb_s_o = bready_dmb_s;
assign arid_periph_s_o = arid_periph_s;
assign araddr_periph_s_o = araddr_periph_s;
assign arlen_periph_s_o = arlen_periph_s;
assign aruser_periph_s_o = aruser_periph_s;
assign arregion_periph_s_o = arregion_periph_s;
assign arsize_periph_s_o = arsize_periph_s;
assign arburst_periph_s_o = arburst_periph_s;
assign arcache_periph_s_o = arcache_periph_s;
assign arlock_periph_s_o = arlock_periph_s;
assign arprot_periph_s_o = arprot_periph_s;
assign arqos_periph_s_o = arqos_periph_s;
assign arvalid_periph_s_o = arvalid_periph_s;
assign arready_periph_s = arready_periph_s_i;
assign rid_periph_s = rid_periph_s_i;
assign rdata_periph_s = rdata_periph_s_i;
assign rlast_periph_s = rlast_periph_s_i;
assign rresp_periph_s = rresp_periph_s_i;
assign rvalid_periph_s = rvalid_periph_s_i;
assign rready_periph_s_o = rready_periph_s;
assign awid_periph_s_o = awid_periph_s;
assign awaddr_periph_s_o = awaddr_periph_s;
assign awlen_periph_s_o = awlen_periph_s;
assign awuser_periph_s_o = awuser_periph_s;
assign awregion_periph_s_o = awregion_periph_s;
assign awsize_periph_s_o = awsize_periph_s;
assign awburst_periph_s_o = awburst_periph_s;
assign awcache_periph_s_o = awcache_periph_s;
assign awlock_periph_s_o = awlock_periph_s;
assign awprot_periph_s_o = awprot_periph_s;
assign awqos_periph_s_o = awqos_periph_s;
assign awvalid_periph_s_o = awvalid_periph_s;
assign awready_periph_s = awready_periph_s_i;
assign wid_periph_s_o = wid_periph_s;
assign wdata_periph_s_o = wdata_periph_s;
assign wlast_periph_s_o = wlast_periph_s;
assign wstrb_periph_s_o = wstrb_periph_s;
assign wvalid_periph_s_o = wvalid_periph_s;
assign wready_periph_s = wready_periph_s_i;
assign bid_periph_s = bid_periph_s_i;
assign bresp_periph_s = bresp_periph_s_i;
assign bvalid_periph_s = bvalid_periph_s_i;
assign bready_periph_s_o = bready_periph_s;
assign arid_sram_m_o = arid_sram_m;
assign araddr_sram_m_o = araddr_sram_m;
assign arlen_sram_m_o = arlen_sram_m;
assign aruser_sram_m_o = aruser_sram_m;
assign arregion_sram_m_o = arregion_sram_m;
assign arsize_sram_m_o = arsize_sram_m;
assign arburst_sram_m_o = arburst_sram_m;
assign arcache_sram_m_o = arcache_sram_m;
assign arlock_sram_m_o = arlock_sram_m;
assign arprot_sram_m_o = arprot_sram_m;
assign arqos_sram_m_o = arqos_sram_m;
assign arvalid_sram_m_o = arvalid_sram_m;
assign arready_sram_m = arready_sram_m_i;
assign rid_sram_m = rid_sram_m_i;
assign rdata_sram_m = rdata_sram_m_i;
assign rlast_sram_m = rlast_sram_m_i;
assign rresp_sram_m = rresp_sram_m_i;
assign rvalid_sram_m = rvalid_sram_m_i;
assign rready_sram_m_o = rready_sram_m;
assign awid_sram_m_o = awid_sram_m;
assign awaddr_sram_m_o = awaddr_sram_m;
assign awlen_sram_m_o = awlen_sram_m;
assign awuser_sram_m_o = awuser_sram_m;
assign awregion_sram_m_o = awregion_sram_m;
assign awsize_sram_m_o = awsize_sram_m;
assign awburst_sram_m_o = awburst_sram_m;
assign awcache_sram_m_o = awcache_sram_m;
assign awlock_sram_m_o = awlock_sram_m;
assign awprot_sram_m_o = awprot_sram_m;
assign awqos_sram_m_o = awqos_sram_m;
assign awvalid_sram_m_o = awvalid_sram_m;
assign awready_sram_m = awready_sram_m_i;
assign wid_sram_m_o = wid_sram_m;
assign wdata_sram_m_o = wdata_sram_m;
assign wlast_sram_m_o = wlast_sram_m;
assign wstrb_sram_m_o = wstrb_sram_m;
assign wvalid_sram_m_o = wvalid_sram_m;
assign wready_sram_m = wready_sram_m_i;
assign bid_sram_m = bid_sram_m_i;
assign bresp_sram_m = bresp_sram_m_i;
assign bvalid_sram_m = bvalid_sram_m_i;
assign bready_sram_m_o = bready_sram_m;

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

