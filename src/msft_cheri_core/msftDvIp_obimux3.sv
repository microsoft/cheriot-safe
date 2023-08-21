
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

//Future enhancements
// - early write response
// - pipeline

// Parameters
// SIZE   4K = 12
// SIZE   8K = 13
// SIZE  16K = 14
// SIZE  32K = 15
// SIZE  64K = 16
// SIZE 128K = 17
// SIZE 256K = 18
// SIZE 512K = 19

module msftDvIp_obimux3 #(
    parameter DBGMEM_START_ADDRESS = 32'h0000_0000,
    parameter DBGMEM_END_ADDRESS   = 32'h0300_0000,
    parameter IROM_START_ADDRESS   = 32'h2000_0000,
    parameter IROM_END_ADDRESS     = 32'h2004_0000,
    parameter IRAM_START_ADDRESS   = 32'h2004_0000,
    parameter IRAM_END_ADDRESS     = 32'h200C_0000,
    parameter DRAM_START_ADDRESS   = 32'h200F_0000,
    parameter DRAM_END_ADDRESS     = 32'h2010_0000,
    parameter AXI_ID               = 4'h0,
    parameter USER_BIT_WIDTH       = 12,
    parameter DATA_WIDTH           = 32
   ) (
  input                     clk_i,
  input                     rstn_i,

  input                     data_req_i,
  output                    data_gnt_o,
  input [31:0]              data_addr_i,
  input [3:0]               data_be_i,
  input [DATA_WIDTH-1:0]    data_wdata_i, 
  input                     data_we_i, 

  output [DATA_WIDTH-1:0]   data_rdata_o,
  output                    data_rvalid_o,
  output                    data_error_o,
  
  input                     instr_req_i,
  output                    instr_gnt_o,
  input [31:0]              instr_addr_i,

  output [DATA_WIDTH-1:0]   instr_rdata_o,
  output                    instr_rvalid_o,
  output                    instr_error_o,

  input                     dbg_req_i,
  output                    dbg_gnt_o,
  input [31:0]              dbg_addr_i,
  input [3:0]               dbg_be_i,
  input [DATA_WIDTH-1:0]    dbg_wdata_i,
  input                     dbg_we_i,

  output [DATA_WIDTH-1:0]   dbg_rdata_o,
  output                    dbg_rvalid_o,
  output                    dbg_error_o,

  output                    DBGMEM_EN_o,
  output [31:0]             DBGMEM_ADDR_o,
  output [DATA_WIDTH-1:0]   DBGMEM_WDATA_o,
  output                    DBGMEM_WE_o,
  output [3:0]              DBGMEM_BE_o,
  input  [DATA_WIDTH-1:0]   DBGMEM_RDATA_i,
  input                     DBGMEM_READY_i,
  input                     DBGMEM_ERROR_i,

  output                    IROM_EN_o,
  output [31:0]             IROM_ADDR_o,
  output [DATA_WIDTH-1:0]   IROM_WDATA_o,
  output                    IROM_WE_o,
  output [3:0]              IROM_BE_o,
  input  [DATA_WIDTH-1:0]   IROM_RDATA_i,
  input                     IROM_READY_i,
  input                     IROM_ERROR_i,

  output                    IRAM_EN_o,
  output [31:0]             IRAM_ADDR_o,
  output [DATA_WIDTH-1:0]   IRAM_WDATA_o,
  output                    IRAM_WE_o,
  output [3:0]              IRAM_BE_o,
  input  [DATA_WIDTH-1:0]   IRAM_RDATA_i,
  input                     IRAM_READY_i,
  input                     IRAM_ERROR_i,

  output                    DRAM_EN_o,
  output [31:0]             DRAM_ADDR_o,
  output [DATA_WIDTH-1:0]   DRAM_WDATA_o,
  output                    DRAM_WE_o,
  output [3:0]              DRAM_BE_o,
  input  [DATA_WIDTH-1:0]   DRAM_RDATA_i,
  input                     DRAM_READY_i,
  input                     DRAM_ERROR_i,

  output [3:0]              AWID_o,
  output [31:0]             AWADDR_o,
  output [7:0]              AWLEN_o,
  output [2:0]              AWSIZE_o,
  output [1:0]              AWBURST_o,
  output [1:0]              AWLOCK_o,
  output [2:0]              AWPROT_o,
  output [3:0]              AWCACHE_o,
  output [USER_BIT_WIDTH-1:0]         AWUSER_o,
  output                    AWVALID_o,
  input                     AWREADY_i,

  output [31:0]             WDATA_o,
  output [3:0]              WSTRB_o,
  output                    WLAST_o,
  output                    WVALID_o,
  input                     WREADY_i,

  input  [3:0]              BID_i,
  input  [1:0]              BRESP_i,
  input                     BVALID_i,
  output                    BREADY_o,

  output [3:0]              ARID_o,
  output [31:0]             ARADDR_o,
  output [7:0]              ARLEN_o,
  output [2:0]              ARSIZE_o,
  output [1:0]              ARBURST_o,
  output [1:0]              ARLOCK_o,
  output [2:0]              ARPROT_o,
  output [3:0]              ARCACHE_o,
  output [USER_BIT_WIDTH-1:0]         ARUSER_o,
  output                    ARVALID_o,
  input                     ARREADY_i,
  
  input  [3:0]              RID_i,
  input  [31:0]             RDATA_i,
  input                     RLAST_i,
  input  [1:0]              RRESP_i,
  input                     RVALID_i,
  output                    RREADY_o

);

