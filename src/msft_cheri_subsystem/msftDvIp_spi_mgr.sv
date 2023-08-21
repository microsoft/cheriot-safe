
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




module msftDvIp_spi_mgr #(
  parameter FIFO_DEPTH=8
  ) (
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

  output        spien_o,
  output [3:0]  spioen_o,
  output [5:0]  ssel_o,
  output        sclk_o,
  output [3:0]  mosi_o,
  input  [3:0]  miso_i,

  output        irq
 
);

//========================================================
// Parameters
//========================================================
localparam SPI_TX_IDLE            = 4'h0;

localparam SPI_TXRX_START         = 4'h1;
localparam SPI_TX                 = 4'h2;

localparam SPI_FLASH_CMD_START    = 4'h3;
localparam SPI_FLASH_CMD          = 4'h4;
localparam SPI_FLASH_ADDR_START   = 4'h5;
localparam SPI_FLASH_ADDR         = 4'h6;
localparam SPI_FLASH_DUMMY        = 4'h7;
localparam SPI_END_SSEL           = 4'h8;

localparam FIFO_PTR_BITS= $clog2(FIFO_DEPTH);

localparam TXRX              = 2'h0;
localparam RX_ONLY           = 2'h1;
localparam TX_ONLY           = 2'h2;

localparam SPI_TRANS                    = 1;
localparam SPI_FLASH_CMD_ONLY           = 2;
localparam SPI_FLASH_CMD_RD             = 3;
localparam SPI_FLASH_CMD_ADDR3_RD       = 4;
localparam SPI_FLASH_CMD_ADDR4_RD       = 5;
localparam SPI_FLASH_CMD_ADDR3_DUMMY_RD = 6;
localparam SPI_FLASH_CMD_ADDR4_DUMMY_RD = 7;

localparam SPI_FLASH_CMD_WR             = 8;
localparam SPI_FLASH_CMD_ADDR3_WR       = 10;
localparam SPI_FLASH_CMD_ADDR4_WR       = 11;

localparam FLASH_SINGLE_MODE            = 2'h0;
localparam FLASH_DUAL_MODE              = 2'h1;
localparam FLASH_QUAD_MODE              = 2'h2;

//========================================================
// Registers/Wires
//========================================================
// APB siganls
wire                        psel;
wire                        penable;
wire [7:0]                  paddr;
wire [31:0]                 pwdata;
wire                        pwrite;
reg  [31:0]                 prdata;
wire                        pready;
wire                        psuberr;

// SPI signals
reg                         sclk;
reg  [3:0]                  mosi;
wire [3:0]                  miso;
wire [5:0]                  ssel;
wire [2:0]                  ssel_sel;
wire                        ssel_en;

// Control Registers
reg [31:0]                  ctrl0;
reg [31:0]                  ctrl1;
reg [31:0]                  inten;
wire [31:0]                 status;
reg [3:0]                   spi_cmd;
wire [3:0]                  spi_cmd_reg;

reg  [18:0]                 txrxcnt;
wire                        txrx_cnt0;

wire                        tx_ovr, tx_udr;
wire                        rx_ovr, rx_udr;

wire [1:0]                  mode;
wire [1:0]                  txtype;
wire [18:0]                 rd_cnt;
wire [11:0]                 spi_div;
wire                        rd_start;

// State Machine
reg [3:0]                   spi_tx_state;
reg [4:0]                   spi_bit_cnt;
reg [31:0]                  spi_tx_data;
reg [31:0]                  spi_rx_data;
reg [1:0]                   txtype_state;
reg [1:0]                   mode_state;
wire                        spi_idle;
wire [4:0]                  spi_bits;

// Divider Registers
reg [15:0]                  spidivcnt;
wire                        spiclkhigh;
wire                        spiclklow;
wire                        enable_clk;

// Fifo Signals
wire                        fifo_rd_tx,     fifo_rd_rx;
wire                        fifo_wr_tx,     fifo_wr_rx;
wire [31:0]                 fwdata_tx,      fwdata_rx;
wire [31:0]                 frdata_tx,      frdata_rx;
wire                        fifo_full_tx,   fifo_full_rx;
wire                        fifo_empty_tx,  fifo_empty_rx;
wire [FIFO_PTR_BITS:0]      fifo_cnt_tx,    fifo_cnt_rx;
wire                        fifo_ovr_tx,    fifo_ovr_rx;
wire                        fifo_udr_tx,    fifo_udr_rx;

