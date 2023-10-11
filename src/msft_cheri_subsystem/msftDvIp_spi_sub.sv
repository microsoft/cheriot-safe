


module msftDvIp_spi_sub #(
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

  input         ssel_i,
  input         sclk_i,
  input  [3:0]  mosi_i,
  output [3:0]  miso_o,
  output        misoen_o,

  output        irq
 
);

//========================================================
// Parameters
//========================================================
localparam SPI_TX_IDLE       = 3'h0;
localparam SPI_TX            = 3'h1;

localparam FIFO_PTR_BITS= $clog2(FIFO_DEPTH);

localparam TXRX              = 2'h0;
localparam RX_ONLY           = 2'h1;
localparam TX_ONLY           = 2'h2;

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
wire [3:0]                  mosi;
reg  [3:0]                  miso;
wire                        ssel;

reg [2:0]                   sclk_sample;
reg [3:0]                   mosi_sample;
reg                         ssel_sample;
wire                        sclk_rise;
wire                        sclk_fall;

// Control Registers
reg [31:0]                  ctrl0;
reg [31:0]                  inten;
wire [31:0]                 status;
wire [1:0]                  txtype;

reg                         rx_fifo_wr;
reg                         tx_ovr, tx_udr;
reg                         rx_ovr, rx_udr;

wire [1:0]                  mode;

// State Machine
reg [2:0]                   spi_tx_state;
reg [4:0]                   spi_data_cnt;
reg [31:0]                  spi_tx_data;
reg [31:0]                  spi_rx_data;


wire [4:0]                  spi_bits;

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
wire [35:0]                 mosi_shift_nxt;
wire [31:0]                 miso_shift_nxt;

//========================================================
// Assignments
//========================================================
// APB bus
assign pready = 1'b1;
assign psuberr = 1'b0;

// SPI Slave Control 0
assign spien          = ctrl0[0];
assign misoen_o       = spien & ~ssel_i;
assign mode           = ctrl0[3:2];
assign single_mode    = mode == 2'h0;
assign dual_mode      = mode == 2'h1;
assign quad_mode      = mode == 2'h2;
assign spi_bits       = ctrl0[8:4];
assign txtype         = ctrl0[10:9];
assign rxen           = (txtype == RX_ONLY) || (txtype == TXRX);
assign txen           = ctrl0[10];

// Fifo read and write signals
assign fifo_wr_tx = psel_i & penable_i &  pwrite_i & (paddr == 8'h10);
assign fifo_rd_tx = spien & ~ssel_sample && spi_tx_state == SPI_TX_IDLE && (txtype == TXRX || txtype == TX_ONLY);
assign fwdata_tx = pwdata;

assign fifo_wr_rx = rx_fifo_wr; 
assign fifo_rd_rx = psel_i & penable_i & ~pwrite_i & (paddr == 8'h10);
assign fwdata_rx = spi_rx_data;

assign miso_shift_nxt = (quad_mode) ? {spi_tx_data, 4'h0} : (dual_mode) ? {2'h0, spi_tx_data, 2'h0} : {3'h0, spi_tx_data, 1'b0};
assign mosi_shift_nxt = (quad_mode) ? {spi_rx_data[27:0], mosi_sample} : (dual_mode) ? {spi_rx_data[29:0], mosi_sample[1:0]} : {spi_rx_data[30:0], mosi_sample[0]};

assign spi_idle = spi_tx_state == SPI_TX_IDLE;

assign rd_status = psel & penable & pready & ~pwrite & (paddr == 8'h08);
assign status = {           {16-FIFO_PTR_BITS-4-1{1'b0}}, fifo_cnt_rx, rx_ovr, rx_udr, fifo_full_rx, fifo_empty_rx,
                  spi_idle, {15-FIFO_PTR_BITS-4-1{1'b0}}, fifo_cnt_tx, tx_ovr, tx_udr, fifo_full_tx, fifo_empty_tx};

assign irq = (|(status[19:16] & inten[19:16])) | (|(status[3:0] & inten[3:0]));

assign spi_data_cnt0 = spi_data_cnt == 5'h00;

assign sclk_rise = sclk_sample == 3'h3;
assign sclk_fall = sclk_sample == 3'h4;

//========================================================
// SCLK Sample
//========================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    sclk_sample  <= 3'h0;
    ssel_sample  <= 1'b0;
  end else begin
    sclk_sample <= {sclk_sample[1:0], sclk};
    ssel_sample <= ssel;
  end
end

//========================================================
// MOSI Sample
//========================================================
always @(posedge sclk)
begin
  mosi_sample <= mosi;
end

//========================================================
// Register Write
//========================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    ctrl0  <= 32'h0000_0000;
    inten  <= 32'h0000_0000;
  end else begin
    if(psel & penable & pwrite) begin
      casez(paddr[7:2]) 
        6'h00: ctrl0  <= pwdata;
        6'h05: inten  <= pwdata;
      endcase
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
    spi_data_cnt <= 5'h00;
    miso <= 4'h0;
    rx_fifo_wr <= 1'b0;
  end else begin
    rx_fifo_wr <= 1'b0;
    if(spien & ~ssel_sample) begin
      casez(spi_tx_state)
        SPI_TX_IDLE: begin
          if(spien) begin
            spi_tx_state <= SPI_TX;
            spi_data_cnt <= (quad_mode) ? spi_bits[4:2] : (dual_mode) ? spi_bits[4:1] : spi_bits;
            spi_tx_data <= frdata_tx;
            spi_rx_data <= 32'h0000_0000;
          end
        end
        SPI_TX: begin
          if(sclk_fall) begin
            {miso, spi_tx_data} <= miso_shift_nxt;
          end
          if(sclk_rise) begin
            spi_data_cnt <= spi_data_cnt - 1'b1;
            spi_rx_data <= mosi_shift_nxt;
            if(spi_data_cnt0) begin
              rx_fifo_wr <= rxen;
              spi_tx_state <= SPI_TX_IDLE;
            end 
          end
        end
      endcase
    end else begin
      spi_tx_state <= SPI_TX_IDLE;
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

assign sclk = sclk_i;
assign mosi = mosi_i;
assign miso_o   = (single_mode) ? {2'h0,miso[0],1'b0} : miso;
assign ssel = ssel_i;

endmodule 