//========================================
// Address Space Defines
//========================================
`define IS_DBG_IROM_ADDR(addr)   (addr >= DBGMEM_START_ADDRESS && addr < DBGMEM_END_ADDRESS)
`define IS_IROM_ADDR(addr)       (addr >= IROM_START_ADDRESS && addr < IROM_END_ADDRESS) 
`define IS_IRAM_ADDR(addr)       (addr >= IRAM_START_ADDRESS && addr < IRAM_END_ADDRESS)
`define IS_DRAM_ADDR(addr)       (addr >= DRAM_START_ADDRESS && addr < DRAM_END_ADDRESS)

//========================================
// Parameters
//========================================
localparam MEM_IDLE            = 'h0;
localparam MEM_ACCESS          = 'h1;
localparam MEM_RESPONSE        = 2'h2;
localparam AXI_MEM_RESPONSE    = 2'h3;

localparam OUTPUT_CHANNELS     = (6);
//========================================
// Structures
//========================================
typedef struct {
  logic [1:0]  state;
  logic [31:0] addr;
  logic        mreq;
  logic [OUTPUT_CHANNELS-1:0]  msel;
  logic [OUTPUT_CHANNELS-1:0]  rsel;
  logic        rvld;
  logic        rerr;
} OBI_RO_INPUTS_t;

typedef struct {
  logic [1:0]  state;
  logic [31:0] addr;
  logic [32:0] wdata;
  logic [3:0]  be;
  logic        we;
  logic        mreq;
  logic [OUTPUT_CHANNELS-1:0]  msel;
  logic [OUTPUT_CHANNELS-1:0]  rsel;
  logic        rvld;
  logic        rerr;
} OBI_INPUTS_t;

OBI_INPUTS_t data, inst, dbg;

enum {
  DBGMEM_SEL,
  IROM_SEL,
  IRAM_SEL,
  DRAM_SEL,
  AXIWR_SEL,
  AXIRD_SEL
} SELECTS;

//========================================
// DBG/Data Mux
//========================================
reg [31:0]      axi_rdata_dly;
reg  axi_wr_state;

//========================================
// Memory Decodes
//========================================
wire [5:0]  mem_rdy;
wire [5:0]  mem_err;

wire [5:0]  dbg_mem_rdy;
wire [5:0]  data_mem_rdy;
wire [5:0]  inst_mem_rdy;

wire [5:0]  dbg_mem_sel;
wire [5:0]  data_mem_sel;
wire [5:0]  inst_mem_sel;

// Mem Ready Bus
assign mem_rdy = {ARREADY_i, AWREADY_i, DRAM_READY_i, IRAM_READY_i, IROM_READY_i, DBGMEM_READY_i};
assign mem_err = {|RRESP_i, |BRESP_i,   DRAM_ERROR_i, IRAM_ERROR_i, IROM_ERROR_i, DBGMEM_ERROR_i};

