

module msftDvIp_uart (

  input             pclk_i,
  input             prstn_i,

  input             psel_i,
  input             penable_i,
  input [7:0]       paddr_i,
  input [31:0]      pwdata_i,
  input             pwrite_i,
  output reg [31:0] prdata_o,
  output            pready_o,
  output            psuberr_o,

  input             rxd_i,
  output            txd_o,

  output            irq_o

);

//=============================================
// Parameters
//=============================================
parameter TX_IDLE       = 4'h0;
parameter TX_START      = 4'h1;
parameter TX_BIT0       = 4'h2;
parameter TX_BIT1       = 4'h3;
parameter TX_BIT2       = 4'h4;
parameter TX_BIT3       = 4'h5;
parameter TX_BIT4       = 4'h6;
parameter TX_BIT5       = 4'h7;
parameter TX_BIT6       = 4'h8;
parameter TX_BIT7       = 4'h9;
parameter TX_PAR        = 4'ha;
parameter TX_STOP1      = 4'hb;
parameter TX_STOP2      = 4'hc;


parameter RX_IDLE       = 4'h0;
parameter RX_START      = 4'h1;
parameter RX_BIT0       = 4'h2;
parameter RX_BIT1       = 4'h3;
parameter RX_BIT2       = 4'h4;
parameter RX_BIT3       = 4'h5;
parameter RX_BIT4       = 4'h6;
parameter RX_BIT5       = 4'h7;
parameter RX_BIT6       = 4'h8;
parameter RX_BIT7       = 4'h9;
parameter RX_PAR        = 4'ha;
parameter RX_STOP1      = 4'hb;


//=============================================
// Registers
//=============================================
/*
  DIV = CLK/(BAUD*16)
  DIV = 100_000_000/(115200*16)
 */ 

reg [15:0]          brg;
reg [16:0]          tx_brg_cnt;
reg                 tx_uart_clk;

reg [16:0]          rx_brg_cnt;
reg                 rx_uart_clk;

reg [3:0]           tx_state;
reg [3:0]           tx_cnt;
reg [3:0]           rx_state;
reg [3:0]           rx_cnt;
reg                 tx_parity;
reg                 rx_parity;

reg [7:0]           txmt;
reg                 txd;
reg [7:0]           rcvr;

reg                 parity_err;
reg                 framing_err;
reg                 break_err;

wire                tx_frd;
wire                tx_fwr;
wire [7:0]          tx_fwdata;
wire [7:0]          tx_frdata;
wire [4:0]          tx_fcnt;
wire                tx_fempty;
wire                tx_ffull;
wire                tx_udr;
wire                tx_ovr;
wire                tx_udr_clr;
wire                tx_ovr_clr;
wire [15:0]         tx_brg_nxt;

wire                rx_frd;
wire                rx_fwr;
wire [7:0]          rx_fwdata;
wire [7:0]          rx_frdata;
wire [4:0]          rx_fcnt;
wire                rx_fempty;
wire                rx_ffull;
wire                rx_udr;
wire                rx_ovr;
wire                rx_udr_clr;
wire                rx_ovr_clr;
wire [15:0]         rx_brg_nxt;

reg [7:0]           ier;
reg [7:0]           lcr;
reg [7:0]           fcr;
reg [7:0]           mcr;
reg [7:0]           scr;
reg [7:0]           uctrl0;
reg [3:0]           frac;

wire [7:0]          lsr;
wire [7:0]          msr;
wire [7:0]          iir;
wire                rd_lsr;
wire [2:0]          irstat;

assign five_bit  = lcr[1:0] == 2'h0;
assign six_bit   = lcr[1:0] == 2'h1;
assign seven_bit = lcr[1:0] == 2'h2;
assign eight_bit = lcr[1:0] == 2'h3;
assign one_stop = ~lcr[2];
assign par_en = lcr[3];
assign odd_par  = lcr[5:4] == 2'h0;
assign even_par = lcr[5:4] == 2'h1;
assign high_par = lcr[5:4] == 2'h2;
assign low_par  = lcr[5:4] == 2'h3;
assign brk = lcr[6];
assign dlab = lcr[7];
assign loopback = uctrl0[0];

