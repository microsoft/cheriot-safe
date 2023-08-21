
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



module msftDvIp_i2c_sub #(
    parameter FIFO_DEPTH=8
  )  (
  input         pclk_i,
  input         prstn_i,

  input         psel_i,
  input         penable_i,
  input  [7:0]  paddr_i,
  input [31:0]  pwdata_i,
  input         pwrite_i,
  
  output [31:0] prdata_o,
  output        pready_o,
  output        psuberr_o,

  output        scl_oen_o,
  output        sda_oen_o,

  input         scl_in_i,
  input         sda_in_i,

  output        irq_o
);

//========================================================
// Parameters
//========================================================
localparam I2C_SUB_IDLE            = 5'h0;
localparam I2C_SUB_HS_IDLE         = 5'h1;
localparam I2C_SUB_START           = 5'h2;
localparam I2C_SUB_ADDR            = 5'h3;
localparam I2C_SUB_10BIT_ADDR      = 5'h4;
localparam I2C_SUB_RDWR            = 5'h5;
localparam I2C_SUB_ADDR_ACK        = 5'h6;
localparam I2C_SUB_10BIT_ACK       = 5'h7;
localparam I2C_SUB_HS_ADDR         = 5'h8;
localparam I2C_SUB_READ            = 5'h9;
localparam I2C_SUB_READ_ACK        = 5'ha;
localparam I2C_SUB_WRITE           = 5'hb;
localparam I2C_SUB_WRITE_ACK       = 5'hc;
localparam I2C_SUB_10BIT_RST_WAIT  = 5'hd;
localparam I2C_SUB_10BIT_RST_ADDR  = 5'he;
localparam I2C_SUB_10BIT_RST_ACK   = 5'hf;
localparam I2C_SUB_WAIT_4_STOP     = 5'h10;

localparam I2C_CTRL0_ADDR          = 6'h0;
localparam I2C_ADDR_STAT_ADDR      = 6'h1;
localparam I2C_STAT_ADDR           = 6'h2;
localparam I2C_FIFO_ADDR           = 6'h3;
localparam I2C_INTEN_ADDR          = 6'h4;

//========================================================
// Register/Wire definitions
//========================================================
wire                        clk;
wire                        rstn;

reg [31:0]                  prdata;

// Detectors
reg [2:0]                   sck_sync;
reg [2:0]                   sda_sync;
reg                         sda_cap;
reg                         sub_rd;
reg                         sub_fifo_wr;

// Control registers
reg [31:0]                  sub_ctrl0;
reg [31:0]                  sub_inten;

// Clocks

// Slave
reg [4:0]                   sub_state;
reg [3:0]                   sub_i2c_cnt;
reg [1:0]                   sub_addr_save;
reg                         sub_hs_det;
reg                         sub_i2c_scl;
reg                         sub_i2c_sda;
reg [7:0]                   sub_data;
reg                         sub_fifo_ovr;
reg                         sub_fifo_udr;
reg                         sub_start_det;
reg                         sub_stop_det;
reg                         sub_clr_fifo;
reg [9:0]                   sub_addr_stat;
reg [3:0]                   dly_cnt;

wire                        sub_enable;
wire [9:0]                  sub_addr;
wire [1:0]                  sub_mode;
wire [31:0]                 sub_addr_stat_reg;

wire                        sub_rd_fifo;
wire                        sub_wr_fifo;
wire                        sub_fifo_full;
wire                        sub_fifo_empty;
wire [7:0]                  sub_frdata;
wire [7:0]                  sub_fwdata;
wire [5:0]                  sub_fifo_cnt;
wire                        sub_i2c_cnt0;
wire [31:0]                 sub_status;
wire                        sub_wr_stat;
wire                        sub_rd_stat;
wire                        sub_ovr_run;
wire                        sub_udr_run;
wire [9:0]                  sub_10bit_rcv_addr;
wire [9:0]                  sub_mask;


wire                        sck_rise;
wire                        sck_fall;
wire                        sda_rise;
wire                        sda_fall;

//========================================================
// Assignments
//========================================================
assign clk        = pclk_i;
assign rstn       = prstn_i;

assign prdata_o   = prdata;
assign pready_o   = 1'b1;
assign psuberr_o  = 1'b0;

assign scl_oen_o  = sub_i2c_scl;
assign sda_oen_o  = sub_i2c_sda;

// SUB_CTRL0
assign sub_enable      = sub_ctrl0[0];
assign sub_addr        = sub_ctrl0[10:1];
assign sub_mode        = sub_ctrl0[12:11];
assign sub_mask        = sub_ctrl0[31:22];

assign sub_10bit_addr = sub_ctrl0[10:1];
assign sub_10_up_addr = sub_ctrl0[10:9];

