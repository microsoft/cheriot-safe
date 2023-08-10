// Copyright (C) Microsoft Corporation. All rights reserved.


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvIp_periph_wrapper_v0 Definition
// ==================================================
module msftDvIp_periph_wrapper_v0 #(
    parameter DEF_ALT_FUNC0 = 32'h0000_0000,
    parameter DEF_ALT_FUNC1 = 32'h0000_0000
  ) (
  input                                      clk_i,
  input                                      rstn_i,
  input  [5-1:0]                             arid_periph_s_i,
  input  [32-1:0]                            araddr_periph_s_i,
  input  [8-1:0]                             arlen_periph_s_i,
  input  [12-1:0]                            aruser_periph_s_i,
  input  [3:0]                               arregion_periph_s_i,
  input  [2:0]                               arsize_periph_s_i,
  input  [1:0]                               arburst_periph_s_i,
  input  [3:0]                               arcache_periph_s_i,
  input  [1:0]                               arlock_periph_s_i,
  input  [2:0]                               arprot_periph_s_i,
  input  [3:0]                               arqos_periph_s_i,
  input                                      arvalid_periph_s_i,
  output                                     arready_periph_s_o,
  output [5-1:0]                             rid_periph_s_o,
  output [32-1:0]                            rdata_periph_s_o,
  output                                     rlast_periph_s_o,
  output [1:0]                               rresp_periph_s_o,
  output                                     rvalid_periph_s_o,
  input                                      rready_periph_s_i,
  input  [5-1:0]                             awid_periph_s_i,
  input  [32-1:0]                            awaddr_periph_s_i,
  input  [8-1:0]                             awlen_periph_s_i,
  input  [12-1:0]                            awuser_periph_s_i,
  input  [3:0]                               awregion_periph_s_i,
  input  [2:0]                               awsize_periph_s_i,
  input  [1:0]                               awburst_periph_s_i,
  input  [3:0]                               awcache_periph_s_i,
  input  [1:0]                               awlock_periph_s_i,
  input  [2:0]                               awprot_periph_s_i,
  input  [3:0]                               awqos_periph_s_i,
  input                                      awvalid_periph_s_i,
  output                                     awready_periph_s_o,
  input  [5-1:0]                             wid_periph_s_i,
  input  [32-1:0]                            wdata_periph_s_i,
  input                                      wlast_periph_s_i,
  input  [4-1:0]                             wstrb_periph_s_i,
  input                                      wvalid_periph_s_i,
  output                                     wready_periph_s_o,
  output [5-1:0]                             bid_periph_s_o,
  output [1:0]                               bresp_periph_s_o,
  output                                     bvalid_periph_s_o,
  input                                      bready_periph_s_i,
  output [4-1:0]                             arid_dma_m_o,
  output [32-1:0]                            araddr_dma_m_o,
  output [8-1:0]                             arlen_dma_m_o,
  output [12-1:0]                            aruser_dma_m_o,
  output [3:0]                               arregion_dma_m_o,
  output [2:0]                               arsize_dma_m_o,
  output [1:0]                               arburst_dma_m_o,
  output [3:0]                               arcache_dma_m_o,
  output [1:0]                               arlock_dma_m_o,
  output [2:0]                               arprot_dma_m_o,
  output [3:0]                               arqos_dma_m_o,
  output                                     arvalid_dma_m_o,
  input                                      arready_dma_m_i,
  input  [4-1:0]                             rid_dma_m_i,
  input  [32-1:0]                            rdata_dma_m_i,
  input                                      rlast_dma_m_i,
  input  [1:0]                               rresp_dma_m_i,
  input                                      rvalid_dma_m_i,
  output                                     rready_dma_m_o,
  output [4-1:0]                             awid_dma_m_o,
  output [32-1:0]                            awaddr_dma_m_o,
  output [8-1:0]                             awlen_dma_m_o,
  output [12-1:0]                            awuser_dma_m_o,
  output [3:0]                               awregion_dma_m_o,
  output [2:0]                               awsize_dma_m_o,
  output [1:0]                               awburst_dma_m_o,
  output [3:0]                               awcache_dma_m_o,
  output [1:0]                               awlock_dma_m_o,
  output [2:0]                               awprot_dma_m_o,
  output [3:0]                               awqos_dma_m_o,
  output                                     awvalid_dma_m_o,
  input                                      awready_dma_m_i,
  output [4-1:0]                             wid_dma_m_o,
  output [32-1:0]                            wdata_dma_m_o,
  output                                     wlast_dma_m_o,
  output [4-1:0]                             wstrb_dma_m_o,
  output                                     wvalid_dma_m_o,
  input                                      wready_dma_m_i,
  input  [4-1:0]                             bid_dma_m_i,
  input  [1:0]                               bresp_dma_m_i,
  input                                      bvalid_dma_m_i,
  output                                     bready_dma_m_o,
  input                                      rxd_dvp_i,
  output                                     txd_dvp_o,
  output                                     TRSTn_d_o,
  output                                     TCK_d_o,
  output                                     TMS_d_o,
  input                                      TDI_d_i,
  output                                     TDO_d_o,
  output                                     TDOoen_d_o,
  output                                     jtag_mux_sel_o,
  input  [5:0]                               irqs_ext_i,
  output                                     irq_o,
  output                                     fiq_o,
  input  [31:0]                              gpio0_in_i,
  output [31:0]                              gpio0_out_o,
  output [31:0]                              gpio0_oen_o,
  input  [31:0]                              gpio1_in_i,
  output [31:0]                              gpio1_out_o,
  output [31:0]                              gpio1_oen_o,
  output                                     i2c0_scl_oe,
  output                                     i2c0_sda_oe,
  input                                      i2c0_scl_in,
  input                                      i2c0_sda_in,
  output                                     i2c0_scl_pu_en,
  output                                     i2c0_sda_pu_en,
  input                                      dw_ssel,
  input                                      dw_sck,
  input  [3:0]                               dw_mosi,
  output [3:0]                               dw_miso,
  input  [3:0]                               dw_oen,
  input  [63:0]                              mmreg_coreout_i,
  output [127:0]                             mmreg_corein_o
);

