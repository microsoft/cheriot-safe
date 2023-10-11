// Copyright (C) Microsoft Corporation. All rights reserved.


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvIp_riscv_cheri_debug Definition
// ==================================================
module msftDvIp_riscv_cheri_debug #(
    parameter DATA_WIDTH = 33
  ) (
  input                                      clk_i,
  input                                      rstn_i,
  input                                      TRSTn_i,
  input                                      TCK_i,
  input                                      TMS_i,
  input                                      TDI_i,
  output                                     TDO_o,
  output                                     TDOoen_o,
  input                                      dbg_gnt_i,
  output                                     dbg_req_o,
  output [31:0]                              dbg_addr_o,
  output [DATA_WIDTH-1:0]                    dbg_wdata_o,
  output                                     dbg_we_o,
  output [3:0]                               dbg_be_o,
  input  [DATA_WIDTH-1:0]                    dbg_rdata_i,
  input                                      dbg_rvalid_i,
  input                                      dbg_error_i,
  output                                     debug_req_o,
  output                                     hartrst_o,
  input                                      DBGMEM_EN_i,
  input  [31:0]                              DBGMEM_ADDR_i,
  input  [DATA_WIDTH-1:0]                    DBGMEM_WDATA_i,
  input                                      DBGMEM_WE_i,
  input  [3:0]                               DBGMEM_BE_i,
  output [DATA_WIDTH-1:0]                    DBGMEM_RDATA_o,
  output                                     DBGMEM_READY_o,
  output                                     DBGMEM_ERROR_o
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
wire                                     dbg_gnt;
wire                                     dbg_req;
wire [31:0]                              dbg_addr;
wire [DATA_WIDTH-1:0]                    dbg_wdata;
wire                                     dbg_we;
wire [3:0]                               dbg_be;
wire [DATA_WIDTH-1:0]                    dbg_rdata;
wire                                     dbg_rvalid;
wire                                     dbg_error;
wire                                     debug_req;
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
// Pre Code Insertion
// ==================================================

// ==================================================
// Instance msftDvIp_riscv_cheri_dmibus wire definitions
// ==================================================
wire                                     psel_dmi;
wire                                     penable_dmi;
wire [7-1:0]                             paddr_dmi;
wire [33-1:0]                            pwdata_dmi;
wire                                     pwrite_dmi;
wire [33-1:0]                            prdata_dmi;
wire                                     pready_dmi;
wire                                     pslverr_dmi;

// ==================================================
// Instance msftDvIp_riscv_cheri_mem wire definitions
// ==================================================
wire                                     ROM_EN;
wire [11:0]                              ROM_ADDR;
wire [33-1:0]                            ROM_RDATA;
wire                                     ROM_READY;
wire                                     ROM_ERROR;
wire                                     dmactive;
wire                                     debug_req_ack;
wire                                     debug_resume;
wire                                     debug_resume_ack;
wire                                     halted;
wire                                     debug_transfer_pgmb;
wire                                     debug_transfer_scr;
wire                                     debug_transfer_csr;
wire                                     debug_transfer_reg;
wire                                     debug_transfer_ack;
wire                                     ac_en;
wire [3:0]                               ac_addr;
wire [33-1:0]                            ac_wdata;
wire                                     ac_write;
wire [33-1:0]                            ac_rdata;
wire                                     prog_buf_en;
wire [7:0]                               prog_buf_addr;
wire [31:0]                              prog_buf_rdata;
wire                                     prog_buf_ready;
wire                                     prog_buf_error;
wire                                     cap_wr_valid;
wire                                     cap_rd_valid;

// ==================================================
// Instance msftDvIp_riscv_cheri_debug_rom wire definitions
// ==================================================

// ==================================================
// Instance msftDvIp_riscv_cheri_debug_reg wire definitions
// ==================================================

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_riscv_cheri_dmibus
// ==================================================
msftDvIp_riscv_cheri_dmibus #(
  .IDCODE(32'h000004ab)
  ) msftDvIp_riscv_cheri_dmibus_i (
  .TCK_i                         ( TCK                                      ),
  .TMS_i                         ( TMS                                      ),
  .TDI_i                         ( TDI                                      ),
  .TRSTn_i                       ( TRSTn                                    ),
  .TDO_o                         ( TDO                                      ),
  .TDOoen_o                      ( TDOoen                                   ),
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .psel_dmi_o                    ( psel_dmi                                 ),
  .penable_dmi_o                 ( penable_dmi                              ),
  .paddr_dmi_o                   ( paddr_dmi                                ),
  .pwdata_dmi_o                  ( pwdata_dmi                               ),
  .pwrite_dmi_o                  ( pwrite_dmi                               ),
  .prdata_dmi_i                  ( prdata_dmi                               ),
  .pready_dmi_i                  ( pready_dmi                               ),
  .pslverr_dmi_i                 ( pslverr_dmi                              )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_riscv_cheri_mem
// ==================================================
msftDvIp_riscv_cheri_mem #(
  .DATA_WIDTH(DATA_WIDTH)
  ) msftDvIp_riscv_cheri_mem_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .DBGMEM_EN_i                   ( DBGMEM_EN                                ),
  .DBGMEM_ADDR_i                 ( DBGMEM_ADDR                              ),
  .DBGMEM_WDATA_i                ( DBGMEM_WDATA                             ),
  .DBGMEM_WE_i                   ( DBGMEM_WE                                ),
  .DBGMEM_BE_i                   ( DBGMEM_BE                                ),
  .DBGMEM_RDATA_o                ( DBGMEM_RDATA                             ),
  .DBGMEM_READY_o                ( DBGMEM_READY                             ),
  .DBGMEM_ERROR_o                ( DBGMEM_ERROR                             ),
  .ROM_EN_o                      ( ROM_EN                                   ),
  .ROM_ADDR_o                    ( ROM_ADDR                                 ),
  .ROM_RDATA_i                   ( ROM_RDATA                                ),
  .ROM_READY_i                   ( ROM_READY                                ),
  .ROM_ERROR_i                   ( ROM_ERROR                                ),
  .dmactive_i                    ( dmactive                                 ),
  .debug_req_ack_o               ( debug_req_ack                            ),
  .debug_resume_i                ( debug_resume                             ),
  .debug_resume_ack_o            ( debug_resume_ack                         ),
  .halted_o                      ( halted                                   ),
  .debug_transfer_pgmb_i         ( debug_transfer_pgmb                      ),
  .debug_transfer_scr_i          ( debug_transfer_scr                       ),
  .debug_transfer_csr_i          ( debug_transfer_csr                       ),
  .debug_transfer_reg_i          ( debug_transfer_reg                       ),
  .debug_transfer_ack_o          ( debug_transfer_ack                       ),
  .ac_en_i                       ( ac_en                                    ),
  .ac_addr_i                     ( ac_addr                                  ),
  .ac_wdata_i                    ( ac_wdata                                 ),
  .ac_write_i                    ( ac_write                                 ),
  .ac_rdata_o                    ( ac_rdata                                 ),
  .prog_buf_en_o                 ( prog_buf_en                              ),
  .prog_buf_addr_o               ( prog_buf_addr                            ),
  .prog_buf_rdata_i              ( prog_buf_rdata                           ),
  .prog_buf_ready_i              ( prog_buf_ready                           ),
  .prog_buf_error_i              ( prog_buf_error                           ),
  .cap_wr_valid_i                ( cap_wr_valid                             ),
  .cap_rd_valid_o                ( cap_rd_valid                             )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_riscv_cheri_debug_rom
// ==================================================
msftDvIp_riscv_cheri_debug_rom #(
  .DATA_WIDTH(DATA_WIDTH)
  ) msftDvIp_riscv_cheri_debug_rom_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .debug_mode_i                  ( debug_req                                ),
  .en_i                          ( ROM_EN                                   ),
  .addr_i                        ( ROM_ADDR                                 ),
  .rdata_o                       ( ROM_RDATA                                ),
  .ready_o                       ( ROM_READY                                ),
  .error_o                       ( ROM_ERROR                                )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_riscv_cheri_debug_reg
