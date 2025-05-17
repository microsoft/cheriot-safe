// Copyright (C) Microsoft Corporation. All rights reserved.


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvIp_cheri_core0 Definition
// ==================================================
module msftDvIp_cheri_core0 #(
    parameter DATA_WIDTH = 33
  ) (
  input                                      clk_i,
  input                                      rstn_i,
  output                                     IROM_EN_o,
  output [31:0]                              IROM_ADDR_o,
  output                                     IROM_IS_CAP_o,
  input  [DATA_WIDTH-1:0]                    IROM_RDATA_i,
  input                                      IROM_READY_i,
  input                                      IROM_ERROR_i,
  output                                     IRAM_EN_o,
  output [31:0]                              IRAM_ADDR_o,
  output [DATA_WIDTH-1:0]                    IRAM_WDATA_o,
  output                                     IRAM_WE_o,
  output [3:0]                               IRAM_BE_o,
  output                                     IRAM_IS_CAP_o,
  input  [DATA_WIDTH-1:0]                    IRAM_RDATA_i,
  input                                      IRAM_READY_i,
  input                                      IRAM_ERROR_i,
  output                                     DRAM_EN_o,
  output [31:0]                              DRAM_ADDR_o,
  output [DATA_WIDTH-1:0]                    DRAM_WDATA_o,
  output                                     DRAM_WE_o,
  output [3:0]                               DRAM_BE_o,
  output                                     DRAM_IS_CAP_o,
  input  [DATA_WIDTH-1:0]                    DRAM_RDATA_i,
  input                                      DRAM_READY_i,
  input                                      DRAM_ERROR_i,
  output                                     TCDEV_EN_o,
  output [31:0]                              TCDEV_ADDR_o,
  output [31:0]                              TCDEV_WDATA_o,
  output                                     TCDEV_WE_o,
  output [3:0]                               TCDEV_BE_o,
  input  [31:0]                              TCDEV_RDATA_i,
  input                                      TCDEV_READY_i,
  input  [127:0]                             mmreg_corein_i,
  output [63:0]                              mmreg_coreout_o,
  input                                      irq_software_i,
  input                                      irq_timer_i,
  input                                      irq_external_i,
  output                                     tsmap_cs_o,
  output [15:0]                              tsmap_addr_o,
  input  [31:0]                              tsmap_rdata_i,
  output [4-1:0]                             arid_cpu_m_o,
  output [32-1:0]                            araddr_cpu_m_o,
  output [8-1:0]                             arlen_cpu_m_o,
  output [12-1:0]                            aruser_cpu_m_o,
  output [3:0]                               arregion_cpu_m_o,
  output [2:0]                               arsize_cpu_m_o,
  output [1:0]                               arburst_cpu_m_o,
  output [3:0]                               arcache_cpu_m_o,
  output [1:0]                               arlock_cpu_m_o,
  output [2:0]                               arprot_cpu_m_o,
  output [3:0]                               arqos_cpu_m_o,
  output                                     arvalid_cpu_m_o,
  input                                      arready_cpu_m_i,
  input  [4-1:0]                             rid_cpu_m_i,
  input  [32-1:0]                            rdata_cpu_m_i,
  input                                      rlast_cpu_m_i,
  input  [1:0]                               rresp_cpu_m_i,
  input                                      rvalid_cpu_m_i,
  output                                     rready_cpu_m_o,
  output [4-1:0]                             awid_cpu_m_o,
  output [32-1:0]                            awaddr_cpu_m_o,
  output [8-1:0]                             awlen_cpu_m_o,
  output [12-1:0]                            awuser_cpu_m_o,
  output [3:0]                               awregion_cpu_m_o,
  output [2:0]                               awsize_cpu_m_o,
  output [1:0]                               awburst_cpu_m_o,
  output [3:0]                               awcache_cpu_m_o,
  output [1:0]                               awlock_cpu_m_o,
  output [2:0]                               awprot_cpu_m_o,
  output [3:0]                               awqos_cpu_m_o,
  output                                     awvalid_cpu_m_o,
  input                                      awready_cpu_m_i,
  output [4-1:0]                             wid_cpu_m_o,
  output [32-1:0]                            wdata_cpu_m_o,
  output                                     wlast_cpu_m_o,
  output [4-1:0]                             wstrb_cpu_m_o,
  output                                     wvalid_cpu_m_o,
  input                                      wready_cpu_m_i,
  input  [4-1:0]                             bid_cpu_m_i,
  input  [1:0]                               bresp_cpu_m_i,
  input                                      bvalid_cpu_m_i,
  output                                     bready_cpu_m_o,
  input                                      TRSTn_i,
  input                                      TCK_i,
  input                                      TMS_i,
  input                                      TDI_i,
  output                                     TDO_o,
  output                                     TDOoen_o,
  input                                      irq_periph_i
);