// ==================================================
// Internal Wire Signals
// ==================================================
wire                                     clk;
wire                                     rstn;
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
wire [4-1:0]                             wstrb_periph_s;
wire                                     wvalid_periph_s;
wire                                     wready_periph_s;
wire [5-1:0]                             bid_periph_s;
wire [1:0]                               bresp_periph_s;
wire                                     bvalid_periph_s;
wire                                     bready_periph_s;
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
wire [4-1:0]                             wstrb_dma_m;
wire                                     wvalid_dma_m;
wire                                     wready_dma_m;
wire [4-1:0]                             bid_dma_m;
wire [1:0]                               bresp_dma_m;
wire                                     bvalid_dma_m;
wire                                     bready_dma_m;
wire                                     rxd_dvp;
wire                                     txd_dvp;
wire                                     TRSTn_d;
wire                                     TCK_d;
wire                                     TMS_d;
wire                                     TDI_d;
wire                                     TDO_d;
wire                                     TDOoen_d;
wire                                     jtag_mux_sel;
wire [5:0]                               irqs_ext;
wire                                     irq;
wire                                     fiq;
wire [31:0]                              gpio0_in;
wire [31:0]                              gpio0_out;
wire [31:0]                              gpio0_oen;
wire [31:0]                              gpio1_in;
wire [31:0]                              gpio1_out;
wire [31:0]                              gpio1_oen;
wire [63:0]                              mmreg_coreout;
wire [127:0]                             mmreg_corein;

// ==================================================
// Pre Code Insertion
// ==================================================

// ==================================================
// Instance msftDvIp_periph_axi2apb_decode wire definitions
// ==================================================
wire                                     penable_m_apb;
wire [31:0]                              paddr_m_apb;
wire [31:0]                              pwdata_m_apb;
wire                                     pwrite_m_apb;
wire [3:0]                               pstrb_m_apb;
wire                                     psel_mmreg;
wire                                     penable_mmreg;
wire [31:0]                              paddr_mmreg;
wire [31:0]                              pwdata_mmreg;
wire                                     pwrite_mmreg;
wire [31:0]                              prdata_mmreg;
wire                                     pready_mmreg;
wire                                     psuberr_mmreg;
wire                                     psel_intc;
wire                                     penable_intc;
wire [31:0]                              paddr_intc;
wire [31:0]                              pwdata_intc;
wire                                     pwrite_intc;
wire [31:0]                              prdata_intc;
wire                                     pready_intc;
wire                                     psuberr_intc;
wire                                     psel_tmr0;
wire                                     penable_tmr0;
wire [31:0]                              paddr_tmr0;
wire [31:0]                              pwdata_tmr0;
wire                                     pwrite_tmr0;
wire [31:0]                              prdata_tmr0;
wire                                     pready_tmr0;
wire                                     psuberr_tmr0;
wire                                     psel_tmr1;
wire                                     penable_tmr1;
wire [31:0]                              paddr_tmr1;
wire [31:0]                              pwdata_tmr1;
wire                                     pwrite_tmr1;
wire [31:0]                              prdata_tmr1;
wire                                     pready_tmr1;
wire                                     psuberr_tmr1;
wire                                     psel_dma0;
wire                                     penable_dma0;
wire [31:0]                              paddr_dma0;
wire [31:0]                              pwdata_dma0;
wire                                     pwrite_dma0;
wire [31:0]                              prdata_dma0;
wire                                     pready_dma0;
wire                                     psuberr_dma0;
wire                                     psel_jtag;
wire                                     penable_jtag;
wire [31:0]                              paddr_jtag;
wire [31:0]                              pwdata_jtag;
wire                                     pwrite_jtag;
wire [31:0]                              prdata_jtag;
wire                                     pready_jtag;
wire                                     psuberr_jtag;
wire                                     psel_uart0;
wire                                     penable_uart0;
wire [31:0]                              paddr_uart0;
wire [31:0]                              pwdata_uart0;
wire                                     pwrite_uart0;
wire [31:0]                              prdata_uart0;
wire                                     pready_uart0;
wire                                     psuberr_uart0;
wire                                     psel_spi0;
wire                                     penable_spi0;
wire [31:0]                              paddr_spi0;
wire [31:0]                              pwdata_spi0;
wire                                     pwrite_spi0;
wire [31:0]                              prdata_spi0;
wire                                     pready_spi0;
wire                                     psuberr_spi0;
wire                                     psel_i2c0;
wire                                     penable_i2c0;
wire [31:0]                              paddr_i2c0;
wire [31:0]                              pwdata_i2c0;
wire                                     pwrite_i2c0;
wire [31:0]                              prdata_i2c0;
wire                                     pready_i2c0;
wire                                     psuberr_i2c0;
wire                                     psel_gpio0;
wire                                     penable_gpio0;
wire [31:0]                              paddr_gpio0;
wire [31:0]                              pwdata_gpio0;
wire                                     pwrite_gpio0;
wire [31:0]                              prdata_gpio0;
wire                                     pready_gpio0;
wire                                     psuberr_gpio0;
wire                                     psel_gpio1;
wire                                     penable_gpio1;
wire [31:0]                              paddr_gpio1;
wire [31:0]                              pwdata_gpio1;
wire                                     pwrite_gpio1;
wire [31:0]                              prdata_gpio1;
wire                                     pready_gpio1;
wire                                     psuberr_gpio1;

