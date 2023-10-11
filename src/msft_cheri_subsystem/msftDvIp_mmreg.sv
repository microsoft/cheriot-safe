// Copyright (C) Microsoft Corporation. All rights reserved.

module msftDvIp_mmreg (
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

  output logic         tbre_intr_o
);


  //=================================================
  // Registers/Wires
  //=================================================
  logic [31:0]      tbre_start_addr;
  logic [31:0]      tbre_end_addr;
  logic             tbre_go;
  logic [30:0]      tbre_epoch;
  logic             tbre_done, tbre_stat_q;

  logic             tbre_intr_stat, tbre_intr_en;


  //=================================================
  // Assignements
  //=================================================
  assign mmreg_corein_o = {63'h0, tbre_go, tbre_end_addr, tbre_start_addr};
  assign tbre_stat      = mmreg_coreout_i[0];
  assign tbre_done      = tbre_stat_q & ~tbre_stat;

  assign tbre_intr_o    = tbre_intr_stat & tbre_intr_en;

  assign wr_op = reg_en_i & reg_we_i;
  assign rd_op = reg_en_i & ~reg_we_i;

  assign reg_ready_o = 1'b1;

  //=================================================
  // Write registers
  //=================================================
  always @(posedge clk_i or negedge rstn_i)
  begin
    if(~rstn_i) begin
      tbre_start_addr <= 32'h0;
      tbre_end_addr   <= 32'h0;
      tbre_go         <= 1'b0;
      tbre_epoch      <= 8'h0;
      tbre_stat_q     <= 1'b0;
      tbre_intr_en    <= 1'b0;
      tbre_intr_stat  <= 1'b0;

    end else begin
      if(wr_op) begin
        casez(reg_addr_i[7:2]) 
          6'h0: tbre_start_addr <= reg_wdata_i;
          6'h1: tbre_end_addr   <= reg_wdata_i;
          6'h5: tbre_intr_en    <= reg_wdata_i[0];
        endcase
      end

      if (wr_op && (reg_addr_i[7:2] == 6'h2))
        tbre_go <= 1'b1;
      else
        tbre_go <= 1'b0;

      tbre_stat_q <= tbre_stat;
      
      if (tbre_done)
        tbre_epoch <= tbre_epoch + 1;

      if (tbre_done) tbre_intr_stat <= 1'b1;
      else if (tbre_intr_en) tbre_intr_stat <= 1'b0;   // auto clear

    end
  end

  //=================================================
  // Read registers
  //=================================================
  always @(posedge clk_i or negedge rstn_i)
  begin
    if(~rstn_i) begin
      reg_rdata_o <= 32'h0000_0000;
    end else begin
      if (rd_op) begin
        casez(reg_addr_i[7:2]) 
          6'h0: reg_rdata_o <= tbre_start_addr;
          6'h1: reg_rdata_o <= tbre_end_addr;
          6'h2: reg_rdata_o <= {16'h5500, 15'h0, tbre_go};
          6'h3: reg_rdata_o <= {tbre_epoch, tbre_stat};
          6'h4: reg_rdata_o <= {31'h0, tbre_intr_stat};
          6'h5: reg_rdata_o <= {31'h0, tbre_intr_en};
          default: reg_rdata_o <= 32'h0000_0000;
        endcase
      end
    end
  end

endmodule