// ==================================================
// Internal Wire Signals
// ==================================================
wire                                     clk;
wire                                     rstn;
wire                                     IROM_EN;
wire [31:0]                              IROM_ADDR;
wire                                     IROM_IS_CAP;
wire [DATA_WIDTH-1:0]                    IROM_RDATA;
wire                                     IROM_READY;
wire                                     IROM_ERROR;
wire                                     IRAM_EN;
wire [31:0]                              IRAM_ADDR;
wire [DATA_WIDTH-1:0]                    IRAM_WDATA;
wire                                     IRAM_WE;
wire [3:0]                               IRAM_BE;
wire                                     IRAM_IS_CAP;
wire [DATA_WIDTH-1:0]                    IRAM_RDATA;
wire                                     IRAM_READY;
wire                                     IRAM_ERROR;
wire                                     DRAM_EN;
wire [31:0]                              DRAM_ADDR;
wire                                     DRAM_IS_CAP;
wire [DATA_WIDTH-1:0]                    DRAM_WDATA;
wire                                     DRAM_WE;
wire [3:0]                               DRAM_BE;
wire [DATA_WIDTH-1:0]                    DRAM_RDATA;
wire                                     DRAM_READY;
wire                                     DRAM_ERROR;
wire                                     TCDEV_EN;
wire [31:0]                              TCDEV_ADDR;
wire [31:0]                              TCDEV_WDATA;
wire                                     TCDEV_WE;
wire [3:0]                               TCDEV_BE;
wire [31:0]                              TCDEV_RDATA;
wire                                     TCDEV_READY;
wire [127:0]                             mmreg_corein;
wire [63:0]                              mmreg_coreout;
wire                                     irq_software;
wire                                     irq_timer;
wire                                     irq_external;
wire                                     tsmap_cs;
wire [15:0]                              tsmap_addr;
wire [31:0]                              tsmap_rdata;
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
wire [4-1:0]                             wstrb_cpu_m;
wire                                     wvalid_cpu_m;
wire                                     wready_cpu_m;
wire [4-1:0]                             bid_cpu_m;
wire [1:0]                               bresp_cpu_m;
wire                                     bvalid_cpu_m;
wire                                     bready_cpu_m;
wire                                     TRSTn;
wire                                     TCK;
wire                                     TMS;
wire                                     TDI;
wire                                     TDO;
wire                                     TDOoen;
wire                                     irq_periph;

// ==================================================
// Pre Code Insertion
// ==================================================

