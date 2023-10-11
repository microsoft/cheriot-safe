// Copyright (C) Microsoft Corporation. All rights reserved.


// This File is Auto Generated do not edit




// ==================================================
// Module msftDvIp_axi_dma_apb Definition
// ==================================================
module msftDvIp_axi_dma_apb #(
    parameter AXI_RCHAN_ID = 0,
    parameter AXI_WCHAN_ID = 1,
    parameter DMA_MAX_BYTE_WIDTH = 24,
    parameter AXI_ID_WIDTH = 4,
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 32,
    parameter AXI_LEN_WIDTH = 8
  ) (
  input                                      clk_i,
  input                                      rstn_i,
  input                                      psel_i,
  input                                      penable_i,
  input  [32-1:0]                            paddr_i,
  output [32-1:0]                            prdata_o,
  input  [32-1:0]                            pwdata_i,
  input                                      pwrite_i,
  output                                     pready_o,
  output                                     psuberr_o,
  output [AXI_ID_WIDTH-1:0]                  arid_dma_m_o,
  output [AXI_ADDR_WIDTH-1:0]                araddr_dma_m_o,
  output [AXI_LEN_WIDTH-1:0]                 arlen_dma_m_o,
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
  input  [AXI_ID_WIDTH-1:0]                  rid_dma_m_i,
  input  [AXI_DATA_WIDTH-1:0]                rdata_dma_m_i,
  input                                      rlast_dma_m_i,
  input  [1:0]                               rresp_dma_m_i,
  input                                      rvalid_dma_m_i,
  output                                     rready_dma_m_o,
  output [AXI_ID_WIDTH-1:0]                  awid_dma_m_o,
  output [AXI_ADDR_WIDTH-1:0]                awaddr_dma_m_o,
  output [AXI_LEN_WIDTH-1:0]                 awlen_dma_m_o,
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
  output [AXI_ID_WIDTH-1:0]                  wid_dma_m_o,
  output [AXI_DATA_WIDTH-1:0]                wdata_dma_m_o,
  output                                     wlast_dma_m_o,
  output [AXI_DATA_WIDTH/8-1:0]              wstrb_dma_m_o,
  output                                     wvalid_dma_m_o,
  input                                      wready_dma_m_i,
  input  [AXI_ID_WIDTH-1:0]                  bid_dma_m_i,
  input  [1:0]                               bresp_dma_m_i,
  input                                      bvalid_dma_m_i,
  output                                     bready_dma_m_o
);

// ==================================================
// Internal Wire Signals
// ==================================================
wire                                     clk;
wire                                     rstn;
wire                                     psel;
wire                                     penable;
wire [32-1:0]                            paddr;
wire [32-1:0]                            prdata;
wire [32-1:0]                            pwdata;
wire                                     pwrite;
wire                                     pready;
wire                                     psuberr;
wire [AXI_ID_WIDTH-1:0]                  arid_dma_m;
wire [AXI_ADDR_WIDTH-1:0]                araddr_dma_m;
wire [AXI_LEN_WIDTH-1:0]                 arlen_dma_m;
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
wire [AXI_ID_WIDTH-1:0]                  rid_dma_m;
wire [AXI_DATA_WIDTH-1:0]                rdata_dma_m;
wire                                     rlast_dma_m;
wire [1:0]                               rresp_dma_m;
wire                                     rvalid_dma_m;
wire                                     rready_dma_m;
wire [AXI_ID_WIDTH-1:0]                  awid_dma_m;
wire [AXI_ADDR_WIDTH-1:0]                awaddr_dma_m;
wire [AXI_LEN_WIDTH-1:0]                 awlen_dma_m;
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
wire [AXI_ID_WIDTH-1:0]                  wid_dma_m;
wire [AXI_DATA_WIDTH-1:0]                wdata_dma_m;
wire                                     wlast_dma_m;
wire [AXI_DATA_WIDTH/8-1:0]              wstrb_dma_m;
wire                                     wvalid_dma_m;
wire                                     wready_dma_m;
wire [AXI_ID_WIDTH-1:0]                  bid_dma_m;
wire [1:0]                               bresp_dma_m;
wire                                     bvalid_dma_m;
wire                                     bready_dma_m;

// ==================================================
// Pre Code Insertion
// ==================================================

// ==================================================
// Instance msftDvIp_dma_engine wire definitions
// ==================================================
wire                                     dma_req;
wire                                     dma_req_ack;
wire                                     dma_rdy;
wire [1:0]                               dma_rd_error;
wire [1:0]                               dma_wr_error;
wire [11:0]                              dma_bytes;
wire [32:0]                              dma_rd_addr;
wire [2:0]                               dma_rd_size;
wire [3:0]                               dma_rd_burst;
wire                                     dma_rd_inc;
wire                                     dma_rd_done;
wire                                     dma_rd_beat;
wire [2:0]                               dma_rd_bytes;
wire [32:0]                              dma_wr_addr;
wire [2:0]                               dma_wr_size;
wire [3:0]                               dma_wr_burst;
wire                                     dma_wr_inc;
wire                                     dma_wr_done;
wire                                     dma_wr_beat;
wire [2:0]                               dma_wr_bytes;

// ==================================================
// Instance msftDvIp_dma_ctrl0 wire definitions
// ==================================================
wire                                     req;
wire                                     ack;

