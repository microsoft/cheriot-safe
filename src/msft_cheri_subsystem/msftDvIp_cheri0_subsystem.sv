// Copyright (C) Microsoft Corporation. All rights reserved.


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvIp_cheri0_subsystem Definition
// ==================================================
module msftDvIp_cheri0_subsystem #(
    parameter APU_NARGS_CPU = 3,
    parameter APU_WOP_CPU = 6,
    parameter APU_NDSFLAGS_CPU = 15,
    parameter APU_NUSFLAGS_CPU = 5,
    parameter DVP_DMB_ID_WIDTH = 4,
    parameter DVP_DMB_AWIDTH = 32,
    parameter DVP_DMB_DATA_WIDTH = 32,
    parameter DVP_DMB_STRB_WIDTH = 4,
    parameter IROM_INIT_FILE = "",
    parameter IRAM_INIT_FILE = "",
    parameter IROM_DEPTH = 'h4000,
    parameter IRAM_DEPTH = 'h1_0000,
    parameter DRAM_DEPTH = 'h4000,
    parameter DEF_ALT_FUNC0 = 32'h0000_0000,
    parameter DEF_ALT_FUNC1 = 32'h0000_0000
  ) (
  input                                      clk_i,
  input                                      rstn_i,
  input                                      TRSTn_i,
  input                                      TCK_i,
  input                                      TMS_i,
  input                                      TDI_i,
  output                                     TDO_o,
  output                                     TDOoen_o,
  output [5-1:0]                             arid_dmb_m_o,
  output [64-1:0]                            araddr_dmb_m_o,
  output [8-1:0]                             arlen_dmb_m_o,
  output [12-1:0]                            aruser_dmb_m_o,
  output [3:0]                               arregion_dmb_m_o,
  output [2:0]                               arsize_dmb_m_o,
  output [1:0]                               arburst_dmb_m_o,
  output [3:0]                               arcache_dmb_m_o,
  output [1:0]                               arlock_dmb_m_o,
  output [2:0]                               arprot_dmb_m_o,
  output [3:0]                               arqos_dmb_m_o,
  output                                     arvalid_dmb_m_o,
  input                                      arready_dmb_m_i,
  input  [5-1:0]                             rid_dmb_m_i,
  input  [64-1:0]                            rdata_dmb_m_i,
  input                                      rlast_dmb_m_i,
  input  [1:0]                               rresp_dmb_m_i,
  input                                      rvalid_dmb_m_i,
  output                                     rready_dmb_m_o,
  output [5-1:0]                             awid_dmb_m_o,
  output [64-1:0]                            awaddr_dmb_m_o,
  output [8-1:0]                             awlen_dmb_m_o,
  output [12-1:0]                            awuser_dmb_m_o,
  output [3:0]                               awregion_dmb_m_o,
  output [2:0]                               awsize_dmb_m_o,
  output [1:0]                               awburst_dmb_m_o,
  output [3:0]                               awcache_dmb_m_o,
  output [1:0]                               awlock_dmb_m_o,
  output [2:0]                               awprot_dmb_m_o,
  output [3:0]                               awqos_dmb_m_o,
  output                                     awvalid_dmb_m_o,
  input                                      awready_dmb_m_i,
  output [5-1:0]                             wid_dmb_m_o,
  output [64-1:0]                            wdata_dmb_m_o,
  output                                     wlast_dmb_m_o,
  output [8-1:0]                             wstrb_dmb_m_o,
  output                                     wvalid_dmb_m_o,
  input                                      wready_dmb_m_i,
  input  [5-1:0]                             bid_dmb_m_i,
  input  [1:0]                               bresp_dmb_m_i,
  input                                      bvalid_dmb_m_i,
  output                                     bready_dmb_m_o,
  input  [1:0]                               eth_irq_i,
  output                                     txd_dvp_o,
  input                                      rxd_dvp_i,
  output [31:0]                              out0_o,
  output [31:0]                              out1_o,
  output [31:0]                              out2_o,
  input  [31:0]                              in0_i,
  output [31:0]                              dbg_gp_out_o,
  input  [31:0]                              dbg_gp_in_i,
  output                                     TCK_d_o,
  output                                     TMS_d_o,
  output                                     TDO_d_o,
  output                                     TDOoen_d_o,
  input                                      TDI_d_i,
  output                                     TRSTn_d_o,
  output                                     jtag_ext_cg_o,
  output                                     jtag_mux_sel_o,
  input  [5:0]                               irq_ext_i,
  input  [31:0]                              gpio0_in_i,
  output [31:0]                              gpio0_out_o,
  output [31:0]                              gpio0_oen_o,
  input  [31:0]                              gpio1_in_i,
  output [31:0]                              gpio1_out_o,
  output [31:0]                              gpio1_oen_o,
  input                                      pclk_bkd_i,
  input                                      prstn_bkd_i,
  input                                      psel_bkd_i,
  input                                      penable_bkd_i,
  input  [31:0]                              paddr_bkd_i,
  input  [47:0]                              pwdata_bkd_i,
  input                                      pwrite_bkd_i,
  output [47:0]                              prdata_bkd_o,
  output                                     pready_bkd_o,
  output                                     psuberr_bkd_o,
  output                                     i2c0_scl_oe,
  output                                     i2c0_sda_oe,
  input                                      i2c0_scl_in,
  input                                      i2c0_sda_in,
  output                                     i2c0_scl_pu_en,
  output                                     i2c0_sda_pu_en
);

// ==================================================
// Internal Wire Signals
// ==================================================
wire                                     clk;
wire                                     rstn;
wire                                     TRSTn;
wire                                     TCK;
wire                                     TMS;
wire                                     TDI;
wire                                     TDO;
wire                                     TDOoen;
wire [5-1:0]                             arid_dmb_m;
wire [64-1:0]                            araddr_dmb_m;
wire [8-1:0]                             arlen_dmb_m;
wire [12-1:0]                            aruser_dmb_m;
wire [3:0]                               arregion_dmb_m;
wire [2:0]                               arsize_dmb_m;
wire [1:0]                               arburst_dmb_m;
wire [3:0]                               arcache_dmb_m;
wire [1:0]                               arlock_dmb_m;
wire [2:0]                               arprot_dmb_m;
wire [3:0]                               arqos_dmb_m;
wire                                     arvalid_dmb_m;
wire                                     arready_dmb_m;
wire [5-1:0]                             rid_dmb_m;
wire [64-1:0]                            rdata_dmb_m;
wire                                     rlast_dmb_m;
wire [1:0]                               rresp_dmb_m;
wire                                     rvalid_dmb_m;
wire                                     rready_dmb_m;
wire [5-1:0]                             awid_dmb_m;
wire [64-1:0]                            awaddr_dmb_m;
wire [8-1:0]                             awlen_dmb_m;
wire [12-1:0]                            awuser_dmb_m;
wire [3:0]                               awregion_dmb_m;
wire [2:0]                               awsize_dmb_m;
wire [1:0]                               awburst_dmb_m;
wire [3:0]                               awcache_dmb_m;
wire [1:0]                               awlock_dmb_m;
wire [2:0]                               awprot_dmb_m;
wire [3:0]                               awqos_dmb_m;
wire                                     awvalid_dmb_m;
wire                                     awready_dmb_m;
wire [5-1:0]                             wid_dmb_m;
wire [64-1:0]                            wdata_dmb_m;
wire                                     wlast_dmb_m;
wire [8-1:0]                             wstrb_dmb_m;
wire                                     wvalid_dmb_m;
wire                                     wready_dmb_m;
wire [5-1:0]                             bid_dmb_m;
wire [1:0]                               bresp_dmb_m;
wire                                     bvalid_dmb_m;
wire                                     bready_dmb_m;
wire                                     txd_dvp;
wire                                     rxd_dvp;
wire [31:0]                              out0;
wire [31:0]                              out1;
wire [31:0]                              out2;
wire [31:0]                              in0;
wire [31:0]                              dbg_gp_out;
wire [31:0]                              dbg_gp_in;
wire                                     TCK_d;
wire                                     TMS_d;
wire                                     TDO_d;
wire                                     TDOoen_d;
wire                                     TDI_d;
wire                                     TRSTn_d;
wire                                     jtag_ext_cg;
wire                                     jtag_mux_sel;
wire [5:0]                               irq_ext;
wire [31:0]                              gpio0_in;
wire [31:0]                              gpio0_out;
wire [31:0]                              gpio0_oen;
wire [31:0]                              gpio1_in;
wire [31:0]                              gpio1_out;
wire [31:0]                              gpio1_oen;
wire                                     pclk_bkd;
wire                                     prstn_bkd;
wire                                     psel_bkd;
wire                                     penable_bkd;
wire [31:0]                              paddr_bkd;
wire [47:0]                              pwdata_bkd;
wire                                     pwrite_bkd;
wire [47:0]                              prdata_bkd;
wire                                     pready_bkd;
wire                                     psuberr_bkd;

// ==================================================
// Pre Code Insertion
// ==================================================