// ==================================================
// Instance msftDvIp_cheri_core_wrapper wire definitions
// ==================================================
wire                                     instr_req;
wire                                     instr_gnt;
wire                                     instr_rvalid;
wire [31:0]                              instr_addr;
wire [31:0]                              instr_rdata;
wire                                     data_req;
wire                                     data_gnt;
wire                                     data_rvalid;
wire                                     data_we;
wire [3:0]                               data_be;
wire                                     data_is_cap;
wire [31:0]                              data_addr;
wire [DATA_WIDTH-1:0]                    data_wdata;
wire [6:0]                               data_wdata_intg;
wire [DATA_WIDTH-1:0]                    data_rdata;
wire                                     scramble_req;
wire                                     debug_req;
wire                                     double_fault_seen;
wire                                     alert_minor;
wire                                     alert_major_internal;
wire                                     alert_major_bus;
wire                                     core_sleep;

// ==================================================
// Instance msftDvIp_riscv_cheri_debug wire definitions
// ==================================================
wire                                     dbg_gnt;
wire                                     dbg_req;
wire [31:0]                              dbg_addr;
wire [DATA_WIDTH-1:0]                    dbg_wdata;
wire                                     dbg_we;
wire [3:0]                               dbg_be;
wire [DATA_WIDTH-1:0]                    dbg_rdata;
wire                                     dbg_rvalid;
wire                                     dbg_error;
wire                                     hartrst;
wire                                     DBGMEM_EN;
wire [31:0]                              DBGMEM_ADDR;
wire [DATA_WIDTH-1:0]                    DBGMEM_WDATA;
wire                                     DBGMEM_WE;
wire [3:0]                               DBGMEM_BE;
wire [DATA_WIDTH-1:0]                    DBGMEM_RDATA;
wire                                     DBGMEM_READY;
wire                                     DBGMEM_ERROR;