// ==================================================
// Instance msftDvIp_creg_timer0 wire definitions
// ==================================================
wire                                     tmr0_irq;
wire                                     err;
wire                                     sticky_err;

// ==================================================
// Instance msftDvIp_creg_timer1 wire definitions
// ==================================================
wire                                     tmr1_irq;

// ==================================================
// Instance msftDvIp_jtag_driver wire definitions
// ==================================================
wire                                     jtag_ext_cg;

// ==================================================
// Instance msftDvIp_spi_1m_1s wire definitions
// ==================================================
wire                                     spien1;
wire [3:0]                               spioen;
wire                                     sclk1;
wire [5:0]                               ssel1;
wire [3:0]                               mosi1;
wire [3:0]                               miso1;
wire                                     sclk1_in;
wire                                     ssel1_in;
wire [3:0]                               mosi1_in;
wire [3:0]                               miso1_in;
wire                                     misoen1;

// ==================================================
// Instance msftDvIp_i2c_1m_1s wire definitions
// ==================================================

// ==================================================
// Instance msftDvIp_uart wire definitions
// ==================================================

// ==================================================
// Instance msftDvIp_axi_dma_apb wire definitions
// ==================================================

// ==================================================
// Instance msftDvIp_creg_intc wire definitions
// ==================================================
wire                                     pslverr;
wire [31:0]                              irqs;
wire                                     intctrl_irq;
wire                                     irqx0;
wire                                     irqx1;

// ==================================================
// Instance msftDvIp_gpio0 wire definitions
// ==================================================
wire [31:0]                              gpio0_alt_sel;
wire [31:0]                              gpio_alt1_sel;
wire [31:0]                              gpio0_alt_out;
wire [31:0]                              gpio_alt1_in;
wire [31:0]                              gpio_alt1_oen;
wire [31:0]                              gpio0_alt1_out;
wire [31:0]                              gpio_alt2_in;
wire [31:0]                              gpio_alt2_oen;
wire [31:0]                              gpio_alt2_out;

// ==================================================
// Instance msftDvIp_gpio1 wire definitions
// ==================================================
wire [31:0]                              gpio1_alt_sel;
wire [31:0]                              gpio1_alt1_sel;
wire [31:0]                              gpio1_alt_in;
wire [31:0]                              gpio1_alt_oen;
wire [31:0]                              gpio_alt_out;
wire [31:0]                              gpio1_alt1_in;
wire [31:0]                              gpio1_alt1_oen;
wire [31:0]                              gpio_alt1_out;
wire [31:0]                              gpio1_alt2_in;
wire [31:0]                              gpio1_alt2_oen;