// ==================================================
// Unconnected Pins
// ==================================================

// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_dma_engine
// ==================================================
msftDvIp_dma_engine #(
  .AXI_RCHAN_ID(AXI_RCHAN_ID),
  .AXI_WCHAN_ID(AXI_WCHAN_ID),
  .MAX_BYTE_WIDTH(DMA_MAX_BYTE_WIDTH),
  .AXI_ID_WIDTH(AXI_ID_WIDTH),
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
  .AXI_LEN_WIDTH(AXI_LEN_WIDTH)
  ) msftDvIp_dma_engine_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .awid_dma_m_o                  ( awid_dma_m                               ),
  .awaddr_dma_m_o                ( awaddr_dma_m                             ),
  .awlen_dma_m_o                 ( awlen_dma_m                              ),
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
  .arid_dma_m_o                  ( arid_dma_m                               ),
  .araddr_dma_m_o                ( araddr_dma_m                             ),
  .arlen_dma_m_o                 ( arlen_dma_m                              ),
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
  .dma_req_i                     ( dma_req                                  ),
  .dma_req_ack_o                 ( dma_req_ack                              ),
  .dma_rdy_o                     ( dma_rdy                                  ),
  .dma_rd_error_o                ( dma_rd_error                             ),
  .dma_wr_error_o                ( dma_wr_error                             ),
  .dma_bytes_i                   ( dma_bytes                                ),
  .dma_rd_addr_i                 ( dma_rd_addr                              ),
  .dma_rd_size_i                 ( dma_rd_size                              ),
  .dma_rd_burst_i                ( dma_rd_burst                             ),
  .dma_rd_inc_i                  ( dma_rd_inc                               ),
  .dma_rd_done_o                 ( dma_rd_done                              ),
  .dma_rd_beat_o                 ( dma_rd_beat                              ),
  .dma_rd_bytes_o                ( dma_rd_bytes                             ),
  .dma_wr_addr_i                 ( dma_wr_addr                              ),
  .dma_wr_size_i                 ( dma_wr_size                              ),
  .dma_wr_burst_i                ( dma_wr_burst                             ),
  .dma_wr_inc_i                  ( dma_wr_inc                               ),
  .dma_wr_done_o                 ( dma_wr_done                              ),
  .dma_wr_beat_o                 ( dma_wr_beat                              ),
  .dma_wr_bytes_o                ( dma_wr_bytes                             )
);


// ==================================================
//  Inst Pre Code 
// ==================================================

// ==================================================
// Instance msftDvIp_dma_ctrl0
// ==================================================
msftDvIp_dma_ctrl0 #(
  .MAX_BYTE_WIDTH(DMA_MAX_BYTE_WIDTH),
  .AXI_ID_WIDTH(AXI_ID_WIDTH),
  .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
  .AXI_LEN_WIDTH(AXI_LEN_WIDTH)
  ) msftDvIp_dma_ctrl0_i (
  .clk_i                         ( clk                                      ),
  .rstn_i                        ( rstn                                     ),
  .psel_i                        ( psel                                     ),
  .penable_i                     ( penable                                  ),
  .paddr_i                       ( paddr                                    ),
  .prdata_o                      ( prdata                                   ),
  .pwdata_i                      ( pwdata                                   ),
  .pwrite_i                      ( pwrite                                   ),
  .pready_o                      ( pready                                   ),
  .psuberr_o                     ( psuberr                                  ),
  .req_i                         ( req                                      ),
  .ack_o                         ( ack                                      ),
  .dma_req_o                     ( dma_req                                  ),
  .dma_req_ack_i                 ( dma_req_ack                              ),
  .dma_rdy_i                     ( dma_rdy                                  ),
  .dma_bytes_o                   ( dma_bytes                                ),
  .dma_rd_addr_o                 ( dma_rd_addr                              ),
  .dma_rd_size_o                 ( dma_rd_size                              ),
  .dma_rd_burst_o                ( dma_rd_burst                             ),
  .dma_rd_inc_o                  ( dma_rd_inc                               ),
  .dma_rd_done_i                 ( dma_rd_done                              ),
  .dma_rd_beat_i                 ( dma_rd_beat                              ),
  .dma_rd_bytes_i                ( dma_rd_bytes                             ),
  .dma_rd_error_i                ( dma_rd_error                             ),
  .dma_wr_addr_o                 ( dma_wr_addr                              ),
  .dma_wr_size_o                 ( dma_wr_size                              ),
  .dma_wr_burst_o                ( dma_wr_burst                             ),
  .dma_wr_inc_o                  ( dma_wr_inc                               ),
  .dma_wr_done_i                 ( dma_wr_done                              ),
  .dma_wr_beat_i                 ( dma_wr_beat                              ),
  .dma_wr_bytes_i                ( dma_wr_bytes                             ),
  .dma_wr_error_i                ( dma_wr_error                             )
);


// ==================================================
//  Connect IO Pins
// ==================================================
assign clk = clk_i;
assign rstn = rstn_i;
assign psel = psel_i;
assign penable = penable_i;
assign paddr = paddr_i;
assign prdata_o = prdata;
assign pwdata = pwdata_i;
assign pwrite = pwrite_i;
assign pready_o = pready;
assign psuberr_o = psuberr;
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

endmodule

// ==================================================
// Post Code Insertion
// ==================================================