// ==================================================
// Instance msftDvIp_obimux3w0 wire definitions
// ==================================================
wire                                     data_error;
wire                                     instr_error;
wire [DATA_WIDTH-1:0]                    IROM_WDATA;
wire                                     IROM_WE;
wire [3:0]                               IROM_BE;

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_cheri_core_wrapper
// ==================================================
msftDvIp_cheri_core_wrapper #(
  .DmHaltAddr(32'h0000_0800),
  .DmExceptionAddr(32'h0000_0800),
  .DataWidth(DATA_WIDTH)
  ) msftDvIp_cheri_core_wrapper_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .test_en_i                     ( 1'b0                                     ),
  .cheri_pmode_i                 ( 1'b1                                     ),
  .cheri_tsafe_en_i              ( 1'b1                                     ),
  .hart_id_i                     ( 32'h0000_0000                            ),
  .boot_addr_i                   ( 32'h2000_0000                            ),
  .instr_req_o                   ( instr_req                                ),
  .instr_gnt_i                   ( instr_gnt                                ),
  .instr_rvalid_i                ( instr_rvalid                             ),
  .instr_addr_o                  ( instr_addr                               ),
  .instr_rdata_i                 ( instr_rdata                              ),
  .instr_rdata_intg_i            ( 7'h0                                     ),
  .instr_err_i                   ( 1'b0                                     ),
  .data_req_o                    ( data_req                                 ),
  .data_gnt_i                    ( data_gnt                                 ),
  .data_rvalid_i                 ( data_rvalid                              ),
  .data_we_o                     ( data_we                                  ),
  .data_be_o                     ( data_be                                  ),
  .data_is_cap_o                 ( data_is_cap                              ),
  .data_addr_o                   ( data_addr                                ),
  .data_wdata_o                  ( data_wdata                               ),
  .data_wdata_intg_o             ( data_wdata_intg                          ),
  .data_rdata_i                  ( data_rdata                               ),
  .data_rdata_intg_i             ( 7'h0                                     ),
  .data_err_i                    ( 1'b0                                     ),
  .tsmap_cs_o                    ( tsmap_cs                                 ),
  .tsmap_addr_o                  ( tsmap_addr                               ),
  .tsmap_rdata_i                 ( tsmap_rdata                              ),
  .mmreg_corein_i                ( mmreg_corein                             ),
  .mmreg_coreout_o               ( mmreg_coreout                            ),
  .irq_software_i                ( irq_software                             ),
  .irq_timer_i                   ( irq_timer                                ),
  .irq_external_i                ( irq_external                             ),
  .irq_fast_i                    ( 15'h0                                    ),
  .irq_nm_i                      ( 1'b0                                     ),
  .scramble_key_valid_i          ( 1'b0                                     ),
  .scramble_key_i                ( 128'h0                                   ),
  .scramble_nonce_i              ( 64'h0                                    ),
  .scramble_req_o                ( scramble_req                             ),
  .debug_req_i                   ( debug_req                                ),
  .double_fault_seen_o           ( double_fault_seen                        ),
  .fetch_enable_i                ( 4'hf                                     ),
  .alert_minor_o                 ( alert_minor                              ),
  .alert_major_internal_o        ( alert_major_internal                     ),
  .alert_major_bus_o             ( alert_major_bus                          ),
  .core_sleep_o                  ( core_sleep                               ),
  .scan_rst_ni                   ( 1'b0                                     )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_riscv_cheri_debug
// ==================================================
msftDvIp_riscv_cheri_debug #(
  .DATA_WIDTH(DATA_WIDTH)  //QQQ
  ) msftDvIp_riscv_cheri_debug_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .TRSTn_i                       ( TRSTn                                    ),
  .TCK_i                         ( TCK                                      ),
  .TMS_i                         ( TMS                                      ),
  .TDI_i                         ( TDI                                      ),
  .TDO_o                         ( TDO                                      ),
  .TDOoen_o                      ( TDOoen                                   ),
  .dbg_gnt_i                     ( dbg_gnt                                  ),
  .dbg_req_o                     ( dbg_req                                  ),
  .dbg_addr_o                    ( dbg_addr                                 ),
  .dbg_wdata_o                   ( dbg_wdata                                ),
  .dbg_we_o                      ( dbg_we                                   ),
  .dbg_be_o                      ( dbg_be                                   ),
  .dbg_rdata_i                   ( dbg_rdata                                ),
  .dbg_rvalid_i                  ( dbg_rvalid                               ),
  .dbg_error_i                   ( dbg_error                                ),
  .debug_req_o                   ( debug_req                                ),
  .hartrst_o                     ( hartrst                                  ),
  .DBGMEM_EN_i                   ( DBGMEM_EN                                ),
  .DBGMEM_ADDR_i                 ( DBGMEM_ADDR                              ),
  .DBGMEM_WDATA_i                ( DBGMEM_WDATA                             ),
  .DBGMEM_WE_i                   ( DBGMEM_WE                                ),
  .DBGMEM_BE_i                   ( DBGMEM_BE                                ),
  .DBGMEM_RDATA_o                ( DBGMEM_RDATA                             ),
  .DBGMEM_READY_o                ( DBGMEM_READY                             ),
  .DBGMEM_ERROR_o                ( DBGMEM_ERROR                             )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_obimux3w0
// ==================================================
msftDvIp_obimux3w0 #(
  .DataWidth(DATA_WIDTH)
  ) msftDvIp_obimux3w0_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .data_req_i                    ( data_req                                 ),
  .data_gnt_o                    ( data_gnt                                 ),
  .data_addr_i                   ( data_addr                                ),
  .data_be_i                     ( data_be                                  ),
  .data_is_cap_i                 ( data_is_cap                              ),
  .data_wdata_i                  ( data_wdata                               ),
  .data_we_i                     ( data_we                                  ),
  .data_rdata_o                  ( data_rdata                               ),
  .data_rvalid_o                 ( data_rvalid                              ),
  .data_error_o                  ( data_error                               ),
  .instr_req_i                   ( instr_req                                ),
  .instr_gnt_o                   ( instr_gnt                                ),
  .instr_addr_i                  ( instr_addr                               ),
  .instr_rdata_o                 ( instr_rdata                              ),
  .instr_rvalid_o                ( instr_rvalid                             ),
  .instr_error_o                 ( instr_error                              ),
  .dbg_req_i                     ( dbg_req                                  ),
  .dbg_gnt_o                     ( dbg_gnt                                  ),
  .dbg_addr_i                    ( dbg_addr                                 ),
  .dbg_be_i                      ( dbg_be                                   ),
  .dbg_wdata_i                   ( dbg_wdata                                ),
  .dbg_we_i                      ( dbg_we                                   ),
  .dbg_rdata_o                   ( dbg_rdata                                ),
  .dbg_rvalid_o                  ( dbg_rvalid                               ),
  .dbg_error_o                   ( dbg_error                                ),
  .DBGMEM_EN_o                   ( DBGMEM_EN                                ),
  .DBGMEM_ADDR_o                 ( DBGMEM_ADDR                              ),
  .DBGMEM_WDATA_o                ( DBGMEM_WDATA                             ),
  .DBGMEM_WE_o                   ( DBGMEM_WE                                ),
  .DBGMEM_BE_o                   ( DBGMEM_BE                                ),
  .DBGMEM_RDATA_i                ( DBGMEM_RDATA                             ),
  .DBGMEM_READY_i                ( DBGMEM_READY                             ),
  .DBGMEM_ERROR_i                ( DBGMEM_ERROR                             ),
  .TCDEV_EN_o                    ( TCDEV_EN                                 ),
  .TCDEV_ADDR_o                  ( TCDEV_ADDR                               ),
  .TCDEV_WDATA_o                 ( TCDEV_WDATA                              ),
  .TCDEV_WE_o                    ( TCDEV_WE                                 ),
  .TCDEV_BE_o                    ( TCDEV_BE                                 ),
  .TCDEV_RDATA_i                 ( TCDEV_RDATA                              ),
  .TCDEV_READY_i                 ( TCDEV_READY                              ),
  .TCDEV_ERROR_i                 ( 1'b0                                     ),
  .IROM_EN_o                     ( IROM_EN                                  ),
  .IROM_ADDR_o                   ( IROM_ADDR                                ),
  .IROM_IS_CAP_o                 ( IROM_IS_CAP                              ),
  .IROM_WDATA_o                  ( IROM_WDATA                               ),
  .IROM_WE_o                     ( IROM_WE                                  ),
  .IROM_BE_o                     ( IROM_BE                                  ),
  .IROM_RDATA_i                  ( IROM_RDATA                               ),
  .IROM_READY_i                  ( IROM_READY                               ),
  .IROM_ERROR_i                  ( IROM_ERROR                               ),
  .IRAM_EN_o                     ( IRAM_EN                                  ),
  .IRAM_ADDR_o                   ( IRAM_ADDR                                ),
  .IRAM_IS_CAP_o                 ( IRAM_IS_CAP                              ),
  .IRAM_WDATA_o                  ( IRAM_WDATA                               ),
  .IRAM_WE_o                     ( IRAM_WE                                  ),
  .IRAM_BE_o                     ( IRAM_BE                                  ),
  .IRAM_RDATA_i                  ( IRAM_RDATA                               ),
  .IRAM_READY_i                  ( IRAM_READY                               ),
  .IRAM_ERROR_i                  ( IRAM_ERROR                               ),
  .DRAM_EN_o                     ( DRAM_EN                                  ),
  .DRAM_ADDR_o                   ( DRAM_ADDR                                ),
  .DRAM_IS_CAP_o                 ( DRAM_IS_CAP                              ),
  .DRAM_WDATA_o                  ( DRAM_WDATA                               ),
  .DRAM_WE_o                     ( DRAM_WE                                  ),
  .DRAM_BE_o                     ( DRAM_BE                                  ),
  .DRAM_RDATA_i                  ( DRAM_RDATA                               ),
  .DRAM_READY_i                  ( DRAM_READY                               ),
  .DRAM_ERROR_i                  ( DRAM_ERROR                               ),
  .AWID_o                        ( awid_cpu_m                               ),
  .AWADDR_o                      ( awaddr_cpu_m                             ),
  .AWLEN_o                       ( awlen_cpu_m                              ),
  .AWSIZE_o                      ( awsize_cpu_m                             ),
  .AWBURST_o                     ( awburst_cpu_m                            ),
  .AWLOCK_o                      ( awlock_cpu_m                             ),
  .AWPROT_o                      ( awprot_cpu_m                             ),
  .AWCACHE_o                     ( awcache_cpu_m                            ),
  .AWUSER_o                      ( awuser_cpu_m                             ),
  .AWVALID_o                     ( awvalid_cpu_m                            ),
  .AWREADY_i                     ( awready_cpu_m                            ),
  .WDATA_o                       ( wdata_cpu_m                              ),
  .WSTRB_o                       ( wstrb_cpu_m                              ),
  .WLAST_o                       ( wlast_cpu_m                              ),
  .WVALID_o                      ( wvalid_cpu_m                             ),
  .WREADY_i                      ( wready_cpu_m                             ),
  .BID_i                         ( bid_cpu_m                                ),
  .BRESP_i                       ( bresp_cpu_m                              ),
  .BVALID_i                      ( bvalid_cpu_m                             ),
  .BREADY_o                      ( bready_cpu_m                             ),
  .ARID_o                        ( arid_cpu_m                               ),
  .ARADDR_o                      ( araddr_cpu_m                             ),
  .ARLEN_o                       ( arlen_cpu_m                              ),
  .ARSIZE_o                      ( arsize_cpu_m                             ),
  .ARBURST_o                     ( arburst_cpu_m                            ),
  .ARLOCK_o                      ( arlock_cpu_m                             ),
  .ARPROT_o                      ( arprot_cpu_m                             ),
  .ARCACHE_o                     ( arcache_cpu_m                            ),
  .ARUSER_o                      ( aruser_cpu_m                             ),
  .ARVALID_o                     ( arvalid_cpu_m                            ),
  .ARREADY_i                     ( arready_cpu_m                            ),
  .RID_i                         ( rid_cpu_m                                ),
  .RDATA_i                       ( rdata_cpu_m                              ),
  .RLAST_i                       ( rlast_cpu_m                              ),
  .RRESP_i                       ( rresp_cpu_m                              ),
  .RVALID_i                      ( rvalid_cpu_m                             ),
  .RREADY_o                      ( rready_cpu_m                             )
);


// ==================================================
//  Connect IO Pins
// ==================================================
assign clk = clk_i;
assign rstn = rstn_i;
assign IROM_EN_o = IROM_EN;
assign IROM_ADDR_o = IROM_ADDR;
assign IROM_IS_CAP_o = IROM_IS_CAP;
assign IROM_RDATA = IROM_RDATA_i;
assign IROM_READY = IROM_READY_i;
assign IROM_ERROR = IROM_ERROR_i;
assign IRAM_EN_o = IRAM_EN;
assign IRAM_ADDR_o = IRAM_ADDR;
assign IRAM_WDATA_o = IRAM_WDATA;
assign IRAM_WE_o = IRAM_WE;
assign IRAM_BE_o = IRAM_BE;
assign IRAM_IS_CAP_o = IRAM_IS_CAP;
assign IRAM_RDATA = IRAM_RDATA_i;
assign IRAM_READY = IRAM_READY_i;
assign IRAM_ERROR = IRAM_ERROR_i;
assign DRAM_EN_o = DRAM_EN;
assign DRAM_ADDR_o = DRAM_ADDR;
assign DRAM_IS_CAP_o = DRAM_IS_CAP;
assign DRAM_WDATA_o = DRAM_WDATA;
assign DRAM_WE_o = DRAM_WE;
assign DRAM_BE_o = DRAM_BE;
assign DRAM_RDATA = DRAM_RDATA_i;
assign DRAM_READY = DRAM_READY_i;
assign DRAM_ERROR = DRAM_ERROR_i;
assign TCDEV_EN_o = TCDEV_EN;
assign TCDEV_ADDR_o = TCDEV_ADDR;
assign TCDEV_WDATA_o = TCDEV_WDATA;
assign TCDEV_WE_o = TCDEV_WE;
assign TCDEV_BE_o = TCDEV_BE;
assign TCDEV_RDATA = TCDEV_RDATA_i;
assign TCDEV_READY = TCDEV_READY_i;
assign mmreg_corein = mmreg_corein_i;
assign mmreg_coreout_o = mmreg_coreout;
assign irq_software = irq_software_i;
assign irq_timer = irq_timer_i;
assign irq_external = irq_external_i;
assign tsmap_cs_o = tsmap_cs;
assign tsmap_addr_o = tsmap_addr;
assign tsmap_rdata = tsmap_rdata_i;
assign arid_cpu_m_o = arid_cpu_m;
assign araddr_cpu_m_o = araddr_cpu_m;
assign arlen_cpu_m_o = arlen_cpu_m;
assign aruser_cpu_m_o = aruser_cpu_m;
assign arregion_cpu_m_o = arregion_cpu_m;
assign arsize_cpu_m_o = arsize_cpu_m;
assign arburst_cpu_m_o = arburst_cpu_m;
assign arcache_cpu_m_o = arcache_cpu_m;
assign arlock_cpu_m_o = arlock_cpu_m;
assign arprot_cpu_m_o = arprot_cpu_m;
assign arqos_cpu_m_o = arqos_cpu_m;
assign arvalid_cpu_m_o = arvalid_cpu_m;
assign arready_cpu_m = arready_cpu_m_i;
assign rid_cpu_m = rid_cpu_m_i;
assign rdata_cpu_m = rdata_cpu_m_i;
assign rlast_cpu_m = rlast_cpu_m_i;
assign rresp_cpu_m = rresp_cpu_m_i;
assign rvalid_cpu_m = rvalid_cpu_m_i;
assign rready_cpu_m_o = rready_cpu_m;
assign awid_cpu_m_o = awid_cpu_m;
assign awaddr_cpu_m_o = awaddr_cpu_m;
assign awlen_cpu_m_o = awlen_cpu_m;
assign awuser_cpu_m_o = awuser_cpu_m;
assign awregion_cpu_m_o = awregion_cpu_m;
assign awsize_cpu_m_o = awsize_cpu_m;
assign awburst_cpu_m_o = awburst_cpu_m;
assign awcache_cpu_m_o = awcache_cpu_m;
assign awlock_cpu_m_o = awlock_cpu_m;
assign awprot_cpu_m_o = awprot_cpu_m;
assign awqos_cpu_m_o = awqos_cpu_m;
assign awvalid_cpu_m_o = awvalid_cpu_m;
assign awready_cpu_m = awready_cpu_m_i;
assign wid_cpu_m_o = wid_cpu_m;
assign wdata_cpu_m_o = wdata_cpu_m;
assign wlast_cpu_m_o = wlast_cpu_m;
assign wstrb_cpu_m_o = wstrb_cpu_m;
assign wvalid_cpu_m_o = wvalid_cpu_m;
assign wready_cpu_m = wready_cpu_m_i;
assign bid_cpu_m = bid_cpu_m_i;
assign bresp_cpu_m = bresp_cpu_m_i;
assign bvalid_cpu_m = bvalid_cpu_m_i;
assign bready_cpu_m_o = bready_cpu_m;
assign TRSTn = TRSTn_i;
assign TCK = TCK_i;
assign TMS = TMS_i;
assign TDI = TDI_i;
assign TDO_o = TDO;
assign TDOoen_o = TDOoen;
assign irq_periph = irq_periph_i;

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