assign sub_fifo_access  = psel_i & penable_i & pready_o & (paddr_i[7:2] == I2C_FIFO_ADDR);

//assign sub_i2c_wr = (sub_state == I2C_SUB_WRITE) & sck_fall & sub_i2c_cnt0;
assign sub_i2c_rd  = (sub_state == I2C_SUB_READ_ACK) & sck_fall;
assign sub_rd_fifo = (sub_rd) ? sub_i2c_rd                   : sub_fifo_access & ~pwrite_i;
assign sub_wr_fifo = (sub_rd) ? sub_fifo_access &  pwrite_i  : sub_fifo_wr;
assign sub_fwdata  = (sub_rd) ? pwdata_i : sub_data;

assign sub_clr_fifo_n = rstn & sub_enable & ~sub_clr_fifo;
assign sub_rd_req = (sub_state == I2C_SUB_READ) & sub_fifo_empty;
assign sub_addr_stat_reg = {22'h000000, sub_addr_stat};

assign sub_stat_decode = paddr_i[7:2] == I2C_STAT_ADDR;
assign sub_i2c_idle = sub_state == I2C_SUB_IDLE;
assign sub_fifo_cnt[5:4] = 2'h0;
assign sub_wr_stat = psel_i & penable_i &  pwrite_i & pready_o & sub_stat_decode;
assign sub_rd_stat = psel_i & penable_i & ~pwrite_i & pready_o & sub_stat_decode;
assign sub_status = {3'h0, sub_state, 2'h0, sub_fifo_cnt, sub_fifo_full, sub_fifo_empty, sub_fifo_ovr, sub_fifo_udr, sck_sync[0], sda_sync[0], 6'h0, sub_rd_req, sub_stop_det, sub_start_det, sub_i2c_idle};

// Detect
assign sck_rise = sck_sync == 3'h3;
assign sck_fall = sck_sync == 3'h4;
assign sda_rise = sda_sync == 3'h3;
assign sda_fall = sda_sync == 3'h4;

assign sub_start = sda_fall & sck_sync == 3'h7;
assign sub_stop  = sda_rise & sck_sync == 3'h7;

assign sub_7bit_mode  = sub_mode == 2'h0;
assign sub_10bit_mode = sub_mode == 2'h1;
assign sub_hs_mode    = sub_mode == 2'h2;
assign sub_i2c_cnt0       = sub_i2c_cnt == 4'h0;

assign irq_o = (|(sub_status[15:12] & sub_inten[15:12])) | (|(sub_status[3:0] & sub_inten[3:0]));

assign sub_10bit_rcv_addr = {sub_addr_save, sub_data};
assign sub7_match  = (sub_mask[6:0] & sub_data[7:1]) == (sub_mask[6:0] & sub_addr[6:0]);
assign sub10_match = (sub_mask & sub_10bit_rcv_addr) == (sub_mask & sub_addr);

assign stretch = (dly_cnt != 0);

//========================================================
// I2C input sync
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    sck_sync <= 3'h0;
    sda_sync  <= 3'h0; 
    sda_cap   <= 1'b0;
  end else begin
    sck_sync <= {sck_sync[1:0], scl_in_i};
    sda_sync <= {sda_sync[1:0], sda_in_i};
    if(sck_rise) begin
      sda_cap <= sda_sync[2];
    end
  end
end

//========================================================
// I2C Slave Status
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    sub_fifo_ovr   <= 1'b0;
    sub_fifo_udr   <= 1'b0;
    sub_start_det  <= 1'b0;
    sub_stop_det   <= 1'b0;
  end else if(~sub_clr_fifo_n) begin
    sub_fifo_ovr   <= 1'b0;
    sub_fifo_udr   <= 1'b0;
    sub_start_det  <= 1'b0;
    sub_stop_det   <= 1'b0;
  end else begin
    sub_fifo_ovr  <= (sub_ovr_run) ? 1'b1 : (sub_rd_stat) ? 1'b0  : sub_fifo_ovr;
    sub_fifo_udr  <= (sub_udr_run) ? 1'b1 : (sub_rd_stat) ? 1'b0  : sub_fifo_udr;
    sub_start_det <= (sub_start)   ? 1'b1 : (sub_rd_stat) ? 1'b0  : sub_start_det;
    sub_stop_det  <= (sub_stop)    ? 1'b1 : (sub_rd_stat) ? 1'b0  : sub_stop_det;
  end
end

//========================================================
// I2C Slave Machine
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    sub_state <= I2C_SUB_IDLE;
    sub_i2c_cnt   <= 3'h0;
    sub_data  <= 8'h00;
    sub_hs_det <= 1'b0;
    sub_i2c_scl    <= 1'b1;
    sub_i2c_sda    <= 1'b1;
    sub_rd         <= 1'b0;
    sub_fifo_wr    <= 1'b0;
    sub_addr_save  <= 2'h0;
    sub_addr_stat  <= 10'h000;
    dly_cnt <= 4'h0;
  end else begin
    if(sub_fifo_empty) begin
      dly_cnt <= 4'hf;
    end else if(dly_cnt != 4'h0) begin
      dly_cnt <= dly_cnt - 1'b1;
    end
    sub_fifo_wr    <= 1'b0;
    if(sub_enable) begin
      if(sub_stop) begin
        sub_hs_det <= 1'b0;
        sub_state <= I2C_SUB_IDLE;
        sub_i2c_sda <= 1'b1;
      end else begin
        casez(sub_state)
          I2C_SUB_IDLE: begin
            if(sub_start & ~sub_hs_det) begin
              sub_state <= I2C_SUB_START;
            end
          end
          I2C_SUB_HS_IDLE: begin
            if(sub_start) begin
              sub_state <= I2C_SUB_START;
            end
          end
          I2C_SUB_START: begin
            if(sck_fall) begin
              sub_i2c_cnt <= 3'h7;
              sub_state <= I2C_SUB_ADDR;
            end
          end
          I2C_SUB_ADDR: begin
            if(sck_rise) begin
            end
            if(sck_fall) begin
              sub_data[sub_i2c_cnt] <= sda_cap;
              sub_i2c_cnt <= sub_i2c_cnt - 1'b1;
              if(sub_i2c_cnt0) begin
                sub_rd <= sda_cap;
                sub_state <= I2C_SUB_ADDR_ACK;
              end
            end
          end
          I2C_SUB_ADDR_ACK: begin
            sub_i2c_sda <= (sub_hs_mode & ~sub_hs_det) ? 1'b1 : (sub_10bit_mode) ? 1'b0 : ~sub7_match;
            if(sck_fall) begin
              if(sub_hs_mode & ~sub_hs_det) begin
                if(sub_data[7:3] == 5'h01) begin
                  // Set High Speed state
                  sub_hs_det <= 1'b1;
                  sub_state <= I2C_SUB_HS_IDLE;
                end else begin
                  sub_state <= I2C_SUB_WAIT_4_STOP;
                end
              end else if(sub_10bit_mode) begin
                // 10-bit address
                if(sub_data[7:3] == 5'h1e) begin
                  sub_addr_save <= sub_data[2:1];
                  sub_i2c_cnt <= 3'h7;
                  sub_state <= I2C_SUB_10BIT_ADDR;
                end else begin
                  sub_state <= I2C_SUB_WAIT_4_STOP;
                end
              end else begin
                // Normal Mode
                if(sub7_match) begin
                  sub_addr_stat <= {3'h0, sub_data[7:1]};
                  sub_i2c_cnt <= 3'h7;
                  sub_state <= (sub_rd) ? I2C_SUB_READ : I2C_SUB_WRITE;
                end else begin
                  sub_state <= I2C_SUB_WAIT_4_STOP;
                end
              end
            end
          end
          I2C_SUB_10BIT_ADDR: begin
            sub_i2c_sda <= 1'b1;
            if(sck_fall) begin
              sub_data[sub_i2c_cnt] <= sda_cap;
              sub_i2c_cnt <= sub_i2c_cnt -1'b1;
              if(sub_i2c_cnt0) begin
                sub_i2c_sda <= 1'b0;
                sub_state <= I2C_SUB_10BIT_ACK;
              end
            end
          end

          I2C_SUB_10BIT_ACK: begin
            if(sub10_match) begin
              sub_i2c_sda <= 1'b0;
              sub_addr_stat <= sub_10bit_rcv_addr;
            end else begin
              sub_state <= I2C_SUB_IDLE;
            end
            if(sck_fall) begin
              sub_i2c_cnt <= 3'h7;
              sub_state <= I2C_SUB_WRITE;
            end
          end

          I2C_SUB_10BIT_RST_WAIT: begin
            if(sck_fall) begin
              sub_state <= I2C_SUB_10BIT_RST_ADDR;
            end
          end
          I2C_SUB_10BIT_RST_ADDR: begin
            sub_i2c_sda <= 1'b1;
            if(sck_fall) begin
              sub_data[sub_i2c_cnt] <= sda_cap;
              sub_i2c_cnt <= sub_i2c_cnt -1'b1;
              if(sub_i2c_cnt0) begin
                sub_rd <= sda_cap;
                sub_i2c_sda <= 1'b0;
                sub_state <= I2C_SUB_10BIT_RST_ACK;
              end
            end
          end

          I2C_SUB_10BIT_RST_ACK: begin
            sub_i2c_sda <= 1'b0;
            if(sck_fall) begin
              sub_i2c_cnt <= 3'h7;
              sub_state <= (sub_rd) ? I2C_SUB_READ : I2C_SUB_WRITE;
            end
          end

          I2C_SUB_READ: begin
            sub_i2c_sda <= sub_frdata[sub_i2c_cnt];
            sub_i2c_scl <= (stretch) ? 1'b0 : 1'b1;
            if(sck_fall) begin
              sub_i2c_cnt <= sub_i2c_cnt - 1'b1;
              if(sub_i2c_cnt0) begin
                sub_i2c_cnt <= 3'h7;
                sub_state <= I2C_SUB_READ_ACK;
              end
            end
          end
          I2C_SUB_READ_ACK: begin
            sub_i2c_scl <= 1'b1;
            sub_i2c_sda <= 1'b1;
            if(sck_fall) begin
              sub_state <= (sda_cap) ? I2C_SUB_WAIT_4_STOP : I2C_SUB_READ;
            end
          end

          I2C_SUB_WRITE: begin
            if(sub_start) begin
              sub_i2c_cnt <= 3'h7;
              sub_state <= I2C_SUB_10BIT_RST_WAIT;
            end
            sub_i2c_scl <= (sub_fifo_full) ? 1'b0 : 1'b1;
            sub_i2c_sda <= 1'b1;
            if(sck_fall) begin
              sub_data[sub_i2c_cnt] <= sda_cap;
              sub_i2c_cnt <= sub_i2c_cnt -1'b1;
              if(sub_i2c_cnt0) begin
                sub_fifo_wr <= 1'b1;
                sub_i2c_sda <= 1'b0;
                sub_state <= I2C_SUB_WRITE_ACK;
              end
            end
          end
          I2C_SUB_WRITE_ACK: begin
            if(sck_fall) begin
              sub_i2c_scl <= 1'b1;
              sub_i2c_sda <= 1'b1;
              sub_i2c_cnt <= 3'h7;
              sub_state <= I2C_SUB_WRITE;
            end 
          end
          I2C_SUB_WAIT_4_STOP: begin
            if(sub_stop) begin
              sub_state <= I2C_SUB_IDLE;
            end
          end
        endcase
      end
    end else begin
      sub_state <= I2C_SUB_IDLE;
      sub_i2c_cnt   <= 3'h0;
      sub_data  <= 8'h00;
      sub_hs_det <= 1'b0;
      sub_i2c_scl    <= 1'b1;
      sub_i2c_sda    <= 1'b1;
      sub_rd         <= 1'b0;
    end
  end
end

//========================================================
// Write Registers
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    sub_ctrl0 <= 32'h0000_0000;
    sub_inten <= 32'h0000_0000;
    sub_clr_fifo   <= 1'b0;
  end else begin
    sub_clr_fifo  <= sub_wr_stat & pwdata_i[23];
    if(psel_i & penable_i & pwrite_i & pready_o && paddr_i[7:2] == I2C_CTRL0_ADDR) begin
      sub_ctrl0 <= pwdata_i;
    end
    if(psel_i & penable_i & pwrite_i & pready_o && paddr_i[7:2] == I2C_INTEN_ADDR) begin
      sub_inten <= pwdata_i;
    end
  end
end

//========================================================
// Read Registers
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    prdata <= 32'h0000_0000;
  end else begin
    prdata <= 32'h0000_0000;
    if(psel_i & ~penable_i & ~pwrite_i) begin
      casez(paddr_i[7:2])
          I2C_CTRL0_ADDR:     prdata <= sub_ctrl0;
          I2C_ADDR_STAT_ADDR: prdata <= sub_addr_stat_reg;
          I2C_STAT_ADDR:      prdata <= sub_status;
          I2C_FIFO_ADDR:      prdata <= {24'h0000_00, sub_frdata};
          I2C_INTEN_ADDR:     prdata <= sub_inten;
        default:              prdata <= 32'h0000_0000;
      endcase
    end
  end
end

//========================================================
// Fifo Instance
//========================================================
msftDvIp_i2c_fifo #(
  .FIFO_WIDTH(8),
  .FIFO_DEPTH(8)
  )  msftDvIp_i2c_fifo_sub_i (
  .clk_i(clk),
  .rstn_i(sub_clr_fifo_n),

  .rd_i(sub_rd_fifo),
  .wr_i(sub_wr_fifo),
  .wdata_i(sub_fwdata),
  .rdata_o(sub_frdata),
  .full_o(sub_fifo_full),
  .empty_o(sub_fifo_empty),
  .cnt_o(sub_fifo_cnt[3:0]),
  .ovr_run_o(sub_ovr_run),
  .udr_run_o(sub_udr_run)
);

endmodule
