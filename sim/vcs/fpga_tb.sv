// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//`define BOOT_ADDR 32'h8000_0000
`define BOOT_ADDR 32'h8000_0000

module fpga_tb ();
  import ibex_pkg::*;
  import prim_ram_1p_pkg::*;

  logic       board_clk, sysclk;
  logic       rst_n;
  logic       uart_tx_fifo_wr;
  logic [7:0] uart_tx_fifo_wdata;
  logic       eth_tx_clk;
  logic       eth_rx_clk;
  logic [3:0] eth_tx_data;
  logic       eth_tx_en;
  logic       end_sim_flag;
  logic       eth_mdo;

  wire        eth_mdio;


  msftDvIp_cheri_arty7_fpga dut (
  .board_clk_i    (board_clk),
  .board_rstn_i   (rst_n),
  .ssel0_i        (1'b0),
  .sck0_i         (1'b0),
  .mosi0_i        (1'b0),
  .miso0_o        (),
  .TRSTn_i        (1'b0),
  .TCK_i          (1'b0),
  .TMS_i          (1'b0),
  .TDI_i          (1'b0),
  .TDO_io         (),
  .alive_o        (),
  .TRSTn_mux_o    (),
  .txd_dvp_o      (),
  .rxd_dvp_i      (1'b1),
  .i2c0_scl_io    (),
  .i2c0_sda_io    (),
  .i2c0_scl_pu_en_o(),
  .i2c0_sda_pu_en_o(),
  .gpio0_io        (),
  .PMODA_io        (),
  .PMODB_io        (),
  .PMODC_io        (),
  .PMODD_io        (),

  .eth_tx_clk_i    (eth_tx_clk),
  .eth_rx_clk_i    (eth_rx_clk),
  .eth_crs_i       (1'b0),
  .eth_dv_i        (eth_tx_en),
  .eth_rx_data_i   (eth_tx_data),
  .eth_col_i       (1'b0),
  .eth_rx_er_i     (1'b0),
  .eth_rst_n_o     (),
  .eth_tx_en_o     (eth_tx_en),
  .eth_tx_data_o   (eth_tx_data),
  .eth_mdio_io     (eth_mdio),
  .eth_mdc_o       (eth_mdc),
  .eth_ref_clk_o   ()
);

  // Generate clk
  initial begin
    board_clk = 1'b0;
    forever begin
      #5 board_clk = ~board_clk;
    end
  end

  initial begin
    eth_tx_clk = 1'b0;
    forever begin
      #200 eth_tx_clk = ~eth_tx_clk;
    end
  end

  initial begin
    eth_rx_clk = 1'b1;
    forever begin
      #200 eth_rx_clk = ~eth_rx_clk;
    end
  end

  initial begin
    rst_n = 1'b1;
    #1;
    rst_n = 1'b0;
   
    repeat(5) @(posedge board_clk);
    #1;
    rst_n = 1'b1;

    repeat(10) @(posedge board_clk);

    while (end_sim_flag == 0)
      @(posedge board_clk);

    $finish();
 
  end

  initial begin
    #0 $fsdbDumpfile("fpga_tb.fsdb");
    $fsdbDumpvars(0, "+all", fpga_tb); 
  end


  assign uart_tx_fifo_wr = dut.msftDvIp_cheri0_subsystem_i.msftDvIp_periph_wrapper_v0_i.msftDvIp_uart_i.msftDvIp_uart_tx_fifo_i.wr_i;
  assign uart_tx_fifo_wdata = dut.msftDvIp_cheri0_subsystem_i.msftDvIp_periph_wrapper_v0_i.msftDvIp_uart_i.msftDvIp_uart_tx_fifo_i.wdata_i;

  assign uart_tx_data_o = uart_tx_fifo_wr ? uart_tx_fifo_wdata : 8'h0;
  assign uart_tx_wr_o   = uart_tx_fifo_wr;
  assign sysclk = dut.sysclk; 

  always @(posedge sysclk, negedge rst_n) begin
    if (!rst_n) begin
      end_sim_flag <= 1'b0;
    end else begin
      if (uart_tx_fifo_wr) begin
        $write("%c", uart_tx_fifo_wdata);
        if (uart_tx_fifo_wdata[7])
          end_sim_flag <= 1'b1;
      end
    end 
  end
  
  // mdio interface
  logic        mdio_active, mdio_we, mdio_oen, mdio_dout;
  logic [4:0]  mdio_phy_addr, mdio_reg_addr;
  logic [15:0] mdio_wdata,  mdio_rdata;
  logic [15:0] mdio_regs[32];
  logic [5:0]  mdio_cnt;
  logic        mdio_reg_wr;
 
  assign eth_mdio = mdio_oen ? 1'bz : mdio_dout;

  assign mdio_rdata = mdio_regs[mdio_reg_addr];

  initial begin
    mdio_reg_wr = 1'b0;
    while (1) begin
      @(posedge eth_mdc);
      if (mdio_active & mdio_we & ((mdio_cnt == 30))) begin
        #1;
        mdio_reg_wr = 1'b1;
        @(negedge eth_mdc);
        #1;
        mdio_reg_wr = 1'b0;
      end
    end;

  end

  always @(negedge eth_mdc) begin
    if (mdio_reg_wr) mdio_regs[mdio_reg_addr] <= mdio_wdata;
  end

  always @(posedge eth_mdc, negedge rst_n)  begin
    if (~rst_n) begin
      mdio_cnt    <= 0;
      mdio_oen    <= 1'b1;
      mdio_dout   <= 1'b1;
      mdio_active <= 1'b0;
    end else begin
      if (~mdio_active & (eth_mdio == 1'b0)) 
        mdio_active <= 1'b1;
      else if (mdio_cnt >= 30)
        mdio_active <= 1'b0;

      if (mdio_cnt >= 30)
        mdio_cnt <= 0;
      else if (mdio_active)
        mdio_cnt <= mdio_cnt + 1;

      if (mdio_active & (mdio_cnt == 1)) begin
        mdio_we <= !eth_mdio;
      end else if (mdio_active & ((mdio_cnt >= 3) && (mdio_cnt<= 7))) begin
        mdio_phy_addr <= {mdio_phy_addr[3:0], eth_mdio};
      end else if (mdio_active & ((mdio_cnt >= 8) && (mdio_cnt<= 12))) begin 
        mdio_reg_addr <= {mdio_reg_addr[3:0], eth_mdio};
      end else if (mdio_active & (mdio_cnt == 13)) begin
        if (!mdio_we) mdio_oen <= 1'b0;
      end else if (mdio_active & mdio_we & ((mdio_cnt >= 15) && (mdio_cnt<= 30))) begin
        mdio_wdata <= {mdio_wdata[14:0], eth_mdio};
      end else if (mdio_active & ~mdio_we & ((mdio_cnt >= 14) && (mdio_cnt<= 29))) begin
        mdio_dout <= mdio_rdata[29-mdio_cnt];
        mdio_oen  <= 1'b0;
      end else if (mdio_active & !mdio_we & (mdio_cnt == 30)) begin
        mdio_oen <= 1'b1;
        mdio_dout <= 1'b0;
      end else if (~mdio_active) begin
        mdio_oen  <= 1'b1;
        mdio_dout <= 1'b0;
      end
      
    end 
  end  // initial
  

  // Receiving and print out Eth Tx frame
  initial begin
    logic [7:0] tx_byte;
    int         tx_cnt;
    logic       tx_en_q;

    tx_cnt = 0;
    tx_byte = 8'h0;
    tx_en_q = 1'b0;

    while (1) begin
      @(negedge eth_tx_clk);

      if (eth_tx_en) begin
        tx_byte = {eth_tx_data, tx_byte[7:4]};
        tx_cnt  = tx_cnt + 1;
        if ((tx_cnt%2) ==0) $write("%02x ", tx_byte);
        if ((tx_cnt%16) ==0) $write("\n");
      end

      if (~eth_tx_en & tx_en_q) begin
        $display("\n----- Tx EOF -------");
        tx_cnt = 0;
      end
      tx_en_q = eth_tx_en;
    end 
  end

  // Generate a Rx Frame and push to the FPGA
  // initial begin
  //   logic [7:0] rx_byte;
  //  int         rx_cnt;
  //
  //  repeat (100) @(posedge eth_rx_clk);
  // end

endmodule

