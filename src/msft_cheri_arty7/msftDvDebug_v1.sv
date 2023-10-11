// Copyright (C) Microsoft Corporation. All rights reserved.


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvDebug_v1 Definition
// ==================================================
module msftDvDebug_v1 #(
    parameter AXI_ID_WIDTH = 4,
    parameter AXI_AWIDTH = 64,
    parameter AXI_DWIDTH = 64,
    parameter AXI_LEN = 8,
    parameter DVDBG_SWIDTH = 8
  ) (
  input                                      clk_i,
  input                                      por_rstn_i,
  output                                     pclk_dbg_o,
  output                                     prstn_dbg_o,
  input                                      disable_jtag_i,
  input                                      TCK_i,
  input                                      TMS_i,
  input                                      TDI_i,
  input                                      TRSTn_i,
  output                                     TDO_o,
  output                                     TDOen_o,
  input                                      sclk_dbg_i,
  input                                      mosi_dbg_i,
  output                                     miso_dbg_o,
  input                                      ssl_dbg_i,
  output                                     miso_oen_dbg_o,
  output                                     psel_dbg_o,
  output                                     penable_dbg_o,
  output [32-1:0]                            paddr_dbg_o,
  input  [48-1:0]                            prdata_dbg_i,
  output [48-1:0]                            pwdata_dbg_o,
  output                                     pwrite_dbg_o,
  input                                      pready_dbg_i,
  input                                      psuberr_dbg_i,
  input                                      scl_dbg_i,
  output                                     scl_oen_dbg_o,
  input                                      sda_dbg_i,
  output                                     sda_oen_dbg_o
);

// ==================================================
// Internal Wire Signals
// ==================================================
wire                                     clk;
wire                                     por_rstn;
wire                                     pclk_dbg;
wire                                     prstn_dbg;
wire                                     disable_jtag;
wire                                     TCK;
wire                                     TMS;
wire                                     TDI;
wire                                     TRSTn;
wire                                     TDO;
wire                                     TDOen;
wire                                     sclk_dbg;
wire                                     mosi_dbg;
wire                                     miso_dbg;
wire                                     ssl_dbg;
wire                                     miso_oen_dbg;
wire                                     psel_dbg;
wire                                     penable_dbg;
wire [32-1:0]                            paddr_dbg;
wire [48-1:0]                            prdata_dbg;
wire [48-1:0]                            pwdata_dbg;
wire                                     pwrite_dbg;
wire                                     pready_dbg;
wire                                     psuberr_dbg;
wire                                     scl_dbg;
wire                                     scl_oen_dbg;
wire                                     sda_dbg;
wire                                     sda_oen_dbg;

// ==================================================
// Pre Code Insertion
// ==================================================
import msftDvDebug_jtag2AxiApb_pkg::*;
assign pclk_dbg = clk;
assign prstn_dbg = por_rstn;

// ==================================================
// Instance msftDvDebug_apb_mgr_sm wire definitions
// ==================================================
wire                                     psel16_jtag;
wire                                     penable16_jtag;
wire [14:0]                              paddr16_jtag;
wire [15:0]                              pwdata16_jtag;
wire                                     pwrite16_jtag;
wire                                     psel32_jtag;
wire                                     penable32_jtag;
wire [31:0]                              paddr32_jtag;
wire [47:0]                              pwdata32_jtag;
wire                                     pwrite32_jtag;
wire [47:0]                              prdata32_jtag;
wire                                     pready32_jtag;
wire                                     psuberr32_jtag;
wire                                     sel_jtag;
wire [1:0]                               apb_req;
wire                                     apb_ack;
wire [APB_CMD_WIDTH-1:0]                 apb_cmd;
wire [APB_RESP_WIDTH-1:0]                apb_resp;

// ==================================================
// Instance msftDvDebug_jtag2AxiApb wire definitions
// ==================================================
wire [1:0]                               axi_req;
wire [AXI_CMD_WIDTH-1:0]                 axi_cmd;

// ==================================================
// Instance msftDvDebug_spiSlave wire definitions
// ==================================================
wire                                     psel16_spi;
wire                                     penable16_spi;
wire [14:0]                              paddr16_spi;
wire [15:0]                              pwdata16_spi;
wire                                     pwrite16_spi;
wire                                     psel32_spi;
wire                                     penable32_spi;
wire [31:0]                              paddr32_spi;
wire [47:0]                              pwdata32_spi;
wire                                     pwrite32_spi;
wire [47:0]                              prdata32_spi;
wire                                     pready32_spi;
wire                                     psuberr32_spi;

// ==================================================
// Instance msftDvDebug_i2c_sub wire definitions
// ==================================================
wire                                     psel32_i2c;
wire                                     penable32_i2c;
wire [31:0]                              paddr32_i2c;
wire [47:0]                              pwdata32_i2c;
wire                                     pwrite32_i2c;
wire [47:0]                              prdata32_i2c;
wire                                     pready32_i2c;
wire                                     psuberr32_i2c;
wire                                     psel16_i2c;
wire                                     penable16_i2c;
wire [14:0]                              paddr16_i2c;
wire [15:0]                              pwdata16_i2c;
wire                                     pwrite16_i2c;
wire                                     sel_i2c;

