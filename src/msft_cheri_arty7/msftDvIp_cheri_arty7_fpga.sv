// Copyright (C) Microsoft Corporation. All rights reserved.


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvIp_cheri_arty7_fpga Definition
// ==================================================
module msftDvIp_cheri_arty7_fpga (
  input                                      board_clk_i,
  input                                      board_rstn_i,
  input                                      ssel0_i,
  input                                      sck0_i,
  input                                      mosi0_i,
  output                                     miso0_o,
  input                                      TRSTn_i,
  input                                      TCK_i,
  input                                      TMS_i,
  input                                      TDI_i,
  inout                                      TDO_io,
  output                                     alive_o,
  output                                     TRSTn_mux_o,
  output                                     txd_dvp_o,
  input                                      rxd_dvp_i,
  inout                                      i2c0_scl_io,
  inout                                      i2c0_sda_io,
  output                                     i2c0_scl_pu_en_o,
  output                                     i2c0_sda_pu_en_o,
  inout  [31:0]                              gpio0_io,
  inout  [7:0]                               PMODA_io,
  inout  [7:0]                               PMODB_io,
  inout  [7:0]                               PMODC_io,
  inout  [7:0]                               PMODD_io,
  input                                      eth_tx_clk_i,
  input                                      eth_rx_clk_i,
  input                                      eth_crs_i,
  input                                      eth_dv_i,
  input  [3:0]                               eth_rx_data_i,
  input                                      eth_col_i,
  input                                      eth_rx_er_i,
  output                                     eth_rst_n_o,
  output                                     eth_tx_en_o,
  output [3:0]                               eth_tx_data_o,
  inout                                      eth_mdio_io,
  output                                     eth_mdc_o,
  output                                     eth_ref_clk_o
);

// ==================================================
// Internal Wire Signals
// ==================================================
wire                                     board_clk;
wire                                     board_rstn;
wire                                     ssel0;
wire                                     sck0;
wire                                     mosi0;
wire                                     miso0;
wire                                     TRSTn;
wire                                     TCK;
wire                                     TMS;
wire                                     TDI;
wire                                     TDO;
wire                                     alive;
wire                                     TRSTn_mux;
wire                                     txd_dvp;
wire                                     rxd_dvp;
wire                                     i2c0_scl;
wire                                     i2c0_sda;
wire                                     i2c0_scl_pu_en;
wire                                     i2c0_sda_pu_en;
wire [31:0]                              gpio0;
wire [7:0]                               PMODA;
wire [7:0]                               PMODB;
wire [7:0]                               PMODC;
wire [7:0]                               PMODD;

// ==================================================
// Pre Code Insertion
// ==================================================

// ==================================================
// Instance msftDvIp_mmcm_arty7_0 wire definitions
// ==================================================
wire                                     sysclk;
wire                                     clk200Mhz;

// ==================================================
// Instance msftDvIp_led_alive wire definitions
// ==================================================
wire                                     rstn;

// ==================================================
// Instance msftDvIp_cheri0_subsystem wire definitions
// ==================================================
wire                                     TCK_mux;
wire                                     TMS_mux;
wire                                     TDI_dvp;
wire                                     TDO_dvp;
wire                                     TDOoen_dvp;
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
wire                                     pclk_dbg;
wire                                     prstn_dbg;
wire                                     psel_sysdbg;
wire                                     penable_bkd;
wire [31:0]                              paddr_bkd;
wire [47:0]                              pwdata_bkd;
wire                                     pwrite_bkd;
wire [47:0]                              prdata_sysdbg;
wire                                     pready_sysdbg;
wire                                     psuberr_sysdbg;
wire                                     i2c0_scl_oe;
wire                                     i2c0_sda_oe;
wire                                     i2c0_scl_in;
wire                                     i2c0_sda_in;

// ==================================================
// Instance external_ram wire definitions
// ==================================================

