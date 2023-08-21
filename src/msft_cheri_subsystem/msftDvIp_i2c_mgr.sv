
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



module msftDvIp_i2c_mgr #(
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
  input         sda_in_i
);

//========================================================
// Parameters
//========================================================
localparam I2C_MGR_IDLE        = 5'h0;
localparam I2C_MGR_START       = 5'h1;
localparam I2C_MGR_HS_ADDR     = 5'h2;
localparam I2C_MGR_HS_ACK      = 5'h3;
localparam I2C_MGR_RESTART     = 5'h4;
localparam I2C_MGR_ADDR        = 5'h5;
localparam I2C_MGR_ADDR_ACK    = 5'h6;
localparam I2C_MGR_10BIT_ADDR0 = 5'h7;
localparam I2C_MGR_10BIT_ACK0  = 5'h8;
localparam I2C_MGR_10BIT_ADDR1 = 5'h9;
localparam I2C_MGR_10BIT_ACK1  = 5'ha;
localparam I2C_MGR_RD_WR       = 5'hb;
localparam I2C_MGR_WRITE       = 5'hc;
localparam I2C_MGR_WRITE_ACK   = 5'hd;
localparam I2C_MGR_WRITE_WAIT  = 5'he;
localparam I2C_MGR_READ_WAIT   = 5'hf;
localparam I2C_MGR_READ        = 5'h10;
localparam I2C_MGR_READ_ACK    = 5'h11;
localparam I2C_MGR_STOP        = 5'h12;

localparam I2C_NO_ERROR         = 3'h0;
localparam I2C_NORM_ACK_ERROR   = 3'h1;
localparam I2C_10BIT_ACK0_ERROR = 3'h2;
localparam I2C_10BIT_ACK1_ERROR = 3'h3;
localparam I2C_HS_ACK_ERROR     = 3'h4;
localparam I2C_WRITE_ACK_ERROR  = 3'h5;

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
reg                         sck_state;
reg                         sub_rd;

// Control registers
reg [31:0]                  mgr_ctrl0;
reg [31:0]                  mgr_ctrl1;
reg [31:0]                  mgr_inten;
reg [31:0]                  mgr_ctrl2;

// Clocks
reg [15:0]                  div_cnt;
reg [2:0]                   div_8;

// MGR   
reg [4:0]                   mgr_state;
reg [3:0]                   mgr_acnt;
reg [2:0]                   mgr_error;
reg [11:0]                  mgr_rd_cnt;
reg                         mgr_hs_det;
reg                         mgr_i2c_scl;
reg                         mgr_i2c_sda;
reg  [7:0]                  mgr_rdata;
reg                         mgr_fifo_ovr;
reg                         mgr_fifo_udr;
reg                         mgr_start_det;
reg                         mgr_clr_fifo;

wire                        mgr_enable;
wire [9:0]                  mgr_addr;
wire [2:0]                  mgr_hs_addr;
wire [15:0]                 mgr_div_val;
wire [15:0]                 mgr_hs_div_val;
wire [9:0]                  mgr_10bit_addr;
wire [1:0]                  mgr_10_up_addr;
wire [15:0]                 mgr_div_sel;
wire                        mgr_mode_hs;
wire [31:0]                 mgr_status;

wire                        mgr_rd_fifo;
wire                        mgr_wr_fifo;
wire                        mgr_fifo_full;
wire                        mgr_fifo_empty;
wire [7:0]                  mgr_fwdata;
wire [7:0]                  mgr_frdata;
wire                        mgr_i2c_wr;
wire                        mgr_i2c_rd;
wire                        mgr_rd_cnt0;
wire [5:0]                  mgr_fifo_cnt;
wire [11:0]                 mgr_rd_bytes;
wire                        mgr_wr_stat;
wire                        mgr_rd_stat;
wire                        mgr_ovr_run;
wire                        mgr_udr_run;

wire                        sck_rise;
wire                        sck_fall;
wire                        sda_rise;
wire                        sda_fall;
wire                        sck_stretch;

//========================================================
// Assignments
//========================================================
assign div0   = div_cnt == 16'h0000;
assign hs_cnt_disable = (mgr_state == I2C_MGR_START) | (mgr_state == I2C_MGR_HS_ADDR) | (mgr_state == I2C_MGR_HS_ACK);
assign mgr_div_sel = (mgr_hs_det) ?  mgr_hs_div_val : mgr_div_val;