// ==================================================
// Instance msftDvDebug_backdoor_v0 wire definitions
// ==================================================
wire                                     cpu_rst;
wire [31:0]                              pc_dvp;
wire                                     inst_valid;
wire                                     branch;
wire                                     rstn_bkdr;
wire                                     enable_cpu1;
wire                                     enable_tap_cpu1;
wire                                     enable_tap_tdr_cpu1;
wire                                     sss;
wire [31:0]                              ss_status;
wire                                     bd1_irom_accen;
wire                                     bd1_irom_cs;
wire [32-1:2]                            bd1_irom_addr;
wire [48-1:0]                            bd1_irom_din;
wire                                     bd1_irom_we;
wire [48-1:0]                            bd1_irom_wstrb;
wire [48-1:0]                            bd1_irom_dout;
wire                                     bd1_irom_ready;
wire                                     bd1_iram_accen;
wire                                     bd1_iram_cs;
wire [32-1:2]                            bd1_iram_addr;
wire [48-1:0]                            bd1_iram_din;
wire                                     bd1_iram_we;
wire [48-1:0]                            bd1_iram_wstrb;
wire [48-1:0]                            bd1_iram_dout;
wire                                     bd1_iram_ready;
wire                                     accen_dram;
wire                                     enable_dram;
wire [32-1:2]                            addr_dram;
wire [48-1:0]                            wdata_dram;
wire                                     write_dram;
wire [48-1:0]                            wstrb_dram;
wire [48-1:0]                            rdata_dram;
wire                                     ready_dram;
wire                                     accen_efuse;
wire                                     enable_efuse;
wire [16-1:2]                            addr_efuse;
wire [32-1:0]                            wdata_efuse;
wire                                     write_efuse;
wire [32-1:0]                            wstrb_efuse;
wire [32-1:0]                            rdata_efuse;
wire                                     ready_efuse;
wire                                     accen_ksu;
wire                                     enable_ksu;
wire [16-1:0]                            addr_ksu;
wire [32-1:0]                            wdata_ksu;
wire                                     write_ksu;
wire [32-1:0]                            wstrb_ksu;
wire [32-1:0]                            rdata_ksu;
wire                                     ready_ksu;

// ==================================================
// Instance msftDvIp_riscv_memory_v0 wire definitions
// ==================================================
wire                                     rstn_ss;
wire                                     IROM_EN;
wire [31:0]                              IROM_ADDR;
wire [33-1:0]                            IROM_RDATA;
wire                                     IROM_READY;
wire                                     IROM_ERROR;
wire                                     IRAM_EN;
wire [31:0]                              IRAM_ADDR;
wire [33-1:0]                            IRAM_WDATA;
wire                                     IRAM_WE;
wire [3:0]                               IRAM_BE;
wire [33-1:0]                            IRAM_RDATA;
wire                                     IRAM_READY;
wire                                     IRAM_ERROR;
wire                                     DRAM_EN;
wire [31:0]                              DRAM_ADDR;
wire [33-1:0]                            DRAM_WDATA;
wire                                     DRAM_WE;
wire [3:0]                               DRAM_BE;
wire [33-1:0]                            DRAM_RDATA;
wire                                     DRAM_READY;
wire                                     DRAM_ERROR;
wire                                     tsmap_cs;
wire [15:0]                              tsmap_addr;
wire [33-1:0]                            tsmap_rdata;

// ==================================================
// Instance msftDvIp_dmb wire definitions
// ==================================================
wire [5-1:0]                             arid_dmb_s;
wire [31:0]                              araddr_dmb_s;
wire [7:0]                               arlen_dmb_s;
wire [12-1:0]                            aruser_dmb_s;
wire [3:0]                               arregion_dmb_s;
wire [2:0]                               arsize_dmb_s;
wire [1:0]                               arburst_dmb_s;
wire [3:0]                               arcache_dmb_s;
wire [1:0]                               arlock_dmb_s;
wire [2:0]                               arprot_dmb_s;
wire [3:0]                               arqos_dmb_s;
wire                                     arvalid_dmb_s;
wire                                     arready_dmb_s;
wire [5-1:0]                             rid_dmb_s;
wire [32-1:0]                            rdata_dmb_s;
wire                                     rlast_dmb_s;
wire [1:0]                               rresp_dmb_s;
wire                                     rvalid_dmb_s;
wire                                     rready_dmb_s;
wire [5-1:0]                             awid_dmb_s;
wire [31:0]                              awaddr_dmb_s;
wire [7:0]                               awlen_dmb_s;
wire [12-1:0]                            awuser_dmb_s;
wire [3:0]                               awregion_dmb_s;
wire [2:0]                               awsize_dmb_s;
wire [1:0]                               awburst_dmb_s;
wire [3:0]                               awcache_dmb_s;
wire [1:0]                               awlock_dmb_s;
wire [2:0]                               awprot_dmb_s;
wire [3:0]                               awqos_dmb_s;
wire                                     awvalid_dmb_s;
wire                                     awready_dmb_s;
wire [5-1:0]                             wid_dmb_s;
wire [32-1:0]                            wdata_dmb_s;
wire                                     wlast_dmb_s;
wire [4-1:0]                             wstrb_dmb_s;
wire                                     wvalid_dmb_s;
wire                                     wready_dmb_s;
wire [5-1:0]                             bid_dmb_s;
wire [1:0]                               bresp_dmb_s;
wire                                     bvalid_dmb_s;
wire                                     bready_dmb_s;

// ==================================================
// Instance msftDvIp_cheri_axi_fabric wire definitions
// ==================================================
wire [4-1:0]                             arid_cpu_m;
wire [32-1:0]                            araddr_cpu_m;
wire [8-1:0]                             arlen_cpu_m;
wire [12-1:0]                            aruser_cpu_m;
wire [3:0]                               arregion_cpu_m;
wire [2:0]                               arsize_cpu_m;
wire [1:0]                               arburst_cpu_m;
wire [3:0]                               arcache_cpu_m;
wire [1:0]                               arlock_cpu_m;
wire [2:0]                               arprot_cpu_m;
wire [3:0]                               arqos_cpu_m;
wire                                     arvalid_cpu_m;
wire                                     arready_cpu_m;
wire [4-1:0]                             rid_cpu_m;
wire [32-1:0]                            rdata_cpu_m;
wire                                     rlast_cpu_m;
wire [1:0]                               rresp_cpu_m;
wire                                     rvalid_cpu_m;
wire                                     rready_cpu_m;
wire [4-1:0]                             awid_cpu_m;
wire [32-1:0]                            awaddr_cpu_m;
wire [8-1:0]                             awlen_cpu_m;
wire [12-1:0]                            awuser_cpu_m;
wire [3:0]                               awregion_cpu_m;
wire [2:0]                               awsize_cpu_m;
wire [1:0]                               awburst_cpu_m;
wire [3:0]                               awcache_cpu_m;
wire [1:0]                               awlock_cpu_m;
wire [2:0]                               awprot_cpu_m;
wire [3:0]                               awqos_cpu_m;
wire                                     awvalid_cpu_m;
wire                                     awready_cpu_m;
wire [4-1:0]                             wid_cpu_m;
wire [32-1:0]                            wdata_cpu_m;
wire                                     wlast_cpu_m;
wire [32/8-1:0]                          wstrb_cpu_m;
wire                                     wvalid_cpu_m;
wire                                     wready_cpu_m;
wire [4-1:0]                             bid_cpu_m;
wire [1:0]                               bresp_cpu_m;
wire                                     bvalid_cpu_m;
wire                                     bready_cpu_m;
wire [4-1:0]                             arid_dma_m;
wire [32-1:0]                            araddr_dma_m;
wire [8-1:0]                             arlen_dma_m;
wire [12-1:0]                            aruser_dma_m;
wire [3:0]                               arregion_dma_m;
wire [2:0]                               arsize_dma_m;
wire [1:0]                               arburst_dma_m;
wire [3:0]                               arcache_dma_m;
wire [1:0]                               arlock_dma_m;
wire [2:0]                               arprot_dma_m;
wire [3:0]                               arqos_dma_m;
wire                                     arvalid_dma_m;
wire                                     arready_dma_m;
wire [4-1:0]                             rid_dma_m;
wire [32-1:0]                            rdata_dma_m;
wire                                     rlast_dma_m;
wire [1:0]                               rresp_dma_m;
wire                                     rvalid_dma_m;
wire                                     rready_dma_m;
wire [4-1:0]                             awid_dma_m;
wire [32-1:0]                            awaddr_dma_m;
wire [8-1:0]                             awlen_dma_m;
wire [12-1:0]                            awuser_dma_m;
wire [3:0]                               awregion_dma_m;
wire [2:0]                               awsize_dma_m;
wire [1:0]                               awburst_dma_m;
wire [3:0]                               awcache_dma_m;
wire [1:0]                               awlock_dma_m;
wire [2:0]                               awprot_dma_m;
wire [3:0]                               awqos_dma_m;
wire                                     awvalid_dma_m;
wire                                     awready_dma_m;
wire [4-1:0]                             wid_dma_m;
wire [32-1:0]                            wdata_dma_m;
wire                                     wlast_dma_m;
wire [32/8-1:0]                          wstrb_dma_m;
wire                                     wvalid_dma_m;
wire                                     wready_dma_m;
wire [4-1:0]                             bid_dma_m;
wire [1:0]                               bresp_dma_m;
wire                                     bvalid_dma_m;
wire                                     bready_dma_m;
wire [5-1:0]                             arid_periph_s;
wire [32-1:0]                            araddr_periph_s;
wire [8-1:0]                             arlen_periph_s;
wire [12-1:0]                            aruser_periph_s;
wire [3:0]                               arregion_periph_s;
wire [2:0]                               arsize_periph_s;
wire [1:0]                               arburst_periph_s;
wire [3:0]                               arcache_periph_s;
wire [1:0]                               arlock_periph_s;
wire [2:0]                               arprot_periph_s;
wire [3:0]                               arqos_periph_s;
wire                                     arvalid_periph_s;
wire                                     arready_periph_s;
wire [5-1:0]                             rid_periph_s;
wire [32-1:0]                            rdata_periph_s;
wire                                     rlast_periph_s;
wire [1:0]                               rresp_periph_s;
wire                                     rvalid_periph_s;
wire                                     rready_periph_s;
wire [5-1:0]                             awid_periph_s;
wire [32-1:0]                            awaddr_periph_s;
wire [8-1:0]                             awlen_periph_s;
wire [12-1:0]                            awuser_periph_s;
wire [3:0]                               awregion_periph_s;
wire [2:0]                               awsize_periph_s;
wire [1:0]                               awburst_periph_s;
wire [3:0]                               awcache_periph_s;
wire [1:0]                               awlock_periph_s;
wire [2:0]                               awprot_periph_s;
wire [3:0]                               awqos_periph_s;
wire                                     awvalid_periph_s;
wire                                     awready_periph_s;
wire [5-1:0]                             wid_periph_s;
wire [32-1:0]                            wdata_periph_s;
wire                                     wlast_periph_s;
wire [32/8-1:0]                          wstrb_periph_s;
wire                                     wvalid_periph_s;
wire                                     wready_periph_s;
wire [5-1:0]                             bid_periph_s;
wire [1:0]                               bresp_periph_s;
wire                                     bvalid_periph_s;
wire                                     bready_periph_s;
wire [5-1:0]                             arid_sram_m;
wire [32-1:0]                            araddr_sram_m;
wire [8-1:0]                             arlen_sram_m;
wire [12-1:0]                            aruser_sram_m;
wire [3:0]                               arregion_sram_m;
wire [2:0]                               arsize_sram_m;
wire [1:0]                               arburst_sram_m;
wire [3:0]                               arcache_sram_m;
wire [1:0]                               arlock_sram_m;
wire [2:0]                               arprot_sram_m;
wire [3:0]                               arqos_sram_m;
wire                                     arvalid_sram_m;
wire                                     arready_sram_m;
wire [5-1:0]                             rid_sram_m;
wire [32-1:0]                            rdata_sram_m;
wire                                     rlast_sram_m;
wire [1:0]                               rresp_sram_m;
wire                                     rvalid_sram_m;
wire                                     rready_sram_m;
wire [5-1:0]                             awid_sram_m;
wire [32-1:0]                            awaddr_sram_m;
wire [8-1:0]                             awlen_sram_m;
wire [12-1:0]                            awuser_sram_m;
wire [3:0]                               awregion_sram_m;
wire [2:0]                               awsize_sram_m;
wire [1:0]                               awburst_sram_m;
wire [3:0]                               awcache_sram_m;
wire [1:0]                               awlock_sram_m;
wire [2:0]                               awprot_sram_m;
wire [3:0]                               awqos_sram_m;
wire                                     awvalid_sram_m;
wire                                     awready_sram_m;
wire [5-1:0]                             wid_sram_m;
wire [32-1:0]                            wdata_sram_m;
wire                                     wlast_sram_m;
wire [32/8-1:0]                          wstrb_sram_m;
wire                                     wvalid_sram_m;
wire                                     wready_sram_m;
wire [5-1:0]                             bid_sram_m;
wire [1:0]                               bresp_sram_m;
wire                                     bvalid_sram_m;
wire                                     bready_sram_m;

