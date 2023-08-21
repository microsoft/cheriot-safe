
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
// Module level_tb1 Definition
// ==================================================
module level_tb1 (
);

// ==================================================
// Internal Wire Signals
// ==================================================

// ==================================================
// Pre Code Insertion
// ==================================================
glbl glbl();

// ==================================================
// Instance msftDvIp_cheri_arty7_fpga wire definitions
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
// Instance msftDvTb_clock wire definitions
// ==================================================
wire                                     ctl_clk;

// ==================================================
// Instance msftDvTb_reset wire definitions
// ==================================================
wire                                     prstn;
wire                                     start_clk;
wire                                     mem_repair_done;
wire                                     run_stall;
wire                                     A0Bypass;

// ==================================================
// Instance msftDvTb_testend wire definitions
// ==================================================

// ==================================================
// Instance msftDvTb_uart_tx_mon wire definitions
// ==================================================
wire                                     txd;
wire                                     testEndUart0;
wire                                     testFailUart0;

// ==================================================
// Instance msftDvPkg_dpi_apb_bus wire definitions
// ==================================================
wire [15:0]                              pselbus;
wire                                     psel_apb;
wire                                     penable_apb;
wire [32-1:0]                            paddr_apb;
wire [32-1:0]                            pwdata_apb;
wire                                     pwrite_apb;
wire [32-1:0]                            prdata_apb;
wire                                     pready_apb;
wire                                     psuberr_apb;
wire                                     testEndApb;
wire                                     testFailApb;

// ==================================================
// Instance msftDvDebug_dpi_apb_mux wire definitions
// ==================================================
wire [(32/8)-1:0]                        pstrb_apb;
wire                                     penable_sub;
wire [32-1:0]                            paddr_sub;
wire [32-1:0]                            pwdata_sub;
wire                                     pwrite_sub;
wire [(32/8)-1:0]                        pstrb_sub;
wire                                     psel_jd;
wire                                     penable_jd;
wire [32-1:0]                            paddr_jd;
wire [32-1:0]                            pwdata_jd;
wire                                     pwrite_jd;
wire [(32/8)-1:0]                        pstrb_jd;
wire [32-1:0]                            prdata_jd;
wire                                     pready_jd;
wire                                     psuberr_jd;
wire                                     psel_emu;
wire                                     penable_emu;
wire [32-1:0]                            paddr_emu;
wire [32-1:0]                            pwdata_emu;
wire                                     pwrite_emu;
wire [(32/8)-1:0]                        pstrb_emu;
wire [32-1:0]                            prdata_emu;
wire                                     pready_emu;
wire                                     psuberr_emu;

// ==================================================
// Instance msftDvIp_jtag_driver wire definitions
// ==================================================
wire                                     TDOoen;
wire                                     jtag_ext_cg;
wire                                     jtag_mux_sel;

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================
assign ssel0 = 1'b0;
assign sck0  = 1'b0;
assign mosi0  = 1'b0;

