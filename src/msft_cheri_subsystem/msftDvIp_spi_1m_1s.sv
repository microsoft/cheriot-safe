
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

// Copyright (C) Microsoft Corporation. All rights reserved.


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvIp_spi_1m_1s Definition
// ==================================================
module msftDvIp_spi_1m_1s (
  input                                      pclk_i,
  input                                      prstn_i,
  input                                      psel_i,
  input                                      penable_i,
  input  [31:0]                              paddr_i,
  input  [31:0]                              pwdata_i,
  input                                      pwrite_i,
  output [31:0]                              prdata_o,
  output                                     pready_o,
  output                                     psuberr_o,
  output                                     spien_o,
  output [3:0]                               spioen_o,
  output                                     sclk_o,
  output [5:0]                               ssel_o,
  output [3:0]                               mosi_o,
  input  [3:0]                               miso_i,
  input                                      sclk_sub_i,
  input                                      ssel_sub_i,
  input  [3:0]                               mosi_sub_i,
  output [3:0]                               miso_sub_o,
  output                                     misoen_o
);

// ==================================================
// Internal Wire Signals
// ==================================================
wire                                     pclk;
wire                                     prstn;
wire                                     psel;
wire                                     penable;
wire [31:0]                              paddr;
wire [31:0]                              pwdata;
wire                                     pwrite;
wire [31:0]                              prdata;
wire                                     pready;
wire                                     psuberr;
wire                                     spien;
wire [3:0]                               spioen;
wire                                     sclk;
wire [5:0]                               ssel;
wire [3:0]                               mosi;
wire [3:0]                               miso;
wire                                     sclk_sub;
wire                                     ssel_sub;
wire [3:0]                               mosi_sub;
wire [3:0]                               miso_sub;
wire                                     misoen;

// ==================================================
// Pre Code Insertion
// ==================================================

// ==================================================
// Instance msftDvIp_spi_mgr wire definitions
// ==================================================
wire                                     psel_mgr;
wire [7:0]                               paddr_mgr;
wire [31:0]                              prdata_mgr;
wire                                     pready_mgr;
wire                                     psuberr_mgr;
wire                                     irq;

// ==================================================
// Instance msftDvIp_spi_sub wire definitions
// ==================================================
wire                                     psel_sub;
wire [7:0]                               paddr_sub;
wire [31:0]                              prdata_sub;
wire                                     pready_sub;
wire                                     psuberr_sub;

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================
assign prdata  = prdata_mgr  | prdata_sub;
assign pready  = pready_mgr  | pready_sub;
assign psuberr = psuberr_mgr | psuberr_sub;
assign psel_mgr = psel & paddr[7:5] == 3'h0;
assign psel_sub = psel & paddr[7:5] == 3'h1;
assign paddr_mgr = {3'h0, paddr[4:0]};
assign paddr_sub = {3'h0, paddr[4:0]};

// ==================================================
// Instance msftDvIp_spi_mgr
// ==================================================
msftDvIp_spi_mgr msftDvIp_spi_mgr_i (
  .pclk_i                        ( pclk                                     ),
  .prstn_i                       ( prstn                                    ),
  .psel_i                        ( psel_mgr                                 ),
  .penable_i                     ( penable                                  ),
  .paddr_i                       ( paddr_mgr                                ),
  .pwdata_i                      ( pwdata                                   ),
  .pwrite_i                      ( pwrite                                   ),
  .prdata_o                      ( prdata_mgr                               ),
  .pready_o                      ( pready_mgr                               ),
  .psuberr_o                     ( psuberr_mgr                              ),
  .spien_o                       ( spien                                    ),
  .spioen_o                      ( spioen                                   ),
  .ssel_o                        ( ssel                                     ),
  .sclk_o                        ( sclk                                     ),
  .mosi_o                        ( mosi                                     ),
  .miso_i                        ( miso                                     ),
  .irq                           ( irq                                      )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_spi_sub
// ==================================================
msftDvIp_spi_sub msftDvIp_spi_sub_i (
  .pclk_i                        ( pclk                                     ),
  .prstn_i                       ( prstn                                    ),
  .psel_i                        ( psel_sub                                 ),
  .penable_i                     ( penable                                  ),
  .paddr_i                       ( paddr_sub                                ),
  .pwdata_i                      ( pwdata                                   ),
  .pwrite_i                      ( pwrite                                   ),
  .prdata_o                      ( prdata_sub                               ),
  .pready_o                      ( pready_sub                               ),
  .psuberr_o                     ( psuberr_sub                              ),
  .ssel_i                        ( ssel_sub                                 ),
  .sclk_i                        ( sclk_sub                                 ),
  .mosi_i                        ( mosi                                     ),
  .miso_o                        ( miso_sub                                 ),
  .misoen_o                      ( misoen                                   ),
  .irq                           ( irq                                      )
);


// ==================================================
//  Connect IO Pins
// ==================================================
assign pclk = pclk_i;
assign prstn = prstn_i;
assign psel = psel_i;
assign penable = penable_i;
assign paddr = paddr_i;
assign pwdata = pwdata_i;
assign pwrite = pwrite_i;
assign prdata_o = prdata;
assign pready_o = pready;
assign psuberr_o = psuberr;
assign spien_o = spien;
assign spioen_o = spioen;
assign sclk_o = sclk;
assign ssel_o = ssel;
assign mosi_o = mosi;
assign miso = miso_i;
assign sclk_sub = sclk_sub_i;
assign ssel_sub = ssel_sub_i;
assign mosi_sub = mosi_sub_i;
assign miso_sub_o = miso_sub;
assign misoen_o = misoen;

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