// SPI update signals
wire [3:0]                  mosi_shift_nxt;
wire [31:0]                 miso_shift_nxt;

wire [3:0]                  spioen;

wire                        spi_bit_cnt0;
wire [4:0]                  spi_bit_cnt_nxt;
wire                        flash_cmd_mode;
wire                        flash_addr_mode;
wire [1:0]                  flashctrl;
wire [4:0]                  flashdummy;
//wire                        spi_flash_state;
reg                         spi_flash_state;

wire                        rxonly;

wire [18:0]                 trans_cnt;
wire                        trans_cnt0;

//========================================================
// Assignments
//========================================================
// APB bus
assign pready = 1'b1;
assign psuberr = 1'b0;

// SPI Master Control 0
assign spien_o        = ctrl0[0];
assign spien          = ctrl0[0];
assign loopback       = ctrl0[1];
assign mode           = ctrl0[3:2];
assign spi_bits       = ctrl0[8:4];
assign txtype         = ctrl0[10:9];
assign ssel_sel       = ctrl0[13:11];
assign flashdummy     = ctrl0[18:14];
assign spi_div        = ctrl0[31:20];

assign single_mode    = mode_state == FLASH_SINGLE_MODE;
assign dual_mode      = mode_state == FLASH_DUAL_MODE;
assign quad_mode      = mode_state == FLASH_QUAD_MODE;

assign rxonly         = txtype_state == RX_ONLY;
assign rxen           = txtype_state == TXRX || txtype_state == RX_ONLY;
assign txen           = txtype_state == TXRX || txtype_state == TX_ONLY;

assign spioen        = (quad_mode & (~rxonly|spi_flash_state)) ? 4'hf : (dual_mode & (~rxonly|spi_flash_state)) ? 4'h3  : (single_mode & ~spi_idle) ? 4'h1 : 4'h0;

