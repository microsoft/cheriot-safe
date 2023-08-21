
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



module msftDvIp_riscv_cheri_debug_reg #(
    parameter DATA_WIDTH=33,                                                                                    // Cheri Diff
    parameter DMI_ADDR_BITS=7
  )   (
  input                               clk_i,
  input                               rstn_i,
  output                              hartrst_o,

  input                               psel_dmi_i,
  input                               penable_dmi_i,
  input  [DMI_ADDR_BITS-1:0]          paddr_dmi_i,
  input  [DATA_WIDTH-1:0]             pwdata_dmi_i,
  input                               pwrite_dmi_i,
  
  output [DATA_WIDTH-1:0]             prdata_dmi_o,
  output                              pready_dmi_o,
  output                              pslverr_dmi_o,

  output                              debug_req_o,
  input                               debug_req_ack_i,
  output                              debug_resume_o,
  input                               debug_resume_ack_i,

  output                              debug_transfer_scr_o,                                                     // Cheri Add
  output                              debug_transfer_pgmb_o,
  output                              debug_transfer_csr_o,
  output                              debug_transfer_reg_o,
  input                               debug_transfer_ack_i,

  output                              dmactive_o,

  input                               halted_i,

  input                               prog_buf_en_i,
  input  [7:0]                        prog_buf_addr_i,
  output reg [31:0]                   prog_buf_rdata_o,
  output                              prog_buf_ready_o,
  output                              prog_buf_error_o,

  output                              ac_en_o,
  output [3:0]                        ac_addr_o,
  output [DATA_WIDTH-1:0]             ac_wdata_o,
  output                              ac_write_o,
  input  [DATA_WIDTH-1:0]             ac_rdata_i,

  input                               dbg_gnt_i,
  output                              dbg_req_o,
  output [31:0]                       dbg_addr_o,
  output [DATA_WIDTH-1:0]             dbg_wdata_o,
  output                              dbg_we_o,
  output [3:0]                        dbg_be_o,
  input  [DATA_WIDTH-1:0]             dbg_rdata_i,
  input                               dbg_rvalid_i,
  input                               dbg_error_i,
  output reg                          cap_wr_valid_o,
  input                               cap_rd_valid_i

);



//=================================================
// Parameters
//=================================================
localparam ABSTRACT_DATA0                  = 8'h04;
localparam ABSTRACT_DATA11                 = 8'h0f;

localparam DEBUG_CONTROL_MODULE            = 8'h10;
localparam DEBUG_MODULE_STATUS             = 8'h11;
localparam HART_INFO                       = 8'h12;
localparam HALT_SUMMARY                    = 8'h13;
localparam HART_ARRAY_WINDOW_SELECT        = 8'h14;
localparam HART_ARRAY_WINDOW               = 8'h15;
localparam ABSTRACT_CONTROL_AND_STATUS     = 8'h16;
localparam ABSTRACT_COMMAND                = 8'h17;
localparam ABSTRACT_COMMAND_AUTOEXEC       = 8'h18;
localparam DEVICE_TREE_ADDR_0              = 8'h19;
localparam DEVICE_TREE_ADDR_1              = 8'h1a;
localparam DEVICE_TREE_ADDR_2              = 8'h1b;
localparam DEVICE_TREE_ADDR_3              = 8'h1c;

localparam PROGRAM_BUFFER_0                = 8'h20;
localparam PROGRAM_BUFFER_15               = 8'h2f;

localparam AUTHENTICATION_DATA             = 8'h30;

localparam SYSTEM_BUS_ACCESS_AND_CONTROL   = 8'h38;
localparam SYSTEM_BUS_ADDRESS_31_0         = 8'h39;
localparam SYSTEM_BUS_ADDRESS_63_32        = 8'h3a;
localparam SYSTEM_BUS_ADDRESS_95_64        = 8'h3b;
localparam SYSTEM_BUS_DATA_31_0            = 8'h3c;
localparam SYSTEM_BUS_DATA_63_32           = 8'h3d;
localparam SYSTEM_BUS_DATA_95_64           = 8'h3e;
localparam SYSTEM_BUS_DATA_127_96          = 8'h3f;

localparam HALT_REGION_0                   = 8'h40;
localparam HALT_REGION_31                  = 8'h5f;