// ==================================================
// Instance msftDvIp_mmreg wire definitions
// ==================================================

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_periph_axi2apb_decode
// ==================================================
msftDvIp_periph_axi2apb_decode msftDvIp_periph_axi2apb_decode_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
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
  .penable_m_apb_o               ( penable_m_apb                            ),
  .paddr_m_apb_o                 ( paddr_m_apb                              ),
  .pwdata_m_apb_o                ( pwdata_m_apb                             ),
  .pwrite_m_apb_o                ( pwrite_m_apb                             ),
  .pstrb_m_apb_o                 ( pstrb_m_apb                              ),
  .psel_mmreg_o                  ( psel_mmreg                               ),
  .penable_mmreg_o               ( penable_mmreg                            ),
  .paddr_mmreg_o                 ( paddr_mmreg                              ),
  .pwdata_mmreg_o                ( pwdata_mmreg                             ),
  .pwrite_mmreg_o                ( pwrite_mmreg                             ),
  .prdata_mmreg_i                ( prdata_mmreg                             ),
  .pready_mmreg_i                ( pready_mmreg                             ),
  .psuberr_mmreg_i               ( psuberr_mmreg                            ),
  .psel_intc_o                   ( psel_intc                                ),
  .penable_intc_o                ( penable_intc                             ),
  .paddr_intc_o                  ( paddr_intc                               ),
  .pwdata_intc_o                 ( pwdata_intc                              ),
  .pwrite_intc_o                 ( pwrite_intc                              ),
  .prdata_intc_i                 ( prdata_intc                              ),
  .pready_intc_i                 ( pready_intc                              ),
  .psuberr_intc_i                ( psuberr_intc                             ),
  .psel_tmr0_o                   ( psel_tmr0                                ),
  .penable_tmr0_o                ( penable_tmr0                             ),
  .paddr_tmr0_o                  ( paddr_tmr0                               ),
  .pwdata_tmr0_o                 ( pwdata_tmr0                              ),
  .pwrite_tmr0_o                 ( pwrite_tmr0                              ),
  .prdata_tmr0_i                 ( prdata_tmr0                              ),
  .pready_tmr0_i                 ( pready_tmr0                              ),
  .psuberr_tmr0_i                ( psuberr_tmr0                             ),
  .psel_tmr1_o                   ( psel_tmr1                                ),
  .penable_tmr1_o                ( penable_tmr1                             ),
  .paddr_tmr1_o                  ( paddr_tmr1                               ),
  .pwdata_tmr1_o                 ( pwdata_tmr1                              ),
  .pwrite_tmr1_o                 ( pwrite_tmr1                              ),
  .prdata_tmr1_i                 ( prdata_tmr1                              ),
  .pready_tmr1_i                 ( pready_tmr1                              ),
  .psuberr_tmr1_i                ( psuberr_tmr1                             ),
  .psel_dma0_o                   ( psel_dma0                                ),
  .penable_dma0_o                ( penable_dma0                             ),
  .paddr_dma0_o                  ( paddr_dma0                               ),
  .pwdata_dma0_o                 ( pwdata_dma0                              ),
  .pwrite_dma0_o                 ( pwrite_dma0                              ),
  .prdata_dma0_i                 ( prdata_dma0                              ),
  .pready_dma0_i                 ( pready_dma0                              ),
  .psuberr_dma0_i                ( psuberr_dma0                             ),
  .psel_jtag_o                   ( psel_jtag                                ),
  .penable_jtag_o                ( penable_jtag                             ),
  .paddr_jtag_o                  ( paddr_jtag                               ),
  .pwdata_jtag_o                 ( pwdata_jtag                              ),
  .pwrite_jtag_o                 ( pwrite_jtag                              ),
  .prdata_jtag_i                 ( prdata_jtag                              ),
  .pready_jtag_i                 ( pready_jtag                              ),
  .psuberr_jtag_i                ( psuberr_jtag                             ),
  .psel_uart0_o                  ( psel_uart0                               ),
  .penable_uart0_o               ( penable_uart0                            ),
  .paddr_uart0_o                 ( paddr_uart0                              ),
  .pwdata_uart0_o                ( pwdata_uart0                             ),
  .pwrite_uart0_o                ( pwrite_uart0                             ),
  .prdata_uart0_i                ( prdata_uart0                             ),
  .pready_uart0_i                ( pready_uart0                             ),
  .psuberr_uart0_i               ( psuberr_uart0                            ),
  .psel_spi0_o                   ( psel_spi0                                ),
  .penable_spi0_o                ( penable_spi0                             ),
  .paddr_spi0_o                  ( paddr_spi0                               ),
  .pwdata_spi0_o                 ( pwdata_spi0                              ),
  .pwrite_spi0_o                 ( pwrite_spi0                              ),
  .prdata_spi0_i                 ( prdata_spi0                              ),
  .pready_spi0_i                 ( pready_spi0                              ),
  .psuberr_spi0_i                ( psuberr_spi0                             ),
  .psel_i2c0_o                   ( psel_i2c0                                ),
  .penable_i2c0_o                ( penable_i2c0                             ),
  .paddr_i2c0_o                  ( paddr_i2c0                               ),
  .pwdata_i2c0_o                 ( pwdata_i2c0                              ),
  .pwrite_i2c0_o                 ( pwrite_i2c0                              ),
  .prdata_i2c0_i                 ( prdata_i2c0                              ),
  .pready_i2c0_i                 ( pready_i2c0                              ),
  .psuberr_i2c0_i                ( psuberr_i2c0                             ),
  .psel_gpio0_o                  ( psel_gpio0                               ),
  .penable_gpio0_o               ( penable_gpio0                            ),
  .paddr_gpio0_o                 ( paddr_gpio0                              ),
  .pwdata_gpio0_o                ( pwdata_gpio0                             ),
  .pwrite_gpio0_o                ( pwrite_gpio0                             ),
  .prdata_gpio0_i                ( prdata_gpio0                             ),
  .pready_gpio0_i                ( pready_gpio0                             ),
  .psuberr_gpio0_i               ( psuberr_gpio0                            ),
  .psel_gpio1_o                  ( psel_gpio1                               ),
  .penable_gpio1_o               ( penable_gpio1                            ),
  .paddr_gpio1_o                 ( paddr_gpio1                              ),
  .pwdata_gpio1_o                ( pwdata_gpio1                             ),
  .pwrite_gpio1_o                ( pwrite_gpio1                             ),
  .prdata_gpio1_i                ( prdata_gpio1                             ),
  .pready_gpio1_i                ( pready_gpio1                             ),
  .psuberr_gpio1_i               ( psuberr_gpio1                            )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_creg_timer0