// ==================================================
// Instance msftDvIp_periph_wrapper_v0 wire definitions
// ==================================================
wire [5:0]                               irqs_ext;
wire                                     irq;
wire                                     fiq;
wire                                     dw_ssel;
wire                                     dw_sck;
wire [3:0]                               dw_mosi;
wire [3:0]                               dw_miso;
wire [3:0]                               dw_oen;

// ==================================================
// Instance msftDvIp_cheri_core0 wire definitions
// ==================================================
wire                                     TCDEV_EN;
wire [31:0]                              TCDEV_ADDR;
wire [33-1:0]                            TCDEV_WDATA;
wire                                     TCDEV_WE;
wire [3:0]                               TCDEV_BE;
wire [33-1:0]                            TCDEV_RDATA;
wire                                     TCDEV_READY;
wire [127:0]                             mmreg_corein;
wire [63:0]                              mmreg_coreout;
wire                                     irq_software;
wire                                     irq_timer;
wire                                     irq_external;

// ==================================================
// Instance shared_ram wire definitions
// ==================================================

// ==================================================
// Instance msftDvIp_tcdev_wrapper wire definitions
// ==================================================
wire                                     irq_periph;

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================
`define SS_IROM_PATH msftDvIp_riscv_memory_v0_i.irom
`ifndef VERILATOR
defparam `SS_IROM_PATH.RAM_BACK_DOOR_ENABLE=1;
`endif
  assign `SS_IROM_PATH.accen_bkdr = bd1_irom_accen;
  assign `SS_IROM_PATH.cs_bkdr = bd1_irom_cs;
  assign `SS_IROM_PATH.addr_bkdr = bd1_irom_addr;
  assign `SS_IROM_PATH.din_bkdr = bd1_irom_din;
  assign `SS_IROM_PATH.we_bkdr = bd1_irom_we;
  assign bd1_irom_dout = `SS_IROM_PATH.dout;
  assign bd1_irom_ready = `SS_IROM_PATH.rdy_bkdr;
`define SS_IRAM_PATH msftDvIp_riscv_memory_v0_i.iram
  assign `SS_IRAM_PATH.accen_bkdr = bd1_iram_accen;
`ifndef VERILATOR
  defparam `SS_IRAM_PATH.RAM_BACK_DOOR_ENABLE = 1;
`endif
  assign `SS_IRAM_PATH.cs_bkdr = bd1_iram_cs;
  assign `SS_IRAM_PATH.addr_bkdr = bd1_iram_addr;
  assign `SS_IRAM_PATH.din_bkdr = bd1_iram_din;
  assign `SS_IRAM_PATH.we_bkdr = bd1_iram_we;
  assign `SS_IRAM_PATH.wstrb_bkdr = bd1_iram_wstrb;
  assign bd1_iram_dout = `SS_IRAM_PATH.dout;
  assign bd1_iram_ready = `SS_IRAM_PATH.rdy_bkdr;
`define SS_CORE_PATH msftDvIp_cheri_core0_i.msftDvIp_cheri_core_wrapper_i.ibex_top_i.u_ibex_top.u_ibex_core
 assign pc_dvp = `SS_CORE_PATH.if_stage_i.pc_id_o;
 assign cpu_rst = ~`SS_CORE_PATH.rst_ni;
 assign inst_valid         = `SS_CORE_PATH.instr_id_done;
 assign branch             = `SS_CORE_PATH.id_stage_i.pc_set_o;
logic [3:0] ctlsm, lsusm;
logic [1:0] fifo_cnt;
 assign ctlsm        = `SS_CORE_PATH.id_stage_i.controller_i.ctrl_fsm_cs[3:0];
 assign lsusm        = `SS_CORE_PATH.load_store_unit_i.ls_fsm_cs[3:0];
 assign cpuexp       = `SS_CORE_PATH.id_stage_i.controller_i.id_exception_o;
 assign cpuexc       = `SS_CORE_PATH.id_stage_i.controller_i.id_exception_o;
 assign valid        = `SS_CORE_PATH.id_stage_i.instr_valid_i;
 assign stall_id     = `SS_CORE_PATH.id_stage_i.stall_id;
 assign stall_mem    = `SS_CORE_PATH.id_stage_i.stall_mem;
 assign stall_wb     = `SS_CORE_PATH.id_stage_i.stall_wb;
 assign if_req       = `SS_CORE_PATH.if_stage_i.gen_prefetch_buffer.prefetch_buffer_i.valid_req;
 assign fifo_cnt     = 'h0;
 assign ss_status  = {14'h0, fifo_cnt, lsusm, ctlsm, 2'h0, stall_mem, if_req, stall_id, stall_wb, cpuexc, cpu_rst};
 assign cheri_ex_dbg_status = `SS_CORE_PATH.g_cheri_ex.u_cheri_ex.dbg_status;
 assign cheri_operator      = `SS_CORE_PATH.g_cheri_ex.u_cheri_ex.cheri_operator_i;
 assign cheri_ex_cs1_vec    = `SS_CORE_PATH.g_cheri_ex.u_cheri_ex.dbg_cs1_vec;
 assign cheri_ex_cs2_vec    = `SS_CORE_PATH.g_cheri_ex.u_cheri_ex.dbg_cs2_vec;
 assign cheri_ex_cd_vec     = `SS_CORE_PATH.g_cheri_ex.u_cheri_ex.dbg_cd_vec;

