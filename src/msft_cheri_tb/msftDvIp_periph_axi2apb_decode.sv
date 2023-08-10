// Copyright (C) Microsoft Corporation. All rights reserved.


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvIp_periph_axi2apb_decode Definition
// ==================================================
module msftDvIp_periph_axi2apb_decode #(
    parameter AXI_ID_WIDTH = 5
  ) (
  input                                      clk_i,
  input                                      rstn_i,
  input  [AXI_ID_WIDTH-1:0]                  arid_periph_s_i,
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
  output [AXI_ID_WIDTH-1:0]                  rid_periph_s_o,
  output [32-1:0]                            rdata_periph_s_o,
  output                                     rlast_periph_s_o,
  output [1:0]                               rresp_periph_s_o,
  output                                     rvalid_periph_s_o,
  input                                      rready_periph_s_i,
  input  [AXI_ID_WIDTH-1:0]                  awid_periph_s_i,
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
  input  [AXI_ID_WIDTH-1:0]                  wid_periph_s_i,
  input  [32-1:0]                            wdata_periph_s_i,
  input                                      wlast_periph_s_i,
  input  [4-1:0]                             wstrb_periph_s_i,
  input                                      wvalid_periph_s_i,
  output                                     wready_periph_s_o,
  output [AXI_ID_WIDTH-1:0]                  bid_periph_s_o,
  output [1:0]                               bresp_periph_s_o,
  output                                     bvalid_periph_s_o,
  input                                      bready_periph_s_i,
  output                                     penable_m_apb_o,
  output [31:0]                              paddr_m_apb_o,
  output [31:0]                              pwdata_m_apb_o,
  output                                     pwrite_m_apb_o,
  output [3:0]                               pstrb_m_apb_o,
  output                                     psel_mmreg_o,
  output                                     penable_mmreg_o,
  output [31:0]                              paddr_mmreg_o,
  output [31:0]                              pwdata_mmreg_o,
  output                                     pwrite_mmreg_o,
  input  [31:0]                              prdata_mmreg_i,
  input                                      pready_mmreg_i,
  input                                      psuberr_mmreg_i,
  output                                     psel_intc_o,
  output                                     penable_intc_o,
  output [31:0]                              paddr_intc_o,
  output [31:0]                              pwdata_intc_o,
  output                                     pwrite_intc_o,
  input  [31:0]                              prdata_intc_i,
  input                                      pready_intc_i,
  input                                      psuberr_intc_i,
  output                                     psel_tmr0_o,
  output                                     penable_tmr0_o,
  output [31:0]                              paddr_tmr0_o,
  output [31:0]                              pwdata_tmr0_o,
  output                                     pwrite_tmr0_o,
  input  [31:0]                              prdata_tmr0_i,
  input                                      pready_tmr0_i,
  input                                      psuberr_tmr0_i,
  output                                     psel_tmr1_o,
  output                                     penable_tmr1_o,
  output [31:0]                              paddr_tmr1_o,
  output [31:0]                              pwdata_tmr1_o,
  output                                     pwrite_tmr1_o,
  input  [31:0]                              prdata_tmr1_i,
  input                                      pready_tmr1_i,
  input                                      psuberr_tmr1_i,
  output                                     psel_dma0_o,
  output                                     penable_dma0_o,
  output [31:0]                              paddr_dma0_o,
  output [31:0]                              pwdata_dma0_o,
  output                                     pwrite_dma0_o,
  input  [31:0]                              prdata_dma0_i,
  input                                      pready_dma0_i,
  input                                      psuberr_dma0_i,
  output                                     psel_jtag_o,
  output                                     penable_jtag_o,
  output [31:0]                              paddr_jtag_o,
  output [31:0]                              pwdata_jtag_o,
  output                                     pwrite_jtag_o,
  input  [31:0]                              prdata_jtag_i,
  input                                      pready_jtag_i,
  input                                      psuberr_jtag_i,
  output                                     psel_uart0_o,
  output                                     penable_uart0_o,
  output [31:0]                              paddr_uart0_o,
  output [31:0]                              pwdata_uart0_o,
  output                                     pwrite_uart0_o,
  input  [31:0]                              prdata_uart0_i,
  input                                      pready_uart0_i,
  input                                      psuberr_uart0_i,
  output                                     psel_spi0_o,
  output                                     penable_spi0_o,
  output [31:0]                              paddr_spi0_o,
  output [31:0]                              pwdata_spi0_o,
  output                                     pwrite_spi0_o,
  input  [31:0]                              prdata_spi0_i,
  input                                      pready_spi0_i,
  input                                      psuberr_spi0_i,
  output                                     psel_i2c0_o,
  output                                     penable_i2c0_o,
  output [31:0]                              paddr_i2c0_o,
  output [31:0]                              pwdata_i2c0_o,
  output                                     pwrite_i2c0_o,
  input  [31:0]                              prdata_i2c0_i,
  input                                      pready_i2c0_i,
  input                                      psuberr_i2c0_i,
  output                                     psel_gpio0_o,
  output                                     penable_gpio0_o,
  output [31:0]                              paddr_gpio0_o,
  output [31:0]                              pwdata_gpio0_o,
  output                                     pwrite_gpio0_o,
  input  [31:0]                              prdata_gpio0_i,
  input                                      pready_gpio0_i,
  input                                      psuberr_gpio0_i,
  output                                     psel_gpio1_o,
  output                                     penable_gpio1_o,
  output [31:0]                              paddr_gpio1_o,
  output [31:0]                              pwdata_gpio1_o,
  output                                     pwrite_gpio1_o,
  input  [31:0]                              prdata_gpio1_i,
  input                                      pready_gpio1_i,
  input                                      psuberr_gpio1_i
);