// ==================================================
msftDvIp_riscv_cheri_debug_reg #(
  .DATA_WIDTH(DATA_WIDTH)
  ) msftDvIp_riscv_cheri_debug_reg_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .hartrst_o                     ( hartrst                                  ),
  .psel_dmi_i                    ( psel_dmi                                 ),
  .penable_dmi_i                 ( penable_dmi                              ),
  .paddr_dmi_i                   ( paddr_dmi                                ),
  .pwdata_dmi_i                  ( pwdata_dmi                               ),
  .pwrite_dmi_i                  ( pwrite_dmi                               ),
  .prdata_dmi_o                  ( prdata_dmi                               ),
  .pready_dmi_o                  ( pready_dmi                               ),
  .pslverr_dmi_o                 ( pslverr_dmi                              ),
  .debug_req_o                   ( debug_req                                ),
  .debug_req_ack_i               ( debug_req_ack                            ),
  .debug_resume_o                ( debug_resume                             ),
  .debug_resume_ack_i            ( debug_resume_ack                         ),
  .debug_transfer_scr_o          ( debug_transfer_scr                       ),
  .debug_transfer_pgmb_o         ( debug_transfer_pgmb                      ),
  .debug_transfer_csr_o          ( debug_transfer_csr                       ),
  .debug_transfer_reg_o          ( debug_transfer_reg                       ),
  .debug_transfer_ack_i          ( debug_transfer_ack                       ),
  .dmactive_o                    ( dmactive                                 ),
  .halted_i                      ( halted                                   ),
  .prog_buf_en_i                 ( prog_buf_en                              ),
  .prog_buf_addr_i               ( prog_buf_addr                            ),
  .prog_buf_rdata_o              ( prog_buf_rdata                           ),
  .prog_buf_ready_o              ( prog_buf_ready                           ),
  .prog_buf_error_o              ( prog_buf_error                           ),
  .ac_en_o                       ( ac_en                                    ),
  .ac_addr_o                     ( ac_addr                                  ),
  .ac_wdata_o                    ( ac_wdata                                 ),
  .ac_write_o                    ( ac_write                                 ),
  .ac_rdata_i                    ( ac_rdata                                 ),
  .dbg_gnt_i                     ( dbg_gnt                                  ),
  .dbg_req_o                     ( dbg_req                                  ),
  .dbg_addr_o                    ( dbg_addr                                 ),
  .dbg_wdata_o                   ( dbg_wdata                                ),
  .dbg_we_o                      ( dbg_we                                   ),
  .dbg_be_o                      ( dbg_be                                   ),
  .dbg_rdata_i                   ( dbg_rdata                                ),
  .dbg_rvalid_i                  ( dbg_rvalid                               ),
  .dbg_error_i                   ( dbg_error                                ),
  .cap_wr_valid_o                ( cap_wr_valid                             ),
  .cap_rd_valid_i                ( cap_rd_valid                             )
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
assign dbg_gnt = dbg_gnt_i;
assign dbg_req_o = dbg_req;
assign dbg_addr_o = dbg_addr;
assign dbg_wdata_o = dbg_wdata;
assign dbg_we_o = dbg_we;
assign dbg_be_o = dbg_be;
assign dbg_rdata = dbg_rdata_i;
assign dbg_rvalid = dbg_rvalid_i;
assign dbg_error = dbg_error_i;
assign debug_req_o = debug_req;
assign hartrst_o = hartrst;
assign DBGMEM_EN = DBGMEM_EN_i;
assign DBGMEM_ADDR = DBGMEM_ADDR_i;
assign DBGMEM_WDATA = DBGMEM_WDATA_i;
assign DBGMEM_WE = DBGMEM_WE_i;
assign DBGMEM_BE = DBGMEM_BE_i;
assign DBGMEM_RDATA_o = DBGMEM_RDATA;
assign DBGMEM_READY_o = DBGMEM_READY;
assign DBGMEM_ERROR_o = DBGMEM_ERROR;

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