// ==================================================
// Instance msftDvDebug_backdoor_v0
// ==================================================
msftDvDebug_backdoor_v0 #(
  .DRAM_ENABLE(0),
  .EFUSE_ENABLE(0),
  .KSU_ENABLE(0)
  ) msftDvDebug_backdoor_v0_i (
  .clk_i                         ( pclk_bkd                                 ),
  .rstn_i                        ( prstn_bkd                                ),
  .cpu_rst_i                     ( cpu_rst                                  ),
  .pc_i                          ( pc_dvp                                   ),
  .inst_val_i                    ( inst_valid                               ),
  .branch_i                      ( branch                                   ),
  .rstn_bkdr_o                   ( rstn_bkdr                                ),
  .enable_cpu_o                  ( enable_cpu1                              ),
  .enable_tap_o                  ( enable_tap_cpu1                          ),
  .enable_tap_tdr_o              ( enable_tap_tdr_cpu1                      ),
  .sss_o                         ( sss                                      ),
  .status                        ( ss_status                                ),
  .psel_bkd_i                    ( psel_bkd                                 ),
  .penable_bkd_i                 ( penable_bkd                              ),
  .paddr_bkd_i                   ( paddr_bkd                                ),
  .pwdata_bkd_i                  ( pwdata_bkd                               ),
  .pwrite_bkd_i                  ( pwrite_bkd                               ),
  .prdata_bkd_o                  ( prdata_bkd                               ),
  .pready_bkd_o                  ( pready_bkd                               ),
  .psuberr_bkd_o                 ( psuberr_bkd                              ),
  .accen_irom_o                  ( bd1_irom_accen                           ),
  .enable_irom_o                 ( bd1_irom_cs                              ),
  .addr_irom_o                   ( bd1_irom_addr                            ),
  .wdata_irom_o                  ( bd1_irom_din                             ),
  .write_irom_o                  ( bd1_irom_we                              ),
  .wstrb_irom_o                  ( bd1_irom_wstrb                           ),
  .rdata_irom_i                  ( bd1_irom_dout                            ),
  .ready_irom_i                  ( bd1_irom_ready                           ),
  .accen_iram_o                  ( bd1_iram_accen                           ),
  .enable_iram_o                 ( bd1_iram_cs                              ),
  .addr_iram_o                   ( bd1_iram_addr                            ),
  .wdata_iram_o                  ( bd1_iram_din                             ),
  .write_iram_o                  ( bd1_iram_we                              ),
  .wstrb_iram_o                  ( bd1_iram_wstrb                           ),
  .rdata_iram_i                  ( bd1_iram_dout                            ),
  .ready_iram_i                  ( bd1_iram_ready                           ),
  .accen_dram_o                  ( accen_dram                               ),
  .enable_dram_o                 ( enable_dram                              ),
  .addr_dram_o                   ( addr_dram                                ),
  .wdata_dram_o                  ( wdata_dram                               ),
  .write_dram_o                  ( write_dram                               ),
  .wstrb_dram_o                  ( wstrb_dram                               ),
  .rdata_dram_i                  ( rdata_dram                               ),
  .ready_dram_i                  ( ready_dram                               ),
  .accen_efuse_o                 ( accen_efuse                              ),
  .enable_efuse_o                ( enable_efuse                             ),
  .addr_efuse_o                  ( addr_efuse                               ),
  .wdata_efuse_o                 ( wdata_efuse                              ),
  .write_efuse_o                 ( write_efuse                              ),
  .wstrb_efuse_o                 ( wstrb_efuse                              ),
  .rdata_efuse_i                 ( rdata_efuse                              ),
  .ready_efuse_i                 ( ready_efuse                              ),
  .accen_ksu_o                   ( accen_ksu                                ),
  .enable_ksu_o                  ( enable_ksu                               ),
  .addr_ksu_o                    ( addr_ksu                                 ),
  .wdata_ksu_o                   ( wdata_ksu                                ),
  .write_ksu_o                   ( write_ksu                                ),
  .wstrb_ksu_o                   ( wstrb_ksu                                ),
  .rdata_ksu_i                   ( rdata_ksu                                ),
  .ready_ksu_i                   ( ready_ksu                                )
);


// ==================================================
//  Inst Pre Code 
// ==================================================
assign rstn_ss = rstn & rstn_bkdr;

// ==================================================
// Instance msftDvIp_riscv_memory_v0
// ==================================================
msftDvIp_riscv_memory_v0 #(
  .IROM_INIT_FILE(IROM_INIT_FILE),
  .IRAM_INIT_FILE(IRAM_INIT_FILE),
  .IROM_DEPTH(IROM_DEPTH),
  .IRAM_DEPTH(IRAM_DEPTH),
  .DRAM_DEPTH(DRAM_DEPTH),
  .DATA_WIDTH(33)
  ) msftDvIp_riscv_memory_v0_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn_ss                                  ),
  .IROM_EN_i                     ( IROM_EN                                  ),
  .IROM_ADDR_i                   ( IROM_ADDR                                ),
  .IROM_RDATA_o                  ( IROM_RDATA                               ),
  .IROM_READY_o                  ( IROM_READY                               ),
  .IROM_ERROR_o                  ( IROM_ERROR                               ),
  .IRAM_EN_i                     ( IRAM_EN                                  ),
  .IRAM_ADDR_i                   ( IRAM_ADDR                                ),
  .IRAM_WDATA_i                  ( IRAM_WDATA                               ),
  .IRAM_WE_i                     ( IRAM_WE                                  ),
  .IRAM_BE_i                     ( IRAM_BE                                  ),
  .IRAM_RDATA_o                  ( IRAM_RDATA                               ),
  .IRAM_READY_o                  ( IRAM_READY                               ),
  .IRAM_ERROR_o                  ( IRAM_ERROR                               ),
  .DRAM_EN_i                     ( DRAM_EN                                  ),
  .DRAM_ADDR_i                   ( DRAM_ADDR                                ),
  .DRAM_WDATA_i                  ( DRAM_WDATA                               ),
  .DRAM_WE_i                     ( DRAM_WE                                  ),
  .DRAM_BE_i                     ( DRAM_BE                                  ),
  .DRAM_RDATA_o                  ( DRAM_RDATA                               ),
  .DRAM_READY_o                  ( DRAM_READY                               ),
  .DRAM_ERROR_o                  ( DRAM_ERROR                               ),
  .tsmap_cs_i                    ( tsmap_cs                                 ),
  .tsmap_addr_i                  ( tsmap_addr                               ),
  .tsmap_rdata_o                 ( tsmap_rdata                              )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_dmb
// ==================================================
msftDvIp_dmb msftDvIp_dmb_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn_ss                                  ),
  .arid_dmb_m_o                  ( arid_dmb_m                               ),
  .araddr_dmb_m_o                ( araddr_dmb_m                             ),
  .arlen_dmb_m_o                 ( arlen_dmb_m                              ),
  .aruser_dmb_m_o                ( aruser_dmb_m                             ),
  .arregion_dmb_m_o              ( arregion_dmb_m                           ),
  .arsize_dmb_m_o                ( arsize_dmb_m                             ),
  .arburst_dmb_m_o               ( arburst_dmb_m                            ),
  .arcache_dmb_m_o               ( arcache_dmb_m                            ),
  .arlock_dmb_m_o                ( arlock_dmb_m                             ),
  .arprot_dmb_m_o                ( arprot_dmb_m                             ),
  .arqos_dmb_m_o                 ( arqos_dmb_m                              ),
  .arvalid_dmb_m_o               ( arvalid_dmb_m                            ),
  .arready_dmb_m_i               ( arready_dmb_m                            ),
  .rid_dmb_m_i                   ( rid_dmb_m                                ),
  .rdata_dmb_m_i                 ( rdata_dmb_m                              ),
  .rlast_dmb_m_i                 ( rlast_dmb_m                              ),
  .rresp_dmb_m_i                 ( rresp_dmb_m                              ),
  .rvalid_dmb_m_i                ( rvalid_dmb_m                             ),
  .rready_dmb_m_o                ( rready_dmb_m                             ),
  .awid_dmb_m_o                  ( awid_dmb_m                               ),
  .awaddr_dmb_m_o                ( awaddr_dmb_m                             ),
  .awlen_dmb_m_o                 ( awlen_dmb_m                              ),
  .awuser_dmb_m_o                ( awuser_dmb_m                             ),
  .awregion_dmb_m_o              ( awregion_dmb_m                           ),
  .awsize_dmb_m_o                ( awsize_dmb_m                             ),
  .awburst_dmb_m_o               ( awburst_dmb_m                            ),
  .awcache_dmb_m_o               ( awcache_dmb_m                            ),
  .awlock_dmb_m_o                ( awlock_dmb_m                             ),
  .awprot_dmb_m_o                ( awprot_dmb_m                             ),
  .awqos_dmb_m_o                 ( awqos_dmb_m                              ),
  .awvalid_dmb_m_o               ( awvalid_dmb_m                            ),
  .awready_dmb_m_i               ( awready_dmb_m                            ),
  .wid_dmb_m_o                   ( wid_dmb_m                                ),
  .wdata_dmb_m_o                 ( wdata_dmb_m                              ),
  .wlast_dmb_m_o                 ( wlast_dmb_m                              ),
  .wstrb_dmb_m_o                 ( wstrb_dmb_m                              ),
  .wvalid_dmb_m_o                ( wvalid_dmb_m                             ),
  .wready_dmb_m_i                ( wready_dmb_m                             ),
  .bid_dmb_m_i                   ( bid_dmb_m                                ),
  .bresp_dmb_m_i                 ( bresp_dmb_m                              ),
  .bvalid_dmb_m_i                ( bvalid_dmb_m                             ),
  .bready_dmb_m_o                ( bready_dmb_m                             ),
  .arid_dmb_s_i                  ( arid_dmb_s                               ),
  .araddr_dmb_s_i                ( araddr_dmb_s                             ),
  .arlen_dmb_s_i                 ( arlen_dmb_s                              ),
  .aruser_dmb_s_i                ( aruser_dmb_s                             ),
  .arregion_dmb_s_i              ( arregion_dmb_s                           ),
  .arsize_dmb_s_i                ( arsize_dmb_s                             ),
  .arburst_dmb_s_i               ( arburst_dmb_s                            ),
  .arcache_dmb_s_i               ( arcache_dmb_s                            ),
  .arlock_dmb_s_i                ( arlock_dmb_s                             ),
  .arprot_dmb_s_i                ( arprot_dmb_s                             ),
  .arqos_dmb_s_i                 ( arqos_dmb_s                              ),
  .arvalid_dmb_s_i               ( arvalid_dmb_s                            ),
  .arready_dmb_s_o               ( arready_dmb_s                            ),
  .rid_dmb_s_o                   ( rid_dmb_s                                ),
  .rdata_dmb_s_o                 ( rdata_dmb_s                              ),
  .rlast_dmb_s_o                 ( rlast_dmb_s                              ),
  .rresp_dmb_s_o                 ( rresp_dmb_s                              ),
  .rvalid_dmb_s_o                ( rvalid_dmb_s                             ),
  .rready_dmb_s_i                ( rready_dmb_s                             ),
  .awid_dmb_s_i                  ( awid_dmb_s                               ),
  .awaddr_dmb_s_i                ( awaddr_dmb_s                             ),
  .awlen_dmb_s_i                 ( awlen_dmb_s                              ),
  .awuser_dmb_s_i                ( awuser_dmb_s                             ),
  .awregion_dmb_s_i              ( awregion_dmb_s                           ),
  .awsize_dmb_s_i                ( awsize_dmb_s                             ),
  .awburst_dmb_s_i               ( awburst_dmb_s                            ),
  .awcache_dmb_s_i               ( awcache_dmb_s                            ),
  .awlock_dmb_s_i                ( awlock_dmb_s                             ),
  .awprot_dmb_s_i                ( awprot_dmb_s                             ),
  .awqos_dmb_s_i                 ( awqos_dmb_s                              ),
  .awvalid_dmb_s_i               ( awvalid_dmb_s                            ),
  .awready_dmb_s_o               ( awready_dmb_s                            ),
  .wid_dmb_s_i                   ( wid_dmb_s                                ),
  .wdata_dmb_s_i                 ( wdata_dmb_s                              ),
  .wlast_dmb_s_i                 ( wlast_dmb_s                              ),
  .wstrb_dmb_s_i                 ( wstrb_dmb_s                              ),
  .wvalid_dmb_s_i                ( wvalid_dmb_s                             ),
  .wready_dmb_s_o                ( wready_dmb_s                             ),
  .bid_dmb_s_o                   ( bid_dmb_s                                ),
  .bresp_dmb_s_o                 ( bresp_dmb_s                              ),
  .bvalid_dmb_s_o                ( bvalid_dmb_s                             ),
  .bready_dmb_s_i                ( bready_dmb_s                             )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_cheri_axi_fabric