assign state0 = div0 & (div_8 == 3'h0);
assign state1 = div0 & (div_8 == 3'h1);
assign state2 = div0 & (div_8 == 3'h2);
assign state3 = div0 & (div_8 == 3'h3);
assign state4 = div0 & (div_8 == 3'h4);
assign state5 = div0 & (div_8 == 3'h5);
assign state6 = div0 & (div_8 == 3'h6);
assign state7 = div0 & (div_8 == 3'h7);

assign clk        = pclk_i;
assign rstn       = prstn_i;

assign prdata_o   = prdata;
assign pready_o   = 1'b1;
assign psuberr_o  = 1'b0;

assign scl_oen_o  = mgr_i2c_scl;
assign sda_oen_o  = mgr_i2c_sda;

// Master
// MGR_CTRL0
assign mgr_enable     = mgr_ctrl0[0];
assign mgr_addr       = mgr_ctrl0[10:1];
assign mgr_hs_addr    = mgr_ctrl0[15:13];
assign mgr_div_val    = mgr_ctrl0[31:16];
assign mgr_mode_10bit = mgr_ctrl0[11];
assign mgr_mode_hs    = mgr_ctrl0[12];
assign mgr_10bit_addr = mgr_ctrl0[10:2];
assign mgr_10_up_addr = mgr_ctrl0[10:9];

// MGR_CTRL1
assign wr_enable      =  psel_i & penable_i & pwrite_i & pready_o;
assign mgr_start      =  mgr_ctrl1[0];
assign mgr_stop       =  mgr_ctrl1[1];
assign mgr_rd_trans   =  mgr_ctrl1[2];
assign mgr_rd_bytes   =  mgr_ctrl1[15:4];

assign mgr_hs_div_val =  mgr_ctrl2[31:16];

assign mgr_fifo_access  = psel_i & penable_i & pready_o & (paddr_i[7:2] == 6'h3);
assign mgr_acnt0 = mgr_acnt == 3'h0;
assign mgr_i2c_wr = mgr_state == I2C_MGR_READ_ACK  & state7;
assign mgr_i2c_rd = mgr_state == I2C_MGR_WRITE & state7 & mgr_acnt0;
assign mgr_i2c_idle = mgr_state == I2C_MGR_IDLE;
assign mgr_rd_fifo = (mgr_rd_trans) ? mgr_fifo_access & ~pwrite_i   : mgr_i2c_rd;
assign mgr_wr_fifo = (mgr_rd_trans) ? mgr_i2c_wr                    : mgr_fifo_access & pwrite_i;
assign mgr_fwdata  = (mgr_rd_trans) ? mgr_rdata                     : pwdata_i[7:0];
assign mgr_clr_fifo_n = mgr_enable & ~mgr_clr_fifo;
assign mgr_fifo_cnt[5:4] = 2'h0;
assign mgr_status = {mgr_error, mgr_state, 2'h0, mgr_fifo_cnt, mgr_fifo_full, mgr_fifo_empty, 2'h0, sck_sync[0], sda_sync[0], 9'h0, mgr_i2c_idle};
assign mgr_rd_cnt0 = mgr_rd_cnt == 12'h000;
assign mgr_wr_stat = psel_i & penable_i &  pwrite_i & pready_o & (paddr_i[7:2] == 6'h2);
assign mgr_rd_stat = psel_i & penable_i & ~pwrite_i & pready_o & (paddr_i[7:2] == 6'h2);

// Detect
assign sck_rise = sck_sync == 3'h3;
assign sck_fall = sck_sync == 3'h4;
assign sda_rise = sda_sync == 3'h3;
assign sda_fall = sda_sync == 3'h4;
assign sck_stretch = state4 & ~sck_state & (mgr_state != I2C_MGR_WRITE_WAIT);

assign sub_start = sda_fall & sck_sync == 3'h7;
assign sub_stop  = sda_rise & sck_sync == 3'h7;

//========================================================
// I2C input sync
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    sck_sync <= 3'h0;
    sda_sync  <= 3'h0; 
    sda_cap <= 1'b0;
    sck_state <= 1'b0;
  end else begin
    sck_sync <= {sck_sync[1:0], scl_in_i};
    sda_sync <= {sda_sync[1:0], sda_in_i};
    if(sck_rise) begin
      sda_cap <= sda_sync[2];
    end
    if(sck_rise | mgr_i2c_idle) begin
      sck_state <= 1'b1;
    end else if(sck_fall) begin
      sck_state <= 1'b0;
    end
  end
end

//========================================================
// Clock Divider
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    div_cnt <= 18'h0000;
  end else begin
    if(~mgr_i2c_idle) begin
      if(div0) begin
        div_cnt <= mgr_div_sel;
      end else begin
        div_cnt <= div_cnt - 1'b1;
      end
    end else begin
      div_cnt <= mgr_div_sel;
    end
  end
end

//========================================================
// Clock Divide by 8
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    div_8  <= 3'h3;
  end else begin
    if(~mgr_i2c_idle) begin
      if(div0 & ~sck_stretch) begin
        div_8 <= div_8 + 1'b1;
      end
    end else begin
      div_8 <= 3'h3;
    end
  end
end

//========================================================
// I2C Master Status
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    mgr_clr_fifo <= 1'b0;
    mgr_fifo_ovr   <= 1'b0;
    mgr_fifo_udr   <= 1'b0;
  end else begin
    mgr_clr_fifo <= mgr_wr_stat & pwdata_i[23];
    mgr_fifo_ovr <= (mgr_ovr_run) ? 1'b1 : (mgr_rd_stat) ? 1'b0 : mgr_fifo_ovr;
    mgr_fifo_udr <= (mgr_udr_run) ? 1'b1 : (mgr_rd_stat) ? 1'b0 : mgr_fifo_udr;
  end
end

//========================================================
// I2C Master
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    mgr_state <= I2C_MGR_IDLE;
    mgr_i2c_scl <= 1'b1;
    mgr_i2c_sda <= 1'b1;
    mgr_rdata <= 8'h00;
    mgr_acnt    <= 3'h0;
    mgr_rd_cnt <= 12'h000;
    mgr_error <= 3'h0;
    mgr_hs_det <= 1'b0;
  end else begin
    if(mgr_enable) begin
      casez(mgr_state)
        I2C_MGR_IDLE: begin
          mgr_i2c_sda <= 1'b1;
          mgr_hs_det <= 1'b0;
          if(mgr_start) begin
            mgr_error <= I2C_NO_ERROR;
            mgr_state <= I2C_MGR_START;
          end
        end
        I2C_MGR_START: begin
          if(state4) begin mgr_i2c_sda <= 1'b0; end
          if(state7) begin
            mgr_i2c_scl <= 1'b0;
            if(mgr_mode_hs) begin
              mgr_acnt <= 4'h7;
              mgr_state <= I2C_MGR_HS_ADDR;
            end else if(mgr_mode_10bit) begin
              mgr_acnt <= 4'h7;
              mgr_rdata <= {5'h1e, mgr_addr[9:8], 1'b0};
              mgr_state <= I2C_MGR_10BIT_ADDR0;
            end else begin
              mgr_acnt <= 4'd6;
              mgr_state <= I2C_MGR_ADDR;
            end
          end
        end

        I2C_MGR_RESTART: begin
          if(state0) begin mgr_i2c_sda <= 1'b1; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end
          if(state4) begin mgr_i2c_sda <= 1'b0; end
          if(state7) begin
            mgr_i2c_scl <= 1'b0;
            mgr_acnt <= 4'd6;
            mgr_rdata <= {5'h1e, mgr_addr[9:8], 1'b0};
            mgr_state <= I2C_MGR_ADDR;
          end
        end

        I2C_MGR_ADDR: begin
          if(state0) begin mgr_i2c_sda <= mgr_addr[mgr_acnt]; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end
          if(state7) begin 
            mgr_i2c_scl <= 1'b0;
            mgr_acnt <= mgr_acnt - 1'b1;
            if(mgr_acnt0) begin
              mgr_state <= I2C_MGR_RD_WR;
            end
          end 
        end

        I2C_MGR_10BIT_ADDR0: begin
          if(state0) begin mgr_i2c_sda <= mgr_rdata[mgr_acnt]; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end
          if(state7) begin 
            mgr_i2c_scl <= 1'b0;
            mgr_acnt <= mgr_acnt - 1'b1;
            if(mgr_acnt0) begin
              mgr_state <= I2C_MGR_10BIT_ACK0;
            end
          end 
        end

        I2C_MGR_10BIT_ACK0: begin
          if(state0) begin mgr_i2c_sda <= 1'b1; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end 
          if(state7) begin 
            if(~sda_cap) begin
              mgr_i2c_scl <= 1'b0;
              mgr_acnt <= 3'h7;
              mgr_rdata <= mgr_addr[7:0];
              mgr_state <= I2C_MGR_10BIT_ADDR1;
            end else begin 
              mgr_state <= I2C_MGR_IDLE;
              mgr_error <= I2C_10BIT_ACK0_ERROR;
            end
          end
        end

        I2C_MGR_10BIT_ADDR1: begin
          if(state0) begin mgr_i2c_sda <= mgr_rdata[mgr_acnt]; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end
          if(state7) begin 
            mgr_i2c_scl <= 1'b0;
            mgr_acnt <= mgr_acnt - 1'b1;
            if(mgr_acnt0) begin
              if(mgr_rd_trans) begin
                mgr_state <= I2C_MGR_10BIT_ACK1;
              end else begin
                mgr_state <= I2C_MGR_ADDR_ACK;
              end
            end
          end 
        end

        I2C_MGR_10BIT_ACK1: begin
          if(state0) begin mgr_i2c_sda <= 1'b1; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end 
          if(state7) begin 
            mgr_i2c_scl <= 1'b0;
            if(~sda_cap) begin
              mgr_state <= I2C_MGR_RESTART;
              mgr_error <= I2C_10BIT_ACK1_ERROR;
            end
          end
        end

        I2C_MGR_HS_ADDR: begin
          if(state0) begin 
            mgr_i2c_sda <= (mgr_acnt > 3'h3) ? 1'b0 : (mgr_acnt == 3'h3) ? 1'b1 : mgr_hs_addr[mgr_acnt[1:0]];
          end
          if(state3) begin mgr_i2c_scl <= 1'b1; end
          if(state7) begin 
            mgr_i2c_scl <= 1'b0;
    
            mgr_acnt <= mgr_acnt - 1'b1;
            if(mgr_acnt0) begin
              mgr_state <= I2C_MGR_HS_ACK;
            end
          end 
        end

        I2C_MGR_HS_ACK: begin
          if(state0) begin mgr_i2c_sda <= 1'b1; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end 
          if(state7) begin 
            mgr_i2c_scl <= 1'b0;
            if(sda_cap) begin
              mgr_acnt <= 3'h0;
              mgr_state <= I2C_MGR_RESTART;
              mgr_hs_det <= 1'b1;
            end else begin
              mgr_state <= I2C_MGR_IDLE;
              mgr_error <= I2C_HS_ACK_ERROR;
            end
          end
        end

        I2C_MGR_RD_WR: begin
          if(state0) begin mgr_i2c_sda <= mgr_rd_trans; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end
          if(state7) begin
            mgr_i2c_scl <= 1'b0;
            mgr_rd_cnt <= mgr_rd_bytes;
            mgr_state <= I2C_MGR_ADDR_ACK;
          end
        end

        I2C_MGR_ADDR_ACK: begin
          if(state0) begin mgr_i2c_sda <= 1'b1; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end 
          if(state7) begin 
            if(~sda_cap) begin
              mgr_i2c_scl <= 1'b0;
              if(mgr_rd_trans) begin
                if(mgr_rd_cnt0) begin
                  mgr_state <= I2C_MGR_STOP;
                end else if(mgr_fifo_full) begin
                  mgr_state <= I2C_MGR_READ_WAIT;
                end else begin
                  mgr_acnt <= 3'h7;
                  mgr_state <= I2C_MGR_READ;
                end
              end else begin
                if(mgr_fifo_empty) begin
                  mgr_state <= I2C_MGR_WRITE_WAIT;
                end else begin
                  mgr_state <= I2C_MGR_WRITE;
                  mgr_acnt <= 3'h7;
                end
              end
            end else begin
              mgr_state <= I2C_MGR_STOP;
              mgr_error <= I2C_NORM_ACK_ERROR;
            end
          end
        end
        I2C_MGR_WRITE: begin
          if(state0) begin mgr_i2c_sda <= mgr_frdata[mgr_acnt]; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end 
          if(state7) begin
            mgr_i2c_scl <= 1'b0;
            mgr_acnt <= mgr_acnt - 1'b1;
            if(mgr_acnt0) begin
              mgr_state <= I2C_MGR_WRITE_ACK;
            end
          end
        end
        I2C_MGR_WRITE_ACK: begin
          if(state0) begin mgr_i2c_sda <= 1'b1; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end 
          if(state7) begin 
            mgr_i2c_scl <= 1'b0;
            if(~sda_cap) begin
              if(mgr_fifo_empty) begin
                mgr_state <= I2C_MGR_WRITE_WAIT;
              end else begin
                mgr_acnt <= 3'h7;
                mgr_state <= I2C_MGR_WRITE;
              end
            end else begin
              mgr_error <= I2C_WRITE_ACK_ERROR;
              mgr_state <= I2C_MGR_IDLE;
            end
          end
        end
        I2C_MGR_WRITE_WAIT: begin
          if(state7) begin
            if(~mgr_fifo_empty) begin
              mgr_state <= I2C_MGR_WRITE;
              mgr_acnt <= 3'h7;
            end else if(mgr_stop) begin
              mgr_i2c_sda <= 1'b0;
              mgr_state <= I2C_MGR_STOP;
            end
          end
        end
        I2C_MGR_READ: begin
          if(state0) begin mgr_i2c_sda <= 1'b1; end
          if(state3) begin 
            mgr_i2c_scl <= 1'b1;
          end
          if(state5) begin mgr_rdata[mgr_acnt] <= {mgr_rdata[6:0],sda_cap}; end
          if(state7) begin 
            mgr_i2c_scl <= 1'b0;
            mgr_acnt <= mgr_acnt - 1'b1;
            if(mgr_acnt0) begin
              mgr_rd_cnt <= mgr_rd_cnt - 1'b1;
              mgr_state <= I2C_MGR_READ_ACK;
            end
          end
        end
        I2C_MGR_READ_ACK: begin
          if(state0) begin mgr_i2c_sda <= (mgr_rd_cnt0) ? 1'b1 : 1'b0; end
          if(state3) begin mgr_i2c_scl <= 1'b1; end 
          if(state7) begin 
          mgr_i2c_scl <= 1'b0;
            if(mgr_rd_cnt0) begin
              mgr_state <= I2C_MGR_STOP;
            end else if(mgr_fifo_full) begin
              mgr_state <= I2C_MGR_READ_WAIT;
            end else begin
              mgr_acnt <= 3'h7;
              mgr_state <= I2C_MGR_READ;
            end
          end
        end
        I2C_MGR_READ_WAIT: begin
          if(state7) begin
            if(~mgr_fifo_full) begin
              mgr_acnt <= 3'h7;
              mgr_state <= I2C_MGR_READ;
            end
          end
        end
        I2C_MGR_STOP: begin
          if(state0) begin mgr_i2c_sda <= 1'b0; end 
          if(state3) begin mgr_i2c_scl <= 1'b1; end
          if(state7) begin
            mgr_i2c_sda <= 1'b1;
            mgr_state <= I2C_MGR_IDLE;
          end
        end
        default: mgr_state <= I2C_MGR_IDLE;
      endcase
    end else begin
      mgr_i2c_scl <= 1'b1;
      mgr_i2c_sda <= 1'b1;
      mgr_acnt    <= 3'h0;
      mgr_state <= I2C_MGR_IDLE;
    end
  end
end

//========================================================
// Write Registers
//========================================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    mgr_ctrl0 <= 32'h0000_0000;
    mgr_ctrl1 <= 32'h0000_0000;
    mgr_ctrl2 <= 32'h0000_0000;
    mgr_inten <= 32'h0000_0000;
  end else begin
    if(wr_enable && paddr_i[7:2] == 6'h00) begin
      mgr_ctrl0 <= pwdata_i;
    end
    if(wr_enable && paddr_i[7:2] == 6'h01) begin
      mgr_ctrl1 <= pwdata_i;
    end else begin
      // Reset Start Bit
      if(mgr_state == I2C_MGR_START) begin
        mgr_ctrl1[0] <= 1'b0;
      end
      // Reset Stop Bit
      if(mgr_state == I2C_MGR_STOP) begin
        mgr_ctrl1[1] <= 1'b0;
      end
    end
    if(wr_enable && paddr_i[7:2] == 6'h05) begin
      mgr_ctrl2 <= pwdata_i;
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
          6'h00: prdata <= mgr_ctrl0;
          6'h01: prdata <= mgr_ctrl1;
          6'h02: prdata <= mgr_status;
          6'h03: prdata <= {24'h0000_00, mgr_frdata};
          6'h04: prdata <= mgr_inten;
          6'h05: prdata <= mgr_ctrl2;
        default: prdata <= 32'h0000_0000;
      endcase
    end
  end
end

//========================================================
// MasterFifo Instance
//========================================================
msftDvIp_i2c_fifo #(
  .FIFO_WIDTH(8),
  .FIFO_DEPTH(8)
  )  msftDvIp_i2c_fifo_mgr_i (
  .clk_i(clk),
  .rstn_i(rstn & mgr_clr_fifo_n),

  .rd_i(mgr_rd_fifo),
  .wr_i(mgr_wr_fifo),
  .wdata_i(mgr_fwdata),
  .rdata_o(mgr_frdata),
  .full_o(mgr_fifo_full),
  .empty_o(mgr_fifo_empty),
  .cnt_o(mgr_fifo_cnt[3:0]),
  .ovr_run_o(mgr_ovr_run),
  .udr_run_o(mgr_udr_run)
);

endmodule


