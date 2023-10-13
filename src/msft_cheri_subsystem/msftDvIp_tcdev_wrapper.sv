// Copyright (C) Microsoft Corporation. All rights reserved.

module msftDvIp_tcdev_wrapper (
  input  logic         clk_i,
  input  logic         rstn_i,

  input  logic         reg_en_i,
  input  logic [31:0]  reg_addr_i,
  input  logic [31:0]  reg_wdata_i,
  input  logic         reg_we_i,
  output logic [31:0]  reg_rdata_o,
  output logic         reg_ready_o,

  input  logic [63:0]  mmreg_coreout_i,
  output logic [127:0] mmreg_corein_o,

  input  logic         irq_periph_i,

  output logic         irq_external_o,
  output logic         irq_software_o,
  output logic         irq_timer_o
);

  logic        irq_tbre;
  logic [31:0] irq_to_plic;
  logic        reg_plic_en, reg_mmreg_en, reg_clint_en;
  logic        reg_plic_en_q, reg_mmreg_en_q, reg_clint_en_q;
  logic [31:0] rdata_plic, rdata_mmreg, rdata_clint;     

  assign irq_to_plic = {30'h0, irq_periph_i, irq_tbre}; 

  assign reg_ready_o = 1'b1;

  assign reg_plic_en  = reg_en_i & ~reg_addr_i[26];
  assign reg_mmreg_en = reg_en_i & (reg_addr_i[26:12] == 15'h4000); // 4kB space
  assign reg_clint_en = reg_en_i & (reg_addr_i[26:12] == 15'h4001); // 4kB space

  assign reg_rdata_o = reg_plic_en_q ? rdata_plic :
                       (reg_mmreg_en_q ? rdata_mmreg : (reg_clint_en_q ? rdata_clint : 32'h0));

  always @(posedge clk_i or negedge rstn_i) begin
    if(~rstn_i) begin
      reg_plic_en_q  <= 1'b0;
      reg_mmreg_en_q <= 1'b0;
      reg_clint_en_q <= 1'b0;
    end else begin
      reg_plic_en_q  <= reg_plic_en ;
      reg_mmreg_en_q <= reg_mmreg_en;
      reg_clint_en_q <= reg_clint_en;
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

endmodule
