// Copyright (C) Microsoft Corporation. All rights reserved.



module msftDvIp_riscv_memory_v0 #(
    parameter IROM_INIT_FILE  = "",
    parameter IRAM_INIT_FILE  = "",
    parameter DATA_WIDTH=32,
    parameter IROM_DEPTH32='h4000,
    parameter IRAM_DEPTH32='h1_0000,
    parameter DRAM_DEPTH32='h4000
  )  (

  input                     clk_i,
  input                     rstn_i,

  input                     IROM_EN_i,
  input  [31:0]             IROM_ADDR_i,
  input                     IROM_IS_CAP_i,
  output [DATA_WIDTH-1:0]   IROM_RDATA_o,
  output                    IROM_READY_o,
  output                    IROM_ERROR_o,

  input                     IRAM_EN_i,
  input  [31:0]             IRAM_ADDR_i,
  input                     IRAM_IS_CAP_i,
  input  [DATA_WIDTH-1:0]   IRAM_WDATA_i,
  input                     IRAM_WE_i,
  input  [3:0]              IRAM_BE_i,
  output [DATA_WIDTH-1:0]   IRAM_RDATA_o,
  output                    IRAM_READY_o,
  output                    IRAM_ERROR_o,

  input                     DRAM_EN_i,
  input  [31:0]             DRAM_ADDR_i,
  input                     DRAM_IS_CAP_i,
  input  [DATA_WIDTH-1:0]   DRAM_WDATA_i,
  input                     DRAM_WE_i,
  input  [3:0]              DRAM_BE_i,
  output [DATA_WIDTH-1:0]   DRAM_RDATA_o,
  output                    DRAM_READY_o,
  output                    DRAM_ERROR_o,

  input                     tsmap_cs_i,
  input  [15:0]             tsmap_addr_i,
  output [31:0]             tsmap_rdata_o
);

localparam IROM_AW32 = $clog2(IROM_DEPTH32);
localparam IRAM_AW32 = $clog2(IRAM_DEPTH32);
localparam DRAM_AW32 = $clog2(DRAM_DEPTH32);

localparam IROM_AW = (DATA_WIDTH == 65) ? IROM_AW32-1: IROM_AW32;
localparam IRAM_AW = (DATA_WIDTH == 65) ? IRAM_AW32-1: IRAM_AW32;
localparam DRAM_AW = (DATA_WIDTH == 65) ? DRAM_AW32-1: DRAM_AW32;

localparam IROM_DEPTH = (DATA_WIDTH == 65) ? IROM_DEPTH32/2 : IROM_DEPTH32;
localparam IRAM_DEPTH = (DATA_WIDTH == 65) ? IRAM_DEPTH32/2 : IRAM_DEPTH32;
localparam DRAM_DEPTH = (DATA_WIDTH == 65) ? DRAM_DEPTH32/2 : DRAM_DEPTH32;

//===============================================
// Internal Wires
//===============================================
wire                  clk;
wire                  rstn;

wire                  IROM_EN;
wire [IROM_AW-1:0]    IROM_ADDR_mem;
wire [DATA_WIDTH-1:0] IROM_RDATA;

wire                  IRAM_EN;
wire [IRAM_AW-1:0]    IRAM_ADDR_mem;
wire [DATA_WIDTH-1:0] IRAM_WDATA;
wire                  IRAM_WE;
wire [3:0]            IRAM_BE;
wire [DATA_WIDTH-1:0] IRAM_RDATA;
wire                  IRAM_READY;
wire                  IRAM_ERROR;

wire                  DRAM_EN;
wire [DRAM_AW-1:0]    DRAM_ADDR_mem;
wire [DATA_WIDTH-1:0] DRAM_WDATA;
wire                  DRAM_WE;
wire [3:0]            DRAM_BE;
wire [DATA_WIDTH-1:0] DRAM_RDATA;
wire                  DRAM_READY;
wire                  DRAM_ERROR;