// ==================================================
msftDvIp_creg_timer msftDvIp_creg_timer0_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .psel_i                        ( psel_tmr0                                ),
  .penable_i                     ( penable_m_apb                            ),
  .paddr_i                       ( paddr_m_apb                              ),
  .pwdata_i                      ( pwdata_m_apb                             ),
  .pwrite_i                      ( pwrite_m_apb                             ),
  .prdata_o                      ( prdata_tmr0                              ),
  .pready_o                      ( pready_tmr0                              ),
  .psuberr_o                     ( psuberr_tmr0                             ),
  .irq_o                         ( tmr0_irq                                 ),
  .err_o                         ( err                                      ),
  .sticky_err_o                  ( sticky_err                               )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_creg_timer1
// ==================================================
msftDvIp_creg_timer msftDvIp_creg_timer1_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .psel_i                        ( psel_tmr1                                ),
  .penable_i                     ( penable_m_apb                            ),
  .paddr_i                       ( paddr_m_apb                              ),
  .pwdata_i                      ( pwdata_m_apb                             ),
  .pwrite_i                      ( pwrite_m_apb                             ),
  .prdata_o                      ( prdata_tmr1                              ),
  .pready_o                      ( pready_tmr1                              ),
  .psuberr_o                     ( psuberr_tmr1                             ),
  .irq_o                         ( tmr1_irq                                 ),
  .err_o                         ( err                                      ),
  .sticky_err_o                  ( sticky_err                               )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_jtag_driver