assign ssel_en = ~spi_idle;
assign ssel[0] = ~(ssel_sel == 3'h0 && ssel_en);
assign ssel[1] = ~(ssel_sel == 3'h1 && ssel_en);
assign ssel[2] = ~(ssel_sel == 3'h2 && ssel_en);
assign ssel[3] = ~(ssel_sel == 3'h3 && ssel_en);
assign ssel[4] = ~(ssel_sel == 3'h4 && ssel_en);
assign ssel[5] = ~(ssel_sel == 3'h5 && ssel_en);

// SPI Master Control 1
assign spi_cmd_reg      =  ctrl1[3:0];
assign flash_cmd_mode   =  ctrl1[4];
assign flash_addr_mode  =  ctrl1[5];
assign flashctrl        =  ctrl1[12:11];
assign trans_cnt        =  ctrl1[31:13];


assign trans_cnt0       = trans_cnt == 18'h0_0000;

assign spi_idle               = spi_tx_state == SPI_TX_IDLE;
assign spi_start_state        = spi_tx_state == SPI_TXRX_START;
assign spi_txrx_state         = spi_tx_state == SPI_TX;
assign spi_fcmd_start_state   = spi_tx_state == SPI_FLASH_CMD_START;
assign spi_faddr_start_state  = spi_tx_state == SPI_FLASH_ADDR_START;

assign fifo_rdy_rx      = ~rxen | (rxen & ~fifo_full_rx);
assign fifo_rdy_tx      = ~txen | (txen & ~fifo_empty_tx) | txrx_cnt0;
assign fifos_rdy        = fifo_rdy_rx & fifo_rdy_tx;

//assign last_bit         = spi_txrx_state & spi_bit_cnt0;
assign last_bit         = spi_txrx_state & spi_bit_cnt0 & spiclkhigh;

// TX Fifo read and write signals
assign fifo_tx_frdy = |fifo_cnt_tx;
assign fifo_wr_tx = psel_i & penable_i &  pwrite_i & (paddr == 8'h10);
assign fifo_rd_tx = (txen & (spi_start_state | (last_bit & fifos_rdy & ~txrx_cnt0))) | ((spi_fcmd_start_state | spi_faddr_start_state) & fifo_tx_frdy);
assign fwdata_tx = pwdata;

// RX Fifo read and write signals
assign fifo_wr_rx = last_bit & fifos_rdy &  rxen; 
assign fifo_rd_rx = psel_i & penable_i & ~pwrite_i & (paddr == 8'h10);
assign fwdata_rx = miso_shift_nxt;

assign spi_bit_cnt0 = spi_bit_cnt == 5'h00;
assign txrx_cnt0 = (txrxcnt-1'b1) == 19'h0_0000;

// Status Registers
assign rd_status = psel & penable & pready & ~pwrite & (paddr == 8'h08);
assign status = {           {16-FIFO_PTR_BITS-4-1{1'b0}}, fifo_cnt_rx, rx_ovr, rx_udr, fifo_full_rx, fifo_empty_rx,
                  spi_idle, {15-FIFO_PTR_BITS-4-1{1'b0}}, fifo_cnt_tx, tx_ovr, tx_udr, fifo_full_tx, fifo_empty_tx};

assign irq = (|(status[19:16] & inten[19:16])) | (|(status[3:0] & inten[3:0]));

// Shift and Count next values
assign miso_shift_nxt = (quad_mode) ? {spi_rx_data[27:0], miso} : (dual_mode) ? {spi_rx_data[29:0], miso[1:0]} : {spi_rx_data[30:0], miso[0]};
assign mosi_shift_nxt = (quad_mode) ? {spi_tx_data[{spi_bit_cnt,2'h3}], spi_tx_data[{spi_bit_cnt,2'h2}], 
                                       spi_tx_data[{spi_bit_cnt,2'h1}], spi_tx_data[{spi_bit_cnt,2'h0}]} :
                        (dual_mode) ? {2'h0, spi_tx_data[{spi_bit_cnt,2'h1}], spi_tx_data[{spi_bit_cnt,2'h0}]} : 
                                      {3'h0, spi_tx_data[spi_bit_cnt]};
assign spi_bit_cnt_nxt = (quad_mode) ? spi_bits[4:2] : (dual_mode) ? spi_bits[4:1] : spi_bits;

//========================================================
// Generate SCLK
//========================================================
assign spi_div_cnt0   = spidivcnt == 12'h000;
assign spiclklow      =  sclk && spi_div_cnt0;
assign spiclkhigh     = (~sclk && spi_div_cnt0);
assign ssel_end       = (spi_tx_state == SPI_END_SSEL && spi_div_cnt0);
assign enable_clk     = spien & ~spi_idle & ~spi_start_state & ~spi_fcmd_start_state & ~spi_faddr_start_state & ~ssel_end; 
assign hold_clk       = last_bit & ~fifos_rdy;
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    sclk <= 1'b1;
    spidivcnt <= 12'h000;
  end else if(enable_clk) begin
    if(spi_div_cnt0) begin
      if(~hold_clk) begin
        spidivcnt <= spi_div;
        sclk <= ~sclk;
      end
    end else begin
      spidivcnt <= spidivcnt - 1'b1;
    end
  end else begin
    sclk <= 1'b1;
    spidivcnt <= spi_div;
  end 
end

//========================================================
// Register Write
//========================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    ctrl0  <= 32'h0000_0000;
    ctrl1  <= 32'h0000_0000;
    inten  <= 32'h0000_0000;
  end else begin
    if(psel & penable & pwrite) begin
      casez(paddr[7:2]) 
        6'h00: ctrl0  <= pwdata;
        6'h01: ctrl1  <= pwdata;
        6'h05: inten  <= pwdata;
      endcase
    end else begin
      if(spi_fcmd_start_state | spi_txrx_state) begin
        ctrl1[3:0] <= 4'h0;
      end
    end
  end 
end

//========================================================
// Register Read
//========================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    prdata <= 32'h0000_0000;
  end else begin
    prdata <= 32'h0000_0000;
    if(psel) begin
      if(~penable & ~pwrite) begin
        casez(paddr[7:2]) 
          5'h00: prdata <= ctrl0;
          5'h01: prdata <= ctrl1;
          5'h03: prdata <= status;
          6'h04: prdata <= frdata_rx;
          6'h05: prdata <= inten;
        default: prdata <= 32'h0000_0000;
        endcase
      end
    end
  end
end

//========================================================
// SPI Tranceiver
//========================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    spi_tx_state <= SPI_TX_IDLE;
    spi_tx_data <= 32'h0000_0000;
    spi_rx_data <= 32'h0000_0000;
    spi_bit_cnt <= 5'h00;
    txtype_state <= 2'h0;
    mode_state <= FLASH_SINGLE_MODE;
    txrxcnt <= 19'h0_0000;
    mosi <= 4'h0;
    spi_flash_state <= 1'b0;
    spi_cmd <= 4'h0;
  end else begin
    if(spien) begin
      casez(spi_tx_state)
        SPI_TX_IDLE: begin
          if(|spi_cmd_reg[3:1]) begin
            mode_state <= (flash_cmd_mode) ?  FLASH_SINGLE_MODE : mode;
            spi_tx_state <= SPI_FLASH_CMD_START;
            spi_cmd <= spi_cmd_reg;
          end else if(spi_cmd_reg == SPI_TRANS) begin
            mode_state <= mode;
            txtype_state <= txtype;
            spi_tx_state <= SPI_TXRX_START;
          end
        end
        SPI_TXRX_START: begin
          spi_flash_state <= 1'b0;
          if(~trans_cnt0) begin
            spi_bit_cnt <= spi_bit_cnt_nxt;
            spi_rx_data <= 32'h0000_0000;
            txrxcnt <= trans_cnt;
            spi_tx_data <= (txen) ? frdata_tx : 32'h0000_0000;
            
            if(fifos_rdy) begin
              spi_tx_state <= SPI_TX;
            end
          end else begin
            spi_tx_state <= SPI_TX_IDLE;
            mosi <= 4'h0;
          end
        end
        SPI_TX: begin
          if(spiclklow) begin
            mosi <= mosi_shift_nxt;
          end
          if(spiclkhigh) begin
            if(spi_bit_cnt0) begin
              if(fifos_rdy) begin
                if(txrx_cnt0) begin
                  spi_tx_state <= SPI_END_SSEL;
                end else begin
                  spi_rx_data <= 32'h0000_0000;
                  spi_tx_data <= (txen) ? frdata_tx : 32'h0000_0000;
                  txrxcnt <= txrxcnt - 1'b1;
                  spi_bit_cnt <= spi_bit_cnt_nxt;
                end
              end
            end else begin
              spi_bit_cnt <= spi_bit_cnt - 1'b1;
              spi_rx_data <= miso_shift_nxt;
            end
          end
        end

        SPI_FLASH_CMD_START: begin
          if(fifo_tx_frdy) begin
            spi_bit_cnt <= (quad_mode) ? 5'h1 : (dual_mode) ? 5'h3 : 5'h7;
            spi_flash_state <= 1'b1;
            spi_tx_data <= frdata_tx;
            spi_tx_state <= SPI_FLASH_CMD; 
            txtype_state <= (spi_cmd[3]) ? 2'h2 : 2'h1;
          end
        end

        SPI_FLASH_CMD: begin
          if(spiclklow) begin
            mosi <= mosi_shift_nxt;
          end
          if(spiclkhigh) begin
            spi_bit_cnt <= spi_bit_cnt - 1'b1;
            if(spi_bit_cnt0) begin
              casez(spi_cmd)
                SPI_TRANS,
                SPI_FLASH_CMD_ONLY: spi_tx_state <= SPI_END_SSEL;
                SPI_FLASH_CMD_RD,
                SPI_FLASH_CMD_WR: begin
                  mode_state <= mode;
                  spi_tx_state <= SPI_TXRX_START;
                end
                SPI_FLASH_CMD_ADDR3_WR,
                SPI_FLASH_CMD_ADDR4_WR,
                SPI_FLASH_CMD_ADDR3_RD,
                SPI_FLASH_CMD_ADDR4_RD,
                SPI_FLASH_CMD_ADDR3_DUMMY_RD,
                SPI_FLASH_CMD_ADDR4_DUMMY_RD: begin
                  mode_state <= (flash_addr_mode) ? FLASH_SINGLE_MODE : mode;
                  spi_tx_state <= SPI_FLASH_ADDR_START;
                end
                default: spi_tx_state <= SPI_END_SSEL;
              endcase
            end
          end
        end

        SPI_FLASH_ADDR_START: begin
          if(fifo_tx_frdy) begin
            spi_tx_data <= frdata_tx;
            casez(spi_cmd)
              SPI_FLASH_CMD_ADDR3_WR,
              SPI_FLASH_CMD_ADDR3_RD,
              SPI_FLASH_CMD_ADDR3_DUMMY_RD: begin spi_bit_cnt <= (quad_mode) ? 5'h5 : (dual_mode) ? 5'hc : 5'h17; end
              SPI_FLASH_CMD_ADDR3_WR,
              SPI_FLASH_CMD_ADDR4_RD,
              SPI_FLASH_CMD_ADDR4_DUMMY_RD: begin spi_bit_cnt <= (quad_mode) ? 5'h7 : (dual_mode) ? 5'hf : 5'h1f; end
            endcase
            spi_tx_state <= SPI_FLASH_ADDR;
          end
        end

        SPI_FLASH_ADDR: begin
          if(spiclklow) begin
            mosi <= mosi_shift_nxt;
          end
          if(spiclkhigh) begin
            spi_bit_cnt <= spi_bit_cnt - 1'b1;
            if(spi_bit_cnt0) begin
              mode_state <= mode;
              casez(spi_cmd)
                SPI_FLASH_CMD_ADDR3_DUMMY_RD,
                SPI_FLASH_CMD_ADDR4_DUMMY_RD: begin
                  spi_bit_cnt <= flashdummy ;
                  spi_tx_data <= 32'h0000_0000;
                  spi_tx_state <= SPI_FLASH_DUMMY;
                end 
                default: spi_tx_state <= SPI_TXRX_START;
              endcase
            end
          end
        end

        SPI_FLASH_DUMMY: begin
          if(spiclklow) begin
            if(spi_bit_cnt < 5'h2) begin
              spi_flash_state <= 1'b0;
            end
          end
          if(spiclkhigh) begin
            spi_bit_cnt <= spi_bit_cnt - 1'b1;
            if(spi_bit_cnt0) begin
              spi_tx_state <= SPI_TXRX_START; 
            end
          end
        end

        SPI_END_SSEL: begin
          if(spi_div_cnt0) begin
            spi_tx_state <= SPI_TX_IDLE; 
            spi_flash_state <= 1'b0;
            mosi <= 4'h0;
          end
        end
      endcase
    end else begin
      spi_flash_state <= 1'b0;
      spi_tx_state <= SPI_TX_IDLE;
      mosi <= 4'h0;
    end
  end
end

//========================================================
// SPI TX Fifo
//========================================================
msftDvIp_spi_fifo #(
  ) spi_tx_fifo  (
  .clk_i(pclk_i),
  .rstn_i(prstn_i),
  .clr_i(~spien),
  .rd_i(fifo_rd_tx),
  .wr_i(fifo_wr_tx),
  .wdata_i(fwdata_tx),
  .rdata_o(frdata_tx),
  .full_o(fifo_full_tx),
  .empty_o(fifo_empty_tx),
  .cnt_o(fifo_cnt_tx),
  .ovr_run_clr_i(rd_status),
  .udr_run_clr_i(rd_status),
  .ovr_run_o(tx_ovr),
  .udr_run_o(tx_udr)
);

//========================================================
// SPI RX Fifo
//========================================================
msftDvIp_spi_fifo #(
  ) spi_rx_fifo  (
  .clk_i(pclk_i),
  .rstn_i(prstn_i),
  .clr_i(~spien),
  .rd_i(fifo_rd_rx),
  .wr_i(fifo_wr_rx),
  .wdata_i(fwdata_rx),
  .rdata_o(frdata_rx),
  .full_o(fifo_full_rx),
  .empty_o(fifo_empty_rx),
  .cnt_o(fifo_cnt_rx),
  .ovr_run_clr_i(rd_status),
  .udr_run_clr_i(rd_status),
  .ovr_run_o(rx_ovr),
  .udr_run_o(rx_udr)
);


//========================================================
// Input/Output signals
//========================================================
assign psel       = psel_i;
assign penable    = penable_i;
assign paddr      = paddr_i;
assign pwdata     = pwdata_i;
assign pwrite     = pwrite_i;

assign prdata_o   = prdata;
assign pready_o   = pready;
assign psuberr_o  = psuberr;

assign sclk_o = sclk;
assign mosi_o = mosi;
assign miso   = (loopback) ? (single_mode) ? {3'h0,mosi_o[0]} : (dual_mode) ? {2'h0,mosi_o[1:0]} : mosi_o : (single_mode) ? {3'h0,miso_i[1]} : miso_i;
assign ssel_o = ssel;
assign spioen_o = spioen;

endmodule 