// ==================================================
// Instance msftDvDebug_globals wire definitions
// ==================================================
wire                                     psel_com;
wire                                     penable_com;
wire [31:0]                              paddr_com;
wire [47:0]                              pwdata_com;
wire                                     pwrite_com;
wire [47:0]                              prdata_com;
wire                                     pready_com;
wire                                     pslverr_com;
wire                                     rstn_dbg;
wire                                     pwrn_dbg;
wire [31:0]                              gpio_out;
wire [31:0]                              gpio_in;

// ==================================================
// Instance msftDvDbug_apb_mux wire definitions
// ==================================================
wire                                     psel_dbg;
wire                                     penable_dbg;
wire [32-1:0]                            paddr_dbg;
wire [48-1:0]                            pwdata_dbg;
wire                                     pwrite_dbg;
wire [(48/8)-1:0]                        pstrb_dbg;
wire [48-1:0]                            prdata_dbg;
wire                                     pready_dbg;
wire                                     psuberr_dbg;
wire [(48/8)-1:0]                        pstrb_bkd;
wire [(48/8)-1:0]                        pstrb_com;
wire                                     psuberr_com;
wire                                     penable_sysdbg;
wire [32-1:0]                            paddr_sysdbg;
wire [48-1:0]                            pwdata_sysdbg;
wire                                     pwrite_sysdbg;
wire [(48/8)-1:0]                        pstrb_sysdbg;

// ==================================================
// Instance msftDvDebug_v1 wire definitions
// ==================================================
wire                                     TDI_dbg;
wire                                     TDO_dbg;
wire                                     TDOen;
wire                                     miso_oen_dbg;
wire                                     scl_dbg;
wire                                     scl_oen_dbg;
wire                                     sda_dbg;
wire                                     sda_oen_dbg;

wire          phy_crs;
wire          phy_dv;
wire  [3:0]   phy_rx_data;
wire          phy_col;
wire          phy_rx_er;
wire          phy_rst_n;
wire          phy_tx_en;
wire  [3:0]   phy_tx_data;
wire          phy_mdio_in;
wire          phy_mdio_out;
wire          phy_mdio_t;
wire          phy_mdc;

wire          clk_25m;
wire          eth_irq;

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================
assign rstn = board_rstn;

// ==================================================
// Instance msftDvIp_mmcm_arty7_0
// ==================================================
msftDvIp_mmcm_arty7_0 msftDvIp_mmcm_arty7_0_i (
  .sysClk_i                      ( board_clk                                ),
  .clk20Mhz_o                    ( sysclk                                   ),
  .clk200Mhz_o                   ( clk200Mhz                                ),
  .RESETn_i                      ( board_rstn                               )
);

// ethernet 25MHz refclk generation
msftDvIp_mmcm_arty7_1 msftDvIp_mmcm_arty7_1_i (
  .sysClk_i                      ( board_clk                                ),
  .clk25Mhz_o                    ( clk_25m                                  ),
  .RESETn_i                      ( board_rstn                               )
);

// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_led_alive
// ==================================================
msftDvIp_led_alive msftDvIp_led_alive_i (
  .clk_i                         ( clk200Mhz                                ),
  .rstn_i                        ( rstn                                     ),
  .alive_o                       ( alive                                    )
);


// ==================================================
//  Inst Pre Code 
// ==================================================
assign TRSTn_mux = (jtag_mux_sel) ? TRSTn_d  : TRSTn;
assign TCK_mux   = (jtag_mux_sel) ? TCK_d    : TCK;
assign TMS_mux   = (jtag_mux_sel) ? TMS_d    : TMS;
assign TDI_mux   = (jtag_mux_sel) ? TDO_d    : TDI;
assign TDI_dbg   = TDI_mux;
assign TDI_dvp   = TDO_dbg;
assign TDO       = TDO_dvp;
assign TDI_d     = TDO_dvp;