//=================================================
// Register/Wires
//=================================================
reg [DATA_WIDTH-1:0]  rdata;


reg             haltreq;
reg             resumereq;
reg             hartreset;
reg             hasel;
reg [9:0]       hartsel;
reg             ndmreset;
reg             dmactive;
reg             cap_valid;

//=================================================
// Assignments
//=================================================
assign  prdata_dmi_o = rdata;
assign  pready_dmi_o = 1'b1;
assign  pslverr_dmi_o = 1'b0;

assign dmi_acc = psel_dmi_i & penable_dmi_i;
assign dmi_wr = dmi_acc &  pwrite_dmi_i;
assign dmi_rd = dmi_acc & ~pwrite_dmi_i;
assign dmactive_o = dmactive;

//=================================================
// Program Buffer
//=================================================
reg [31:0] prog_buf [2];
reg [3:0] prog_buf_sel;

wire  [2:0]         dmerr;
wire                impbreak;
wire                allhavereset;
wire                anyhavereset;
wire                allresumeack;
wire                anyresumeack;
wire                allnonexistent;
wire                allunavail;
wire                anyunavail;
wire                allrunning;
wire                anyrunning;
wire                allhalted;
wire                anyhalted;
wire                authenticated;
wire                authbusy;
wire                devtreevalid;
wire [3:0]          version;

//=================================================
// DM Control
//=================================================
assign debug_req_o = haltreq;
assign debug_resume_o = resumereq;

assign dmctrl_wr = dmi_wr & (paddr_dmi_i == DEBUG_CONTROL_MODULE);

assign hartsel0 = hartsel == 10'h000;

assign dmerr = 3'h0;
assign impbreak = 1'b1;
assign allhavereset = hartreset & hartsel0;
assign anyhavereset = hartreset & hartsel0;
assign allresumeack = ~resumereq;
assign anyresumeack = ~resumereq;
assign allnonexistent = ~hartsel0;
assign anynonexistent = ~hartsel0;
assign allunavail = ~hartsel0;
assign anyunavail = ~hartsel0;
assign allrunning = ~halted_i & hartsel0;
assign anyrunning = ~halted_i & hartsel0;
assign allhalted = halted_i & hartsel0;
assign anyhalted = halted_i & hartsel0;
assign authenticated = 1'b1;
assign authbusy = 1'b0;
assign devtreevalid = 1'b0;
assign version = 4'h2;

assign hartrst_o = hartreset;

wire [31:0] dmctrl = {haltreq, resumereq, hartreset, 2'h0, hasel, hartsel, 14'h0000, ndmreset, dmactive};

wire [31:0] dmi_status = {5'h0, dmerr, 1'b0, impbreak, 2'h0, allhavereset, anyhavereset, allresumeack, anyresumeack, allnonexistent, anynonexistent, allunavail, anyunavail, allrunning, anyrunning, allhalted, anyhalted, authenticated, authbusy, 1'b0, devtreevalid, version};

//=================================================
// DM Control Register (0x10)
//=================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    haltreq <= 1'b0;
    resumereq <= 1'b0;
    hartreset <= 1'b0;
    hasel <= 1'b0;
    hartsel <= 10'h0;
    ndmreset <= 1'b0;
    dmactive <= 1'b0;
  end else begin
    if(dmctrl_wr) begin
      dmactive  <= pwdata_dmi_i[0];
    end
    if(dmactive) begin
      if(dmctrl_wr) begin
        haltreq   <= pwdata_dmi_i[31];
        resumereq <= pwdata_dmi_i[30];
        hartreset <= pwdata_dmi_i[29];
        hasel     <= pwdata_dmi_i[26];
//        hartsel   <= pwdata_dmi_i[25:16]; // Only one hart is available so this needs to be 0
        ndmreset  <= pwdata_dmi_i[1];
      end else if(halted_i) begin
        haltreq <= 1'b0;
      end else if(~halted_i) begin
        resumereq <= 1'b0;
      end
    end else begin
      haltreq <= 1'b0;
      resumereq <= 1'b0;
      hartreset <= 1'b0;
      hasel <= 1'b0;
      hartsel <= 10'h0;
      ndmreset <= 1'b0;
    end
  end
end