// ==================================================
// Instance msftDvDebug_apb_mux_32 wire definitions
// ==================================================

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvDebug_apb_mgr_sm
// ==================================================
msftDvDebug_apb_mgr_sm msftDvDebug_apb_mgr_sm_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( por_rstn                                 ),
  .psel16_jtag_o                 ( psel16_jtag                              ),
  .penable16_jtag_o              ( penable16_jtag                           ),
  .paddr16_jtag_o                ( paddr16_jtag                             ),
  .pwdata16_jtag_o               ( pwdata16_jtag                            ),
  .pwrite16_jtag_o               ( pwrite16_jtag                            ),
  .prdata16_jtag_i               ( 16'h0000                                 ),
  .pready16_jtag_i               ( 1'h0                                     ),
  .psuberr16_jtag_i              ( 1'h0                                     ),
  .psel32_jtag_o                 ( psel32_jtag                              ),
  .penable32_jtag_o              ( penable32_jtag                           ),
  .paddr32_jtag_o                ( paddr32_jtag                             ),
  .pwdata32_jtag_o               ( pwdata32_jtag                            ),
  .pwrite32_jtag_o               ( pwrite32_jtag                            ),
  .prdata32_jtag_i               ( prdata32_jtag                            ),
  .pready32_jtag_i               ( pready32_jtag                            ),
  .psuberr32_jtag_i              ( psuberr32_jtag                           ),
  .sel_jtag_o                    ( sel_jtag                                 ),
  .apb_req_i                     ( apb_req                                  ),
  .apb_ack_i                     ( apb_ack                                  ),
  .apb_cmd                       ( apb_cmd                                  ),
  .apb_resp                      ( apb_resp                                 )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvDebug_jtag2AxiApb
// ==================================================
msftDvDebug_jtag2AxiApb msftDvDebug_jtag2AxiApb_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( por_rstn                                 ),
  .disabled                      ( disable_jtag                             ),
  .TCK_i                         ( TCK                                      ),
  .TMS_i                         ( TMS                                      ),
  .TDI_i                         ( TDI                                      ),
  .TRSTn_i                       ( TRSTn                                    ),
  .TDO_o                         ( TDO                                      ),
  .TDOen_o                       ( TDOen                                    ),
  .axi_req_o                     ( axi_req                                  ),
  .axi_ack_i                     ( 1'h0                                     ),
  .axi_cmd_o                     ( axi_cmd                                  ),
  .axi_resp_i                    ( 67'h0                                    ),
  .apb_req_o                     ( apb_req                                  ),
  .apb_ack_i                     ( apb_ack                                  ),
  .apb_cmd_o                     ( apb_cmd                                  ),
  .apb_resp_i                    ( apb_resp                                 )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvDebug_spiSlave
// ==================================================
msftDvDebug_spiSlave msftDvDebug_spiSlave_i (
  .sclk                          ( sclk_dbg                                 ),
  .mosi                          ( mosi_dbg                                 ),
  .miso                          ( miso_dbg                                 ),
  .ss0n                          ( ssl_dbg                                  ),
  .miso_oen                      ( miso_oen_dbg                             ),
  .clk                           ( clk                                      ),
  .rstn                          ( por_rstn                                 ),
  .psel16_spi                    ( psel16_spi                               ),
  .penable16_spi                 ( penable16_spi                            ),
  .paddr16_spi                   ( paddr16_spi                              ),
  .pwdata16_spi                  ( pwdata16_spi                             ),
  .pwrite16_spi                  ( pwrite16_spi                             ),
  .prdata16_spi                  ( 16'h0000                                 ),
  .pready16_spi                  ( 1'h0                                     ),
  .psuberr16_spi                 ( 1'h0                                     ),
  .psel32_spi                    ( psel32_spi                               ),
  .penable32_spi                 ( penable32_spi                            ),
  .paddr32_spi                   ( paddr32_spi                              ),
  .pwdata32_spi                  ( pwdata32_spi                             ),
  .pwrite32_spi                  ( pwrite32_spi                             ),
  .prdata32_spi                  ( prdata32_spi                             ),
  .pready32_spi                  ( pready32_spi                             ),
  .psuberr32_spi                 ( psuberr32_spi                            )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvDebug_i2c_sub
// ==================================================
msftDvDebug_i2c_sub msftDvDebug_i2c_sub_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( por_rstn                                 ),
  .scl_i                         ( scl_dbg                                  ),
  .scl_oen_o                     ( scl_oen_dbg                              ),
  .sda_i                         ( sda_dbg                                  ),
  .sda_oen_o                     ( sda_oen_dbg                              ),
  .psel32_i2c_o                  ( psel32_i2c                               ),
  .penable32_i2c_o               ( penable32_i2c                            ),
  .paddr32_i2c_o                 ( paddr32_i2c                              ),
  .pwdata32_i2c_o                ( pwdata32_i2c                             ),
  .pwrite32_i2c_o                ( pwrite32_i2c                             ),
  .prdata32_i2c_i                ( prdata32_i2c                             ),
  .pready32_i2c_i                ( pready32_i2c                             ),
  .psuberr32_i2c_i               ( psuberr32_i2c                            ),
  .psel16_i2c_o                  ( psel16_i2c                               ),
  .penable16_i2c_o               ( penable16_i2c                            ),
  .paddr16_i2c_o                 ( paddr16_i2c                              ),
  .pwdata16_i2c_o                ( pwdata16_i2c                             ),
  .pwrite16_i2c_o                ( pwrite16_i2c                             ),
  .prdata16_i2c_i                ( 16'h0000                                 ),
  .pready16_i2c_i                ( 1'h0                                     ),
  .psuberr16_i2c_i               ( 1'h0                                     ),
  .sel_i2c_o                     ( sel_i2c                                  )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvDebug_apb_mux_32
// ==================================================
msftDvDebug_apb_mux #(
  .DATA_WIDTH(48)
  ) msftDvDebug_apb_mux_32_i (
  .psel_out_o                    ( psel_dbg                                 ),
  .penable_out_o                 ( penable_dbg                              ),
  .paddr_out_o                   ( paddr_dbg                                ),
  .pwdata_out_o                  ( pwdata_dbg                               ),
  .pwrite_out_o                  ( pwrite_dbg                               ),
  .prdata_out_i                  ( prdata_dbg                               ),
  .pready_out_i                  ( pready_dbg                               ),
  .psuberr_out_i                 ( psuberr_dbg                              ),
  .psel_0_i                      ( psel32_spi                               ),
  .penable_0_i                   ( penable32_spi                            ),
  .paddr_0_i                     ( paddr32_spi                              ),
  .pwdata_0_i                    ( pwdata32_spi                             ),
  .pwrite_0_i                    ( pwrite32_spi                             ),
  .prdata_0_o                    ( prdata32_spi                             ),
  .pready_0_o                    ( pready32_spi                             ),
  .psuberr_0_o                   ( psuberr32_spi                            ),
  .psel_1_i                      ( psel32_i2c                               ),
  .penable_1_i                   ( penable32_i2c                            ),
  .paddr_1_i                     ( paddr32_i2c                              ),
  .pwdata_1_i                    ( pwdata32_i2c                             ),
  .pwrite_1_i                    ( pwrite32_i2c                             ),
  .prdata_1_o                    ( prdata32_i2c                             ),
  .pready_1_o                    ( pready32_i2c                             ),
  .psuberr_1_o                   ( psuberr32_i2c                            ),
  .psel_2_i                      ( psel32_jtag                              ),
  .penable_2_i                   ( penable32_jtag                           ),
  .paddr_2_i                     ( paddr32_jtag                             ),
  .pwdata_2_i                    ( pwdata32_jtag                            ),
  .pwrite_2_i                    ( pwrite32_jtag                            ),
  .prdata_2_o                    ( prdata32_jtag                            ),
  .pready_2_o                    ( pready32_jtag                            ),
  .psuberr_2_o                   ( psuberr32_jtag                           ),
  .sel_i                         ( {sel_jtag,sel_i2c}                       )
);


// ==================================================
//  Connect IO Pins
// ==================================================
assign clk = clk_i;
assign por_rstn = por_rstn_i;
assign pclk_dbg_o = pclk_dbg;
assign prstn_dbg_o = prstn_dbg;
assign disable_jtag = disable_jtag_i;
assign TCK = TCK_i;
assign TMS = TMS_i;
assign TDI = TDI_i;
assign TRSTn = TRSTn_i;
assign TDO_o = TDO;
assign TDOen_o = TDOen;
assign sclk_dbg = sclk_dbg_i;
assign mosi_dbg = mosi_dbg_i;
assign miso_dbg_o = miso_dbg;
assign ssl_dbg = ssl_dbg_i;
assign miso_oen_dbg_o = miso_oen_dbg;
assign psel_dbg_o = psel_dbg;
assign penable_dbg_o = penable_dbg;
assign paddr_dbg_o = paddr_dbg;
assign prdata_dbg = prdata_dbg_i;
assign pwdata_dbg_o = pwdata_dbg;
assign pwrite_dbg_o = pwrite_dbg;
assign pready_dbg = pready_dbg_i;
assign psuberr_dbg = psuberr_dbg_i;
assign scl_dbg = scl_dbg_i;
assign scl_oen_dbg_o = scl_oen_dbg;
assign sda_dbg = sda_dbg_i;
assign sda_oen_dbg_o = sda_oen_dbg;

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