// ==================================================
// Instance msftDvIp_cheri_arty7_fpga
// ==================================================
msftDvIp_cheri_arty7_fpga msftDvIp_cheri_arty7_fpga_i (
  .board_clk_i                   ( board_clk                                ),
  .board_rstn_i                  ( board_rstn                               ),
  .ssel0_i                       ( ssel0                                    ),
  .sck0_i                        ( sck0                                     ),
  .mosi0_i                       ( mosi0                                    ),
  .miso0_o                       ( miso0                                    ),
  .TRSTn_i                       ( TRSTn                                    ),
  .TCK_i                         ( TCK                                      ),
  .TMS_i                         ( TMS                                      ),
  .TDI_i                         ( TDI                                      ),
  .TDO_io                        ( TDO                                      ),
  .alive_o                       ( alive                                    ),
  .TRSTn_mux_o                   ( TRSTn_mux                                ),
  .txd_dvp_o                     ( txd_dvp                                  ),
  .rxd_dvp_i                     ( rxd_dvp                                  ),
  .i2c0_scl_io                   ( i2c0_scl                                 ),
  .i2c0_sda_io                   ( i2c0_sda                                 ),
  .i2c0_scl_pu_en_o              ( i2c0_scl_pu_en                           ),
  .i2c0_sda_pu_en_o              ( i2c0_sda_pu_en                           ),
  .gpio0_io                      ( gpio0                                    ),
  .PMODA_io                      ( PMODA                                    ),
  .PMODB_io                      ( PMODB                                    ),
  .PMODC_io                      ( PMODC                                    ),
  .PMODD_io                      ( PMODD                                    )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvTb_clock
// ==================================================
msftDvTb_clock #(
  .FREQUENCY(100000000)
  ) msftDvTb_clock_i (
  .clk_o                         ( board_clk                                ),
  .ctl_clk_o                     ( ctl_clk                                  ),
  .en_i                          ( 1'b0                                     )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvTb_reset
// ==================================================
msftDvTb_reset msftDvTb_reset_i (
  .clk_i                         ( board_clk                                ),
  .prstn_o                       ( prstn                                    ),
  .srstn_o                       ( board_rstn                               ),
  .start_clk_o                   ( start_clk                                ),
  .mem_repair_done_o             ( mem_repair_done                          ),
  .run_stall_o                   ( run_stall                                ),
  .A0Bypass_o                    ( A0Bypass                                 )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvTb_testend
// ==================================================
msftDvTb_testend #(
  .TEST_INPUTS(2),
  .TIMEOUT(100000000)
  ) msftDvTb_testend_i (
  .testEnd                       ( {testEndUart0,testEndApb}                ),
  .testFail                      ( {testFailUart0,testFailApb}              ),
  .clk                           ( board_clk                                )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvTb_uart_tx_mon
// ==================================================
msftDvTb_uart_tx_mon #(
  .DO_PRINT(1)
  ) msftDvTb_uart_tx_mon_i (
  .rstn_i                        ( board_rstn                               ),
  .rxd_i                         ( txd_dvp                                  ),
  .txd_o                         ( txd                                      ),
  .testDisabled_i                ( 1'b0                                     ),
  .testEnd_o                     ( testEndUart0                             ),
  .testFail_o                    ( testFailUart0                            )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvPkg_dpi_apb_bus
// ==================================================
msftDvPkg_dpi_apb_bus msftDvPkg_dpi_apb_bus_i (
  .pclk_i                        ( board_clk                                ),
  .prstn_i                       ( prstn                                    ),
  .pselbus_o                     ( pselbus                                  ),
  .psel_o                        ( psel_apb                                 ),
  .penable_o                     ( penable_apb                              ),
  .paddr_o                       ( paddr_apb                                ),
  .pwdata_o                      ( pwdata_apb                               ),
  .pwrite_o                      ( pwrite_apb                               ),
  .prdata_i                      ( prdata_apb                               ),
  .pready_i                      ( pready_apb                               ),
  .psuberr_i                     ( psuberr_apb                              ),
  .testEnd_o                     ( testEndApb                               ),
  .testFail_o                    ( testFailApb                              )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvDebug_dpi_apb_mux
// ==================================================
msftDvDebug_dpi_apb_mux msftDvDebug_dpi_apb_mux_i (
  .psel_apb_i                    ( psel_apb                                 ),
  .penable_apb_i                 ( penable_apb                              ),
  .paddr_apb_i                   ( paddr_apb                                ),
  .pwdata_apb_i                  ( pwdata_apb                               ),
  .pwrite_apb_i                  ( pwrite_apb                               ),
  .pstrb_apb_i                   ( pstrb_apb                                ),
  .prdata_apb_o                  ( prdata_apb                               ),
  .pready_apb_o                  ( pready_apb                               ),
  .psuberr_apb_o                 ( psuberr_apb                              ),
  .penable_sub_o                 ( penable_sub                              ),
  .paddr_sub_o                   ( paddr_sub                                ),
  .pwdata_sub_o                  ( pwdata_sub                               ),
  .pwrite_sub_o                  ( pwrite_sub                               ),
  .pstrb_sub_o                   ( pstrb_sub                                ),
  .psel_jd_o                     ( psel_jd                                  ),
  .penable_jd_o                  ( penable_jd                               ),
  .paddr_jd_o                    ( paddr_jd                                 ),
  .pwdata_jd_o                   ( pwdata_jd                                ),
  .pwrite_jd_o                   ( pwrite_jd                                ),
  .pstrb_jd_o                    ( pstrb_jd                                 ),
  .prdata_jd_i                   ( prdata_jd                                ),
  .pready_jd_i                   ( pready_jd                                ),
  .psuberr_jd_i                  ( psuberr_jd                               ),
  .psel_emu_o                    ( psel_emu                                 ),
  .penable_emu_o                 ( penable_emu                              ),
  .paddr_emu_o                   ( paddr_emu                                ),
  .pwdata_emu_o                  ( pwdata_emu                               ),
  .pwrite_emu_o                  ( pwrite_emu                               ),
  .pstrb_emu_o                   ( pstrb_emu                                ),
  .prdata_emu_i                  ( prdata_emu                               ),
  .pready_emu_i                  ( pready_emu                               ),
  .psuberr_emu_i                 ( psuberr_emu                              )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_jtag_driver
// ==================================================
msftDvIp_jtag_driver msftDvIp_jtag_driver_i (
  .pclk_i                        ( board_clk                                ),
  .prstn_i                       ( board_rstn                               ),
  .psel_i                        ( psel_jd                                  ),
  .penable_i                     ( penable_sub                              ),
  .paddr_i                       ( paddr_sub[7:0]                           ),
  .pwdata_i                      ( pwdata_sub                               ),
  .pwrite_i                      ( pwrite_sub                               ),
  .prdata_o                      ( prdata_jd                                ),
  .pready_o                      ( pready_jd                                ),
  .psuberr_o                     ( psuberr_jd                               ),
  .TCK_o                         ( TCK                                      ),
  .TMS_o                         ( TMS                                      ),
  .TDO_o                         ( TDI                                      ),
  .TDOoen_o                      ( TDOoen                                   ),
  .TDI_i                         ( TDO                                      ),
  .TRSTn_o                       ( TRSTn                                    ),
  .jtag_ext_cg_o                 ( jtag_ext_cg                              ),
  .jtag_mux_sel_o                ( jtag_mux_sel                             )
);


// ==================================================
//  Connect IO Pins
// ==================================================

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