logic [DATA_WIDTH-1:0] tsmap_rdata;
logic [DRAM_AW-1:0]    tsmap_addr_mem;
logic [DATA_WIDTH-1:0] dram_wstrb, iram_wstrb;
logic                  iram_rd32hi_q, irom_rd32hi_q, dram_rd32hi_q, tsmap_rd32hi_q;
logic [31:0]           iram_wstrb32, dram_wstrb32;

localparam CBIT9 = (DATA_WIDTH == 33) ? 9 : 8;


//===============================================
// IROM
//===============================================
msftDvIp_fpga_block_ram_model #(
    .RAM_WIDTH (DATA_WIDTH),
    .RAM_DEPTH (IROM_DEPTH),
    .INIT_FILE (IROM_INIT_FILE)
  ) irom (
    .clk    (clk),
    .cs     (IROM_EN),
    .dout   (IROM_RDATA),
    .addr   (IROM_ADDR_mem),
    .din    ({DATA_WIDTH{1'b0}}),
    .we     (1'b0)
  );
    
//===============================================
// IRAM
//===============================================
msftDvIp_fpga_block_ram_byte_wr_model #(
    .RAM_WIDTH        (DATA_WIDTH),
    .RAM_DEPTH        (IRAM_DEPTH),
    .INIT_FILE        (IRAM_INIT_FILE)
  ) iram (
    .clk    (clk),
    .cs     (IRAM_EN),
    .addr   (IRAM_ADDR_mem),
    .dout   (IRAM_RDATA),
    .din    (IRAM_WDATA),
    .we     (IRAM_WE),
    .wstrb  (iram_wstrb),
    .ready  (IRAM_READY)
  );

//===============================================
// DRAM
//===============================================
msftDvIp_fpga_block_ram_2port_model #(
    .RAM_WIDTH        (DATA_WIDTH),
    .RAM_DEPTH        (DRAM_DEPTH),
    .INIT_FILE        ("")
  ) dram (
    .clk(clk),
    .cs(DRAM_EN),
    .dout(DRAM_RDATA),
    .addr(DRAM_ADDR_mem),
    .din(DRAM_WDATA),
    .we(DRAM_WE),
    .wstrb(dram_wstrb),
    .ready(dram_rdy),
    .cs2(tsmap_cs_i),
    .addr2(tsmap_addr_mem),
    .dout2(tsmap_rdata)
  );

//===============================================
// Connect ports
//===============================================
assign clk = clk_i;
assign rstn = rstn_i;

assign IROM_EN = IROM_EN_i;

assign IROM_READY_o = 1'b1;
assign IROM_ERROR_o = 1'b0;

assign IRAM_EN = IRAM_EN_i;
assign IRAM_WE = IRAM_WE_i;
assign IRAM_BE = IRAM_BE_i;
assign IRAM_READY_o = 1'b1;
assign IRAM_ERROR_o = 1'b0;

assign DRAM_EN = DRAM_EN_i;
assign DRAM_WDATA = DRAM_WDATA_i;
assign DRAM_WE = DRAM_WE_i;
assign DRAM_BE = DRAM_BE_i;
assign DRAM_READY_o = 1'b1;
assign DRAM_ERROR_o = 1'b0;

assign iram_wstrb32 = {{8{IRAM_BE[3]}}, {8{IRAM_BE[2]}}, {8{IRAM_BE[1]}}, {8{IRAM_BE[0]}} };
assign dram_wstrb32 = {{8{DRAM_BE[3]}}, {8{DRAM_BE[2]}}, {8{DRAM_BE[1]}}, {8{DRAM_BE[0]}} };

if (DATA_WIDTH == 65) begin
  assign IROM_ADDR_mem = IROM_ADDR_i[IROM_AW32+1:3];
  assign IRAM_ADDR_mem = IRAM_ADDR_i[IRAM_AW32+1:3];
  assign DRAM_ADDR_mem = DRAM_ADDR_i[DRAM_AW32+1:3];
  assign tsmap_addr_mem = tsmap_addr_i[15:1];

  assign IROM_RDATA_o = irom_rd32hi_q ?  {33'h0, IROM_RDATA[63:32]} : IROM_RDATA;
  assign IRAM_RDATA_o = iram_rd32hi_q ?  {33'h0, IRAM_RDATA[63:32]} : IRAM_RDATA;
  assign DRAM_RDATA_o = dram_rd32hi_q ?  {33'h0, DRAM_RDATA[63:32]} : DRAM_RDATA;

  assign IRAM_WDATA = (IRAM_WE & ~IRAM_IS_CAP_i)  ? {IRAM_WDATA_i[64], IRAM_WDATA_i[31:0], IRAM_WDATA_i[31:0]} :
                                                    IRAM_WDATA_i;
  
  assign DRAM_WDATA = (DRAM_WE & ~DRAM_IS_CAP_i)  ? {DRAM_WDATA_i[64], DRAM_WDATA_i[31:0], DRAM_WDATA_i[31:0]} :
                                                    DRAM_WDATA_i;

  assign iram_wstrb = (IRAM_WE & ~IRAM_IS_CAP_i & IRAM_ADDR_i[2]) ? {1'b1, iram_wstrb32, 32'h0} : 
                      ((IRAM_WE & ~IRAM_IS_CAP_i) ? {1'b1, 32'h0, iram_wstrb32} : {65{1'b1}});
  assign dram_wstrb = (DRAM_WE & ~DRAM_IS_CAP_i & DRAM_ADDR_i[2]) ? {1'b1, dram_wstrb32, 32'h0} : 
                      ((DRAM_WE & ~DRAM_IS_CAP_i) ? {1'b1, 32'h0, dram_wstrb32} : {65{1'b1}});
 
  assign tsmap_rdata_o =  tsmap_rd32hi_q ? tsmap_rdata[63:32] : tsmap_rdata[31:0];
  
end else begin
  assign IROM_ADDR_mem = IROM_ADDR_i[IROM_AW32+1:2];
  assign IRAM_ADDR_mem = IRAM_ADDR_i[IRAM_AW32+1:2];
  assign DRAM_ADDR_mem = DRAM_ADDR_i[DRAM_AW32+1:2];
  assign tsmap_addr_mem = tsmap_addr_i;

  assign IROM_RDATA_o = IROM_RDATA;
  assign IRAM_RDATA_o = IRAM_RDATA;
  assign DRAM_RDATA_o = DRAM_RDATA;

  assign IRAM_WDATA = IRAM_WDATA_i;
  assign DRAM_WDATA = DRAM_WDATA_i;
  assign iram_wstrb = {1'b1, iram_wstrb32};
  assign dram_wstrb = {1'b1, dram_wstrb32};

  assign tsmap_rdata_o = tsmap_rdata[31:0];
end

always_ff @(posedge clk or negedge rstn) begin
  if (~rstn) begin
    irom_rd32hi_q  <= 1'b0;
    iram_rd32hi_q  <= 1'b0;
    dram_rd32hi_q  <= 1'b0;
    tsmap_rd32hi_q <= 1'b0;
  end else begin
    if (IROM_EN) irom_rd32hi_q <= ~IROM_IS_CAP_i & IROM_ADDR_i[2];
    if (IRAM_EN) iram_rd32hi_q <= ~IRAM_WE & ~IRAM_IS_CAP_i & IRAM_ADDR_i[2];
    if (DRAM_EN) dram_rd32hi_q <= ~DRAM_WE & ~DRAM_IS_CAP_i & DRAM_ADDR_i[2];
    if (tsmap_cs_i) tsmap_rd32hi_q <= tsmap_addr_i[0];
  end  
end

endmodule 