//======================================================
// Priority from high to low is DBG, DATA, INST
//======================================================
assign dbg_mem_rdy   =  mem_rdy &  dbg.msel;
assign data_mem_rdy  =  mem_rdy & ~dbg.msel &  data.msel;
assign inst_mem_rdy  =  mem_rdy & ~dbg.msel & ~data.msel  & inst.msel;

//======================================================
// Memory Decoding
//======================================================
assign dbgrom_inst_sel    = `IS_DBG_IROM_ADDR(instr_addr_i);
assign irom_inst_sel      = `IS_IROM_ADDR(instr_addr_i);
assign iram_inst_sel      = `IS_IRAM_ADDR(instr_addr_i);
assign dram_inst_sel      = `IS_DRAM_ADDR(instr_addr_i);
assign axi_rd_inst_sel    = ~(irom_inst_sel | iram_inst_sel | dram_inst_sel | dbgrom_inst_sel);
assign inst_mem_sel       = {axi_rd_inst_sel, 1'b0, dram_inst_sel, iram_inst_sel, irom_inst_sel, dbgrom_inst_sel};

assign dbgrom_data_sel    = `IS_DBG_IROM_ADDR(data_addr_i);
assign irom_data_sel      = `IS_IROM_ADDR(data_addr_i);
assign iram_data_sel      = `IS_IRAM_ADDR(data_addr_i);
assign dram_data_sel      = `IS_DRAM_ADDR(data_addr_i);
assign axi_data_sel       = ~(irom_data_sel | iram_data_sel | dram_data_sel | dbgrom_data_sel);
assign axi_wr_data_sel    =  data_we_i & axi_data_sel;
assign axi_rd_data_sel    = ~data_we_i  & axi_data_sel;
assign data_mem_sel       = {axi_rd_data_sel, axi_wr_data_sel, dram_data_sel, iram_data_sel, irom_data_sel, dbgrom_data_sel};

assign dbgrom_dbg_sel     = `IS_DBG_IROM_ADDR(dbg_addr_i);
assign irom_dbg_sel       = `IS_IROM_ADDR(dbg_addr_i);
assign iram_dbg_sel       = `IS_IRAM_ADDR(dbg_addr_i);
assign dram_dbg_sel       = `IS_DRAM_ADDR(dbg_addr_i);
assign axi_dbg_sel        = ~(irom_dbg_sel | iram_dbg_sel | dram_dbg_sel | dbgrom_dbg_sel);
assign axi_wr_dbg_sel     =  dbg_we_i & axi_dbg_sel;
assign axi_rd_dbg_sel     = ~dbg_we_i  & axi_dbg_sel;
assign dbg_mem_sel        = {axi_rd_dbg_sel,  axi_wr_dbg_sel,  dram_dbg_sel,  iram_dbg_sel,  irom_dbg_sel, dbgrom_dbg_sel};

assign inst_axi_sel       = inst.msel[AXIRD_SEL] | inst.msel[AXIWR_SEL];
assign instr_gnt_o        = (inst.state == AXI_MEM_RESPONSE) ? 1'b0 : (inst.state == MEM_ACCESS) ? (|inst_mem_rdy) & ~inst_axi_sel : 1'b1 ;
assign instr_rdata_o      = (inst.rsel[DBGMEM_SEL]) ? DBGMEM_RDATA_i : (inst.rsel[IROM_SEL]) ? IROM_RDATA_i : (inst.rsel[IRAM_SEL]) ? IRAM_RDATA_i : (inst.rsel[DRAM_SEL]) ? DRAM_RDATA_i : axi_rdata_dly;
assign instr_rvalid_o     = inst.rvld;
assign instr_error_o      = inst.rerr;

assign data_axi_sel       = data.msel[AXIRD_SEL] | data.msel[AXIWR_SEL];
assign data_gnt_o         = (data.state == AXI_MEM_RESPONSE) ? 1'b0 : (data.state == MEM_ACCESS) ? (|data_mem_rdy) & ~data_axi_sel : 1'b1;
assign data_rdata_o       = (data.rsel[DBGMEM_SEL]) ? DBGMEM_RDATA_i : (data.rsel[IROM_SEL]) ? IROM_RDATA_i : (data.rsel[IRAM_SEL]) ? IRAM_RDATA_i : (data.rsel[DRAM_SEL]) ? DRAM_RDATA_i : axi_rdata_dly;
assign data_rvalid_o      = data.rvld;
assign data_error_o       = data.rerr;

assign dbg_axi_sel        = dbg.msel[AXIRD_SEL] | dbg.msel[AXIWR_SEL];
assign dbg_gnt_o          = (dbg.state == AXI_MEM_RESPONSE) ? 1'b0 : (dbg.state == MEM_ACCESS) ? (|dbg_mem_rdy) & ~dbg_axi_sel : 1'b1;
assign dbg_rdata_o        = (dbg.rsel[DBGMEM_SEL]) ? DBGMEM_RDATA_i :(dbg.rsel[IROM_SEL]) ? IROM_RDATA_i     : (dbg.rsel[IRAM_SEL]) ? IRAM_RDATA_i : (dbg.rsel[DRAM_SEL]) ? DRAM_RDATA_i : axi_rdata_dly;
assign dbg_rvalid_o       = dbg.rvld;
assign dbg_error_o        = dbg.rerr;

//====================================================
// RDATA Delay
//====================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    axi_rdata_dly <= 32'h0000_0000;
  end else begin
    if(RVALID_i & RREADY_o) begin
      axi_rdata_dly <= RDATA_i;
    end
  end
end

//====================================================
// Inst Bus State Machine
//====================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    inst.state <= MEM_IDLE;
    inst.addr <= 32'h0000_0000;
    inst.msel <= {OUTPUT_CHANNELS{1'b0}};
    inst.rsel <= {OUTPUT_CHANNELS{1'b0}};
    inst.rvld <= 1'b0;
    inst.rerr <= 1'b0;
  end else begin
    casez(inst.state)
    MEM_IDLE: begin
      if(instr_req_i) begin
        inst.addr  <= instr_addr_i;
        inst.msel  <= inst_mem_sel;
        inst.state <= MEM_ACCESS;
      end
    end
    MEM_ACCESS: begin
      if(|inst_mem_rdy) begin
        if(inst_axi_sel) begin
          inst.msel <= {OUTPUT_CHANNELS{1'b0}};
          inst.rsel <= inst.msel;
          inst.state <= AXI_MEM_RESPONSE;
          inst.rvld <= 1'b0;
        end else begin
          inst.rvld <= 1'b1;
          if(instr_req_i) begin
            inst.addr  <= instr_addr_i;
            inst.msel  <= inst_mem_sel;
            inst.rsel <= inst.msel;
            inst.rerr <= |(mem_err&inst.msel);
            inst.state <= MEM_ACCESS;
          end else begin
            inst.msel <= {OUTPUT_CHANNELS{1'b0}};
            inst.rsel <= inst.msel;
            inst.state <= MEM_RESPONSE;
          end
        end
      end else begin
        inst.rvld <= 1'b0;
      end
    end
    MEM_RESPONSE: begin
      inst.rvld <= 1'b0;
      inst.rsel <= 1'b0;
      if(instr_req_i) begin
        inst.addr  <= instr_addr_i;
        inst.msel  <= inst_mem_sel;
        inst.state <= MEM_ACCESS;
      end else begin
        inst.msel <= {OUTPUT_CHANNELS{1'b0}};
        inst.state <= MEM_IDLE;
      end
    end
    AXI_MEM_RESPONSE: begin
      if(inst.rsel[AXIRD_SEL]) begin
        if(RVALID_i) begin
          inst.rerr <= RRESP_i[1];
          inst.rvld <= 1'b1;
          inst.state <= MEM_RESPONSE;
        end
      end else if(inst.rsel[AXIWR_SEL]) begin
        if(BVALID_i) begin
          inst.rerr <= BRESP_i[1];
          inst.rvld <= 1'b1;
          inst.state <= MEM_RESPONSE;
        end
      end
    end
    endcase
  end
end

//====================================================
// Data Bus State Machine
//====================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    data.state <= MEM_IDLE;
    data.addr <= 32'h0000_0000;
    data.wdata <= 33'h0_0000_0000;
    data.we <= 1'b0;
    data.be <= 4'h0;
    data.msel <= {OUTPUT_CHANNELS{1'b0}};
    data.rvld <= 1'b0;
    data.rsel <= {OUTPUT_CHANNELS{1'b0}};
    data.rerr <= 1'b0;
  end else begin
    casez(data.state)
    MEM_IDLE: begin
      if(|data_req_i) begin
        data.addr  <= data_addr_i;
        data.wdata <= data_wdata_i;
        data.be    <= data_be_i;
        data.we    <= data_we_i;
        data.msel  <= data_mem_sel;
        data.state <= MEM_ACCESS;
      end
    end
    MEM_ACCESS: begin
      if(|data_mem_rdy) begin
        if(data_axi_sel) begin
          data.msel <= {OUTPUT_CHANNELS{1'b0}};
          data.rsel <= data.msel;
          data.state <= AXI_MEM_RESPONSE;
          data.rvld <= 1'b0;
        end else begin
          data.rvld <= 1'b1;
          if(data_req_i) begin
            data.addr  <= data_addr_i;
            data.wdata <= data_wdata_i;
            data.be    <= data_be_i;
            data.we    <= data_we_i;
            data.msel  <= data_mem_sel;
            data.rsel  <= data.msel;
            data.rerr  <= |(mem_err&data.msel);
            data.state <= MEM_ACCESS;
          end else begin
            data.msel <= {OUTPUT_CHANNELS{1'b0}};
            data.rsel <= data.msel;
            data.state <= MEM_RESPONSE;
          end
        end
      end else begin
        data.rvld <= 1'b0;
      end
    end
    MEM_RESPONSE: begin
      data.rvld <= 1'b0;
      data.rsel <= {OUTPUT_CHANNELS{1'b0}};
      if(data_req_i) begin
        data.addr  <= data_addr_i;
        data.wdata <= data_wdata_i;
        data.be    <= data_be_i;
        data.we    <= data_we_i;
        data.msel  <= data_mem_sel;
        data.state <= MEM_ACCESS;
      end else begin
        data.msel <= {OUTPUT_CHANNELS{1'b0}};
        data.state <= MEM_IDLE;
      end
    end
    AXI_MEM_RESPONSE: begin
      if(data.rsel[AXIRD_SEL]) begin
        if(RVALID_i) begin
          data.rerr <= RRESP_i[1];
          data.rvld <= 1'b1;
          data.state <= MEM_RESPONSE;
        end
      end else if(data.rsel[AXIWR_SEL]) begin
        if(BVALID_i) begin
          data.rerr <= BRESP_i[1];
          data.rvld <= 1'b1;
          data.state <= MEM_RESPONSE;
        end
      end
    end
    endcase
  end
end

//====================================================
// DBG Bus State Machine
//====================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    dbg.state <= MEM_IDLE;
    dbg.addr <= 32'h0000_0000;
    dbg.wdata <= 33'h0_0000_0000;
    dbg.we <= 1'b0;
    dbg.be <= 4'h0;
    dbg.msel <= {OUTPUT_CHANNELS{1'b0}};
    dbg.rsel <= {OUTPUT_CHANNELS{1'b0}};
    dbg.rvld <= 1'b0;
    dbg.rerr <= 1'b0;
  end else begin
    casez(dbg.state)
    MEM_IDLE: begin
      if(|dbg_req_i) begin
        dbg.addr  <= dbg_addr_i;
        dbg.wdata <= dbg_wdata_i;
        dbg.be    <= dbg_be_i;
        dbg.we    <= dbg_we_i;
        dbg.msel  <= dbg_mem_sel;
        dbg.state <= MEM_ACCESS;
      end
    end
    MEM_ACCESS: begin
      if(|dbg_mem_rdy) begin
        if(dbg_axi_sel) begin
          dbg.msel <= {OUTPUT_CHANNELS{1'b0}};
          dbg.rsel <= dbg.msel;
          dbg.state <= AXI_MEM_RESPONSE;
          dbg.rvld <= 1'b0;
        end else begin
          dbg.rvld <= 1'b1;
          if(dbg_req_i) begin
            dbg.addr  <= dbg_addr_i;
            dbg.wdata <= dbg_wdata_i;
            dbg.be    <= dbg_be_i;
            dbg.we    <= dbg_we_i;
            dbg.msel  <= dbg_mem_sel;
            dbg.rsel  <= dbg.msel;
            dbg.rerr  <= |(mem_err&dbg.msel);
            dbg.state <= MEM_ACCESS;
          end else begin
            dbg.msel <= {OUTPUT_CHANNELS{1'b0}};
            dbg.rsel <= dbg.msel;
            dbg.state <= MEM_RESPONSE;
          end
        end
      end else begin
        dbg.rvld <= 1'b0;
      end
    end
    MEM_RESPONSE: begin
      dbg.rvld <= 1'b0;
      dbg.rsel <= 6'h0;
      if(dbg_req_i) begin
        dbg.addr  <= dbg_addr_i;
        dbg.wdata <= dbg_wdata_i;
        dbg.be    <= dbg_be_i;
        dbg.we    <= dbg_we_i;
        dbg.msel  <= dbg_mem_sel;
        dbg.state <= MEM_ACCESS;
      end else begin
        dbg.msel <= {OUTPUT_CHANNELS{1'b0}};
        dbg.state <= MEM_IDLE;
      end
    end
    AXI_MEM_RESPONSE: begin
      if(dbg.rsel[AXIRD_SEL]) begin
        if(RVALID_i) begin
          dbg.rerr <= RRESP_i[1];
          dbg.rvld <= 1'b1;
          dbg.state <= MEM_RESPONSE;
        end
      end else if(dbg.rsel[AXIWR_SEL]) begin
        if(BVALID_i) begin
          dbg.rerr <= BRESP_i[1];
          dbg.rvld <= 1'b1;
          dbg.state <= MEM_RESPONSE;
        end
      end
    end
    endcase
  end
end

//====================================================
// Hold WVALID till WREADY shows up
//====================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    axi_wr_state <= 1'b0;
  end else if(~axi_wr_state) begin
    axi_wr_state <= AWVALID_o & AWREADY_i & ~WREADY_i;
  end else if(WREADY_i) begin
    axi_wr_state <= 1'b1;
  end
end

//====================================================
// BUS Signals
//====================================================
// DBGMEM outgoing
assign DBGMEM_EN_o    =  dbg.msel[DBGMEM_SEL] | data.msel[DBGMEM_SEL] | inst.msel[DBGMEM_SEL];
assign DBGMEM_ADDR_o  = (dbg.msel[DBGMEM_SEL]) ? dbg.addr  : (data.msel[DBGMEM_SEL]) ? data.addr  : (inst.msel[DBGMEM_SEL]) ? inst.addr : 32'h0000_0000;
assign DBGMEM_WDATA_o = (dbg.msel[DBGMEM_SEL]) ? dbg.wdata : (data.msel[DBGMEM_SEL]) ? data.wdata : 33'h0_0000_0000;
assign DBGMEM_WE_o    = (dbg.msel[DBGMEM_SEL]) ? dbg.we    : (data.msel[DBGMEM_SEL]) ? data.we    : 1'b0;
assign DBGMEM_BE_o    = (dbg.msel[DBGMEM_SEL]) ? dbg.be    : (data.msel[DBGMEM_SEL]) ? data.be    : 4'h0;

// IROM outgoing
assign IROM_EN_o      =  dbg.msel[IROM_SEL] | data.msel[IROM_SEL] | inst.msel[IROM_SEL];
assign IROM_ADDR_o    = (dbg.msel[IROM_SEL]) ? dbg.addr  : (data.msel[IROM_SEL]) ? data.addr  : (inst.msel[IROM_SEL]) ? inst.addr : 32'h0000_0000;
assign IROM_WDATA_o   = (dbg.msel[IROM_SEL]) ? dbg.wdata : (data.msel[IROM_SEL]) ? data.wdata : 33'h0_0000_0000;
assign IROM_WE_o      = (dbg.msel[IROM_SEL]) ? dbg.we    : (data.msel[IROM_SEL]) ? data.we    : 1'b0;
assign IROM_BE_o      = (dbg.msel[IROM_SEL]) ? dbg.be    : (data.msel[IROM_SEL]) ? data.be    : 4'h0;

// IRAM outgoing
assign IRAM_EN_o      =  dbg.msel[IRAM_SEL] | data.msel[IRAM_SEL] | inst.msel[IRAM_SEL];
assign IRAM_ADDR_o    = (dbg.msel[IRAM_SEL]) ? dbg.addr  : (data.msel[IRAM_SEL]) ? data.addr  : (inst.msel[IRAM_SEL]) ? inst.addr : 32'h0000_0000;
assign IRAM_WDATA_o   = (dbg.msel[IRAM_SEL]) ? dbg.wdata : (data.msel[IRAM_SEL]) ? data.wdata : 33'h0_0000_0000;
assign IRAM_WE_o      = (dbg.msel[IRAM_SEL]) ? dbg.we    : (data.msel[IRAM_SEL]) ? data.we    : 1'b0;
assign IRAM_BE_o      = (dbg.msel[IRAM_SEL]) ? dbg.be    : (data.msel[IRAM_SEL]) ? data.be    : 4'h0;

// DRAM outgoing
assign DRAM_EN_o      =  dbg.msel[DRAM_SEL] | data.msel[DRAM_SEL] | inst.msel[DRAM_SEL];
assign DRAM_ADDR_o    = (dbg.msel[DRAM_SEL]) ? dbg.addr  : (data.msel[DRAM_SEL]) ? data.addr  : (inst.msel[DRAM_SEL]) ? inst.addr : 32'h0000_0000;
assign DRAM_WDATA_o   = (dbg.msel[DRAM_SEL]) ? dbg.wdata : (data.msel[DRAM_SEL]) ? data.wdata : 33'h0_0000_0000;
assign DRAM_WE_o      = (dbg.msel[DRAM_SEL]) ? dbg.we    : (data.msel[DRAM_SEL]) ? data.we    : 1'b0;
assign DRAM_BE_o      = (dbg.msel[DRAM_SEL]) ? dbg.be    : (data.msel[DRAM_SEL]) ? data.be    : 4'h0;

// AXI Write Bus
assign AWID_o         = AXI_ID;
assign AWADDR_o       = (dbg.msel[AXIWR_SEL]) ? dbg.addr  : (data.msel[AXIWR_SEL]) ? data.addr  : (inst.msel[AXIWR_SEL]) ? inst.addr : 32'h0000_0000;
assign AWLEN_o        = 8'h0;
assign AWSIZE_o       = 2'h2;
assign AWBURST_o      = 2'h1;
assign AWLOCK_o       = 1'b0;
assign AWPROT_o       = 3'h1;
assign AWCACHE_o      = 4'h0;
assign AWUSER_o       = {USER_BIT_WIDTH{1'b0}};
assign AWVALID_o      = dbg.msel[AXIWR_SEL] | data.msel[AXIWR_SEL];

assign WVALID_o       = AWVALID_o | axi_wr_state;
assign WDATA_o        = (dbg.msel[AXIWR_SEL] | dbg.rsel[AXIWR_SEL]) ? dbg.wdata : (data.msel[AXIWR_SEL] | data.rsel[AXIWR_SEL]) ? data.wdata : 32'h0000_0000;
assign WSTRB_o        = (dbg.msel[AXIWR_SEL] | dbg.rsel[AXIWR_SEL]) ? dbg.be    : (data.msel[AXIWR_SEL] | data.rsel[AXIWR_SEL]) ? data.be    : 2'h0;
assign WLAST_o        = 1'b1;

assign BREADY_o       = 1'b1;

// AXI Read Bus
assign ARID_o         = AXI_ID;
assign ARADDR_o       = (dbg.msel[AXIRD_SEL]) ? dbg.addr  : (data.msel[AXIRD_SEL]) ? data.addr  : (inst.msel[AXIRD_SEL]) ? inst.addr : 32'h0000_0000;
assign ARLEN_o        = 8'h0;
assign ARSIZE_o       = 2'h2;
assign ARBURST_o      = 2'h1;
assign ARLOCK_o       = 1'b0;
assign ARPROT_o       = 3'h1;
assign ARCACHE_o      = 4'h0;
assign ARUSER_o       = {USER_BIT_WIDTH{1'b0}};
assign ARVALID_o      = dbg.msel[AXIRD_SEL] | data.msel[AXIRD_SEL] | inst.msel[AXIRD_SEL];

assign RREADY_o       = 1'b1;

endmodule