// ==================================================
// Internal Wire Signals
// ==================================================
wire                                     clk;
wire                                     rstn;
wire [AXI_ID_WIDTH-1:0]                  arid_periph_s;
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
wire [AXI_ID_WIDTH-1:0]                  rid_periph_s;
wire [32-1:0]                            rdata_periph_s;
wire                                     rlast_periph_s;
wire [1:0]                               rresp_periph_s;
wire                                     rvalid_periph_s;
wire                                     rready_periph_s;
wire [AXI_ID_WIDTH-1:0]                  awid_periph_s;
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
wire [AXI_ID_WIDTH-1:0]                  wid_periph_s;
wire [32-1:0]                            wdata_periph_s;
wire                                     wlast_periph_s;
wire [4-1:0]                             wstrb_periph_s;
wire                                     wvalid_periph_s;
wire                                     wready_periph_s;
wire [AXI_ID_WIDTH-1:0]                  bid_periph_s;
wire [1:0]                               bresp_periph_s;
wire                                     bvalid_periph_s;
wire                                     bready_periph_s;
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
// Pre Code Insertion
// ==================================================

// ==================================================
// Instance msftDvIp_axi2apb wire definitions
// ==================================================
wire                                     psel_mgr;
wire                                     penable_mgr;
wire [32-1:0]                            paddr_mgr;
wire [2:0]                               pprot_mgr;
wire [(32/8)-1:0]                        pstrb_mgr;
wire [32-1:0]                            prdata_mgr;
wire [32-1:0]                            pwdata_mgr;
wire                                     pwrite_mgr;
wire                                     pready_mgr;
wire                                     psuberr_mgr;