assign tx_idle = tx_state == TX_IDLE;
assign txd_o = txd & ~brk;
assign txcnt0 = tx_cnt == 4'h0;
assign tx_frd = (tx_state == TX_IDLE) & ~tx_fempty;
assign tx_fwr = psel_i & penable_i & pwrite_i & ~dlab & (paddr_i == 8'h00);
assign tx_fwdata = pwdata_i[7:0];
assign tx_udr_clr = 1'b0;
assign tx_ovr_clr = 1'b0;

assign rx_idle = rx_state == RX_IDLE;
assign rxd = (loopback) ? txd_o : rxd_i;
assign rxcnt0 = rx_cnt == 4'h0;
assign rx_frd = psel_i & penable_i & ~pwrite_i & ~dlab & (paddr_i == 8'h00);
assign rx_fwr = (rx_state == RX_STOP1) & rx_uart_clk & rxcnt0;
assign rx_fwdata = rcvr;
assign rx_udr_clr = 1'b0;
assign rx_ovr_clr = rd_lsr;

assign pready_o = 1'b1;
assign psuberr_o = 1'b0;

assign rd_irq =  lsr[0];
assign th_irq =  lsr[5];
assign rs_irq = |lsr[4:1];

assign irq   = rd_irq | th_irq | rs_irq;
assign irq_o = (rd_irq & ier[0]) | (th_irq & ier[1]) | (rs_irq & ier[2]);;

assign err_detect = rx_state == RX_STOP1 & rxcnt0;
assign rd_lsr = psel_i & penable_i & ~pwrite_i & pready_o & (paddr_i[7:2] == 6'h05);
assign lsr = {1'b0, tx_idle & tx_fempty, tx_idle, break_err, framing_err, parity_err, rx_ovr, ~rx_fempty};
assign msr = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
assign irstat = (th_irq) ? 3'b001 : (rd_irq) ? 3'b010 : (rs_irq) ? 3'b011 : 3'b000;
assign iir = {2'h3, 2'h0, irstat,  irq};

assign brg0 = brg == 16'h0000;


function bit addclk(input [3:0] frac_in, input [3:0] cnt);
    addclk =  ((cnt == 4'h8) & frac_in[0]) |
              (((cnt == 4'h4) | (cnt == 4'hc)) & frac_in[1]) |
              (((cnt == 4'h2) | (cnt == 4'h6) | (cnt == 4'ha) | (cnt == 4'he)) & frac_in[2]) |
              (((cnt == 4'h1) | (cnt == 4'h3) | (cnt == 4'h5) | (cnt == 4'h7) | (cnt == 4'h9) | (cnt == 4'hb) | (cnt == 4'hd) | (cnt == 4'hf)) & frac_in[3]);
endfunction

assign tx_brg_nxt = brg - ((addclk(frac, tx_cnt)) ? 1'b0 : 1'b1);
assign rx_brg_nxt = brg - ((addclk(frac, rx_cnt)) ? 1'b0 : 1'b1);


//=============================================
// TX_BRG
//=============================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    tx_brg_cnt <= 16'h0000;
    tx_uart_clk <= 1'b0;
    tx_cnt <= 4'hf;
  end else begin
    if(~brg0 & ~tx_idle) begin
        if(tx_uart_clk) begin
          tx_cnt <= tx_cnt - 1'b1;
        end
        if(tx_brg_cnt == 16'h0000) begin
          tx_brg_cnt <= tx_brg_nxt;
          tx_uart_clk <= 1'b1;
        end else begin
          tx_brg_cnt <= tx_brg_cnt - 1'b1;
          tx_uart_clk <= 1'b0;
        end
    end else begin
      tx_cnt <= 4'hf;
      tx_brg_cnt <= tx_brg_nxt;
      tx_uart_clk <= 1'b0;
    end
  end
end

//=============================================
// RX_BRG
//=============================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    rx_brg_cnt <= 16'h0000;
    rx_uart_clk <= 1'b0;
    rx_cnt <= 4'h7;
  end else begin
    if(~brg0 & ~rx_idle) begin
        if(rx_uart_clk) begin
          rx_cnt <= rx_cnt - 1'b1;
        end
        if(rx_brg_cnt == 16'h0000) begin
          rx_brg_cnt <= rx_brg_nxt;
          rx_uart_clk <= 1'b1;
        end else begin
          rx_brg_cnt <= rx_brg_cnt - 1'b1;
          rx_uart_clk <= 1'b0;
        end
    end else begin
      rx_brg_cnt <= rx_brg_nxt;
      rx_uart_clk <= 1'b0;
      rx_cnt <= 4'h7;
    end
  end
end

//=============================================
// Write Registers
//=============================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    brg <= 16'h0000;
    ier <= 4'h0;
    fcr <= 8'h00;
    lcr <= 8'h00;
    mcr <= 8'h00;
    scr <= 8'h00;
    uctrl0 <= 8'h00;
    frac <= 4'h0;
  end else begin
    if(psel_i & ~penable_i & pwrite_i) begin
      casez(paddr_i[7:2])
        6'h00: if(dlab) begin brg[7:0]  <= pwdata_i[7:0]; end
        6'h01: if(dlab) begin brg[15:8] <= pwdata_i[7:0]; end else begin ier <= pwdata_i[7:0]; end
        6'h02: fcr <= pwdata_i[7:0];
        6'h03: lcr <= pwdata_i[7:0];
        6'h04: mcr <= pwdata_i[7:0];
        6'h07: scr <= pwdata_i[7:0];
        6'h08: uctrl0 <= pwdata_i[7:0];
        6'h09: frac <= pwdata_i[3:0];
        6'h30: frac <= pwdata_i[3:0];
      endcase
    end 
  end
end

//=============================================
// Read Registers
//=============================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    prdata_o <= 32'h0000_0000;
  end else begin
    if(psel_i & ~penable_i & ~pwrite_i) begin
      casez(paddr_i[7:2])
         6'h00: if(dlab) begin prdata_o <= {24'h0000_00,brg[7:0]};  end else begin prdata_o <= {24'h0000_00, rx_frdata}; end
         6'h01: if(dlab) begin prdata_o <= {24'h0000_00,brg[15:8]}; end else begin prdata_o <= {24'h0000_00, ier};       end
         6'h02: prdata_o <= {24'h0000_00,  iir};
         6'h03: prdata_o <= {24'h0000_00,  lcr};
         6'h04: prdata_o <= {24'h0000_00,  mcr};
         6'h05: prdata_o <= {24'h0000_00,  lsr};
         6'h06: prdata_o <= {24'h0000_00,  msr};
         6'h07: prdata_o <= {24'h0000_00,  scr};
         6'h08: prdata_o <= {24'h0000_00, uctrl0};
         6'h09: prdata_o <= {28'h0000_000, frac};
         6'h30: prdata_o <= {28'h0000_000, frac};
        default: prdata_o <= 32'h0000_0000;
      endcase
    end else begin
      prdata_o <= 32'h0000_0000;
    end
  end
