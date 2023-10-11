// Copyright (C) Microsoft Corporation. All rights reserved.


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvIp_i2c_1m_1s Definition
// ==================================================
module msftDvIp_i2c_1m_1s (
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
  output                                     scl_oen_o,
  output                                     sda_oen_o,
  input                                      scl_in_i,
  input                                      sda_in_i
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
wire                                     scl_oen;
wire                                     sda_oen;
wire                                     scl_in;
wire                                     sda_in;

// ==================================================
// Pre Code Insertion
// ==================================================

// ==================================================
// Instance msftDvIp_i2c_mgr wire definitions
// ==================================================
wire                                     psel_mgr;
wire [7:0]                               paddr_mgr;
wire [31:0]                              prdata_mgr;
wire                                     pready_mgr;
wire                                     psuberr_mgr;
wire                                     scl_oen_mgr;
wire                                     sda_oen_mgr;

// ==================================================
// Instance msftDvIp_i2c_sub wire definitions
// ==================================================
wire                                     psel_sub;
wire [7:0]                               paddr_sub;
wire [31:0]                              prdata_sub;
wire                                     pready_sub;
wire                                     psuberr_sub;
wire                                     scl_oen_sub;
wire                                     sda_oen_sub;
wire                                     irq;

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================
assign prdata  = prdata_mgr  | prdata_sub;
assign pready  = pready_mgr  | pready_sub;
assign psuberr = psuberr_mgr | psuberr_sub;
assign scl_oen = scl_oen_mgr & scl_oen_sub;
assign sda_oen = sda_oen_mgr & sda_oen_sub;
assign psel_mgr = psel & paddr[7:5] == 3'h0;
assign psel_sub = psel & paddr[7:5] == 3'h1;
assign paddr_mgr = {3'h0, paddr[4:0]};
assign paddr_sub = {3'h0, paddr[4:0]};

// ==================================================
// Instance msftDvIp_i2c_mgr
// ==================================================
msftDvIp_i2c_mgr msftDvIp_i2c_mgr_i (
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
  .scl_oen_o                     ( scl_oen_mgr                              ),
  .sda_oen_o                     ( sda_oen_mgr                              ),
  .scl_in_i                      ( scl_in                                   ),
  .sda_in_i                      ( sda_in                                   )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_i2c_sub
// ==================================================
msftDvIp_i2c_sub msftDvIp_i2c_sub_i (
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
  .scl_oen_o                     ( scl_oen_sub                              ),
  .sda_oen_o                     ( sda_oen_sub                              ),
  .scl_in_i                      ( scl_in                                   ),
  .sda_in_i                      ( sda_in                                   ),
  .irq_o                         ( irq                                      )
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
assign scl_oen_o = scl_oen;
assign sda_oen_o = sda_oen;
assign scl_in = scl_in_i;
assign sda_in = sda_in_i;

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