// ==================================================
// Instance msftDvIp_cheri0_subsystem
// ==================================================
msftDvIp_cheri0_subsystem #(
  .IROM_INIT_FILE("firmware/cpu0_irom.vhx"),
  .IRAM_INIT_FILE("firmware/cpu0_iram.vhx"),
  .IROM_DEPTH('h4000),
  .IRAM_DEPTH('h10000),
  .DRAM_DEPTH('h4000)
  ) msftDvIp_cheri0_subsystem_i (
  .clk_i                         ( sysclk                                   ),
  .rstn_i                        ( rstn                                     ),
  .TRSTn_i                       ( TRSTn_mux                                ),
  .TCK_i                         ( TCK_mux                                  ),
  .TMS_i                         ( TMS_mux                                  ),
  .TDI_i                         ( TDI_dvp                                  ),
  .TDO_o                         ( TDO_dvp                                  ),
  .TDOoen_o                      ( TDOoen_dvp                               ),
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
  .eth_irq_i                     ( eth_irq),
  .txd_dvp_o                     ( txd_dvp                                  ),
  .rxd_dvp_i                     ( rxd_dvp                                  ),
  .out0_o                        ( out0                                     ),
  .out1_o                        ( out1                                     ),
  .out2_o                        ( out2                                     ),
  .in0_i                         ( in0                                      ),
  .dbg_gp_out_o                  ( dbg_gp_out                               ),
  .dbg_gp_in_i                   ( dbg_gp_in                                ),
  .TCK_d_o                       ( TCK_d                                    ),
  .TMS_d_o                       ( TMS_d                                    ),
  .TDO_d_o                       ( TDO_d                                    ),
  .TDOoen_d_o                    ( TDOoen_d                                 ),
  .TDI_d_i                       ( TDI_d                                    ),
  .TRSTn_d_o                     ( TRSTn_d                                  ),
  .jtag_ext_cg_o                 ( jtag_ext_cg                              ),
  .jtag_mux_sel_o                ( jtag_mux_sel                             ),
  .irq_ext_i                     ( irq_ext                                  ),
  .gpio0_in_i                    ( gpio0_in                                 ),
  .gpio0_out_o                   ( gpio0_out                                ),
  .gpio0_oen_o                   ( gpio0_oen                                ),
  .gpio1_in_i                    ( gpio1_in                                 ),
  .gpio1_out_o                   ( gpio1_out                                ),
  .gpio1_oen_o                   ( gpio1_oen                                ),
  .pclk_bkd_i                    ( pclk_dbg                                 ),
  .prstn_bkd_i                   ( prstn_dbg                                ),
  .psel_bkd_i                    ( psel_sysdbg                              ),
  .penable_bkd_i                 ( penable_bkd                              ),
  .paddr_bkd_i                   ( paddr_bkd                                ),
  .pwdata_bkd_i                  ( pwdata_bkd                               ),
  .pwrite_bkd_i                  ( pwrite_bkd                               ),
  .prdata_bkd_o                  ( prdata_sysdbg                            ),
  .pready_bkd_o                  ( pready_sysdbg                            ),
  .psuberr_bkd_o                 ( psuberr_sysdbg                           ),
  .i2c0_scl_oe                   ( i2c0_scl_oe                              ),
  .i2c0_sda_oe                   ( i2c0_sda_oe                              ),
  .i2c0_scl_in                   ( i2c0_scl_in                              ),
  .i2c0_sda_in                   ( i2c0_sda_in                              ),
  .i2c0_scl_pu_en                ( i2c0_scl_pu_en                           ),
  .i2c0_sda_pu_en                ( i2c0_sda_pu_en                           )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance external_ram
// ==================================================
// msftDvIp_axi_mem_bit_write #(
//  .AXI_ADDR_WIDTH(64),
//  .AXI_DATA_WIDTH(64),
//  .AXI_ID_WIDTH(5),
//  .AXI_LEN_WIDTH(8),
//  .AXI_LOCK_WIDTH(2),
//  .MEM_SIZE('h100)
//  ) external_ram_i (
//  .s_axi_clk                     ( sysclk                                   ),
//  .s_axi_rst_n                   ( rstn                                     ),
//  .s_axi_awid                    ( awid_dmb_m                               ),
//  .s_axi_awaddr                  ( awaddr_dmb_m                             ),
//  .s_axi_awlen                   ( awlen_dmb_m                              ),
//  .s_axi_awsize                  ( awsize_dmb_m                             ),
//  .s_axi_awburst                 ( awburst_dmb_m                            ),
//  .s_axi_awlock                  ( awlock_dmb_m                             ),
//  .s_axi_awcache                 ( awcache_dmb_m                            ),
//  .s_axi_awprot                  ( awprot_dmb_m                             ),
//  .s_axi_awqos                   ( awqos_dmb_m                              ),
//  .s_axi_awvalid                 ( awvalid_dmb_m                            ),
//  .s_axi_awready                 ( awready_dmb_m                            ),
//  .s_axi_wdata                   ( wdata_dmb_m                              ),
//  .s_axi_wstrb                   ( wstrb_dmb_m                              ),
//  .s_axi_wlast                   ( wlast_dmb_m                              ),
//  .s_axi_wvalid                  ( wvalid_dmb_m                             ),
//  .s_axi_wready                  ( wready_dmb_m                             ),
//  .s_axi_bready                  ( bready_dmb_m                             ),
//  .s_axi_bid                     ( bid_dmb_m                                ),
//  .s_axi_bresp                   ( bresp_dmb_m                              ),
//  .s_axi_bvalid                  ( bvalid_dmb_m                             ),
//  .s_axi_arid                    ( arid_dmb_m                               ),
//  .s_axi_araddr                  ( araddr_dmb_m                             ),
//  .s_axi_arlen                   ( arlen_dmb_m                              ),
//  .s_axi_arsize                  ( arsize_dmb_m                             ),
//  .s_axi_arburst                 ( arburst_dmb_m                            ),
//  .s_axi_arlock                  ( arlock_dmb_m                             ),
//  .s_axi_arcache                 ( arcache_dmb_m                            ),
//  .s_axi_arprot                  ( arprot_dmb_m                             ),
//  .s_axi_arqos                   ( arqos_dmb_m                              ),
//  .s_axi_arvalid                 ( arvalid_dmb_m                            ),
//  .s_axi_arready                 ( arready_dmb_m                            ),
//  .s_axi_rready                  ( rready_dmb_m                             ),
//  .s_axi_rid                     ( rid_dmb_m                                ),
//  .s_axi_rdata                   ( rdata_dmb_m                              ),
//  .s_axi_rresp                   ( rresp_dmb_m                              ),
//  .s_axi_rlast                   ( rlast_dmb_m                              ),
//  .s_axi_rvalid                  ( rvalid_dmb_m                             )
//);

// ==================================================
// Instance axi_etherlite 
// ==================================================
  axi_ethernetlite_csafe0 eth_mac_i (
  .s_axi_aclk                    ( sysclk        ),
  .s_axi_aresetn                 ( rstn          ),
  .ip2intc_irpt                  ( eth_irq),
  .s_axi_awaddr                  ( awaddr_dmb_m  ),
  .s_axi_awvalid                 ( awvalid_dmb_m ),
  .s_axi_awready                 ( awready_dmb_m ),
  .s_axi_wdata                   ( wdata_dmb_m   ),
  .s_axi_wstrb                   ( wstrb_dmb_m   ),
  .s_axi_wvalid                  ( wvalid_dmb_m  ),
  .s_axi_wready                  ( wready_dmb_m  ),
  .s_axi_bready                  ( bready_dmb_m  ),
  .s_axi_bresp                   ( bresp_dmb_m   ),
  .s_axi_bvalid                  ( bvalid_dmb_m  ),
  .s_axi_araddr                  ( araddr_dmb_m  ),
  .s_axi_arvalid                 ( arvalid_dmb_m ),
  .s_axi_arready                 ( arready_dmb_m ),
  .s_axi_rready                  ( rready_dmb_m  ),
  .s_axi_rdata                   ( rdata_dmb_m   ),
  .s_axi_rresp                   ( rresp_dmb_m   ),
  .s_axi_rvalid                  ( rvalid_dmb_m  ),
  .phy_tx_clk                    ( phy_tx_clk    ),
  .phy_rx_clk                    ( phy_rx_clk    ),
  .phy_crs                       ( phy_crs       ),
  .phy_dv                        ( phy_dv        ),
  .phy_rx_data                   ( phy_rx_data   ),
  .phy_col                       ( phy_col       ),
  .phy_rx_er                     ( phy_rx_er     ),
  .phy_rst_n                     ( phy_rst_n     ),
  .phy_tx_en                     ( phy_tx_en     ),
  .phy_tx_data                   ( phy_tx_data   ),
  .phy_mdio_i                    ( phy_mdio_in   ),
  .phy_mdio_o                    ( phy_mdio_out  ),                  
  .phy_mdio_t                    ( phy_mdio_t    ),
  .phy_mdc                       ( phy_mdc       )
);                                 
                                   
//   phy_tx_clk : IN STD_LOGIC;
//   phy_rx_clk : IN STD_LOGIC;
//   phy_crs : IN STD_LOGIC;
//   phy_dv : IN STD_LOGIC;
//   phy_rx_data : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
//   phy_col : IN STD_LOGIC;
//   phy_rx_er : IN STD_LOGIC;
//   phy_rst_n : OUT STD_LOGIC;
//   phy_tx_en : OUT STD_LOGIC;
//   phy_tx_data : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
//   phy_mdio_i : IN STD_LOGIC;
//   phy_mdio_o : OUT STD_LOGIC;
//   phy_mdio_t : OUT STD_LOGIC;
//   phy_mdc : OUT STD_LOGIC

// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvDebug_globals
// ==================================================
msftDvDebug_globals #(
  .PART_NUM(16'h100),
  .CHANGE_LIST(32'hc9b54_124),
  .CAPABILITY_0(32'ha55a5aa5),
  .CAPABILITY_1(32'h5aa5a55a)
  ) msftDvDebug_globals_i (
  .clk_i                         ( sysclk                                   ),
  .rstn_i                        ( board_rstn                               ),
  .psel_com_i                    ( psel_com                                 ),
  .penable_com_i                 ( penable_com                              ),
  .paddr_com_i                   ( paddr_com                                ),
  .pwdata_com_i                  ( pwdata_com                               ),
  .pwrite_com_i                  ( pwrite_com                               ),
  .prdata_com_o                  ( prdata_com                               ),
  .pready_com_o                  ( pready_com                               ),
  .pslverr_com_o                 ( pslverr_com                              ),
  .rstn_dbg_o                    ( rstn_dbg                                 ),
  .pwrn_dbg_o                    ( pwrn_dbg                                 ),
  .gpio_out_o                    ( gpio_out                                 ),
  .gpio_in_i                     ( gpio_in                                  )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvDbug_apb_mux
// ==================================================
msftDvDbug_apb_mux #(
  .APB_DATA_WIDTH(48)
  ) msftDvDbug_apb_mux_i (
  .psel_dbg_i                    ( psel_dbg                                 ),
  .penable_dbg_i                 ( penable_dbg                              ),
  .paddr_dbg_i                   ( paddr_dbg                                ),
  .pwdata_dbg_i                  ( pwdata_dbg                               ),
  .pwrite_dbg_i                  ( pwrite_dbg                               ),
  .pstrb_dbg_i                   ( pstrb_dbg                                ),
  .prdata_dbg_o                  ( prdata_dbg                               ),
  .pready_dbg_o                  ( pready_dbg                               ),
  .psuberr_dbg_o                 ( psuberr_dbg                              ),
  .penable_bkd_o                 ( penable_bkd                              ),
  .paddr_bkd_o                   ( paddr_bkd                                ),
  .pwdata_bkd_o                  ( pwdata_bkd                               ),
  .pwrite_bkd_o                  ( pwrite_bkd                               ),
  .pstrb_bkd_o                   ( pstrb_bkd                                ),
  .psel_com_o                    ( psel_com                                 ),
  .penable_com_o                 ( penable_com                              ),
  .paddr_com_o                   ( paddr_com                                ),
  .pwdata_com_o                  ( pwdata_com                               ),
  .pwrite_com_o                  ( pwrite_com                               ),
  .pstrb_com_o                   ( pstrb_com                                ),
  .prdata_com_i                  ( prdata_com                               ),
  .pready_com_i                  ( pready_com                               ),
  .psuberr_com_i                 ( psuberr_com                              ),
  .psel_sysdbg_o                 ( psel_sysdbg                              ),
  .penable_sysdbg_o              ( penable_sysdbg                           ),
  .paddr_sysdbg_o                ( paddr_sysdbg                             ),
  .pwdata_sysdbg_o               ( pwdata_sysdbg                            ),
  .pwrite_sysdbg_o               ( pwrite_sysdbg                            ),
  .pstrb_sysdbg_o                ( pstrb_sysdbg                             ),
  .prdata_sysdbg_i               ( prdata_sysdbg                            ),
  .pready_sysdbg_i               ( pready_sysdbg                            ),
  .psuberr_sysdbg_i              ( psuberr_sysdbg                           )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvDebug_v1
// ==================================================
msftDvDebug_v1 msftDvDebug_v1_i (
  .clk_i                         ( sysclk                                   ),
  .por_rstn_i                    ( board_rstn                               ),
  .pclk_dbg_o                    ( pclk_dbg                                 ),
  .prstn_dbg_o                   ( prstn_dbg                                ),
  .disable_jtag_i                ( 1'b0                                     ),
  .TCK_i                         ( TCK_mux                                  ),
  .TMS_i                         ( TMS_mux                                  ),
  .TDI_i                         ( TDI_dbg                                  ),
  .TRSTn_i                       ( TRSTn_mux                                ),
  .TDO_o                         ( TDO_dbg                                  ),
  .TDOen_o                       ( TDOen                                    ),
  .sclk_dbg_i                    ( sck0                                     ),
  .mosi_dbg_i                    ( mosi0                                    ),
  .miso_dbg_o                    ( miso0                                    ),
  .ssl_dbg_i                     ( ssel0                                    ),
  .miso_oen_dbg_o                ( miso_oen_dbg                             ),
  .psel_dbg_o                    ( psel_dbg                                 ),
  .penable_dbg_o                 ( penable_dbg                              ),
  .paddr_dbg_o                   ( paddr_dbg                                ),
  .prdata_dbg_i                  ( prdata_dbg                               ),
  .pwdata_dbg_o                  ( pwdata_dbg                               ),
  .pwrite_dbg_o                  ( pwrite_dbg                               ),
  .pready_dbg_i                  ( pready_dbg                               ),
  .psuberr_dbg_i                 ( psuberr_dbg                              ),
  .scl_dbg_i                     ( scl_dbg                                  ),
  .scl_oen_dbg_o                 ( scl_oen_dbg                              ),
  .sda_dbg_i                     ( sda_dbg                                  ),
  .sda_oen_dbg_o                 ( sda_oen_dbg                              )
);


// ==================================================
//  Connect IO Pins
// ==================================================
IBUF  xPAD_board_clk_inst                                           (.I(         board_clk_i),  .O(           board_clk) );
IBUF  xPAD_board_rstn_inst                                          (.I(        board_rstn_i),  .O(          board_rstn) );
IBUF  xPAD_ssel0_inst                                               (.I(             ssel0_i),  .O(               ssel0) );
IBUF  xPAD_sck0_inst                                                (.I(              sck0_i),  .O(                sck0) );
IBUF  xPAD_mosi0_inst                                               (.I(             mosi0_i),  .O(               mosi0) );
OBUF  xPAD_miso0_inst                                               (.O(             miso0_o),  .I(               miso0) );
IBUF  xPAD_TRSTn_inst                                               (.I(             TRSTn_i),  .O(               TRSTn) );
IBUF  xPAD_TCK_inst                                                 (.I(               TCK_i),  .O(                 TCK) );
IBUF  xPAD_TMS_inst                                                 (.I(               TMS_i),  .O(                 TMS) );
IBUF  xPAD_TDI_inst                                                 (.I(               TDI_i),  .O(                 TDI) );
IOBUF xPAD_TDO_inst                                                 (.IO(              TDO_io), .I(                 TDO), .O(              TDO_in), .T(         ~TDOoen_dvp) );
OBUF  xPAD_alive_inst                                               (.O(             alive_o),  .I(               alive) );
OBUF  xPAD_TRSTn_mux_inst                                           (.O(         TRSTn_mux_o),  .I(           TRSTn_mux) );
OBUF  xPAD_txd_dvp_inst                                             (.O(           txd_dvp_o),  .I(             txd_dvp) );
IBUF  xPAD_rxd_dvp_inst                                             (.I(           rxd_dvp_i),  .O(             rxd_dvp) );
IOBUF xPAD_i2c0_scl_inst                                            (.IO(         i2c0_scl_io), .I(                1'b0), .O(         i2c0_scl_in), .T(         i2c0_scl_oe) );
IOBUF xPAD_i2c0_sda_inst                                            (.IO(         i2c0_sda_io), .I(                1'b0), .O(         i2c0_sda_in), .T(         i2c0_sda_oe) );
OBUF  xPAD_i2c0_scl_pu_en_inst                                      (.O(    i2c0_scl_pu_en_o),  .I(      i2c0_scl_pu_en) );
OBUF  xPAD_i2c0_sda_pu_en_inst                                      (.O(    i2c0_sda_pu_en_o),  .I(      i2c0_sda_pu_en) );
IOBUF xPAD_gpio0_inst                [31:0]                         (.IO(            gpio0_io), .I(     gpio0_out[31:0]), .O(      gpio0_in[31:0]), .T(    ~gpio0_oen[31:0]) );
IOBUF xPAD_PMODA_inst                [7:0]                          (.IO(            PMODA_io), .I(      gpio1_out[7:0]), .O(       gpio1_in[7:0]), .T(     ~gpio1_oen[7:0]) );
IOBUF xPAD_PMODB_inst                [7:0]                          (.IO(            PMODB_io), .I(     gpio1_out[15:8]), .O(      gpio1_in[15:8]), .T(    ~gpio1_oen[15:8]) );
IOBUF xPAD_PMODC_inst                [7:0]                          (.IO(            PMODC_io), .I(    gpio1_out[23:16]), .O(     gpio1_in[23:16]), .T(   ~gpio1_oen[23:16]) );
IOBUF xPAD_PMODD_inst                [7:0]                          (.IO(            PMODD_io), .I(    gpio1_out[31:24]), .O(     gpio1_in[31:24]), .T(   ~gpio1_oen[31:24]) );

IBUF  xPAD_eth_tx_clk_inst                                          (.I(         eth_tx_clk_i), .O(        phy_tx_clk) );
IBUF  xPAD_eth_rx_clk_inst                                          (.I(         eth_rx_clk_i), .O(        phy_rx_clk) );
IBUF  xPAD_eth_crs_inst                                             (.I(            eth_crs_i), .O(           phy_crs) );
IBUF  xPAD_eth_dv_inst                                              (.I(             eth_dv_i), .O(            phy_dv) );
IBUF  xPAD_eth_rx_data_inst          [3:0]                          (.I(        eth_rx_data_i), .O(       phy_rx_data) );
IBUF  xPAD_eth_col_inst                                             (.I(            eth_col_i), .O(           phy_col) );
IBUF  xPAD_eth_rx_er_inst                                           (.I(          eth_rx_er_i), .O(         phy_rx_er) );

OBUF  xPAD_eth_rst_n_inst                                           (.O(          eth_rst_n_o), .I(         phy_rst_n) );
OBUF  xPAD_eth_tx_en_inst                                           (.O(          eth_tx_en_o), .I(         phy_tx_en) );
OBUF  xPAD_eth_tx_data_inst          [3:0]                          (.O(        eth_tx_data_o), .I(       phy_tx_data) );
OBUF  xPAD_eth_mdc_inst                                             (.O(            eth_mdc_o), .I(           phy_mdc) );
OBUF  xPAD_eth_ref_clk_inst                                         (.O(        eth_ref_clk_o), .I(           clk_25m) );

IOBUF xPAD_eth_mdio_inst                                            (.IO(         eth_mdio_io), .I(    phy_mdio_out),     .O(     phy_mdio_in), .T(  phy_mdio_t ));

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