// ==================================================
msftDvIp_cheri_axi_fabric msftDvIp_cheri_axi_fabric_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn_ss                                  ),
  .arid_cpu_m_i                  ( arid_cpu_m                               ),
  .araddr_cpu_m_i                ( araddr_cpu_m                             ),
  .arlen_cpu_m_i                 ( arlen_cpu_m                              ),
  .aruser_cpu_m_i                ( aruser_cpu_m                             ),
  .arregion_cpu_m_i              ( arregion_cpu_m                           ),
  .arsize_cpu_m_i                ( arsize_cpu_m                             ),
  .arburst_cpu_m_i               ( arburst_cpu_m                            ),
  .arcache_cpu_m_i               ( arcache_cpu_m                            ),
  .arlock_cpu_m_i                ( arlock_cpu_m                             ),
  .arprot_cpu_m_i                ( arprot_cpu_m                             ),
  .arqos_cpu_m_i                 ( arqos_cpu_m                              ),
  .arvalid_cpu_m_i               ( arvalid_cpu_m                            ),
  .arready_cpu_m_o               ( arready_cpu_m                            ),
  .rid_cpu_m_o                   ( rid_cpu_m                                ),
  .rdata_cpu_m_o                 ( rdata_cpu_m                              ),
  .rlast_cpu_m_o                 ( rlast_cpu_m                              ),
  .rresp_cpu_m_o                 ( rresp_cpu_m                              ),
  .rvalid_cpu_m_o                ( rvalid_cpu_m                             ),
  .rready_cpu_m_i                ( rready_cpu_m                             ),
  .awid_cpu_m_i                  ( awid_cpu_m                               ),
  .awaddr_cpu_m_i                ( awaddr_cpu_m                             ),
  .awlen_cpu_m_i                 ( awlen_cpu_m                              ),
  .awuser_cpu_m_i                ( awuser_cpu_m                             ),
  .awregion_cpu_m_i              ( awregion_cpu_m                           ),
  .awsize_cpu_m_i                ( awsize_cpu_m                             ),
  .awburst_cpu_m_i               ( awburst_cpu_m                            ),
  .awcache_cpu_m_i               ( awcache_cpu_m                            ),
  .awlock_cpu_m_i                ( awlock_cpu_m                             ),
  .awprot_cpu_m_i                ( awprot_cpu_m                             ),
  .awqos_cpu_m_i                 ( awqos_cpu_m                              ),
  .awvalid_cpu_m_i               ( awvalid_cpu_m                            ),
  .awready_cpu_m_o               ( awready_cpu_m                            ),
  .wid_cpu_m_i                   ( wid_cpu_m                                ),
  .wdata_cpu_m_i                 ( wdata_cpu_m                              ),
  .wlast_cpu_m_i                 ( wlast_cpu_m                              ),
  .wstrb_cpu_m_i                 ( wstrb_cpu_m                              ),
  .wvalid_cpu_m_i                ( wvalid_cpu_m                             ),
  .wready_cpu_m_o                ( wready_cpu_m                             ),
  .bid_cpu_m_o                   ( bid_cpu_m                                ),
  .bresp_cpu_m_o                 ( bresp_cpu_m                              ),
  .bvalid_cpu_m_o                ( bvalid_cpu_m                             ),
  .bready_cpu_m_i                ( bready_cpu_m                             ),
  .arid_dma_m_i                  ( arid_dma_m                               ),
  .araddr_dma_m_i                ( araddr_dma_m                             ),
  .arlen_dma_m_i                 ( arlen_dma_m                              ),
  .aruser_dma_m_i                ( aruser_dma_m                             ),
  .arregion_dma_m_i              ( arregion_dma_m                           ),
  .arsize_dma_m_i                ( arsize_dma_m                             ),
  .arburst_dma_m_i               ( arburst_dma_m                            ),
  .arcache_dma_m_i               ( arcache_dma_m                            ),
  .arlock_dma_m_i                ( arlock_dma_m                             ),
  .arprot_dma_m_i                ( arprot_dma_m                             ),
  .arqos_dma_m_i                 ( arqos_dma_m                              ),
  .arvalid_dma_m_i               ( arvalid_dma_m                            ),
  .arready_dma_m_o               ( arready_dma_m                            ),
  .rid_dma_m_o                   ( rid_dma_m                                ),
  .rdata_dma_m_o                 ( rdata_dma_m                              ),
  .rlast_dma_m_o                 ( rlast_dma_m                              ),
  .rresp_dma_m_o                 ( rresp_dma_m                              ),
  .rvalid_dma_m_o                ( rvalid_dma_m                             ),
  .rready_dma_m_i                ( rready_dma_m                             ),
  .awid_dma_m_i                  ( awid_dma_m                               ),
  .awaddr_dma_m_i                ( awaddr_dma_m                             ),
  .awlen_dma_m_i                 ( awlen_dma_m                              ),
  .awuser_dma_m_i                ( awuser_dma_m                             ),
  .awregion_dma_m_i              ( awregion_dma_m                           ),
  .awsize_dma_m_i                ( awsize_dma_m                             ),
  .awburst_dma_m_i               ( awburst_dma_m                            ),
  .awcache_dma_m_i               ( awcache_dma_m                            ),
  .awlock_dma_m_i                ( awlock_dma_m                             ),
  .awprot_dma_m_i                ( awprot_dma_m                             ),
  .awqos_dma_m_i                 ( awqos_dma_m                              ),
  .awvalid_dma_m_i               ( awvalid_dma_m                            ),
  .awready_dma_m_o               ( awready_dma_m                            ),
  .wid_dma_m_i                   ( wid_dma_m                                ),
  .wdata_dma_m_i                 ( wdata_dma_m                              ),
  .wlast_dma_m_i                 ( wlast_dma_m                              ),
  .wstrb_dma_m_i                 ( wstrb_dma_m                              ),
  .wvalid_dma_m_i                ( wvalid_dma_m                             ),
  .wready_dma_m_o                ( wready_dma_m                             ),
  .bid_dma_m_o                   ( bid_dma_m                                ),
  .bresp_dma_m_o                 ( bresp_dma_m                              ),
  .bvalid_dma_m_o                ( bvalid_dma_m                             ),
  .bready_dma_m_i                ( bready_dma_m                             ),
  .arid_dmb_s_o                  ( arid_dmb_s                               ),
  .araddr_dmb_s_o                ( araddr_dmb_s                             ),
  .arlen_dmb_s_o                 ( arlen_dmb_s                              ),
  .aruser_dmb_s_o                ( aruser_dmb_s                             ),
  .arregion_dmb_s_o              ( arregion_dmb_s                           ),
  .arsize_dmb_s_o                ( arsize_dmb_s                             ),
  .arburst_dmb_s_o               ( arburst_dmb_s                            ),
  .arcache_dmb_s_o               ( arcache_dmb_s                            ),
  .arlock_dmb_s_o                ( arlock_dmb_s                             ),
  .arprot_dmb_s_o                ( arprot_dmb_s                             ),
  .arqos_dmb_s_o                 ( arqos_dmb_s                              ),
  .arvalid_dmb_s_o               ( arvalid_dmb_s                            ),
  .arready_dmb_s_i               ( arready_dmb_s                            ),
  .rid_dmb_s_i                   ( rid_dmb_s                                ),
  .rdata_dmb_s_i                 ( rdata_dmb_s                              ),
  .rlast_dmb_s_i                 ( rlast_dmb_s                              ),
  .rresp_dmb_s_i                 ( rresp_dmb_s                              ),
  .rvalid_dmb_s_i                ( rvalid_dmb_s                             ),
  .rready_dmb_s_o                ( rready_dmb_s                             ),
  .awid_dmb_s_o                  ( awid_dmb_s                               ),
  .awaddr_dmb_s_o                ( awaddr_dmb_s                             ),
  .awlen_dmb_s_o                 ( awlen_dmb_s                              ),
  .awuser_dmb_s_o                ( awuser_dmb_s                             ),
  .awregion_dmb_s_o              ( awregion_dmb_s                           ),
  .awsize_dmb_s_o                ( awsize_dmb_s                             ),
  .awburst_dmb_s_o               ( awburst_dmb_s                            ),
  .awcache_dmb_s_o               ( awcache_dmb_s                            ),
  .awlock_dmb_s_o                ( awlock_dmb_s                             ),
  .awprot_dmb_s_o                ( awprot_dmb_s                             ),
  .awqos_dmb_s_o                 ( awqos_dmb_s                              ),
  .awvalid_dmb_s_o               ( awvalid_dmb_s                            ),
  .awready_dmb_s_i               ( awready_dmb_s                            ),
  .wid_dmb_s_o                   ( wid_dmb_s                                ),
  .wdata_dmb_s_o                 ( wdata_dmb_s                              ),
  .wlast_dmb_s_o                 ( wlast_dmb_s                              ),
  .wstrb_dmb_s_o                 ( wstrb_dmb_s                              ),
  .wvalid_dmb_s_o                ( wvalid_dmb_s                             ),
  .wready_dmb_s_i                ( wready_dmb_s                             ),
  .bid_dmb_s_i                   ( bid_dmb_s                                ),
  .bresp_dmb_s_i                 ( bresp_dmb_s                              ),
  .bvalid_dmb_s_i                ( bvalid_dmb_s                             ),
  .bready_dmb_s_o                ( bready_dmb_s                             ),
  .arid_periph_s_o               ( arid_periph_s                            ),
  .araddr_periph_s_o             ( araddr_periph_s                          ),
  .arlen_periph_s_o              ( arlen_periph_s                           ),
  .aruser_periph_s_o             ( aruser_periph_s                          ),
  .arregion_periph_s_o           ( arregion_periph_s                        ),
  .arsize_periph_s_o             ( arsize_periph_s                          ),
  .arburst_periph_s_o            ( arburst_periph_s                         ),
  .arcache_periph_s_o            ( arcache_periph_s                         ),
  .arlock_periph_s_o             ( arlock_periph_s                          ),
  .arprot_periph_s_o             ( arprot_periph_s                          ),
  .arqos_periph_s_o              ( arqos_periph_s                           ),
  .arvalid_periph_s_o            ( arvalid_periph_s                         ),
  .arready_periph_s_i            ( arready_periph_s                         ),
  .rid_periph_s_i                ( rid_periph_s                             ),
  .rdata_periph_s_i              ( rdata_periph_s                           ),
  .rlast_periph_s_i              ( rlast_periph_s                           ),
  .rresp_periph_s_i              ( rresp_periph_s                           ),
  .rvalid_periph_s_i             ( rvalid_periph_s                          ),
  .rready_periph_s_o             ( rready_periph_s                          ),
  .awid_periph_s_o               ( awid_periph_s                            ),
  .awaddr_periph_s_o             ( awaddr_periph_s                          ),
  .awlen_periph_s_o              ( awlen_periph_s                           ),
  .awuser_periph_s_o             ( awuser_periph_s                          ),
  .awregion_periph_s_o           ( awregion_periph_s                        ),
  .awsize_periph_s_o             ( awsize_periph_s                          ),
  .awburst_periph_s_o            ( awburst_periph_s                         ),
  .awcache_periph_s_o            ( awcache_periph_s                         ),
  .awlock_periph_s_o             ( awlock_periph_s                          ),
  .awprot_periph_s_o             ( awprot_periph_s                          ),
  .awqos_periph_s_o              ( awqos_periph_s                           ),
  .awvalid_periph_s_o            ( awvalid_periph_s                         ),
  .awready_periph_s_i            ( awready_periph_s                         ),
  .wid_periph_s_o                ( wid_periph_s                             ),
  .wdata_periph_s_o              ( wdata_periph_s                           ),
  .wlast_periph_s_o              ( wlast_periph_s                           ),
  .wstrb_periph_s_o              ( wstrb_periph_s                           ),
  .wvalid_periph_s_o             ( wvalid_periph_s                          ),
  .wready_periph_s_i             ( wready_periph_s                          ),
  .bid_periph_s_i                ( bid_periph_s                             ),
  .bresp_periph_s_i              ( bresp_periph_s                           ),
  .bvalid_periph_s_i             ( bvalid_periph_s                          ),
  .bready_periph_s_o             ( bready_periph_s                          ),
  .arid_sram_m_o                 ( arid_sram_m                              ),
  .araddr_sram_m_o               ( araddr_sram_m                            ),
  .arlen_sram_m_o                ( arlen_sram_m                             ),
  .aruser_sram_m_o               ( aruser_sram_m                            ),
  .arregion_sram_m_o             ( arregion_sram_m                          ),
  .arsize_sram_m_o               ( arsize_sram_m                            ),
  .arburst_sram_m_o              ( arburst_sram_m                           ),
  .arcache_sram_m_o              ( arcache_sram_m                           ),
  .arlock_sram_m_o               ( arlock_sram_m                            ),
  .arprot_sram_m_o               ( arprot_sram_m                            ),
  .arqos_sram_m_o                ( arqos_sram_m                             ),
  .arvalid_sram_m_o              ( arvalid_sram_m                           ),
  .arready_sram_m_i              ( arready_sram_m                           ),
  .rid_sram_m_i                  ( rid_sram_m                               ),
  .rdata_sram_m_i                ( rdata_sram_m                             ),
  .rlast_sram_m_i                ( rlast_sram_m                             ),
  .rresp_sram_m_i                ( rresp_sram_m                             ),
  .rvalid_sram_m_i               ( rvalid_sram_m                            ),
  .rready_sram_m_o               ( rready_sram_m                            ),
  .awid_sram_m_o                 ( awid_sram_m                              ),
  .awaddr_sram_m_o               ( awaddr_sram_m                            ),
  .awlen_sram_m_o                ( awlen_sram_m                             ),
  .awuser_sram_m_o               ( awuser_sram_m                            ),
  .awregion_sram_m_o             ( awregion_sram_m                          ),
  .awsize_sram_m_o               ( awsize_sram_m                            ),
  .awburst_sram_m_o              ( awburst_sram_m                           ),
  .awcache_sram_m_o              ( awcache_sram_m                           ),
  .awlock_sram_m_o               ( awlock_sram_m                            ),
  .awprot_sram_m_o               ( awprot_sram_m                            ),
  .awqos_sram_m_o                ( awqos_sram_m                             ),
  .awvalid_sram_m_o              ( awvalid_sram_m                           ),
  .awready_sram_m_i              ( awready_sram_m                           ),
  .wid_sram_m_o                  ( wid_sram_m                               ),
  .wdata_sram_m_o                ( wdata_sram_m                             ),
  .wlast_sram_m_o                ( wlast_sram_m                             ),
  .wstrb_sram_m_o                ( wstrb_sram_m                             ),
  .wvalid_sram_m_o               ( wvalid_sram_m                            ),
  .wready_sram_m_i               ( wready_sram_m                            ),
  .bid_sram_m_i                  ( bid_sram_m                               ),
  .bresp_sram_m_i                ( bresp_sram_m                             ),
  .bvalid_sram_m_i               ( bvalid_sram_m                            ),
  .bready_sram_m_o               ( bready_sram_m                            )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_periph_wrapper_v0
