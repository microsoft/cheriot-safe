// Copyright (C) Microsoft Corporation. All rights reserved.

module msftDvIp_tcdev_wrapper (
  input  logic         clk_i,
  input  logic         rstn_i,

  input  logic         reg_en_i,
  input  logic [31:0]  reg_addr_i,
  input  logic [31:0]  reg_wdata_i,
  input  logic         reg_we_i,
  input  logic [3:0]   reg_be_i,
  output logic [31:0]  reg_rdata_o,
  output logic         reg_ready_o,

  input  logic [63:0]  mmreg_coreout_i,
  output logic [127:0] mmreg_corein_o,

  input  logic         irq_periph_i,

  output logic         irq_external_o,
  output logic         irq_software_o,
  output logic         irq_timer_o,

  input  logic         phy_tx_clk,
  input  logic         phy_rx_clk,
  input  logic         phy_crs,
  input  logic         phy_dv,
  input  logic [3:0]   phy_rx_data,
  input  logic         phy_col,
  input  logic         phy_rx_er,
  output logic         phy_rst_n,
  output logic         phy_tx_en,
  output logic [3:0]   phy_tx_data,
  input  logic         phy_mdio_i,
  output logic         phy_mdio_o,
  output logic         phy_mdio_t,
  output logic         phy_mdc
);

  logic        irq_tbre;
  logic [31:0] irq_to_plic;
  logic        reg_plic_en, reg_mmreg_en, reg_clint_en, reg_eth_mac_en;
  logic        reg_plic_en_q, reg_mmreg_en_q, reg_clint_en_q, reg_eth_mac_en_q;
  logic [31:0] rdata_plic, rdata_mmreg, rdata_clint, rdata_eth_mac;     
  logic        eth_tx_irq, eth_rx_irq;

  assign irq_to_plic = {28'h0, eth_rx_irq, eth_tx_irq, irq_periph_i, irq_tbre}; 

  assign reg_ready_o = 1'b1;

  assign reg_plic_en    = reg_en_i & ~reg_addr_i[26];
  assign reg_mmreg_en   = reg_en_i & (reg_addr_i[26:12] == 15'h4000); // 4kB space
  assign reg_clint_en   = reg_en_i & (reg_addr_i[26:12] == 15'h4001); // 4kB space
  assign reg_eth_mac_en = reg_en_i & (reg_addr_i[26:14] == 13'h1001); // 16kB space

  always_comb begin
    reg_rdata_o = 32'h0;
    unique case (1'b1) 
      reg_plic_en_q    : reg_rdata_o = rdata_plic;
      reg_mmreg_en_q   : reg_rdata_o = rdata_mmreg;
      reg_clint_en_q   : reg_rdata_o = rdata_clint;
      reg_eth_mac_en_q : reg_rdata_o = rdata_eth_mac;
      default          : reg_rdata_o = 32'h0;
    endcase
  end

  always @(posedge clk_i or negedge rstn_i) begin
    if(~rstn_i) begin
      reg_plic_en_q    <= 1'b0;
      reg_mmreg_en_q   <= 1'b0;
      reg_clint_en_q   <= 1'b0;
      reg_eth_mac_en_q <= 1'b0;
    end else begin
      reg_plic_en_q    <= reg_plic_en ;
      reg_mmreg_en_q   <= reg_mmreg_en;
      reg_clint_en_q   <= reg_clint_en;
      reg_eth_mac_en_q <= reg_eth_mac_en;
    end
  end

  msftDvIp_plic #(.nIntrSrc(32)
  ) u_plic (
    .clk_i           (clk_i      ),          
    .rstn_i          (rstn_i     ),
    .reg_en_i        (reg_plic_en),
    .reg_addr_i      (reg_addr_i ),
    .reg_wdata_i     (reg_wdata_i),
    .reg_we_i        (reg_we_i   ),
    .reg_rdata_o     (rdata_plic ),
    .reg_ready_o     (), 
    .irqs_i          (irq_to_plic),
    .irq_external_o  (irq_external_o)
  );

  msftDvIp_mmreg u_mmreg (
    .clk_i           (clk_i      ),          
    .rstn_i          (rstn_i     ),
    .reg_en_i        (reg_mmreg_en),
    .reg_addr_i      (reg_addr_i ),
    .reg_wdata_i     (reg_wdata_i),
    .reg_we_i        (reg_we_i   ),
    .reg_rdata_o     (rdata_mmreg),
    .reg_ready_o     (), 
    .mmreg_coreout_i (mmreg_coreout_i),
    .mmreg_corein_o  (mmreg_corein_o ),
    .tbre_intr_o     (irq_tbre)
  );

  msftDvIp_clint_tmr u_clint_tmr (
    .clk_i           (clk_i      ),          
    .rstn_i          (rstn_i     ),
    .reg_en_i        (reg_clint_en),
    .reg_addr_i      (reg_addr_i ),
    .reg_wdata_i     (reg_wdata_i),
    .reg_we_i        (reg_we_i   ),
    .reg_rdata_o     (rdata_clint),
    .reg_ready_o     (), 
    .irq_software_o  (irq_software_o),
    .irq_timer_o     (irq_timer_o)   
  );

  msftDvIp_eth_mac_lite # (
    .UseAXI  (0)
    ) u_eth_mac (
    .sysclk_i                      (clk_i      ),
    .rstn_i                        (rstn_i     ),
    .reg_en_i                      (reg_eth_mac_en),
    .reg_addr_i                    (reg_addr_i ),
    .reg_wdata_i                   (reg_wdata_i),
    .reg_we_i                      (reg_we_i   ),
    .reg_be_i                      (reg_be_i   ),
    .reg_rdata_o                   (rdata_eth_mac),
    .reg_ready_o                   (), 
    .eth_tx_irq                    ( eth_tx_irq),
    .eth_rx_irq                    ( eth_rx_irq),
    .s_axi_awaddr                  ( 14'h0  ),
    .s_axi_awvalid                 ( 1'b0 ),
    .s_axi_awready                 ( ),
    .s_axi_wdata                   (64'h0   ),
    .s_axi_wstrb                   ( 8'h0   ),
    .s_axi_wvalid                  ( 1'b0  ),
    .s_axi_wready                  ( ),
    .s_axi_bready                  ( 1'b0),
    .s_axi_bresp                   (  ),
    .s_axi_bvalid                  (  ),
    .s_axi_araddr                  ( 14'h0  ),
    .s_axi_arvalid                 ( 1'b0 ),
    .s_axi_arready                 ( ),
    .s_axi_rready                  ( 1'b0 ),
    .s_axi_rdata                   ( ),
    .s_axi_rresp                   ( ),
    .s_axi_rvalid                  ( ),
    .phy_rx_clk                    ( phy_rx_clk    ),
    .phy_dv                        ( phy_dv        ),
    .phy_rx_data                   ( phy_rx_data   ),
    .phy_crs                       ( phy_crs       ),
    .phy_col                       ( phy_col       ),
    .phy_rx_er                     ( phy_rx_er     ),
    .phy_rst_n                     ( phy_rst_n     ),
    .phy_tx_clk                    ( phy_tx_clk    ),
    .phy_tx_en                     ( phy_tx_en     ),
    .phy_tx_data                   ( phy_tx_data   ),
    .phy_mdio_i                    ( phy_mdio_i    ),
    .phy_mdio_o                    ( phy_mdio_o    ),                  
    .phy_mdio_t                    ( phy_mdio_t    ),
    .phy_mdc                       ( phy_mdc       )
  );

endmodule