// ==================================================
msftDvIp_jtag_driver msftDvIp_jtag_driver_i (
  .pclk_i                        ( clk                                      ),
  .prstn_i                       ( rstn                                     ),
  .psel_i                        ( psel_jtag                                ),
  .penable_i                     ( penable_m_apb                            ),
  .paddr_i                       ( paddr_m_apb[7:0]                         ),
  .pwdata_i                      ( pwdata_m_apb                             ),
  .pwrite_i                      ( pwrite_m_apb                             ),
  .prdata_o                      ( prdata_jtag                              ),
  .pready_o                      ( pready_jtag                              ),
  .psuberr_o                     ( psuberr_jtag                             ),
  .TCK_o                         ( TCK_d                                    ),
  .TMS_o                         ( TMS_d                                    ),
  .TDO_o                         ( TDO_d                                    ),
  .TDOoen_o                      ( TDOoen_d                                 ),
  .TDI_i                         ( TDI_d                                    ),
  .TRSTn_o                       ( TRSTn_d                                  ),
  .jtag_ext_cg_o                 ( jtag_ext_cg                              ),
  .jtag_mux_sel_o                ( jtag_mux_sel                             )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_spi_1m_1s
// ==================================================
msftDvIp_spi_1m_1s msftDvIp_spi_1m_1s_i (
  .pclk_i                        ( clk                                      ),
  .prstn_i                       ( rstn                                     ),
  .psel_i                        ( psel_spi0                                ),
  .penable_i                     ( penable_m_apb                            ),
  .paddr_i                       ( paddr_m_apb                              ),
  .pwdata_i                      ( pwdata_m_apb                             ),
  .pwrite_i                      ( pwrite_m_apb                             ),
  .prdata_o                      ( prdata_spi0                              ),
  .pready_o                      ( pready_spi0                              ),
  .psuberr_o                     ( psuberr_spi0                             ),
  .spien_o                       ( spien1                                   ),
  .spioen_o                      ( spioen                                   ),
  .sclk_o                        ( sclk1                                    ),
  .ssel_o                        ( ssel1                                    ),
  .mosi_o                        ( mosi1                                    ),
  .miso_i                        ( miso1                                    ),
  .sclk_sub_i                    ( sclk1_in                                 ),
  .ssel_sub_i                    ( ssel1_in                                 ),
  .mosi_sub_i                    ( mosi1_in                                 ),
  .miso_sub_o                    ( miso1_in                                 ),
  .misoen_o                      ( misoen1                                  )
);


// ==================================================
//  Inst Pre Code 
// ==================================================
assign i2c0_scl_pu_en = 1'b1;
assign i2c0_sda_pu_en = 1'b1;

// ==================================================
// Instance msftDvIp_i2c_1m_1s
// ==================================================
msftDvIp_i2c_1m_1s msftDvIp_i2c_1m_1s_i (
  .pclk_i                        ( clk                                      ),
  .prstn_i                       ( rstn                                     ),
  .psel_i                        ( psel_i2c0                                ),
  .penable_i                     ( penable_m_apb                            ),
  .paddr_i                       ( paddr_m_apb                              ),
  .pwdata_i                      ( pwdata_m_apb                             ),
  .pwrite_i                      ( pwrite_m_apb                             ),
  .prdata_o                      ( prdata_i2c0                              ),
  .pready_o                      ( pready_i2c0                              ),
  .psuberr_o                     ( psuberr_i2c0                             ),
  .scl_oen_o                     ( i2c0_scl_oe                              ),
  .sda_oen_o                     ( i2c0_sda_oe                              ),
  .scl_in_i                      ( i2c0_scl_in                              ),
  .sda_in_i                      ( i2c0_sda_in                              )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_uart
// ==================================================
msftDvIp_uart msftDvIp_uart_i (
  .pclk_i                        ( clk                                      ),
  .prstn_i                       ( rstn                                     ),
  .psel_i                        ( psel_uart0                               ),
  .penable_i                     ( penable_m_apb                            ),
  .paddr_i                       ( paddr_m_apb[7:0]                         ),
  .pwdata_i                      ( pwdata_m_apb                             ),
  .pwrite_i                      ( pwrite_m_apb                             ),
  .prdata_o                      ( prdata_uart0                             ),
  .pready_o                      ( pready_uart0                             ),
  .psuberr_o                     ( psuberr_uart0                            ),
  .rxd_i                         ( rxd_dvp                                  ),
  .txd_o                         ( txd_dvp                                  ),
  .irq_o                         ( irq                                      )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_axi_dma_apb
// ==================================================
msftDvIp_axi_dma_apb #(
  .AXI_RCHAN_ID(1),
  .AXI_WCHAN_ID(1),
  .AXI_ID_WIDTH(4)
  ) msftDvIp_axi_dma_apb_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .psel_i                        ( psel_dma0                                ),
  .penable_i                     ( penable_dma0                             ),
  .paddr_i                       ( paddr_dma0                               ),
  .prdata_o                      ( prdata_dma0                              ),
  .pwdata_i                      ( pwdata_dma0                              ),
  .pwrite_i                      ( pwrite_dma0                              ),
  .pready_o                      ( pready_dma0                              ),
  .psuberr_o                     ( psuberr_dma0                             ),
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
  .bready_dma_m_o                ( bready_dma_m                             )
);


// ==================================================
//  Inst Pre Code 
// ==================================================
assign irqs[15:0]  = 16'h0000;
assign irqs[16]    = 1'b0;
assign irqs[17]    = tmr0_irq | tmr0_irq;
assign irqs[25:18] = 8'h00;
assign irqs[31:26] = irqs_ext;

// ==================================================
// Instance msftDvIp_creg_intc
// ==================================================
msftDvIp_creg_intc msftDvIp_creg_intc_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .psel_i                        ( psel_intc                                ),
  .penable_i                     ( penable_m_apb                            ),
  .paddr_i                       ( paddr_m_apb                              ),
  .pwdata_i                      ( pwdata_m_apb                             ),
  .pwrite_i                      ( pwrite_m_apb                             ),
  .prdata_o                      ( prdata_intc                              ),
  .pready_o                      ( pready_intc                              ),
  .pslverr_o                     ( pslverr                                  ),
  .irqs                          ( irqs                                     ),
  .fiq                           ( fiq                                      ),
  .irq                           ( intctrl_irq                              ),
  .irqx0                         ( irqx0                                    ),
  .irqx1                         ( irqx1                                    )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_gpio0
// ==================================================
msftDvIp_gpio #(
  .DEF_ALT_FUNC(DEF_ALT_FUNC0)
  ) msftDvIp_gpio0_i (
  .pclk_i                        ( clk                                      ),
  .prstn_i                       ( rstn                                     ),
  .psel_i                        ( psel_gpio0                               ),
  .penable_i                     ( penable_m_apb                            ),
  .paddr_i                       ( paddr_m_apb                              ),
  .pwdata_i                      ( pwdata_m_apb                             ),
  .pwrite_i                      ( pwrite_m_apb                             ),
  .prdata_o                      ( prdata_gpio0                             ),
  .pready_o                      ( pready_gpio0                             ),
  .psuberr_o                     ( psuberr_gpio0                            ),
  .gpio_in_i                     ( gpio0_in                                 ),
  .gpio_out_o                    ( gpio0_out                                ),
  .gpio_oen_o                    ( gpio0_oen                                ),
  .gpio_alt_sel_o                ( gpio0_alt_sel                            ),
  .gpio_alt1_sel_o               ( gpio_alt1_sel                            ),
  .gpio_alt_in_i                 ( 32'h0000_0000                            ),
  .gpio_alt_oen_i                ( 32'h0000_0000                            ),
  .gpio_alt_out_o                ( gpio0_alt_out                            ),
  .gpio_alt1_in_i                ( gpio_alt1_in                             ),
  .gpio_alt1_oen_i               ( gpio_alt1_oen                            ),
  .gpio_alt1_out_o               ( gpio0_alt1_out                           ),
  .gpio_alt2_in_i                ( gpio_alt2_in                             ),
  .gpio_alt2_oen_i               ( gpio_alt2_oen                            ),
  .gpio_alt2_out_o               ( gpio_alt2_out                            )
);


// ==================================================
//  Inst Pre Code 
// ==================================================
assign rst = 1'b0;
assign miso1           = {gpio_alt_out[7], gpio_alt_out[6], gpio_alt_out[1], gpio_alt_out[2]};
assign gpio1_alt_in    = {23'h0000_00, txd_dvp, mosi1[3], mosi1[2], rst, 1'b0, sclk1, mosi1[0], mosi1[1], ssel1[0]};
assign gpio1_alt_oen   = {23'h0000_00, 1'b1, spioen[3],  spioen[2], 1'b0, 1'b1, 1'b1, spioen[0], spioen[1], 1'b1};
assign gpio1_alt1_in   = {24'h0000_00, dw_mosi[3], dw_mosi[2], rst, 1'b0, dw_sck, dw_mosi[0], dw_mosi[1], dw_ssel};
assign gpio1_alt1_oen  = {24'h0000_00, ~dw_oen[3],  ~dw_oen[2], 1'b0, 1'b1, 1'b1, ~dw_oen[0], ~dw_oen[1], 1'b1};
assign dw_miso         = {gpio_alt1_out[7], gpio_alt1_out[6], gpio_alt1_out[1], gpio_alt1_out[2]};

// ==================================================
// Instance msftDvIp_gpio1
// ==================================================
msftDvIp_gpio #(
  .DEF_ALT_FUNC(DEF_ALT_FUNC1)
  ) msftDvIp_gpio1_i (
  .pclk_i                        ( clk                                      ),
  .prstn_i                       ( rstn                                     ),
  .psel_i                        ( psel_gpio1                               ),
  .penable_i                     ( penable_m_apb                            ),
  .paddr_i                       ( paddr_m_apb                              ),
  .pwdata_i                      ( pwdata_m_apb                             ),
  .pwrite_i                      ( pwrite_m_apb                             ),
  .prdata_o                      ( prdata_gpio1                             ),
  .pready_o                      ( pready_gpio1                             ),
  .psuberr_o                     ( psuberr_gpio1                            ),
  .gpio_in_i                     ( gpio1_in                                 ),
  .gpio_out_o                    ( gpio1_out                                ),
  .gpio_oen_o                    ( gpio1_oen                                ),
  .gpio_alt_sel_o                ( gpio1_alt_sel                            ),
  .gpio_alt1_sel_o               ( gpio1_alt1_sel                           ),
  .gpio_alt_in_i                 ( gpio1_alt_in                             ),
  .gpio_alt_oen_i                ( gpio1_alt_oen                            ),
  .gpio_alt_out_o                ( gpio_alt_out                             ),
  .gpio_alt1_in_i                ( gpio1_alt1_in                            ),
  .gpio_alt1_oen_i               ( gpio1_alt1_oen                           ),
  .gpio_alt1_out_o               ( gpio_alt1_out                            ),
  .gpio_alt2_in_i                ( gpio1_alt2_in                            ),
  .gpio_alt2_oen_i               ( gpio1_alt2_oen                           ),
  .gpio_alt2_out_o               ( gpio_alt2_out                            )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_mmreg
// ==================================================
msftDvIp_mmreg msftDvIp_mmreg_i (
  .pclk_i                        ( clk                                      ),
  .prstn_i                       ( rstn                                     ),
  .psel_i                        ( psel_mmreg                               ),
  .penable_i                     ( penable_m_apb                            ),
  .paddr_i                       ( paddr_m_apb[7:0]                         ),
  .pwdata_i                      ( pwdata_m_apb                             ),
  .pwrite_i                      ( pwrite_m_apb                             ),
  .prdata_o                      ( prdata_mmreg                             ),
  .pready_o                      ( pready_mmreg                             ),
  .pslverr_o                     ( pslverr                                  ),
  .mmreg_coreout_i               ( mmreg_coreout                            ),
  .mmreg_corein_o                ( mmreg_corein                             )
);


// ==================================================
//  Connect IO Pins
// ==================================================
assign clk = clk_i;
assign rstn = rstn_i;
assign arid_periph_s = arid_periph_s_i;
assign araddr_periph_s = araddr_periph_s_i;
assign arlen_periph_s = arlen_periph_s_i;
assign aruser_periph_s = aruser_periph_s_i;
assign arregion_periph_s = arregion_periph_s_i;
assign arsize_periph_s = arsize_periph_s_i;
assign arburst_periph_s = arburst_periph_s_i;
assign arcache_periph_s = arcache_periph_s_i;
assign arlock_periph_s = arlock_periph_s_i;
assign arprot_periph_s = arprot_periph_s_i;
assign arqos_periph_s = arqos_periph_s_i;
assign arvalid_periph_s = arvalid_periph_s_i;
assign arready_periph_s_o = arready_periph_s;
assign rid_periph_s_o = rid_periph_s;
assign rdata_periph_s_o = rdata_periph_s;
assign rlast_periph_s_o = rlast_periph_s;
assign rresp_periph_s_o = rresp_periph_s;
assign rvalid_periph_s_o = rvalid_periph_s;
assign rready_periph_s = rready_periph_s_i;
assign awid_periph_s = awid_periph_s_i;
assign awaddr_periph_s = awaddr_periph_s_i;
assign awlen_periph_s = awlen_periph_s_i;
assign awuser_periph_s = awuser_periph_s_i;
assign awregion_periph_s = awregion_periph_s_i;
assign awsize_periph_s = awsize_periph_s_i;
assign awburst_periph_s = awburst_periph_s_i;
assign awcache_periph_s = awcache_periph_s_i;
assign awlock_periph_s = awlock_periph_s_i;
assign awprot_periph_s = awprot_periph_s_i;
assign awqos_periph_s = awqos_periph_s_i;
assign awvalid_periph_s = awvalid_periph_s_i;
assign awready_periph_s_o = awready_periph_s;
assign wid_periph_s = wid_periph_s_i;
assign wdata_periph_s = wdata_periph_s_i;
assign wlast_periph_s = wlast_periph_s_i;
assign wstrb_periph_s = wstrb_periph_s_i;
assign wvalid_periph_s = wvalid_periph_s_i;
assign wready_periph_s_o = wready_periph_s;
assign bid_periph_s_o = bid_periph_s;
assign bresp_periph_s_o = bresp_periph_s;
assign bvalid_periph_s_o = bvalid_periph_s;
assign bready_periph_s = bready_periph_s_i;
assign arid_dma_m_o = arid_dma_m;
assign araddr_dma_m_o = araddr_dma_m;
assign arlen_dma_m_o = arlen_dma_m;
assign aruser_dma_m_o = aruser_dma_m;
assign arregion_dma_m_o = arregion_dma_m;
assign arsize_dma_m_o = arsize_dma_m;
assign arburst_dma_m_o = arburst_dma_m;
assign arcache_dma_m_o = arcache_dma_m;
assign arlock_dma_m_o = arlock_dma_m;
assign arprot_dma_m_o = arprot_dma_m;
assign arqos_dma_m_o = arqos_dma_m;
assign arvalid_dma_m_o = arvalid_dma_m;
assign arready_dma_m = arready_dma_m_i;
assign rid_dma_m = rid_dma_m_i;
assign rdata_dma_m = rdata_dma_m_i;
assign rlast_dma_m = rlast_dma_m_i;
assign rresp_dma_m = rresp_dma_m_i;
assign rvalid_dma_m = rvalid_dma_m_i;
assign rready_dma_m_o = rready_dma_m;
assign awid_dma_m_o = awid_dma_m;
assign awaddr_dma_m_o = awaddr_dma_m;
assign awlen_dma_m_o = awlen_dma_m;
assign awuser_dma_m_o = awuser_dma_m;
assign awregion_dma_m_o = awregion_dma_m;
assign awsize_dma_m_o = awsize_dma_m;
assign awburst_dma_m_o = awburst_dma_m;
assign awcache_dma_m_o = awcache_dma_m;
assign awlock_dma_m_o = awlock_dma_m;
assign awprot_dma_m_o = awprot_dma_m;
assign awqos_dma_m_o = awqos_dma_m;
assign awvalid_dma_m_o = awvalid_dma_m;
assign awready_dma_m = awready_dma_m_i;
assign wid_dma_m_o = wid_dma_m;
assign wdata_dma_m_o = wdata_dma_m;
assign wlast_dma_m_o = wlast_dma_m;
assign wstrb_dma_m_o = wstrb_dma_m;
assign wvalid_dma_m_o = wvalid_dma_m;
assign wready_dma_m = wready_dma_m_i;
assign bid_dma_m = bid_dma_m_i;
assign bresp_dma_m = bresp_dma_m_i;
assign bvalid_dma_m = bvalid_dma_m_i;
assign bready_dma_m_o = bready_dma_m;
assign rxd_dvp = rxd_dvp_i;
assign txd_dvp_o = txd_dvp;
assign TRSTn_d_o = TRSTn_d;
assign TCK_d_o = TCK_d;
assign TMS_d_o = TMS_d;
assign TDI_d = TDI_d_i;
assign TDO_d_o = TDO_d;
assign TDOoen_d_o = TDOoen_d;
assign jtag_mux_sel_o = jtag_mux_sel;
assign irqs_ext = irqs_ext_i;
assign irq_o = irq;
assign fiq_o = fiq;
assign gpio0_in = gpio0_in_i;
assign gpio0_out_o = gpio0_out;
assign gpio0_oen_o = gpio0_oen;
assign gpio1_in = gpio1_in_i;
assign gpio1_out_o = gpio1_out;
assign gpio1_oen_o = gpio1_oen;











assign mmreg_coreout = mmreg_coreout_i;
assign mmreg_corein_o = mmreg_corein;

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