// ==================================================
msftDvIp_periph_wrapper_v0 #(
  .DEF_ALT_FUNC0(DEF_ALT_FUNC0),
  .DEF_ALT_FUNC1(DEF_ALT_FUNC1)
  ) msftDvIp_periph_wrapper_v0_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn_ss                                  ),
  .arid_periph_s_i               ( arid_periph_s                            ),
  .araddr_periph_s_i             ( araddr_periph_s                          ),
  .arlen_periph_s_i              ( arlen_periph_s                           ),
  .aruser_periph_s_i             ( aruser_periph_s                          ),
  .arregion_periph_s_i           ( arregion_periph_s                        ),
  .arsize_periph_s_i             ( arsize_periph_s                          ),
  .arburst_periph_s_i            ( arburst_periph_s                         ),
  .arcache_periph_s_i            ( arcache_periph_s                         ),
  .arlock_periph_s_i             ( arlock_periph_s                          ),
  .arprot_periph_s_i             ( arprot_periph_s                          ),
  .arqos_periph_s_i              ( arqos_periph_s                           ),
  .arvalid_periph_s_i            ( arvalid_periph_s                         ),
  .arready_periph_s_o            ( arready_periph_s                         ),
  .rid_periph_s_o                ( rid_periph_s                             ),
  .rdata_periph_s_o              ( rdata_periph_s                           ),
  .rlast_periph_s_o              ( rlast_periph_s                           ),
  .rresp_periph_s_o              ( rresp_periph_s                           ),
  .rvalid_periph_s_o             ( rvalid_periph_s                          ),
  .rready_periph_s_i             ( rready_periph_s                          ),
  .awid_periph_s_i               ( awid_periph_s                            ),
  .awaddr_periph_s_i             ( awaddr_periph_s                          ),
  .awlen_periph_s_i              ( awlen_periph_s                           ),
  .awuser_periph_s_i             ( awuser_periph_s                          ),
  .awregion_periph_s_i           ( awregion_periph_s                        ),
  .awsize_periph_s_i             ( awsize_periph_s                          ),
  .awburst_periph_s_i            ( awburst_periph_s                         ),
  .awcache_periph_s_i            ( awcache_periph_s                         ),
  .awlock_periph_s_i             ( awlock_periph_s                          ),
  .awprot_periph_s_i             ( awprot_periph_s                          ),
  .awqos_periph_s_i              ( awqos_periph_s                           ),
  .awvalid_periph_s_i            ( awvalid_periph_s                         ),
  .awready_periph_s_o            ( awready_periph_s                         ),
  .wid_periph_s_i                ( wid_periph_s                             ),
  .wdata_periph_s_i              ( wdata_periph_s                           ),
  .wlast_periph_s_i              ( wlast_periph_s                           ),
  .wstrb_periph_s_i              ( wstrb_periph_s                           ),
  .wvalid_periph_s_i             ( wvalid_periph_s                          ),
  .wready_periph_s_o             ( wready_periph_s                          ),
  .bid_periph_s_o                ( bid_periph_s                             ),
  .bresp_periph_s_o              ( bresp_periph_s                           ),
  .bvalid_periph_s_o             ( bvalid_periph_s                          ),
  .bready_periph_s_i             ( bready_periph_s                          ),
  .arid_dma_m_o                  ( arid_dma_m                               ),
  .araddr_dma_m_o                ( araddr_dma_m                             ),
  .arlen_dma_m_o                 ( arlen_dma_m                              ),
  .aruser_dma_m_o                ( aruser_dma_m                             ),
  .arregion_dma_m_o              ( arregion_dma_m                           ),
  .arsize_dma_m_o                ( arsize_dma_m                             ),
  .arburst_dma_m_o               ( arburst_dma_m                            ),
  .arcache_dma_m_o               ( arcache_dma_m                            ),
  .arlock_dma_m_o                ( arlock_dma_m                             ),
  .arprot_dma_m_o                ( arprot_dma_m                             ),
  .arqos_dma_m_o                 ( arqos_dma_m                              ),
  .arvalid_dma_m_o               ( arvalid_dma_m                            ),
  .arready_dma_m_i               ( arready_dma_m                            ),
  .rid_dma_m_i                   ( rid_dma_m                                ),
  .rdata_dma_m_i                 ( rdata_dma_m                              ),
  .rlast_dma_m_i                 ( rlast_dma_m                              ),
  .rresp_dma_m_i                 ( rresp_dma_m                              ),
  .rvalid_dma_m_i                ( rvalid_dma_m                             ),
  .rready_dma_m_o                ( rready_dma_m                             ),
  .awid_dma_m_o                  ( awid_dma_m                               ),
  .awaddr_dma_m_o                ( awaddr_dma_m                             ),
  .awlen_dma_m_o                 ( awlen_dma_m                              ),
  .awuser_dma_m_o                ( awuser_dma_m                             ),
  .awregion_dma_m_o              ( awregion_dma_m                           ),
  .awsize_dma_m_o                ( awsize_dma_m                             ),
  .awburst_dma_m_o               ( awburst_dma_m                            ),
  .awcache_dma_m_o               ( awcache_dma_m                            ),
  .awlock_dma_m_o                ( awlock_dma_m                             ),
  .awprot_dma_m_o                ( awprot_dma_m                             ),
  .awqos_dma_m_o                 ( awqos_dma_m                              ),
  .awvalid_dma_m_o               ( awvalid_dma_m                            ),
  .awready_dma_m_i               ( awready_dma_m                            ),
  .wid_dma_m_o                   ( wid_dma_m                                ),
  .wdata_dma_m_o                 ( wdata_dma_m                              ),
  .wlast_dma_m_o                 ( wlast_dma_m                              ),
  .wstrb_dma_m_o                 ( wstrb_dma_m                              ),
  .wvalid_dma_m_o                ( wvalid_dma_m                             ),
  .wready_dma_m_i                ( wready_dma_m                             ),
  .bid_dma_m_i                   ( bid_dma_m                                ),
  .bresp_dma_m_i                 ( bresp_dma_m                              ),
  .bvalid_dma_m_i                ( bvalid_dma_m                             ),
  .bready_dma_m_o                ( bready_dma_m                             ),
  .rxd_dvp_i                     ( rxd_dvp                                  ),
  .txd_dvp_o                     ( txd_dvp                                  ),
  .TRSTn_d_o                     ( TRSTn_d                                  ),
  .TCK_d_o                       ( TCK_d                                    ),
  .TMS_d_o                       ( TMS_d                                    ),
  .TDI_d_i                       ( TDI_d                                    ),
  .TDO_d_o                       ( TDO_d                                    ),
  .TDOoen_d_o                    ( TDOoen_d                                 ),
  .jtag_mux_sel_o                ( jtag_mux_sel                             ),
  .irqs_ext_i                    ( irqs_ext                                 ),
  .irq_o                         ( irq                                      ),
  .fiq_o                         ( fiq                                      ),
  .gpio0_in_i                    ( gpio0_in                                 ),
  .gpio0_out_o                   ( gpio0_out                                ),
  .gpio0_oen_o                   ( gpio0_oen                                ),
  .gpio1_in_i                    ( gpio1_in                                 ),
  .gpio1_out_o                   ( gpio1_out                                ),
  .gpio1_oen_o                   ( gpio1_oen                                ),
  .i2c0_scl_oe                   ( i2c0_scl_oe                              ),
  .i2c0_sda_oe                   ( i2c0_sda_oe                              ),
  .i2c0_scl_in                   ( i2c0_scl_in                              ),
  .i2c0_sda_in                   ( i2c0_sda_in                              ),
  .i2c0_scl_pu_en                ( i2c0_scl_pu_en                           ),
  .i2c0_sda_pu_en                ( i2c0_sda_pu_en                           ),
  .dw_ssel                       ( dw_ssel                                  ),
  .dw_sck                        ( dw_sck                                   ),
  .dw_mosi                       ( dw_mosi                                  ),
  .dw_miso                       ( dw_miso                                  ),
  .dw_oen                        ( dw_oen                                   )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_cheri_core0