// ==================================================
// Instance msftDvIp_periph_axi2apb_decode_decoder wire definitions
// ==================================================
wire [(32/8)-1:0]                        pstrb_mmreg;
wire [(32/8)-1:0]                        pstrb_intc;
wire [(32/8)-1:0]                        pstrb_tmr0;
wire [(32/8)-1:0]                        pstrb_tmr1;
wire [(32/8)-1:0]                        pstrb_dma0;
wire [(32/8)-1:0]                        pstrb_jtag;
wire [(32/8)-1:0]                        pstrb_uart0;
wire [(32/8)-1:0]                        pstrb_spi0;
wire [(32/8)-1:0]                        pstrb_i2c0;
wire [(32/8)-1:0]                        pstrb_gpio0;
wire [(32/8)-1:0]                        pstrb_gpio1;

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_axi2apb
// ==================================================
msftDvIp_axi2apb #(
  .AXI_ID_WIDTH(AXI_ID_WIDTH)
  ) msftDvIp_axi2apb_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .arid_m_i                      ( arid_periph_s                            ),
  .araddr_m_i                    ( araddr_periph_s                          ),
  .arprot_m_i                    ( arprot_periph_s                          ),
  .arlen_m_i                     ( arlen_periph_s                           ),
  .arsize_m_i                    ( arsize_periph_s                          ),
  .arburst_m_i                   ( arburst_periph_s                         ),
  .arvalid_m_i                   ( arvalid_periph_s                         ),
  .arready_m_o                   ( arready_periph_s                         ),
  .rdata_m_o                     ( rdata_periph_s                           ),
  .rlast_m_o                     ( rlast_periph_s                           ),
  .rid_m_o                       ( rid_periph_s                             ),
  .rready_m_i                    ( rready_periph_s                          ),
  .rvalid_m_o                    ( rvalid_periph_s                          ),
  .rresp_m_o                     ( rresp_periph_s                           ),
  .awid_m_i                      ( awid_periph_s                            ),
  .awaddr_m_i                    ( awaddr_periph_s                          ),
  .awprot_m_i                    ( awprot_periph_s                          ),
  .awlen_m_i                     ( awlen_periph_s                           ),
  .awsize_m_i                    ( awsize_periph_s                          ),
  .awburst_m_i                   ( awburst_periph_s                         ),
  .awvalid_m_i                   ( awvalid_periph_s                         ),
  .awready_m_o                   ( awready_periph_s                         ),
  .wdata_m_i                     ( wdata_periph_s                           ),
  .wstrb_m_i                     ( wstrb_periph_s                           ),
  .wvalid_m_i                    ( wvalid_periph_s                          ),
  .wready_m_o                    ( wready_periph_s                          ),
  .wlast_m_i                     ( wlast_periph_s                           ),
  .bid_m_o                       ( bid_periph_s                             ),
  .bresp_m_o                     ( bresp_periph_s                           ),
  .bvalid_m_o                    ( bvalid_periph_s                          ),
  .bready_m_i                    ( bready_periph_s                          ),
  .psel_mgr_o                    ( psel_mgr                                 ),
  .penable_mgr_o                 ( penable_mgr                              ),
  .paddr_mgr_o                   ( paddr_mgr                                ),
  .pprot_mgr_o                   ( pprot_mgr                                ),
  .pstrb_mgr_o                   ( pstrb_mgr                                ),
  .prdata_mgr_i                  ( prdata_mgr                               ),
  .pwdata_mgr_o                  ( pwdata_mgr                               ),
  .pwrite_mgr_o                  ( pwrite_mgr                               ),
  .pready_mgr_i                  ( pready_mgr                               ),
  .psuberr_mgr_i                 ( psuberr_mgr                              )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_periph_axi2apb_decode_decoder
