
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



module msftDvIp_riscv_cheri_mem #(
    parameter DATA_WIDTH=33                                                                           // Cheri Diff
  )  (
  input                         clk_i,
  input                         rstn_i,

  input                         DBGMEM_EN_i,
  input      [31:0]             DBGMEM_ADDR_i,
  input      [DATA_WIDTH-1:0]   DBGMEM_WDATA_i,
  input                         DBGMEM_WE_i,
  input      [3:0]              DBGMEM_BE_i,
  output reg [DATA_WIDTH-1:0]   DBGMEM_RDATA_o,
  output reg                    DBGMEM_READY_o,
  output reg                    DBGMEM_ERROR_o,

  output                        ROM_EN_o,
  output  [11:0]                ROM_ADDR_o,
  input   [DATA_WIDTH-1:0]      ROM_RDATA_i,
  input                         ROM_READY_i,
  input                         ROM_ERROR_i,

  input                         dmactive_i,

  output                        debug_req_ack_o,

  input                         debug_resume_i,
  output                        debug_resume_ack_o,

  output                        halted_o,

  input                         debug_transfer_pgmb_i,
  input                         debug_transfer_scr_i,
  input                         debug_transfer_csr_i,
  input                         debug_transfer_reg_i,
  output                        debug_transfer_ack_o,

  input                         ac_en_i,
  input [3:0]                   ac_addr_i,
  input [DATA_WIDTH-1:0]        ac_wdata_i,
  input                         ac_write_i,
  output [DATA_WIDTH-1:0]       ac_rdata_o,

  output                        prog_buf_en_o,
  output [7:0]                  prog_buf_addr_o,
  input  [31:0]                 prog_buf_rdata_i,
  input                         prog_buf_ready_i,
  input                         prog_buf_error_i,

  input                         cap_wr_valid_i,
  output                        cap_rd_valid_o
);


//============================================
// Debug Memory Map
//   FLAG0: 0x100-0x110"
//    PGMB: 0x300-0x3ff"
//   FLAG1: 0x400-0x7ff"
//     ROM: 0x800-0xfff"
// 
//    HALTING: 0x100
//      GOING: 0x104
//   RESUMING: 0x108
//  EXCEPTION: 0x10C
//============================================
localparam RAM_ADDR = 18'h3f;

reg [3:0]   mem_sel;
reg [31:0]  pmb_reg;

reg         halted;
reg         exception;

reg [32:0]  ram_reg [4];                                                                              // Cheri Diff

reg         dbg_en;
reg [7:0]   dbg_addr;
reg         flag0_sel;
reg         pgmb_sel;
reg         flag1_sel;
reg         rom_sel;
reg         ram_sel;

assign halted_o = halted;

assign addr_sel      = DBGMEM_EN_i && DBGMEM_ADDR_i[31:12] == 20'h0000_0;
assign wr_addr_sel   = addr_sel &  DBGMEM_WE_i;
assign rd_addr_sel   = addr_sel & ~DBGMEM_WE_i;

assign flag0_acc     = rd_addr_sel     &&  DBGMEM_ADDR_i[11:8]  == 4'h1;      // FLAG0 0x100 - 0x1ff
assign prgmb_acc     = rd_addr_sel     &&  DBGMEM_ADDR_i[11:8]  == 4'h3;      // PGMB  0x300 - 0x37f
assign flag1_acc     = rd_addr_sel     &&  DBGMEM_ADDR_i[11:10] == 2'h1;      // FLAG1 0x400 - 0x7ff
assign rom_acc       = rd_addr_sel     &&  DBGMEM_ADDR_i[11];                 // ROM   0x800 - 0xfff
assign ram_acc       = rd_addr_sel     &&  DBGMEM_ADDR_i[11:4]  == RAM_ADDR;  // RAM Location 

assign ram_wr        = wr_addr_sel    &&  DBGMEM_ADDR_i[11:4] == RAM_ADDR;    // RAM Write
assign halted_wr     = wr_addr_sel    &&  DBGMEM_ADDR_i[11:0] == 12'h100;
assign transfer_wr   = wr_addr_sel    &&  DBGMEM_ADDR_i[11:0] == 12'h104;
assign resuming_wr   = wr_addr_sel    &&  DBGMEM_ADDR_i[11:0] == 12'h108;
assign exception_wr  = wr_addr_sel    &&  DBGMEM_ADDR_i[11:0] == 12'h10C;