//=================================================
// Hart INFO, Summary and region
//=================================================
localparam NSCRATCH = 4'h1;      // Only allow 1 Scratch Register
localparam DATAACCESS = 1'b1;    // DATA registers are shadowed in memory map.
localparam DATASIZE = 4'h0;      // TODO: Figure out what this means
localparam DATAADDR = 12'h000;   // TODO: Find the correct address

wire [31:0] hart_info = {8'h00, NSCRATCH, 3'h0, DATAACCESS, DATASIZE, DATAADDR};
wire [31:0] halt_summary = {31'h0000_0000, halted_i };
wire [31:0] halt_region_0 = {31'h0000_0000, halted_i};

//=================================================
// System Bus
//=================================================
localparam SB_IDLE       = 3'h0;
localparam SB_READ       = 3'h1;
localparam SB_READ_RESP  = 3'h2;
localparam SB_WRITE      = 3'h3;
localparam SB_WRITE_RESP = 3'h4;

reg [2:0]             sb_state;
reg [DATA_WIDTH-1:0]  sb_rdata;
reg [31:0]            sb_addr_31_0;
reg [DATA_WIDTH-1:0]  sb_data_bus;
reg                   sb_autoincrement;
reg                   sb_autoread;
reg  [3:0]            sb_access;
reg  [2:0]            sb_error;

wire                  sb_incr_addr;
wire [2:0]            sb_incr_val;
wire [31:0]           sb_acc_ctrl_stat;
wire [3:0]            be_byte, be_hword, be_word;

localparam SB_VERSION    = 3'h1;
localparam SB_SIZE       = 7'h20; 
localparam SB_ACCESS_128 = 1'b0;
localparam SB_ACCESS_64  = 1'b0;
localparam SB_ACCESS_32  = 1'b1;
localparam SB_ACCESS_16  = 1'b1;
localparam SB_ACCESS_8   = 1'b1;

assign sb_acc_ctrl_stat = { 11'h000, 1'b0, sb_access, sb_autoincrement, sb_autoread, sb_error, 
                            SB_SIZE, SB_ACCESS_128, SB_ACCESS_64, SB_ACCESS_32, SB_ACCESS_16, SB_ACCESS_8};

assign be_byte         = {sb_addr_31_0[1:0] == 2'h3, sb_addr_31_0[1:0] == 2'h2, sb_addr_31_0[1:0] == 2'h1, sb_addr_31_0[1:0] == 2'h0};
assign be_hword        = {sb_addr_31_0[1],           sb_addr_31_0[1],           sb_addr_31_0[0],           sb_addr_31_0[0]};
assign be_word         = 4'hf;

assign dbg_req_o       = (sb_state == SB_READ) || (sb_state == SB_WRITE);
assign dbg_addr_o      = sb_addr_31_0;
assign dbg_wdata_o     = sb_data_bus;
assign dbg_we_o        = sb_state == SB_WRITE;
assign dbg_be_o        = (sb_access == 4'h2) ? be_word : (sb_access == 4'h1) ? be_hword : be_byte;

assign sb_ctrl_wr      = dmi_wr & (paddr_dmi_i == SYSTEM_BUS_ACCESS_AND_CONTROL);
assign sb_addr_wr      = dmi_wr & (paddr_dmi_i == SYSTEM_BUS_ADDRESS_31_0);
assign sb_data_wr      = dmi_wr & (paddr_dmi_i == SYSTEM_BUS_DATA_31_0);
assign sb_incr_val     = {sb_access[1:0], 1'b0};
assign sb_incr_addr    = ((sb_state == SB_READ_RESP) | (sb_state == SB_WRITE_RESP)) & dbg_rvalid_i & sb_autoincrement;

assign sb_rd_single_rd = sb_ctrl_wr & pwdata_dmi_i[20];
assign sb_rd_data      = dmi_rd & (paddr_dmi_i == SYSTEM_BUS_DATA_31_0) & sb_autoread;
assign sb_rd_start     = sb_rd_data | sb_rd_single_rd;

assign sb_wr_data      = dmi_wr & (paddr_dmi_i == SYSTEM_BUS_DATA_31_0);
assign sb_wr_start     = sb_wr_data;

//=================================================
// System Bus Access Control and Status (0x38)
//=================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    sb_autoincrement <= 1'b0;
    sb_access <= 3'h2;
    sb_autoread <= 1'b0;
    sb_addr_31_0 <= 32'h0000_0000;
    sb_data_bus  <= 32'h0000_0000;
  end else begin
    if(dmactive) begin
      // Control/Status Register
      if(sb_ctrl_wr) begin
        sb_access         <= pwdata_dmi_i[19:17];
        sb_autoincrement  <= pwdata_dmi_i[16];
        sb_autoread       <= pwdata_dmi_i[15];
      end

      // Address register
      if(sb_incr_addr) begin
        sb_addr_31_0 <= sb_addr_31_0 + sb_incr_val;
      end else if(sb_addr_wr) begin
        sb_addr_31_0 <= pwdata_dmi_i;
      end

      // Data register
      if(sb_data_wr) begin
        sb_data_bus <= pwdata_dmi_i;
      end
    end
  end
end

//=================================================
// System Bus State Machine
//=================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    sb_state <= SB_IDLE;
    sb_rdata <= 32'h0000_0000;
    sb_error <= 2'h0;
  end else begin
    casez(sb_state)
      SB_IDLE: begin
        if(sb_wr_start) begin
          sb_state <= SB_WRITE;
        end else if(sb_rd_start) begin
          sb_state <= SB_READ;
        end
      end
      SB_READ: begin
        if(dbg_gnt_i) begin
          sb_state <= SB_READ_RESP;
        end
      end
      SB_READ_RESP: begin
        if(dbg_rvalid_i) begin
          sb_state <= SB_IDLE;
          sb_rdata <= dbg_rdata_i;
          sb_error[1] <= dbg_error_i;
        end
      end
      SB_WRITE: begin
        if(dbg_gnt_i) begin
          sb_state <= SB_WRITE_RESP;
        end
      end
      SB_WRITE_RESP: begin
        if(dbg_rvalid_i) begin
          sb_state <= SB_IDLE;
          sb_error[1] <= dbg_error_i;
        end
      end
    endcase
  end
end

//=================================================
// Abstract Commands
//=================================================
localparam PROG_BUF_SIZE       = 5'h02;
localparam AC_DATA_REG_SIZE    = 5'h02;

localparam AR_ZERO             = 5'h0;
localparam AR_S0               = 5'h8;
localparam OP_LW               = 7'h03;
localparam OP_SW               = 7'h23;
localparam OP_CSRRW            = 7'h73;
localparam OP_WORD             = 3'h2;
localparam ABS_OFFSET0         = 12'h3f0;
localparam ABS_OFFSET1         = 12'h3f4;

// Cheri 
localparam OP_CAP              = 3'h3;                                                                          // Cheri Add
localparam OP_CHERI            = 7'h5b;                                                                         // Cheri Add
localparam ABS_OFFSET2         = 12'h3f8;                                                                       // Cheri Add
localparam ABS_OFFSET3         = 12'h3fc;                                                                       // Cheri Add

reg [7:0]   ac_cmdtype;
reg [2:0]   ac_size;
reg         ac_postexec;
reg         ac_transfer;
reg         ac_write;
reg [15:0]  ac_regno;
reg [2:0]   ac_cmderr;

wire        ac_busy;
wire [31:0] ac_cmd;
wire [31:0] ac_status;

assign ac_en_o = dmi_acc & (paddr_dmi_i[DMI_ADDR_BITS-1:4] == 4'h0) & (paddr_dmi_i[3:2] != 2'h0);
assign ac_addr_o = paddr_dmi_i[3:0] - 3'h4;
assign ac_wdata_o = pwdata_dmi_i;
assign ac_write_o = pwrite_dmi_i;
assign ac_busy = ac_transfer;

assign ac_cmd_wr = dmi_wr & (paddr_dmi_i[DMI_ADDR_BITS-1:0] == ABSTRACT_COMMAND);

assign ac_cmd = {ac_cmdtype, 1'b0, ac_size, 1'b0, ac_postexec, ac_transfer, ac_write, ac_regno};
assign ac_status = {3'h0, PROG_BUF_SIZE, 11'h000, ac_busy, 1'b0, ac_cmderr, 3'h0, AC_DATA_REG_SIZE};

assign valid_tx_size = ac_size == 3'h2;
assign debug_transfer_csr_o  = ac_transfer & (ac_regno[15:12] == 4'h0) & valid_tx_size;
assign debug_transfer_reg_o  = ac_transfer & (ac_regno[15:12] == 4'h1) & valid_tx_size;
assign debug_transfer_scr_o  = ac_transfer & (ac_regno[15:12] == 4'h2) & valid_tx_size;                         // Cheri Add
assign debug_transfer_pgmb_o = ac_postexec & ~ac_transfer;

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    ac_cmdtype <= 8'h00;
    ac_size <= 3'h0;
    ac_postexec <= 1'b0;
    ac_transfer <= 1'b0;
    ac_write    <= 1'b0;
    ac_cmderr   <= 3'h0;
    ac_regno    <= 16'h0000;
  end else begin
    if(dmactive) begin
      if(ac_cmd_wr) begin
        ac_cmdtype <= pwdata_dmi_i[31:24];
        ac_size <= pwdata_dmi_i[22:20];
        ac_postexec <= pwdata_dmi_i[18];
        ac_transfer <= pwdata_dmi_i[17];
        ac_write <= pwdata_dmi_i[16];
        ac_regno <= pwdata_dmi_i[15:0];
      end else if(ac_transfer & ~valid_tx_size) begin
        ac_transfer <= 1'b0;
        ac_cmderr <= 3'h2;
      end else if(debug_transfer_ack_i) begin
        if(ac_transfer) begin
          ac_transfer <= 1'b0;
          ac_cmderr <= 3'h0;
        end else begin
          ac_postexec <= 1'b0;
        end
      end
    end else begin
      ac_cmdtype <= 8'h00;
      ac_size <= 3'h0;
      ac_postexec <= 1'b0;
      ac_transfer <= 1'b0;
      ac_write    <= 1'b0;
      ac_regno    <= 16'h0000;
      ac_cmderr   <= 3'h0;
    end
  end
end

//=================================================
// Misc DM Registers
//=================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    prog_buf[0]  <= 32'h0000_0000;
    prog_buf[1]  <= 32'h0000_0000;
    cap_wr_valid_o    <= 1'b0;
  end else begin
    if(psel_dmi_i & penable_dmi_i & pwrite_dmi_i) begin
      casez(paddr_dmi_i)
        'h1f: cap_wr_valid_o   <= pwdata_dmi_i[0];
        'h20: prog_buf[0]      <= pwdata_dmi_i;
        'h21: prog_buf[1]      <= pwdata_dmi_i;
      endcase
    end
  end
end

//=================================================
// Read Registers
//=================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    rdata <= 32'h0000_0000;
  end else begin
    if(psel_dmi_i & (~pready_dmi_o | ~penable_dmi_i ) ) begin
      casez(paddr_dmi_i)
        'b0000_1???,
        'b0000_?1??: rdata <= ac_rdata_i;

        'h10: rdata <= dmctrl;
        'h11: rdata <= dmi_status;
        'h12: rdata <= hart_info;
        'h13: rdata <= halt_summary;

        'h16: rdata <= ac_status;
        'h17: rdata <= ac_cmd;

        'h1f: rdata <= {15'h0000, cap_rd_valid_i, 15'h0000, cap_wr_valid_o};
        'h20: rdata <= prog_buf[0];
        'h21: rdata <= prog_buf[1];

        'h38: rdata <= sb_acc_ctrl_stat;
        'h39: rdata <= sb_addr_31_0;
        'h3C: rdata <= sb_rdata;

        'h40: rdata <= halt_region_0;

        default: rdata <= 32'h0000_0000;
      endcase
    end else begin
      rdata <= 32'h0000_0000;
    end
  end
end

//=================================================
// Program Buffer
//=================================================
wire [31:0] lw_inst = {ABS_OFFSET0, AR_ZERO,       OP_WORD,   ac_regno[4:0], OP_LW};
wire [31:0] sw_inst = {ABS_OFFSET0[11:5], ac_regno[4:0], AR_ZERO, OP_WORD, ABS_OFFSET0[4:0], OP_SW};
wire [31:0] lc_inst = {ABS_OFFSET0, AR_ZERO,       OP_CAP,   ac_regno[4:0], OP_LW};                             // Cheri Add
wire [31:0] sc_inst = {ABS_OFFSET0[11:5], ac_regno[4:0], AR_ZERO, OP_CAP, ABS_OFFSET0[4:0], OP_SW};             // Cheri Add
wire [31:0] ebreak_inst = {12'h001, 5'h00, 3'h0, 5'h0, 7'h73};
wire [31:0] csrr_inst = {ac_regno[11:0], AR_ZERO, 3'h2, AR_S0, OP_CSRRW};
wire [31:0] csrw_inst = {ac_regno[11:0], AR_S0, 3'h1, AR_ZERO, OP_CSRRW};
wire [31:0] scrr_inst = {7'h1, ac_regno[4:0], AR_ZERO, 3'h0, AR_S0, OP_CHERI};                                  // Cheri Add
wire [31:0] scrw_inst = {7'h1, ac_regno[4:0], AR_S0, 3'h0, AR_ZERO, OP_CHERI};                                  // Cheri Add

wire [31:0] lw_s0_inst     = {ABS_OFFSET0, AR_ZERO, OP_WORD, AR_S0, OP_LW};
wire [31:0] sw_s0_inst     = {ABS_OFFSET0[11:5], AR_S0, AR_ZERO,  OP_WORD, ABS_OFFSET0[4:0], OP_SW};
wire [31:0] lw_s0_res_inst = {ABS_OFFSET1, AR_ZERO, OP_WORD, AR_S0, OP_LW};
wire [31:0] sw_s0_sav_inst = {ABS_OFFSET1[11:5], AR_S0, AR_ZERO,  OP_WORD, ABS_OFFSET1[4:0], OP_SW};

wire [31:0] lc_s0_inst     = {ABS_OFFSET0, AR_ZERO, OP_CAP, AR_S0, OP_LW};                                      // Cheri Add
wire [31:0] sc_s0_inst     = {ABS_OFFSET0[11:5], AR_S0, AR_ZERO,  OP_CAP, ABS_OFFSET0[4:0], OP_SW};             // Cheri Add
wire [31:0] lc_s0_res_inst = {ABS_OFFSET2, AR_ZERO, OP_CAP, AR_S0, OP_LW};                                      // Cheri Add
wire [31:0] sc_s0_sav_inst = {ABS_OFFSET2[11:5], AR_S0, AR_ZERO,  OP_CAP, ABS_OFFSET2[4:0], OP_SW};             // Cheri Add

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    prog_buf_rdata_o <= 32'h0000_0000;
  end else begin
    if(prog_buf_en_i) begin
      casez(prog_buf_addr_i) 
        // Program Buffer
        8'h00: prog_buf_rdata_o <= prog_buf[0];
        8'h04: prog_buf_rdata_o <= prog_buf[1];

        // REG Transfer
        8'h80: prog_buf_rdata_o <= (ac_write) ? lc_inst : sc_inst;                                              // Cheri Diff
  
        // CSR Transfer
        8'h90: prog_buf_rdata_o <= sc_s0_sav_inst;                                                              // Cheri Diff
        8'h94: prog_buf_rdata_o <= (ac_write) ? lw_s0_inst  : csrr_inst;
        8'h98: prog_buf_rdata_o <= (ac_write) ? csrw_inst   : sw_s0_inst;
        8'h9c: prog_buf_rdata_o <= lc_s0_res_inst;                                                              // Cheri Add

        // CHERI SCR Transfer
        8'hb0: prog_buf_rdata_o <= sc_s0_sav_inst;                                                              // Cheri Add
        8'hb4: prog_buf_rdata_o <= (ac_write) ? lc_s0_inst  : scrr_inst;                                        // Cheri Add
        8'hb8: prog_buf_rdata_o <= (ac_write) ? scrw_inst   : sc_s0_inst;                                       // Cheri Add
        8'hbc: prog_buf_rdata_o <= lc_s0_res_inst;                                                              // Cheri Add

        default: prog_buf_rdata_o <= ebreak_inst;
      endcase
    end else begin
      prog_buf_rdata_o <= 32'h0000_0000;
    end
    prog_buf_sel <= prog_buf_addr_i;
  end
end

assign prog_buf_ready_o = 1'b1;
assign prog_buf_error_o = 1'b0;

endmodule
