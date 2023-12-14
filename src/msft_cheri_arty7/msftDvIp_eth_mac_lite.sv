// Copyright (C) Microsoft Corporation. All rights reserved.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module msftDvIp_eth_mac_lite (
  input  logic        s_axi_aclk,
  input  logic        s_axi_aresetn,
  output logic        eth_tx_irq,
  output logic        eth_rx_irq,
  input  logic [13:0] s_axi_awaddr,
  input  logic        s_axi_awvalid,
  output logic        s_axi_awready,
  input  logic [63:0] s_axi_wdata,
  input  logic [7:0]  s_axi_wstrb,
  input  logic        s_axi_wvalid,
  output logic        s_axi_wready,
  output logic [1:0]  s_axi_bresp,
  output logic        s_axi_bvalid,
  input  logic        s_axi_bready,
  input  logic [13:0] s_axi_araddr,
  input  logic        s_axi_arvalid,
  output logic        s_axi_arready,
  output logic [63:0] s_axi_rdata,
  output logic [1:0]  s_axi_rresp,
  output logic        s_axi_rvalid,
  input  logic        s_axi_rready,
  input  logic        phy_tx_clk,
  input  logic        phy_rx_clk,
  input  logic        phy_crs,
  input  logic        phy_dv,
  input  logic [3:0]  phy_rx_data,
  input  logic        phy_col,
  input  logic        phy_rx_er,
  output logic        phy_rst_n,
  output logic        phy_tx_en,
  output logic [3:0]  phy_tx_data,
  input  logic        phy_mdio_i,
  output logic        phy_mdio_o,
  output logic        phy_mdio_t,
  output logic        phy_mdc
  );

  localparam ADDR_BUS_WIDTH=12;
  localparam DATA_BUS_WIDTH=32;

  logic [ADDR_BUS_WIDTH-1:0]   reg_waddr, reg_raddr;
  logic [DATA_BUS_WIDTH-1:0]   reg_wdata, reg_rdata;

  logic [3:0] reg_wstrb;

  logic        reg_rd_done, reg_wr_done;
  logic [1:0]  rdState, wrState;
  logic        reg_rd_req, reg_wr_req;

  logic        tx_ram_p0_cs, tx_ram_p0_we, tx_ram_p1_cs;
  logic [9:0]  tx_ram_p0_addr, tx_ram_p1_addr;
  logic [31:0] tx_ram_p0_wdata, tx_ram_p0_rdata;
  logic [31:0] tx_ram_p1_rdata;

  logic        rx_ram_p0_cs, rx_ram_p0_we, rx_ram_p1_cs;
  logic [9:0]  rx_ram_p0_addr, rx_ram_p1_addr;
  logic [31:0] rx_ram_p0_wdata, rx_ram_p0_rdata;
  logic [31:0] rx_ram_p1_rdata;

  logic        tx_fifo_wvalid, tx_fifo_rvalid;
  logic        tx_fifo_wready, tx_fifo_rready;
  logic [3:0]  tx_fifo_wdata, tx_fifo_rdata;
  logic [4:0]  tx_fifo_wdepth, tx_fifo_rdepth;
               
  logic        rx_fifo_wvalid, rx_fifo_rvalid;
  logic        rx_fifo_wready, rx_fifo_rready;
  logic [5:0]  rx_fifo_wdata, rx_fifo_rdata;
  logic [4:0]  rx_fifo_wdepth, rx_fifo_rdepth;
  
  logic [31:0] mac_regs_rdata[0:31];
  logic        mac_reg_sel;
  logic [31:0] scratch_reg;

  logic [4:0]  mdio_phy_addr;
  logic        mdio_op;
  logic [4:0]  mdio_reg_addr;
  logic [15:0] mdio_wdata, mdio_rdata;
  logic        mdio_en, mdio_stat, mdio_init;

  logic [15:0] tx_len_0, tx_len_1;
  logic        tx_stat_0, tx_stat_1;
  logic        tx_done_0, tx_done_1;
  logic        tx_intr_stat;
  logic        tx_err_0, tx_err_1;
 
  logic [15:0] rx_len_0, rx_len_1;
  logic        rx_stat_0, rx_stat_1;
  logic        rx_err_0, rx_err_1;
  logic        rx_intr_stat;
  logic [1:0]  intr_enable;
  logic [31:0] tx_dbg_info, rx_dbg_info;
  logic [31:0] rx_total_cnt;
  logic [31:0] rx_good_cnt;
  logic [31:0] rx_drop_cnt;
  logic [31:0] rx_err_cnt;
  logic [31:0] rx_filtd_cnt;
  logic [31:0] rx_fcs_err_cnt;

  logic [6:0]  mdio_cnt;

  typedef enum logic [3:0] {TX_IDLE, TX_PRE, TX_DATA, TX_WAIT1, TX_FCS, TX_DONE, TX_IFG} tx_fsm_t;
  tx_fsm_t     tx_fsm_d, tx_fsm_q;

  logic [11:0] tx_nibl_cnt, tx_nibl_cnt_max;
  logic        cur_tx_buf;
  logic        tx_nibl_req, tx_nibl_req_q;
  logic  [2:0] tx_nibl_cnt_lsb_q;
  logic  [8:0] tx_ifg_cnt;
  logic        tx_err_acc;

  logic        phy_dv_q;
  logic [31:0] phy_nibl_cnt;
  logic  [3:0] phy_flags;

  typedef enum logic [3:0] {RX_IDLE, RX_HUNT, RX_DATA, RX_DONE, RX_OVR} rx_fsm_t;
  rx_fsm_t     rx_fsm_d, rx_fsm_q;

  logic [11:0] rx_nibl_cnt;
  logic        cur_rx_buf;
  logic        rx_eof, rx_err_acc;
  logic        rx_dv, rx_err;
  logic [3:0]  rx_nibl;
  logic [31:0] rx_fifo_rcnt;

  logic        tx_raw_mode, rx_fcs_filt, rx_addr_filt;
  logic [3:0]  rx_addr_match_en;
  logic [47:0] rx_sta_addr;

  localparam [31:0] crc32_tbl[16] = {32'h00000000, 32'h1db71064, 32'h3b6e20c8, 32'h26d930ac,
                                     32'h76dc4190, 32'h6b6b51f4, 32'h4db26158, 32'h5005713c,
                                     32'hedb88320, 32'hf00f9344, 32'hd6d6a3e8, 32'hcb61b38c,
                                     32'h9b64c2b0, 32'h86d3d2d4, 32'ha00ae278, 32'hbdbdf21c
                                    };
  logic [31:0] tx_fcs32, rx_fcs32;


  logic [31:0] axi_rdata32;

  //===================================
  // AXI Read 
  //===================================
  localparam AXI_RD_IDLE     = 0;
  localparam AXI_RD_REQ      = 1;
  localparam AXI_RD_RESP     = 2;

  assign reg_rd_req = (rdState == AXI_RD_REQ);
  assign s_axi_rdata = {axi_rdata32, axi_rdata32};

  always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if(!s_axi_aresetn) begin
      reg_raddr     <= {DATA_BUS_WIDTH{1'b0}};
      s_axi_arready <= 1'b1;
      s_axi_rvalid  <= 1'b0;
      s_axi_rresp   <= 2'h0;
      rdState       <= AXI_RD_IDLE;
      axi_rdata32   <= 0;
    end else begin
      case (rdState)
        AXI_RD_IDLE: begin
          if(s_axi_arvalid) begin
            reg_raddr     <= s_axi_araddr[13:2];
            s_axi_arready <= 1'b0;
            s_axi_rvalid  <= 1'b0;
            rdState       <= AXI_RD_REQ;
          end
        end
        AXI_RD_REQ: begin
          if(reg_rd_done) begin
            s_axi_rvalid <= 1'b1;
            s_axi_rresp  <= {1'b0, 1'b0};
            axi_rdata32  <= reg_rdata;
            rdState      <= AXI_RD_RESP; 
          end
        end
        AXI_RD_RESP: begin
          if(s_axi_rready) begin
            s_axi_rvalid  <= 1'b0;
            s_axi_rresp   <= 2'h0;
            s_axi_arready <= 1'b1;
            rdState       <= AXI_RD_IDLE;
          end
        end
      endcase
    end
  end

  //===================================
  // AXI Write 
  //===================================
  localparam AXI_WR_IDLE     = 0;
  localparam AXI_WDATA_WAIT  = 1;
  localparam AXI_WR_REQ      = 2;
  localparam AXI_WR_RESP     = 3;

  assign reg_wr_req = (wrState == AXI_WR_REQ);

  always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if(!s_axi_aresetn) begin
      reg_waddr     <= {DATA_BUS_WIDTH{1'b0}};
      reg_wdata     <= {DATA_BUS_WIDTH{1'b0}};
      reg_wstrb     <= 4'h0;
      s_axi_awready <= 1'b1;
      s_axi_wready  <= 1'b1;
      s_axi_bresp   <= 2'h0;
      s_axi_bvalid  <= 1'b0;
      wrState       <= AXI_WR_IDLE;
    end else begin
      case (wrState)
        AXI_WR_IDLE: begin
          if(s_axi_awvalid) begin
            reg_waddr     <= s_axi_awaddr[13:2];
            s_axi_awready <= 1'b0;
            if(s_axi_wvalid) begin
              reg_wdata    <= s_axi_awaddr[2] ? s_axi_wdata[63:32] : s_axi_wdata[31:0];
              reg_wstrb    <= s_axi_awaddr[2] ? s_axi_wstrb[7:4] : s_axi_wstrb[3:0];
              s_axi_wready <= 1'b0;
              wrState      <= AXI_WR_REQ;
            end else begin
              wrState <= AXI_WDATA_WAIT;
            end
          end
        end
        AXI_WDATA_WAIT: begin
          if(s_axi_wvalid) begin
            reg_wdata    <= reg_waddr[0] ? s_axi_wdata[63:32] : s_axi_wdata[31:0];
            reg_wstrb    <= reg_waddr[0] ? s_axi_wstrb[7:4] : s_axi_wstrb[3:0];
            wrState    <= AXI_WR_REQ;
          end
        end
        AXI_WR_REQ: begin
          if(reg_wr_done) begin
            s_axi_bvalid <= 1'b1;
            s_axi_bresp  <= {1'b0, 1'b0};
            wrState      <= AXI_WR_RESP; 
          end
        end
        AXI_WR_RESP: begin
          if(s_axi_bready) begin
            s_axi_bvalid <= 1'b0;
            s_axi_bresp <= 2'h0;
            s_axi_awready <= 1'b1;
            s_axi_wready <= 1'b1;
            wrState <= AXI_WR_IDLE;
          end
        end
      endcase
    end
  end

  //===================================
  // Registers and muxing
  //===================================
  assign reg_wr_done = 1'b1;


  always_comb begin
    case (reg_raddr[11:10])
      2'b00:
        reg_rdata = mac_regs_rdata[reg_raddr[4:0]];
      2'b01:
        reg_rdata = tx_ram_p0_rdata;
      2'b10:
        reg_rdata = rx_ram_p1_rdata;
      default:
        reg_rdata = mac_regs_rdata[reg_raddr[4:0]];
    endcase
  end

  // Bit 0 of reg[0] controls phy reset 
  assign mac_regs_rdata[0]  = {16'h1234, 2'h0, rx_addr_filt, rx_fcs_filt, rx_addr_match_en, 3'h0, tx_raw_mode, 4'h0};  
  assign mac_regs_rdata[1]  = {rx_sta_addr[31:0]};
  assign mac_regs_rdata[2]  = {16'h0, rx_sta_addr[47:32]}; 
  assign mac_regs_rdata[3]  = scratch_reg; 
  assign mac_regs_rdata[4]  = {21'h0, mdio_op, mdio_phy_addr, mdio_reg_addr}; 
  assign mac_regs_rdata[5]  = {16'h0, mdio_wdata}; 
  assign mac_regs_rdata[6]  = {16'h0, mdio_rdata}; 
  assign mac_regs_rdata[7]  = {27'h0, mdio_init, 3'h0, mdio_stat}; 
  assign mac_regs_rdata[8]  = {16'h0, tx_len_0}; 
  assign mac_regs_rdata[9]  = {30'h0, tx_err_0, tx_stat_0}; 
  assign mac_regs_rdata[10] = {16'h0, tx_len_1}; 
  assign mac_regs_rdata[11] = {30'h0, tx_err_1, tx_stat_1}; 
  assign mac_regs_rdata[12] = {1'b0, rx_len_0[15:1], 14'h0, rx_err_0,  rx_stat_0}; 
  assign mac_regs_rdata[13] = {1'b0, rx_len_1[15:1], 14'h0, rx_err_1,  rx_stat_1}; 
  assign mac_regs_rdata[14] = {30'h0, intr_enable}; 
  assign mac_regs_rdata[15] = {30'h0, rx_intr_stat, tx_intr_stat}; 
  assign mac_regs_rdata[16] = {rx_len_1, rx_len_0}; 
  assign mac_regs_rdata[17] = rx_total_cnt;
  assign mac_regs_rdata[18] = rx_good_cnt;
  assign mac_regs_rdata[19] = rx_drop_cnt;
  assign mac_regs_rdata[20] = rx_filtd_cnt;
  assign mac_regs_rdata[21] = rx_fcs_err_cnt;
  assign mac_regs_rdata[22] = rx_err_cnt;
  assign mac_regs_rdata[23] = 0;
  assign mac_regs_rdata[24] = tx_dbg_info;
  assign mac_regs_rdata[25] = rx_dbg_info;
  assign mac_regs_rdata[26] = phy_nibl_cnt;
  assign mac_regs_rdata[27] = rx_fifo_rcnt;

  for (genvar i = 28; i<32; i++) begin : g_unused_regs
    assign mac_regs_rdata[i] = 32'h0; 
  end

  assign mac_reg_sel = (reg_waddr[11:5] == 0);

  assign eth_tx_irq = intr_enable[0] & tx_intr_stat;
  assign eth_rx_irq = intr_enable[1] & rx_intr_stat;

  always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    int i;
    if (~s_axi_aresetn) begin
      tx_raw_mode       <= 1'b0;
      rx_addr_match_en  <= 4'hf;
      rx_fcs_filt       <= 1'b1;
      rx_addr_filt      <= 1'b1;
      rx_sta_addr       <= 48'h0;
      reg_rd_done       <= 1'b0;
      intr_enable       <= 2'b0;
      scratch_reg       <= 32'h0;
    end else begin
      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 0)) 
        tx_raw_mode <= reg_wdata[4];

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 0)) 
        rx_addr_match_en <= reg_wdata[11:8];

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 0)) 
        rx_fcs_filt <= reg_wdata[12];

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 0)) 
        rx_addr_filt <= reg_wdata[13];

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 1)) 
        rx_sta_addr[31:0] <= reg_wdata[31:0];

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 2)) 
        rx_sta_addr[47:32] <= reg_wdata[15:0];

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 3)) 
        scratch_reg <= reg_wdata;

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 14)) 
        intr_enable = reg_wdata[1:0];

      reg_rd_done <= reg_rd_req;
    end
  end

  // phy reset generation (>1 us low pulse)
  logic [7:0] phy_rst_cnt;

  always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
      phy_rst_n   <= 1'b1;
      phy_rst_cnt <= 1'b1;
    end else begin
      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 0) && reg_wdata[0])
        phy_rst_cnt <= 1;
      else if (phy_rst_cnt > 33)
        phy_rst_cnt <= 0;
      else if (phy_rst_cnt > 0)
        phy_rst_cnt <= phy_rst_cnt + 1;

      phy_rst_n = ~((phy_rst_cnt >=2) && (phy_rst_cnt <=32));
    end
  end

  //===================================
  // MDIO function
  //===================================
  localparam  MDIO_CNT_MAX = 65;
  localparam  MDIO_CNT_INIT_MAX = 125;

  // per MDIO spec, MDIO_IO is driven and sampled at falling edge of MDC by STA

  // active low tri-state OE, pull high till midio_init is done
  assign phy_mdio_t =  mdio_init | (mdio_stat & mdio_op && (mdio_cnt > 29));
  assign mdio_en = 1'b1;
  
  always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
      mdio_phy_addr  <= 5'h1;
      mdio_reg_addr  <= 5'h0;
      mdio_op        <= 1'b0;
      mdio_wdata     <= 16'h0;
      mdio_stat      <= 1'b0;
      mdio_init      <= 1'b1;
      mdio_cnt       <= 0;
      mdio_rdata     <= 0;
      phy_mdio_o     <= 1'b1;
    end else begin
      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 4)) begin
        mdio_op       <= reg_wdata[10];
        mdio_phy_addr <= reg_wdata[9:5];
        mdio_reg_addr <= reg_wdata[4:0];
      end

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 5)) 
        mdio_wdata <= reg_wdata[15:0];

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 7)) begin
        if (mdio_en && reg_wdata[0]) mdio_stat <= 1'b1; 
      end else if (mdio_cnt >= MDIO_CNT_MAX) begin
        mdio_stat <= 1'b0;
      end

      if (mdio_cnt >= MDIO_CNT_INIT_MAX)
        mdio_init <= 1'b0;     // toggle mdc for 32 cycles after reset per MDIO spec

      // 0..65 state count (33 full cycles)
      // generated MDC both for 
      //   - init case (kick of by a reg write) 
      //   - mdio r/w case
      if (mdio_init & mdio_cnt >= MDIO_CNT_INIT_MAX)
         mdio_cnt <= 0;
      else if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 7) && reg_wdata[4] & mdio_init)
         mdio_cnt <= 1;
      else if (mdio_init & mdio_cnt > 0)
         mdio_cnt <= mdio_cnt + 1;
      else if (mdio_stat & mdio_cnt >= MDIO_CNT_MAX)
         mdio_cnt <= 0;
      else if (mdio_stat)
         mdio_cnt <= mdio_cnt + 1;

      if (mdio_stat & mdio_cnt[0]) begin     // drive MDIO at falling edge of mdc
        case (mdio_cnt[6:1])   // MDC cycle count
          0:  phy_mdio_o <= 1'b0;
          1:  phy_mdio_o <= 1'b1;
          2:  phy_mdio_o <= mdio_op;
          3:  phy_mdio_o <= ~mdio_op;
          4:  phy_mdio_o <= mdio_phy_addr[4];
          5:  phy_mdio_o <= mdio_phy_addr[3];
          6:  phy_mdio_o <= mdio_phy_addr[2];
          7:  phy_mdio_o <= mdio_phy_addr[1];
          8:  phy_mdio_o <= mdio_phy_addr[0];
          9:  phy_mdio_o <= mdio_reg_addr[4];
          10: phy_mdio_o <= mdio_reg_addr[3];
          11: phy_mdio_o <= mdio_reg_addr[2];
          12: phy_mdio_o <= mdio_reg_addr[1];
          13: phy_mdio_o <= mdio_reg_addr[0];
          14: phy_mdio_o <= 1'b1;         // TA
          15: phy_mdio_o <= 1'b0;
          16: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[15];
          17: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[14];
          18: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[13];
          19: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[12];
          20: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[11];
          21: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[10];
          22: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[9];
          23: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[8];
          24: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[7];
          25: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[6];
          26: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[5];
          27: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[4];
          28: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[3];
          29: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[2];
          30: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[1];
          31: phy_mdio_o <= mdio_op? 1'b0 : mdio_wdata[0];
          default: phy_mdio_o <= 1'b1;
        endcase
      end

      // falling edge of mdc sampling
      if (mdio_stat & mdio_op & mdio_cnt[0] && (mdio_cnt[6:1]>15) && (mdio_cnt[6:1]<32)) begin
        mdio_rdata <= {mdio_rdata[14:0], phy_mdio_i};
      end
      
    end
  end

  assign phy_mdc     = mdio_cnt[0];  

  //===================================
  // Tx function
  //===================================
	// Let's do 10Mbps only, for MAC
	//  -- Tx_clk rising edge launch tx_data
	//  -- Rx_clk falling edge sample tx_data
   
  // inter-frame gap 9.6us (10Base-T) in 20MHz cycles, plus time to flush 12 nibbles in the tx FIFO
  localparam TX_IFG_MAX = 300; 

  logic [4:0] tx_hwdata_cnt;
  logic       tx_hwdata_req;
  logic [1:0] phy_col_q;

  // Tx MII driver 
  assign phy_tx_en   = tx_fifo_rvalid & tx_fifo_rready;
  assign phy_tx_data = tx_fifo_rdata;

  always @(posedge phy_tx_clk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
      tx_fifo_rready <= 1'b0;
    end else begin
      if (tx_fifo_rdepth > 4)
        tx_fifo_rready <= 1'b1;
      else if (~tx_fifo_rvalid)
        tx_fifo_rready <= 1'b0;
    end
  end
  
  // Main Tx state machine
  assign tx_done_0 = (tx_fsm_q == TX_DONE) & ~cur_tx_buf;
  assign tx_done_1 = (tx_fsm_q == TX_DONE) & cur_tx_buf;

  assign tx_nibl_cnt_max = cur_tx_buf ? ({tx_len_1[10:0], 1'b0}-1) : ({tx_len_0[10:0], 1'b0}-1);
  assign tx_nibl_req     = (tx_fsm_q == TX_DATA) && (tx_fifo_wdepth < 12);

  assign tx_ram_p1_cs    = (tx_fsm_q == TX_DATA);
  assign tx_ram_p1_addr  = {cur_tx_buf, tx_nibl_cnt[11:3]};

  assign tx_dbg_info = {19'h0, tx_fifo_wdepth, 3'h0, cur_tx_buf, tx_fsm_q};


  assign tx_hwdata_req   = ~tx_raw_mode && ((tx_fsm_q == TX_PRE) || (tx_fsm_q == TX_FCS)) && 
                           (tx_fifo_wdepth < 12);

  assign tx_fifo_wvalid  = tx_nibl_req_q | tx_hwdata_req;

  always_comb begin
    tx_fsm_d = tx_fsm_q;
    case (tx_fsm_q)
      TX_IDLE:
        if ((tx_stat_0 | tx_stat_1) & ~phy_crs) tx_fsm_d = TX_PRE;
      TX_PRE:
        if (tx_raw_mode) tx_fsm_d = TX_DATA;
        else if ((tx_hwdata_cnt >= 15) && tx_hwdata_req) tx_fsm_d = TX_DATA;
      TX_DATA:
        if ((tx_nibl_cnt >= tx_nibl_cnt_max) && tx_nibl_req) tx_fsm_d = TX_WAIT1;
      TX_WAIT1:   // this state is just to make sure ram_rdata comes back so FCS can be updated
        tx_fsm_d = TX_FCS;
      TX_FCS:
        if (tx_raw_mode) tx_fsm_d = TX_DONE;
        else if ((tx_hwdata_cnt >= 7) && tx_hwdata_req) tx_fsm_d = TX_DONE;
      TX_DONE:
        tx_fsm_d = TX_IFG;
      TX_IFG:         // inter-frame gap
        if (tx_ifg_cnt == TX_IFG_MAX) tx_fsm_d = TX_IDLE;
      default:
        tx_fsm_d = TX_IDLE;
    endcase

    if (tx_nibl_req_q) begin
      case (tx_nibl_cnt_lsb_q) 
        0: tx_fifo_wdata = tx_ram_p1_rdata[3:0];   
        1: tx_fifo_wdata = tx_ram_p1_rdata[7:4];
        2: tx_fifo_wdata = tx_ram_p1_rdata[11:8];
        3: tx_fifo_wdata = tx_ram_p1_rdata[15:12];
        4: tx_fifo_wdata = tx_ram_p1_rdata[19:16];
        5: tx_fifo_wdata = tx_ram_p1_rdata[23:20];
        6: tx_fifo_wdata = tx_ram_p1_rdata[27:24];
        7: tx_fifo_wdata = tx_ram_p1_rdata[31:28];
        default: tx_fifo_wdata = 0;
      endcase
    end else if (tx_hwdata_req) begin
      if ((tx_fsm_q == TX_PRE) && (tx_hwdata_cnt < 15)) begin
        tx_fifo_wdata = 4'h5;
      end else if ((tx_fsm_q == TX_PRE) && (tx_hwdata_cnt == 15)) begin
        tx_fifo_wdata = 4'hd;
      end else if (tx_fsm_q == TX_FCS) begin
        case (tx_hwdata_cnt[2:0]) 
          0: tx_fifo_wdata = ~tx_fcs32[3:0];  
          1: tx_fifo_wdata = ~tx_fcs32[7:4];
          2: tx_fifo_wdata = ~tx_fcs32[11:8];
          3: tx_fifo_wdata = ~tx_fcs32[15:12];
          4: tx_fifo_wdata = ~tx_fcs32[19:16];
          5: tx_fifo_wdata = ~tx_fcs32[23:20];
          6: tx_fifo_wdata = ~tx_fcs32[27:24];
          7: tx_fifo_wdata = ~tx_fcs32[31:28];
          default: tx_fifo_wdata = 0;
        endcase
      end else begin
        tx_fifo_wdata = 0;
      end
    end else begin
      tx_fifo_wdata = 0;
    end
  end

  always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (~s_axi_aresetn) begin
      tx_len_0          <= 0;
      tx_len_1          <= 0;
      tx_stat_0         <= 1'b0;
      tx_stat_1         <= 1'b0;
      tx_fsm_q          <= TX_IDLE;
      cur_tx_buf        <= 1'b0;
      tx_nibl_req_q     <= 1'b0;
      tx_nibl_cnt       <= 0;
      tx_nibl_cnt_lsb_q <= 0; 
      tx_hwdata_cnt     <= 0;
      tx_ifg_cnt        <= 0;
      tx_intr_stat      <= 1'b0;
      phy_col_q         <= 2'h0;
      tx_err_acc        <= 1'b0;
      tx_err_0          <= 1'b0;
      tx_err_1          <= 1'b0;
      tx_fcs32          <= 32'h0;
    end else begin  
      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 8)) 
        tx_len_0 <= reg_wdata[15:0];
      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 10))
        tx_len_1 <= reg_wdata[15:0];

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 9) && reg_wdata[0]) 
        tx_stat_0 <= 1'b1;
      else if (tx_done_0)
        tx_stat_0 <= 1'b0;

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 11) && reg_wdata[0]) 
        tx_stat_1 <= 1'b1;
      else if (tx_done_1)
        tx_stat_1 <= 1'b0;

      tx_fsm_q <= tx_fsm_d;

      if ((tx_fsm_q == TX_IDLE) && tx_stat_0)
        cur_tx_buf   <= 1'b0;
      else if ((tx_fsm_q == TX_IDLE) && tx_stat_1)
        cur_tx_buf <= 1'b1;

      if (tx_fsm_q == TX_DONE) 
        tx_nibl_cnt  <= 0;
      else if (tx_nibl_req)
        tx_nibl_cnt <= tx_nibl_cnt + 1;

      if ((tx_fsm_q != TX_PRE) && (tx_fsm_q != TX_FCS)) 
        tx_hwdata_cnt  <= 0;
      else if (tx_hwdata_req)
        tx_hwdata_cnt <= tx_hwdata_cnt + 1;
  
      tx_nibl_req_q     <= tx_nibl_req;         // to align with ram rdata
      tx_nibl_cnt_lsb_q <= tx_nibl_cnt[2:0];

      if (tx_fsm_q == TX_IFG)
        tx_ifg_cnt <= tx_ifg_cnt + 1;
      else
        tx_ifg_cnt <= 0;

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 15) && reg_wdata[0]) 
        tx_intr_stat <= 1'b0;
      else if (tx_fsm_q == TX_DONE)
        tx_intr_stat <= 1'b1;

      phy_col_q <= {phy_col_q[0], phy_col};     // double sync for CDC

      if (tx_fsm_q == TX_DONE)
        tx_err_acc <= 1'b0;
      else if ((tx_fsm_q == TX_DATA) & phy_col_q[1])
        tx_err_acc <= 1'b1;

      if ((tx_fsm_q == TX_DONE) && ~cur_tx_buf)
        tx_err_0 <= tx_err_acc;              // transfer to MAC registers for sw read later

      if ((tx_fsm_q == TX_DONE) && cur_tx_buf)
        tx_err_1 <= tx_err_acc;

      // crc calculation
      // x = mac_data[i];
      // x1 = (fcs32 ^x)&0xf;
      // fcs32 = (fcs32 >> 4) ^ crc32_tbl[x1];
 
      if (tx_fsm_q == TX_PRE)
        tx_fcs32 <= 32'hffff_ffff;      // initial value
      else if (tx_nibl_req_q)
        tx_fcs32 <= crc32_tbl[tx_fcs32[3:0]^tx_fifo_wdata] ^ {4'h0, tx_fcs32[31:4]};
    end
  end


  //===================================
  // Rx function
  //===================================
  // Rx MII driver 

  // always @(negedge phy_rx_clk or negedge s_axi_aresetn) begin
  always @(posedge phy_rx_clk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
      rx_fifo_wvalid <= 1'b0;
      rx_fifo_wdata  <= 6'h0;
      phy_dv_q       <= 1'b0;
      phy_nibl_cnt   <= 0;
      phy_flags      <= 4'h0;
    end else begin
      rx_fifo_wvalid <= phy_dv | phy_dv_q;   // write EOF to FIFO
      rx_fifo_wdata  <= {phy_rx_er, phy_dv, phy_rx_data};
      phy_dv_q       <= phy_dv;

      if (phy_dv && (phy_nibl_cnt < 32'hffff_ffff)) phy_nibl_cnt <= phy_nibl_cnt+1; 
      if (phy_dv && (phy_rx_data != 4'h5)) phy_flags[0] <= 1'b1;
      if (rx_fifo_wvalid & ~rx_fifo_wready) phy_flags[1] <= 1'b1;
    end
  end

  // Rx main function
  localparam bit [31:0] FCS_VD = 32'h2144df1c;

  logic [3:0] rx_addr_match_q, rx_addr_match_d;
  logic [3:0] rx_prev_nibl;
  logic [3:0] rx_sta_nibls[16];
  logic       rx_frame_good;
  logic       rx_fcs_err;

  localparam [3:0] ipv4_mcast_nibls[8] = {4'h1, 4'h0, 4'h0, 4'h0, 4'he, 4'h5, 4'h0, 4'h0};

  assign rx_err  = rx_fifo_rdata[5];
  assign rx_dv   = rx_fifo_rdata[4];
  assign rx_nibl = rx_fifo_rdata[3:0];
  assign rx_eof  = rx_fifo_rvalid & ~rx_dv;

  assign rx_fifo_rready = (rx_fsm_q == RX_HUNT) || (rx_fsm_q == RX_DATA) || (rx_fsm_q == RX_OVR);
  assign rx_ram_p0_we   = 1'b1;

  // determine whether to drop the packet
  assign rx_fcs_err    = (rx_fsm_q == RX_DONE) & ((~rx_fcs32)!=FCS_VD);
  assign rx_frame_good = (rx_fsm_q == RX_DONE) & (~rx_addr_filt | (|rx_addr_match_q)) & 
                         ~(rx_fcs_filt & (rx_fcs_err|rx_err_acc));

  assign rx_dbg_info = {11'h0, rx_fifo_rdepth, 4'h0, phy_flags, 3'h0, cur_rx_buf, rx_fsm_q};

  always_comb begin
    rx_fsm_d = rx_fsm_q;
    case (rx_fsm_q)
      RX_IDLE:
        if (rx_fifo_rvalid & (~rx_stat_0 | ~rx_stat_1)) rx_fsm_d = RX_HUNT;
        else if (rx_fifo_rvalid) rx_fsm_d = RX_OVR;
      RX_HUNT:
        if (rx_eof) 
          rx_fsm_d = RX_DONE;
        else if (rx_fifo_rvalid && (rx_nibl == 4'hd) && (rx_prev_nibl == 4'h5) & ~rx_err)
          rx_fsm_d = RX_DATA;
      RX_DATA:
        if (rx_eof) rx_fsm_d = RX_DONE;
      RX_DONE:
        rx_fsm_d = RX_IDLE;
      RX_OVR:
        if (rx_eof) rx_fsm_d = RX_IDLE;  // discard entire frame
      default:
        rx_fsm_d = RX_IDLE;
    endcase
  end

  // MAC rx address filtering 
  assign rx_sta_nibls[0]  = rx_sta_addr[43:40];
  assign rx_sta_nibls[1]  = rx_sta_addr[47:44];
  assign rx_sta_nibls[2]  = rx_sta_addr[35:32];
  assign rx_sta_nibls[3]  = rx_sta_addr[39:36];
  assign rx_sta_nibls[4]  = rx_sta_addr[27:24];
  assign rx_sta_nibls[5]  = rx_sta_addr[31:28];
  assign rx_sta_nibls[6]  = rx_sta_addr[19:16];
  assign rx_sta_nibls[7]  = rx_sta_addr[23:20];
  assign rx_sta_nibls[8]  = rx_sta_addr[11:8];
  assign rx_sta_nibls[9]  = rx_sta_addr[15:12];
  assign rx_sta_nibls[10] = rx_sta_addr[3:0];
  assign rx_sta_nibls[11] = rx_sta_addr[7:4];
  assign rx_sta_nibls[12] = 4'h0;
  assign rx_sta_nibls[13] = 4'h0;
  assign rx_sta_nibls[14] = 4'h0;
  assign rx_sta_nibls[15] = 4'h0;

  always_comb begin
    rx_addr_match_d = rx_addr_match_q;

    if (rx_fsm_q == RX_HUNT) begin
      rx_addr_match_d = 4'hf;
    end else if ((rx_fsm_q == RX_DATA) & rx_fifo_rvalid & rx_dv) begin
      // match 0: individual STA MAC address
      if (rx_addr_match_en[0] & (rx_nibl_cnt >= 0) && (rx_nibl_cnt <= 11)  && 
          (rx_nibl != rx_sta_nibls[rx_nibl_cnt[3:0]]))
        rx_addr_match_d[0] = 1'b0;       

      // match 1: broadcast MAC address (all 1s)
      if (rx_addr_match_en[1] & (rx_nibl_cnt >= 0) && (rx_nibl_cnt <= 11)  && (rx_nibl != 4'hf))
        rx_addr_match_d[1] = 1'b0;       

      // match 2: IP v4 multicast address
      if (rx_addr_match_en[2] & (rx_nibl_cnt >= 0) && (rx_nibl_cnt <= 5)  && (rx_nibl != ipv4_mcast_nibls[rx_nibl_cnt[2:0]]))
        rx_addr_match_d[2] = 1'b0;       

      // match 3: IP v6 multicast address. we only check the prefix (0x3333)
      if (rx_addr_match_en[3] & (rx_nibl_cnt >= 0) && (rx_nibl_cnt <= 3)  && (rx_nibl != 4'h3))
        rx_addr_match_d[3] = 1'b0;       
    end 
  end

  always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
      rx_stat_0       <= 1'b0;
      rx_stat_1       <= 1'b0;
      rx_fsm_q        <= RX_IDLE;
      cur_rx_buf      <= 1'b0;
      rx_nibl_cnt     <= 0;
      rx_prev_nibl    <= 4'h0;
      rx_ram_p0_wdata <= 32'h0;
      rx_ram_p0_cs    <= 1'b0;
      rx_ram_p0_addr  <= 0;
      rx_addr_match_q <= 4'h0;
      rx_fcs32        <= 32'h0;
      rx_intr_stat    <= 1'b0;
      rx_err_acc      <= 1'b0;
      rx_err_0        <= 1'b0;
      rx_err_1        <= 1'b0;
      rx_len_0        <= 0;
      rx_len_1        <= 0;
    end else begin
      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 12) && reg_wdata[0]) 
        rx_stat_0 <= 1'b0;
      else if ((rx_fsm_q == RX_DONE) & ~cur_rx_buf & rx_frame_good)
        rx_stat_0 <= 1'b1;

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 13) && reg_wdata[0]) 
        rx_stat_1 <= 1'b0;
      else if ((rx_fsm_q == RX_DONE) & cur_rx_buf & rx_frame_good)
        rx_stat_1 <= 1'b1;
       
      rx_fsm_q <= rx_fsm_d;

      if ((rx_fsm_q == RX_IDLE) & rx_fifo_rvalid & ~rx_stat_0)
        cur_rx_buf <= 1'b0;
      else if ((rx_fsm_q == RX_IDLE) & rx_fifo_rvalid & ~rx_stat_1)
        cur_rx_buf <= 1'b1;

      if (rx_fsm_q != RX_HUNT) 
        rx_prev_nibl <= 4'h0;
      else if (rx_fifo_rvalid & rx_fifo_rready)
        rx_prev_nibl <= rx_nibl;
        
      if (rx_fsm_q != RX_DATA) 
        rx_nibl_cnt  <= 0;
      else if ((rx_fsm_q == RX_DATA) & rx_fifo_rvalid & ~rx_eof)
        rx_nibl_cnt <= rx_nibl_cnt + 1;

      if (rx_fsm_q != RX_DATA) 
        rx_ram_p0_wdata <= 32'h0;
      else if (rx_fifo_rvalid & ~rx_eof) begin
        rx_ram_p0_wdata <= {rx_nibl, rx_ram_p0_wdata[31:4]};
        case (rx_nibl_cnt[2:0])
          0: rx_ram_p0_wdata <= {rx_ram_p0_wdata[31:4], rx_nibl};
          1: rx_ram_p0_wdata <= {rx_ram_p0_wdata[31:8], rx_nibl, rx_ram_p0_wdata[3:0]};
          2: rx_ram_p0_wdata <= {rx_ram_p0_wdata[31:12], rx_nibl, rx_ram_p0_wdata[7:0]};
          3: rx_ram_p0_wdata <= {rx_ram_p0_wdata[31:16], rx_nibl, rx_ram_p0_wdata[11:0]};
          4: rx_ram_p0_wdata <= {rx_ram_p0_wdata[31:20], rx_nibl, rx_ram_p0_wdata[15:0]};
          5: rx_ram_p0_wdata <= {rx_ram_p0_wdata[31:24], rx_nibl, rx_ram_p0_wdata[19:0]};
          6: rx_ram_p0_wdata <= {rx_ram_p0_wdata[31:28], rx_nibl, rx_ram_p0_wdata[23:0]};
          7: rx_ram_p0_wdata <= {rx_nibl, rx_ram_p0_wdata[27:0]};
          default: rx_ram_p0_wdata <= 32'hffff_ffff;
        endcase
      end
      
      // write when collected 8 nibbles or an EOF comes and already collected at least 1 nibble
      rx_ram_p0_cs   <= (rx_fsm_q == RX_DATA) & rx_fifo_rvalid & 
                        ((rx_nibl_cnt[2:0] == 7) | (rx_eof & (rx_nibl_cnt[2:0]!=0)));
      rx_ram_p0_addr <= {cur_rx_buf, rx_nibl_cnt[11:3]};

      rx_addr_match_q <= rx_addr_match_d;

      if (rx_fsm_q == RX_HUNT)
        rx_fcs32 <= 32'hffff_ffff;      // initial value
      else if ((rx_fsm_q == RX_DATA) & rx_fifo_rvalid & rx_dv)
        rx_fcs32 <= crc32_tbl[rx_fcs32[3:0]^rx_nibl] ^ {4'h0, rx_fcs32[31:4]};

      if (reg_wr_req & mac_reg_sel && (reg_waddr[4:0] == 15) && reg_wdata[1]) 
        rx_intr_stat <= 1'b0;
      else if ((rx_fsm_q == RX_DONE) & rx_frame_good)
        rx_intr_stat <= 1'b1;

      if (rx_fsm_q == RX_DONE)
        rx_err_acc <= 1'b0;
      else if ((rx_fsm_q == RX_DATA) & rx_dv & rx_err)
        rx_err_acc <= 1'b1;

      if ((rx_fsm_q == RX_DONE) && ~cur_rx_buf) begin
        rx_err_0 <= rx_err_acc | rx_fcs_err;
        rx_len_0 <= rx_nibl_cnt[11:0];
      end

      if ((rx_fsm_q == RX_DONE) && cur_rx_buf) begin
        rx_err_1 <= rx_err_acc | rx_fcs_err;
        rx_len_1 <= rx_nibl_cnt[11:0];
      end

    end
  end

  // rx counters
  always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
      rx_total_cnt    <= 0;
      rx_good_cnt     <= 0;
      rx_drop_cnt     <= 0;
      rx_filtd_cnt    <= 0;
      rx_fcs_err_cnt  <= 0;
      rx_err_cnt      <= 0;
      rx_fifo_rcnt    <= 0;
    end else begin
      if (((rx_fsm_q == RX_DATA) || (rx_fsm_q == RX_OVR)) & rx_eof & (rx_total_cnt < 32'hffff_ffff))
        rx_total_cnt <= rx_total_cnt + 1;  

      if ((rx_fsm_q == RX_DONE) & rx_frame_good & (rx_good_cnt < 32'hffff_ffff))
        rx_good_cnt <= rx_good_cnt + 1;  

      if ((rx_fsm_q == RX_OVR) & rx_eof & (rx_drop_cnt < 32'hffff_ffff))
        rx_drop_cnt <= rx_drop_cnt + 1;  

      if ((rx_fsm_q == RX_DONE) & ~(|rx_addr_match_q) & ~(rx_fcs_err|rx_err_acc) & 
          (rx_filtd_cnt < 32'hffff_ffff))
        rx_filtd_cnt <= rx_filtd_cnt + 1;  

      if ((rx_fsm_q == RX_DONE) &  (rx_fcs_err) & (rx_fcs_err_cnt < 32'hffff_ffff))
        rx_fcs_err_cnt <= rx_fcs_err_cnt + 1;  

      if (((rx_fsm_q == RX_DATA) || (rx_fsm_q == RX_OVR)) & rx_err_acc & rx_eof & (rx_err_cnt < 32'hffff_ffff))
        rx_err_cnt <= rx_err_cnt + 1;  

      if (rx_fifo_rvalid && rx_fifo_rready && (rx_fifo_rcnt < 32'hffff_ffff)) 
        rx_fifo_rcnt <= rx_fifo_rcnt+1; 
    end
  end  

  //===================================
  // Tx/Rx buffer memories
  //===================================
  assign tx_ram_p0_cs = (reg_wr_req & (reg_waddr[11:10]==2'b01)) | (reg_rd_req & (reg_raddr[11:10]==2'b01));
  assign tx_ram_p0_we = reg_wr_req;
  assign tx_ram_p0_addr = reg_wr_req ? reg_waddr[9:0] : reg_raddr[9:0];
  assign tx_ram_p0_wdata = reg_wdata;

  assign rx_ram_p1_cs = reg_rd_req & (reg_raddr[11:10]==2'b10);
  assign rx_ram_p1_addr = reg_raddr[9:0];

  msftDvIp_fpga_block_ram_2port_model #(
    .RAM_WIDTH        (32),
    .RAM_DEPTH        (1024)
  ) u_tx_ram (
    .clk   (s_axi_aclk),
    .cs    (tx_ram_p0_cs),
    .dout  (tx_ram_p0_rdata),
    .addr  (tx_ram_p0_addr),
    .din   (tx_ram_p0_wdata),
    .we    (tx_ram_p0_we),
    .wstrb ({{8{reg_wstrb[3]}}, {8{reg_wstrb[2]}}, {8{reg_wstrb[1]}}, {8{reg_wstrb[0]}}}),
    .ready (),
    .cs2   (tx_ram_p1_cs),
    .addr2 (tx_ram_p1_addr),
    .dout2 (tx_ram_p1_rdata)
  );

  msftDvIp_fpga_block_ram_2port_model #(
    .RAM_WIDTH        (32),
    .RAM_DEPTH        (1024)
  ) u_rx_ram (
    .clk   (s_axi_aclk),
    .cs    (rx_ram_p0_cs),
    .dout  (),
    .addr  (rx_ram_p0_addr),
    .din   (rx_ram_p0_wdata),
    .we    (rx_ram_p0_we),
    .wstrb ({32{1'b1}}),
    .ready (),
    .cs2   (rx_ram_p1_cs),
    .addr2 (rx_ram_p1_addr),
    .dout2 (rx_ram_p1_rdata)
  );

  //===================================
  // Tx/Rx Fifo's
  //===================================
  
  prim_fifo_async #(
    .Width (4),
    .Depth (16)
  ) u_tx_fifo (
    .clk_wr_i  (s_axi_aclk),
    .rst_wr_ni (s_axi_aresetn),
    .wvalid_i  (tx_fifo_wvalid),
    .wready_o  (tx_fifo_wready),
    .wdata_i   (tx_fifo_wdata),
    .wdepth_o  (tx_fifo_wdepth),
    .clk_rd_i  (phy_tx_clk),
    .rst_rd_ni (s_axi_aresetn),
    .rvalid_o  (tx_fifo_rvalid),
    .rready_i  (tx_fifo_rready),
    .rdata_o   (tx_fifo_rdata),
    .rdepth_o  (tx_fifo_rdepth)
  );

  prim_fifo_async #(
    .Width (6),
    .Depth (16)
  ) u_rx_fifo (
    .clk_wr_i  (phy_rx_clk),
    .rst_wr_ni (s_axi_aresetn),
    .wvalid_i  (rx_fifo_wvalid),
    .wready_o  (rx_fifo_wready),
    .wdata_i   (rx_fifo_wdata),
    .wdepth_o  (rx_fifo_wdepth),
    .clk_rd_i  (s_axi_aclk),
    .rst_rd_ni (s_axi_aresetn),
    .rvalid_o  (rx_fifo_rvalid),
    .rready_i  (rx_fifo_rready),
    .rdata_o   (rx_fifo_rdata),
    .rdepth_o  (rx_fifo_rdepth)
  );

endmodule