// ==================================================
msftDvIp_cheri_core0 msftDvIp_cheri_core0_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn_ss                                  ),
  .IROM_EN_o                     ( IROM_EN                                  ),
  .IROM_ADDR_o                   ( IROM_ADDR                                ),
  .IROM_RDATA_i                  ( IROM_RDATA                               ),
  .IROM_READY_i                  ( IROM_READY                               ),
  .IROM_ERROR_i                  ( IROM_ERROR                               ),
  .IRAM_EN_o                     ( IRAM_EN                                  ),
  .IRAM_ADDR_o                   ( IRAM_ADDR                                ),
  .IRAM_WDATA_o                  ( IRAM_WDATA                               ),
  .IRAM_WE_o                     ( IRAM_WE                                  ),
  .IRAM_BE_o                     ( IRAM_BE                                  ),
  .IRAM_RDATA_i                  ( IRAM_RDATA                               ),
  .IRAM_READY_i                  ( IRAM_READY                               ),
  .IRAM_ERROR_i                  ( IRAM_ERROR                               ),
  .DRAM_EN_o                     ( DRAM_EN                                  ),
  .DRAM_ADDR_o                   ( DRAM_ADDR                                ),
  .DRAM_WDATA_o                  ( DRAM_WDATA                               ),
  .DRAM_WE_o                     ( DRAM_WE                                  ),
  .DRAM_BE_o                     ( DRAM_BE                                  ),
  .DRAM_RDATA_i                  ( DRAM_RDATA                               ),
  .DRAM_READY_i                  ( DRAM_READY                               ),
  .DRAM_ERROR_i                  ( DRAM_ERROR                               ),
  .TCDEV_EN_o                    ( TCDEV_EN                                 ),
  .TCDEV_ADDR_o                  ( TCDEV_ADDR                               ),
  .TCDEV_WDATA_o                 ( TCDEV_WDATA                              ),
  .TCDEV_WE_o                    ( TCDEV_WE                                 ),
  .TCDEV_BE_o                    ( TCDEV_BE                                 ),
  .TCDEV_RDATA_i                 ( TCDEV_RDATA                              ),
  .TCDEV_READY_i                 ( TCDEV_READY                              ),
  .mmreg_corein_i                ( mmreg_corein                             ),
  .mmreg_coreout_o               ( mmreg_coreout                            ),
  .irq_software_i                ( irq_software                             ),
  .irq_timer_i                   ( irq_timer                                ),
  .irq_external_i                ( irq_external                             ),
  .tsmap_cs_o                    ( tsmap_cs                                 ),
  .tsmap_addr_o                  ( tsmap_addr                               ),
  .tsmap_rdata_i                 ( tsmap_rdata                              ),
  .arid_cpu_m_o                  ( arid_cpu_m                               ),
  .araddr_cpu_m_o                ( araddr_cpu_m                             ),
  .arlen_cpu_m_o                 ( arlen_cpu_m                              ),
  .aruser_cpu_m_o                ( aruser_cpu_m                             ),
  .arregion_cpu_m_o              ( arregion_cpu_m                           ),
  .arsize_cpu_m_o                ( arsize_cpu_m                             ),
  .arburst_cpu_m_o               ( arburst_cpu_m                            ),
  .arcache_cpu_m_o               ( arcache_cpu_m                            ),
  .arlock_cpu_m_o                ( arlock_cpu_m                             ),
  .arprot_cpu_m_o                ( arprot_cpu_m                             ),
  .arqos_cpu_m_o                 ( arqos_cpu_m                              ),
  .arvalid_cpu_m_o               ( arvalid_cpu_m                            ),
  .arready_cpu_m_i               ( arready_cpu_m                            ),
  .rid_cpu_m_i                   ( rid_cpu_m                                ),
  .rdata_cpu_m_i                 ( rdata_cpu_m                              ),
  .rlast_cpu_m_i                 ( rlast_cpu_m                              ),
  .rresp_cpu_m_i                 ( rresp_cpu_m                              ),
  .rvalid_cpu_m_i                ( rvalid_cpu_m                             ),
  .rready_cpu_m_o                ( rready_cpu_m                             ),
  .awid_cpu_m_o                  ( awid_cpu_m                               ),
  .awaddr_cpu_m_o                ( awaddr_cpu_m                             ),
  .awlen_cpu_m_o                 ( awlen_cpu_m                              ),
  .awuser_cpu_m_o                ( awuser_cpu_m                             ),
  .awregion_cpu_m_o              ( awregion_cpu_m                           ),
  .awsize_cpu_m_o                ( awsize_cpu_m                             ),
  .awburst_cpu_m_o               ( awburst_cpu_m                            ),
  .awcache_cpu_m_o               ( awcache_cpu_m                            ),
  .awlock_cpu_m_o                ( awlock_cpu_m                             ),
  .awprot_cpu_m_o                ( awprot_cpu_m                             ),
  .awqos_cpu_m_o                 ( awqos_cpu_m                              ),
  .awvalid_cpu_m_o               ( awvalid_cpu_m                            ),
  .awready_cpu_m_i               ( awready_cpu_m                            ),
  .wid_cpu_m_o                   ( wid_cpu_m                                ),
  .wdata_cpu_m_o                 ( wdata_cpu_m                              ),
  .wlast_cpu_m_o                 ( wlast_cpu_m                              ),
  .wstrb_cpu_m_o                 ( wstrb_cpu_m                              ),
  .wvalid_cpu_m_o                ( wvalid_cpu_m                             ),
  .wready_cpu_m_i                ( wready_cpu_m                             ),
  .bid_cpu_m_i                   ( bid_cpu_m                                ),
  .bresp_cpu_m_i                 ( bresp_cpu_m                              ),
  .bvalid_cpu_m_i                ( bvalid_cpu_m                             ),
  .bready_cpu_m_o                ( bready_cpu_m                             ),
  .TRSTn_i                       ( TRSTn                                    ),
  .TCK_i                         ( TCK                                      ),
  .TMS_i                         ( TMS                                      ),
  .TDI_i                         ( TDI                                      ),
  .TDO_o                         ( TDO                                      ),
  .TDOoen_o                      ( TDOoen                                   ),
  .irq_periph_i                  ( irq                                      )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance shared_ram