// ==================================================
msftDvIp_periph_axi2apb_decode_decoder msftDvIp_periph_axi2apb_decode_decoder_i (
  .psel_mgr_i                    ( psel_mgr                                 ),
  .penable_mgr_i                 ( penable_mgr                              ),
  .paddr_mgr_i                   ( paddr_mgr                                ),
  .pwdata_mgr_i                  ( pwdata_mgr                               ),
  .pwrite_mgr_i                  ( pwrite_mgr                               ),
  .pstrb_mgr_i                   ( pstrb_mgr                                ),
  .prdata_mgr_o                  ( prdata_mgr                               ),
  .pready_mgr_o                  ( pready_mgr                               ),
  .psuberr_mgr_o                 ( psuberr_mgr                              ),
  .penable_sub_o                 ( penable_m_apb                            ),
  .paddr_sub_o                   ( paddr_m_apb                              ),
  .pwdata_sub_o                  ( pwdata_m_apb                             ),
  .pwrite_sub_o                  ( pwrite_m_apb                             ),
  .pstrb_sub_o                   ( pstrb_m_apb                              ),
  .psel_mmreg_o                  ( psel_mmreg                               ),
  .penable_mmreg_o               ( penable_mmreg                            ),
  .paddr_mmreg_o                 ( paddr_mmreg                              ),
  .pwdata_mmreg_o                ( pwdata_mmreg                             ),
  .pwrite_mmreg_o                ( pwrite_mmreg                             ),
  .pstrb_mmreg_o                 ( pstrb_mmreg                              ),
  .prdata_mmreg_i                ( prdata_mmreg                             ),
  .pready_mmreg_i                ( pready_mmreg                             ),
  .psuberr_mmreg_i               ( psuberr_mmreg                            ),
  .psel_intc_o                   ( psel_intc                                ),
  .penable_intc_o                ( penable_intc                             ),
  .paddr_intc_o                  ( paddr_intc                               ),
  .pwdata_intc_o                 ( pwdata_intc                              ),
  .pwrite_intc_o                 ( pwrite_intc                              ),
  .pstrb_intc_o                  ( pstrb_intc                               ),
  .prdata_intc_i                 ( prdata_intc                              ),
  .pready_intc_i                 ( pready_intc                              ),
  .psuberr_intc_i                ( psuberr_intc                             ),
  .psel_tmr0_o                   ( psel_tmr0                                ),
  .penable_tmr0_o                ( penable_tmr0                             ),
  .paddr_tmr0_o                  ( paddr_tmr0                               ),
  .pwdata_tmr0_o                 ( pwdata_tmr0                              ),
  .pwrite_tmr0_o                 ( pwrite_tmr0                              ),
  .pstrb_tmr0_o                  ( pstrb_tmr0                               ),
  .prdata_tmr0_i                 ( prdata_tmr0                              ),
  .pready_tmr0_i                 ( pready_tmr0                              ),
  .psuberr_tmr0_i                ( psuberr_tmr0                             ),
  .psel_tmr1_o                   ( psel_tmr1                                ),
  .penable_tmr1_o                ( penable_tmr1                             ),
  .paddr_tmr1_o                  ( paddr_tmr1                               ),
  .pwdata_tmr1_o                 ( pwdata_tmr1                              ),
  .pwrite_tmr1_o                 ( pwrite_tmr1                              ),
  .pstrb_tmr1_o                  ( pstrb_tmr1                               ),
  .prdata_tmr1_i                 ( prdata_tmr1                              ),
  .pready_tmr1_i                 ( pready_tmr1                              ),
  .psuberr_tmr1_i                ( psuberr_tmr1                             ),
  .psel_dma0_o                   ( psel_dma0                                ),
  .penable_dma0_o                ( penable_dma0                             ),
  .paddr_dma0_o                  ( paddr_dma0                               ),
  .pwdata_dma0_o                 ( pwdata_dma0                              ),
  .pwrite_dma0_o                 ( pwrite_dma0                              ),
  .pstrb_dma0_o                  ( pstrb_dma0                               ),
  .prdata_dma0_i                 ( prdata_dma0                              ),
  .pready_dma0_i                 ( pready_dma0                              ),
  .psuberr_dma0_i                ( psuberr_dma0                             ),
  .psel_jtag_o                   ( psel_jtag                                ),
  .penable_jtag_o                ( penable_jtag                             ),
  .paddr_jtag_o                  ( paddr_jtag                               ),
  .pwdata_jtag_o                 ( pwdata_jtag                              ),
  .pwrite_jtag_o                 ( pwrite_jtag                              ),
  .pstrb_jtag_o                  ( pstrb_jtag                               ),
  .prdata_jtag_i                 ( prdata_jtag                              ),
  .pready_jtag_i                 ( pready_jtag                              ),
  .psuberr_jtag_i                ( psuberr_jtag                             ),
  .psel_uart0_o                  ( psel_uart0                               ),
  .penable_uart0_o               ( penable_uart0                            ),
  .paddr_uart0_o                 ( paddr_uart0                              ),
  .pwdata_uart0_o                ( pwdata_uart0                             ),
  .pwrite_uart0_o                ( pwrite_uart0                             ),
  .pstrb_uart0_o                 ( pstrb_uart0                              ),
  .prdata_uart0_i                ( prdata_uart0                             ),
  .pready_uart0_i                ( pready_uart0                             ),
  .psuberr_uart0_i               ( psuberr_uart0                            ),
  .psel_spi0_o                   ( psel_spi0                                ),
  .penable_spi0_o                ( penable_spi0                             ),
  .paddr_spi0_o                  ( paddr_spi0                               ),
  .pwdata_spi0_o                 ( pwdata_spi0                              ),
  .pwrite_spi0_o                 ( pwrite_spi0                              ),
  .pstrb_spi0_o                  ( pstrb_spi0                               ),
  .prdata_spi0_i                 ( prdata_spi0                              ),
  .pready_spi0_i                 ( pready_spi0                              ),
  .psuberr_spi0_i                ( psuberr_spi0                             ),
  .psel_i2c0_o                   ( psel_i2c0                                ),
  .penable_i2c0_o                ( penable_i2c0                             ),
  .paddr_i2c0_o                  ( paddr_i2c0                               ),
  .pwdata_i2c0_o                 ( pwdata_i2c0                              ),
  .pwrite_i2c0_o                 ( pwrite_i2c0                              ),
  .pstrb_i2c0_o                  ( pstrb_i2c0                               ),
  .prdata_i2c0_i                 ( prdata_i2c0                              ),
  .pready_i2c0_i                 ( pready_i2c0                              ),
  .psuberr_i2c0_i                ( psuberr_i2c0                             ),
  .psel_gpio0_o                  ( psel_gpio0                               ),
  .penable_gpio0_o               ( penable_gpio0                            ),
  .paddr_gpio0_o                 ( paddr_gpio0                              ),
  .pwdata_gpio0_o                ( pwdata_gpio0                             ),
  .pwrite_gpio0_o                ( pwrite_gpio0                             ),
  .pstrb_gpio0_o                 ( pstrb_gpio0                              ),
  .prdata_gpio0_i                ( prdata_gpio0                             ),
  .pready_gpio0_i                ( pready_gpio0                             ),
  .psuberr_gpio0_i               ( psuberr_gpio0                            ),
  .psel_gpio1_o                  ( psel_gpio1                               ),
  .penable_gpio1_o               ( penable_gpio1                            ),
  .paddr_gpio1_o                 ( paddr_gpio1                              ),
  .pwdata_gpio1_o                ( pwdata_gpio1                             ),
  .pwrite_gpio1_o                ( pwrite_gpio1                             ),
  .pstrb_gpio1_o                 ( pstrb_gpio1                              ),
  .prdata_gpio1_i                ( prdata_gpio1                             ),
  .pready_gpio1_i                ( pready_gpio1                             ),
  .psuberr_gpio1_i               ( psuberr_gpio1                            )
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
assign penable_m_apb_o = penable_m_apb;
assign paddr_m_apb_o = paddr_m_apb;
assign pwdata_m_apb_o = pwdata_m_apb;
assign pwrite_m_apb_o = pwrite_m_apb;
assign pstrb_m_apb_o = pstrb_m_apb;
assign psel_mmreg_o = psel_mmreg;
assign penable_mmreg_o = penable_mmreg;
assign paddr_mmreg_o = paddr_mmreg;
assign pwdata_mmreg_o = pwdata_mmreg;
assign pwrite_mmreg_o = pwrite_mmreg;
assign prdata_mmreg = prdata_mmreg_i;
assign pready_mmreg = pready_mmreg_i;
assign psuberr_mmreg = psuberr_mmreg_i;
assign psel_intc_o = psel_intc;
assign penable_intc_o = penable_intc;
assign paddr_intc_o = paddr_intc;
assign pwdata_intc_o = pwdata_intc;
assign pwrite_intc_o = pwrite_intc;
assign prdata_intc = prdata_intc_i;
assign pready_intc = pready_intc_i;
assign psuberr_intc = psuberr_intc_i;
assign psel_tmr0_o = psel_tmr0;
assign penable_tmr0_o = penable_tmr0;
assign paddr_tmr0_o = paddr_tmr0;
assign pwdata_tmr0_o = pwdata_tmr0;
assign pwrite_tmr0_o = pwrite_tmr0;
assign prdata_tmr0 = prdata_tmr0_i;
assign pready_tmr0 = pready_tmr0_i;
assign psuberr_tmr0 = psuberr_tmr0_i;
assign psel_tmr1_o = psel_tmr1;
assign penable_tmr1_o = penable_tmr1;
assign paddr_tmr1_o = paddr_tmr1;
assign pwdata_tmr1_o = pwdata_tmr1;
assign pwrite_tmr1_o = pwrite_tmr1;
assign prdata_tmr1 = prdata_tmr1_i;
assign pready_tmr1 = pready_tmr1_i;
assign psuberr_tmr1 = psuberr_tmr1_i;
assign psel_dma0_o = psel_dma0;
assign penable_dma0_o = penable_dma0;
assign paddr_dma0_o = paddr_dma0;
assign pwdata_dma0_o = pwdata_dma0;
assign pwrite_dma0_o = pwrite_dma0;
assign prdata_dma0 = prdata_dma0_i;
assign pready_dma0 = pready_dma0_i;
assign psuberr_dma0 = psuberr_dma0_i;
assign psel_jtag_o = psel_jtag;
assign penable_jtag_o = penable_jtag;
assign paddr_jtag_o = paddr_jtag;
assign pwdata_jtag_o = pwdata_jtag;
assign pwrite_jtag_o = pwrite_jtag;
assign prdata_jtag = prdata_jtag_i;
assign pready_jtag = pready_jtag_i;
assign psuberr_jtag = psuberr_jtag_i;
assign psel_uart0_o = psel_uart0;
assign penable_uart0_o = penable_uart0;
assign paddr_uart0_o = paddr_uart0;
assign pwdata_uart0_o = pwdata_uart0;
assign pwrite_uart0_o = pwrite_uart0;
assign prdata_uart0 = prdata_uart0_i;
assign pready_uart0 = pready_uart0_i;
assign psuberr_uart0 = psuberr_uart0_i;
assign psel_spi0_o = psel_spi0;
assign penable_spi0_o = penable_spi0;
assign paddr_spi0_o = paddr_spi0;
assign pwdata_spi0_o = pwdata_spi0;
assign pwrite_spi0_o = pwrite_spi0;
assign prdata_spi0 = prdata_spi0_i;
assign pready_spi0 = pready_spi0_i;
assign psuberr_spi0 = psuberr_spi0_i;
assign psel_i2c0_o = psel_i2c0;
assign penable_i2c0_o = penable_i2c0;
assign paddr_i2c0_o = paddr_i2c0;
assign pwdata_i2c0_o = pwdata_i2c0;
assign pwrite_i2c0_o = pwrite_i2c0;
assign prdata_i2c0 = prdata_i2c0_i;
assign pready_i2c0 = pready_i2c0_i;
assign psuberr_i2c0 = psuberr_i2c0_i;
assign psel_gpio0_o = psel_gpio0;
assign penable_gpio0_o = penable_gpio0;
assign paddr_gpio0_o = paddr_gpio0;
assign pwdata_gpio0_o = pwdata_gpio0;
assign pwrite_gpio0_o = pwrite_gpio0;
assign prdata_gpio0 = prdata_gpio0_i;
assign pready_gpio0 = pready_gpio0_i;
assign psuberr_gpio0 = psuberr_gpio0_i;
assign psel_gpio1_o = psel_gpio1;
assign penable_gpio1_o = penable_gpio1;
assign paddr_gpio1_o = paddr_gpio1;
assign pwdata_gpio1_o = pwdata_gpio1;
assign pwrite_gpio1_o = pwrite_gpio1;
assign prdata_gpio1 = prdata_gpio1_i;
assign pready_gpio1 = pready_gpio1_i;
assign psuberr_gpio1 = psuberr_gpio1_i;

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