end

//=============================================
// Error bits
//=============================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    parity_err <= 1'b0;
    framing_err <= 1'b0;
    break_err <= 1'b0;
  end else begin
    if(err_detect) begin
      framing_err <= ~txd;
      break_err <= ~txd & txmt == 8'h00;
      if(par_en) begin
        casez(lcr[5:4]) 
          2'h0: parity_err <= ~rx_parity;
          2'h1: parity_err <=  rx_parity;
          2'h2: parity_err <= ~rx_parity;
          2'h3: parity_err <=  rx_parity;
        endcase
      end
    end else if(rd_lsr) begin
      parity_err <= 1'b0;
      framing_err <= 1'b0;
      break_err <= 1'b0;
    end
  end
end

//=============================================
// UART TX
//=============================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    tx_state <= TX_IDLE;
    txmt <= 8'h00;
    txd <= 1'b1;
    tx_parity <= 1'b0;
  end else begin
    casez(tx_state) 
      TX_IDLE: begin
        if(~tx_fempty) begin
          tx_state <= TX_START;
          txmt <= tx_frdata;
          tx_parity <= 1'b0;
        end
      end
      TX_START: begin
        txd <= 1'b0;
        if(tx_uart_clk) begin
          if(txcnt0) begin
            txd <= txmt[0];
            tx_parity <= tx_parity ^ txmt[0];
            tx_state <= TX_BIT0; 
          end
        end
      end
      TX_BIT0: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            txd <= txmt[1];
            tx_parity <= tx_parity ^ txmt[1];
            tx_state <= TX_BIT1; 
          end
        end
      end
      TX_BIT1: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            txd <= txmt[2];
            tx_parity <= tx_parity ^ txmt[2];
            tx_state <= TX_BIT2; 
          end
        end
      end
      TX_BIT2: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            txd <= txmt[3];
            tx_parity <= tx_parity ^ txmt[3];
            tx_state <= TX_BIT3; 
          end
        end
      end
      TX_BIT3: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            txd <= txmt[4];
            tx_parity <= tx_parity ^ txmt[4];
            tx_state <= TX_BIT4; 
          end
        end
      end
      TX_BIT4: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            if(five_bit)  begin
              if(par_en) begin
                casez(lcr[5:4])
                  2'b00: txd <=  tx_parity;
                  2'b01: txd <= ~tx_parity;
                  2'b10: txd <= 1'b1;
                  2'b11: txd <= 1'b0;
                endcase
                tx_state <= TX_PAR; 
              end else begin
                txd <= 1'b1;
                tx_state <= (one_stop) ? TX_STOP2 : TX_STOP1; 
              end
            end else begin
              txd <= txmt[5];
              tx_parity <= tx_parity ^ txmt[5];
              tx_state <= TX_BIT5; 
            end
          end
        end
      end
      TX_BIT5: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            if(six_bit)  begin
              if(par_en) begin
                casez(lcr[5:4])
                  2'b00: txd <=  tx_parity;
                  2'b01: txd <= ~tx_parity;
                  2'b10: txd <= 1'b1;
                  2'b11: txd <= 1'b0;
                endcase
                tx_state <= TX_PAR; 
              end else begin
                txd <= 1'b1;
                tx_state <= (one_stop) ? TX_STOP2 : TX_STOP1; 
              end
            end else begin
              txd <= txmt[6];
              tx_parity <= tx_parity ^ txmt[6];
              tx_state <= TX_BIT6; 
            end
          end
        end
      end
      TX_BIT6: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            if(seven_bit) begin
              if(par_en) begin
                casez(lcr[5:4])
                  2'b00: txd <=  tx_parity;
                  2'b01: txd <= ~tx_parity;
                  2'b10: txd <= 1'b1;
                  2'b11: txd <= 1'b0;
                endcase
                tx_state <= TX_PAR; 
              end else begin
                txd <= 1'b1;
                tx_state <= (one_stop) ? TX_STOP2 : TX_STOP1; 
              end
            end else begin
              txd <= txmt[7];
              tx_parity <= tx_parity ^ txmt[7];
              tx_state <= TX_BIT7; 
            end
          end
        end
      end
      TX_BIT7: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            if(par_en) begin
              casez(lcr[5:4])
                2'b00: txd <=  tx_parity;
                2'b01: txd <= ~tx_parity;
                2'b10: txd <= 1'b1;
                2'b11: txd <= 1'b0;
              endcase
              tx_state <= TX_PAR; 
            end else begin
              txd <= 1'b1;
              tx_state <= (one_stop) ? TX_STOP2 : TX_STOP1; 
            end
          end
        end
      end
      TX_PAR: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            txd <= 1'b1;
            tx_state <= (one_stop) ? TX_STOP2 : TX_STOP1; 
          end
        end
      end
      TX_STOP1: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            txd <= 1'b1;
            tx_state <= TX_STOP2; 
          end
        end
      end
      TX_STOP2: begin
        if(tx_uart_clk) begin
          if(txcnt0) begin
            txd <= 1'b1;
            tx_state <= TX_IDLE; 
          end
        end
      end
      default: begin
        txd <= 1'b1;
        tx_state <= TX_IDLE;
      end
    endcase
  end