assign debug_req_ack_o = halted_wr;
assign debug_resume_ack_o = resuming_wr;
assign debug_transfer_ack_o = transfer_wr;

assign ROM_EN_o        = rom_acc;
assign ROM_ADDR_o      = DBGMEM_ADDR_i[10:0];

assign prog_buf_en_o   = prgmb_acc;
assign prog_buf_addr_o = DBGMEM_ADDR_i[7:0];

//==================================
// Debugger State
//==================================
always @(posedge clk_i or negedge rstn_i) 
begin
  if(~rstn_i) begin
    halted    <= 1'b0;
    exception <= 1'b0; 
  end else begin
    if(halted_wr) begin
      halted <= 1'b1;
    end else if(resuming_wr| transfer_wr) begin
      halted <= 1'b0;
    end
    if(exception_wr) begin
      exception <= 1'b1;
    end
  end
end

//==================================
// Abstract Memory
//==================================
assign ac_rdata_o = ram_reg[ac_addr_i[1:0]];                                                          // Cheri Diff
wire [31:0] ac0_data = ram_reg[0];
wire [31:0] ac1_data = ram_reg[1];
assign cap_rd_valid_o = ram_reg[1][32];

always @(posedge clk_i or negedge rstn_i) 
begin
  if(~rstn_i) begin
    ram_reg[0] <= {DATA_WIDTH{1'b0}};
    ram_reg[1] <= {DATA_WIDTH{1'b0}};
    ram_reg[2] <= {DATA_WIDTH{1'b0}};                                                                  // Cheri Add
    ram_reg[3] <= {DATA_WIDTH{1'b0}};                                                                  // Cheri Add
  end else begin
    if(ram_wr & dmactive_i) begin
      ram_reg[DBGMEM_ADDR_i[3:2]] <= DBGMEM_WDATA_i;                                                  // Cheri Diff
    end else if(ac_en_i) begin
      if(ac_write_i) begin
        ram_reg[ac_addr_i[1:0]] <= ac_wdata_i;                                                        // Cheri Diff
      end
    end
  end
end

//==================================
// Memory Read Select
//==================================
always @(posedge clk_i or negedge rstn_i) 
begin
  if(~rstn_i) begin
    dbg_en <= 1'b0;
    dbg_addr <= 8'h00;
    flag0_sel <= 1'b0;
    pgmb_sel <= 1'b0;
    flag1_sel <= 1'b0;
    rom_sel <= 1'b0;
    ram_sel <= 1'b0;
  end else begin
    dbg_en    <= addr_sel;
    dbg_addr  <= DBGMEM_ADDR_i[7:0];
    flag0_sel <= flag0_acc;
    pgmb_sel  <= prgmb_acc;
    flag1_sel <= flag1_acc;
    rom_sel <= rom_acc;
    ram_sel <= ram_acc;
  end
end

//==================================
// Memory Read 
//==================================
always @*
begin
  DBGMEM_RDATA_o = {DATA_WIDTH{1'b0}};
  DBGMEM_READY_o = 1'b1;
  DBGMEM_ERROR_o = 1'b0;
  if(dbg_en & dmactive_i) begin
    if(rom_sel) begin
      DBGMEM_RDATA_o = ROM_RDATA_i;
      DBGMEM_READY_o = ROM_READY_i;
      DBGMEM_ERROR_o = ROM_ERROR_i;
    end else if(ram_sel) begin
      DBGMEM_RDATA_o = {cap_wr_valid_i, ram_reg[dbg_addr[2]][31:0]};
      DBGMEM_READY_o = prog_buf_ready_i;
      DBGMEM_ERROR_o = prog_buf_error_i;
    end else if(pgmb_sel) begin
      DBGMEM_RDATA_o = prog_buf_rdata_i;
      DBGMEM_READY_o = prog_buf_ready_i;
      DBGMEM_ERROR_o = prog_buf_error_i;
    end else if(flag1_sel) begin
      if(dbg_addr == 8'h00) begin
        DBGMEM_RDATA_o = {27'h000_0000, debug_transfer_scr_i, debug_transfer_csr_i,
                         debug_transfer_reg_i, debug_resume_i, debug_transfer_pgmb_i};
      end else begin
        DBGMEM_ERROR_o = 1'b1;
      end
    end else begin
      DBGMEM_ERROR_o = 1'b1;
    end
  end
end

endmodule