// ==================================================
msftDvIp_axi_mem_bit_write #(
  .AXI_ADDR_WIDTH(32),
  .AXI_DATA_WIDTH(32),
  .AXI_ID_WIDTH(5),
  .AXI_LEN_WIDTH(8),
  .AXI_LOCK_WIDTH(2),
  .MEM_SIZE('h2000)
  ) shared_ram_i (
  .s_axi_clk                     ( clk                                      ),
  .s_axi_rst_n                   ( rstn_ss                                  ),
  .s_axi_awid                    ( awid_sram_m                              ),
  .s_axi_awaddr                  ( awaddr_sram_m                            ),
  .s_axi_awlen                   ( awlen_sram_m                             ),
  .s_axi_awsize                  ( awsize_sram_m                            ),
  .s_axi_awburst                 ( awburst_sram_m                           ),
  .s_axi_awlock                  ( awlock_sram_m                            ),
  .s_axi_awcache                 ( awcache_sram_m                           ),
  .s_axi_awprot                  ( awprot_sram_m                            ),
  .s_axi_awqos                   ( awqos_sram_m                             ),
  .s_axi_awvalid                 ( awvalid_sram_m                           ),
  .s_axi_awready                 ( awready_sram_m                           ),
  .s_axi_wdata                   ( wdata_sram_m                             ),
  .s_axi_wstrb                   ( wstrb_sram_m                             ),
  .s_axi_wlast                   ( wlast_sram_m                             ),
  .s_axi_wvalid                  ( wvalid_sram_m                            ),
  .s_axi_wready                  ( wready_sram_m                            ),
  .s_axi_bready                  ( bready_sram_m                            ),
  .s_axi_bid                     ( bid_sram_m                               ),
  .s_axi_bresp                   ( bresp_sram_m                             ),
  .s_axi_bvalid                  ( bvalid_sram_m                            ),
  .s_axi_arid                    ( arid_sram_m                              ),
  .s_axi_araddr                  ( araddr_sram_m                            ),
  .s_axi_arlen                   ( arlen_sram_m                             ),
  .s_axi_arsize                  ( arsize_sram_m                            ),
  .s_axi_arburst                 ( arburst_sram_m                           ),
  .s_axi_arlock                  ( arlock_sram_m                            ),
  .s_axi_arcache                 ( arcache_sram_m                           ),
  .s_axi_arprot                  ( arprot_sram_m                            ),
  .s_axi_arqos                   ( arqos_sram_m                             ),
  .s_axi_arvalid                 ( arvalid_sram_m                           ),
  .s_axi_arready                 ( arready_sram_m                           ),
  .s_axi_rready                  ( rready_sram_m                            ),
  .s_axi_rid                     ( rid_sram_m                               ),
  .s_axi_rdata                   ( rdata_sram_m                             ),
  .s_axi_rresp                   ( rresp_sram_m                             ),
  .s_axi_rlast                   ( rlast_sram_m                             ),
  .s_axi_rvalid                  ( rvalid_sram_m                            )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_tcdev_wrapper
// ==================================================
msftDvIp_tcdev_wrapper msftDvIp_tcdev_wrapper_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .reg_en_i                      ( TCDEV_EN                                 ),
  .reg_addr_i                    ( TCDEV_ADDR                               ),
  .reg_wdata_i                   ( TCDEV_WDATA                              ),
  .reg_we_i                      ( TCDEV_WE                                 ),
  .reg_rdata_o                   ( TCDEV_RDATA                              ),
  .reg_ready_o                   ( TCDEV_READY                              ),
  .mmreg_coreout_i               ( mmreg_coreout                            ),
  .mmreg_corein_o                ( mmreg_corein                             ),
  .irq_periph_i                  ( irq_periph                               ),
  .irq_eth_i                     ( eth_irq                                  ),
  .irq_external_o                ( irq_external                             ),
  .irq_software_o                ( irq_software                             ),
  .irq_timer_o                   ( irq_timer                                )
);


// ==================================================
//  Connect IO Pins
// ==================================================
assign clk = clk_i;
assign rstn = rstn_i;
assign TRSTn = TRSTn_i;
assign TCK = TCK_i;
assign TMS = TMS_i;
assign TDI = TDI_i;
assign TDO_o = TDO;
assign TDOoen_o = TDOoen;
assign arid_dmb_m_o = arid_dmb_m;
assign araddr_dmb_m_o = araddr_dmb_m;
assign arlen_dmb_m_o = arlen_dmb_m;
assign aruser_dmb_m_o = aruser_dmb_m;
assign arregion_dmb_m_o = arregion_dmb_m;
assign arsize_dmb_m_o = arsize_dmb_m;
assign arburst_dmb_m_o = arburst_dmb_m;
assign arcache_dmb_m_o = arcache_dmb_m;
assign arlock_dmb_m_o = arlock_dmb_m;
assign arprot_dmb_m_o = arprot_dmb_m;
assign arqos_dmb_m_o = arqos_dmb_m;
assign arvalid_dmb_m_o = arvalid_dmb_m;
assign arready_dmb_m = arready_dmb_m_i;
assign rid_dmb_m = rid_dmb_m_i;
assign rdata_dmb_m = rdata_dmb_m_i;
assign rlast_dmb_m = rlast_dmb_m_i;
assign rresp_dmb_m = rresp_dmb_m_i;
assign rvalid_dmb_m = rvalid_dmb_m_i;
assign rready_dmb_m_o = rready_dmb_m;
assign awid_dmb_m_o = awid_dmb_m;
assign awaddr_dmb_m_o = awaddr_dmb_m;
assign awlen_dmb_m_o = awlen_dmb_m;
assign awuser_dmb_m_o = awuser_dmb_m;
assign awregion_dmb_m_o = awregion_dmb_m;
assign awsize_dmb_m_o = awsize_dmb_m;
assign awburst_dmb_m_o = awburst_dmb_m;
assign awcache_dmb_m_o = awcache_dmb_m;
assign awlock_dmb_m_o = awlock_dmb_m;
assign awprot_dmb_m_o = awprot_dmb_m;
assign awqos_dmb_m_o = awqos_dmb_m;
assign awvalid_dmb_m_o = awvalid_dmb_m;
assign awready_dmb_m = awready_dmb_m_i;
assign wid_dmb_m_o = wid_dmb_m;
assign wdata_dmb_m_o = wdata_dmb_m;
assign wlast_dmb_m_o = wlast_dmb_m;
assign wstrb_dmb_m_o = wstrb_dmb_m;
assign wvalid_dmb_m_o = wvalid_dmb_m;
assign wready_dmb_m = wready_dmb_m_i;
assign bid_dmb_m = bid_dmb_m_i;
assign bresp_dmb_m = bresp_dmb_m_i;
assign bvalid_dmb_m = bvalid_dmb_m_i;
assign bready_dmb_m_o = bready_dmb_m;
assign txd_dvp_o = txd_dvp;
assign rxd_dvp = rxd_dvp_i;
assign out0_o = out0;
assign out1_o = out1;
assign out2_o = out2;
assign in0 = in0_i;
assign dbg_gp_out_o = dbg_gp_out;
assign dbg_gp_in = dbg_gp_in_i;
assign TCK_d_o = TCK_d;
assign TMS_d_o = TMS_d;
assign TDO_d_o = TDO_d;
assign TDOoen_d_o = TDOoen_d;
assign TDI_d = TDI_d_i;
assign TRSTn_d_o = TRSTn_d;
assign jtag_ext_cg_o = jtag_ext_cg;
assign jtag_mux_sel_o = jtag_mux_sel;
assign irq_ext = irq_ext_i;
assign gpio0_in = gpio0_in_i;
assign gpio0_out_o = gpio0_out;
assign gpio0_oen_o = gpio0_oen;
assign gpio1_in = gpio1_in_i;
assign gpio1_out_o = gpio1_out;
assign gpio1_oen_o = gpio1_oen;
assign pclk_bkd = pclk_bkd_i;
assign prstn_bkd = prstn_bkd_i;
assign psel_bkd = psel_bkd_i;
assign penable_bkd = penable_bkd_i;
assign paddr_bkd = paddr_bkd_i;
assign pwdata_bkd = pwdata_bkd_i;
assign pwrite_bkd = pwrite_bkd_i;
assign prdata_bkd_o = prdata_bkd;
assign pready_bkd_o = pready_bkd;
assign psuberr_bkd_o = psuberr_bkd;







endmodule

// ==================================================
// Post Code Insertion
// ==================================================