end

//=============================================
// UART RX
//=============================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    rx_state <= RX_IDLE;
    rcvr <= 8'h00;
    rx_parity <= 1'b0;
  end else begin
    casez(rx_state) 
      RX_IDLE: begin
        if(~rxd) begin
          rx_state <= RX_START;
        end
      end
      RX_START: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            rx_state <= RX_BIT0; 
          end
        end
      end
      RX_BIT0: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            rcvr[0] <= rxd;
            rx_parity <= rx_parity ^ rxd;
            rx_state <= RX_BIT1; 
          end
        end
      end
      RX_BIT1: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            rx_state <= RX_BIT2; 
            rx_parity <= rx_parity ^ rxd;
            rcvr[1] <= rxd;
          end
        end
      end
      RX_BIT2: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            rx_state <= RX_BIT3; 
            rx_parity <= rx_parity ^ rxd;
            rcvr[2] <= rxd;
          end
        end
      end
      RX_BIT3: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            rx_state <= RX_BIT4; 
            rx_parity <= rx_parity ^ rxd;
            rcvr[3] <= rxd;
          end
        end
      end
      RX_BIT4: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            if(five_bit) begin
              rx_state <= (par_en) ? RX_PAR : RX_STOP1;
            end else begin
              rx_state <= RX_BIT5; 
              rx_parity <= rx_parity ^ rxd;
              rcvr[4] <= rxd;
            end
          end
        end
      end
      RX_BIT5: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            if(six_bit) begin
              rx_state <= (par_en) ? RX_PAR : RX_STOP1;
            end else begin
              rx_state <= RX_BIT6; 
              rx_parity <= rx_parity ^ rxd;
              rcvr[5] <= rxd;
            end
          end
        end
      end
      RX_BIT6: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            if(seven_bit) begin
              rx_state <= (par_en) ? RX_PAR : RX_STOP1;
            end else begin
              rx_state <= RX_BIT7; 
              rx_parity <= rx_parity ^ rxd;
              rcvr[6] <= rxd;
            end
          end
        end
      end
      RX_BIT7: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            rcvr[7] <= rxd;
            rx_state <= (par_en) ? RX_PAR : RX_STOP1;
            rx_parity <= rx_parity ^ rxd;
          end
        end
      end
      RX_PAR: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            rx_parity <= (lcr[5]) ? rxd : rx_parity ^ rxd;
            rx_state <= RX_STOP1; 
          end
        end
      end
      RX_STOP1: begin
        if(rx_uart_clk) begin
          if(rxcnt0) begin
            rx_state <= RX_IDLE; 
          end
        end
      end
      default: begin
        rx_state <= RX_IDLE;
      end
    endcase
  end
end



//========================================================
// TX Fifo Instance
//========================================================
msftDvIp_uart_fifo #(
  .FIFO_WIDTH(8),
  .FIFO_DEPTH(16)
  )  msftDvIp_uart_tx_fifo_i (
  .clk_i(pclk_i),
  .rstn_i(prstn_i),

  .rd_i(tx_frd),
  .wr_i(tx_fwr),
  .wdata_i(tx_fwdata),
  .rdata_o(tx_frdata),
  .full_o(tx_ffull),
  .empty_o(tx_fempty),
  .cnt_o(tx_fcnt[4:0]),
  .ovr_o(tx_fovr),
  .udr_o(tx_udr),
  .ovr_clr_i(tx_ovr_clr),
  .udr_clr_i(tx_udr_clr)
);
//
//========================================================
// RX Fifo Instance
//========================================================
msftDvIp_uart_fifo #(
  .FIFO_WIDTH(8),
  .FIFO_DEPTH(16)
  )  msftDvIp_uart_rx_fifo_i (
  .clk_i(pclk_i),
  .rstn_i(prstn_i),

  .rd_i(rx_frd),
  .wr_i(rx_fwr),
  .wdata_i(rx_fwdata),
  .rdata_o(rx_frdata),
  .full_o(rx_ffull),
  .empty_o(rx_fempty),
  .cnt_o(rx_fcnt[4:0]),
  .ovr_o(rx_ovr),
  .udr_o(rx_udr),
  .ovr_clr_i(rx_ovr_clr),
  .udr_clr_i(rx_udr_clr)
);

endmodule
