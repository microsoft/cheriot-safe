// Copyright (C) Microsoft Corporation. All rights reserved.

module msftDvIp_clint_tmr (
  input  logic         clk_i,
  input  logic         rstn_i,

  input  logic         reg_en_i,
  input  logic [31:0]  reg_addr_i,
  input  logic [31:0]  reg_wdata_i,
  input  logic         reg_we_i,
  output logic [31:0]  reg_rdata_o,
  output logic         reg_ready_o,
                    
  output logic         irq_software_o,
  output logic         irq_timer_o
);


  //=================================================
  // Registers/Wires
  //=================================================
  logic [31:0] mtime_hi, mtime_lo;
  logic [31:0] mtimecmp_hi, mtimecmp_lo;
  logic        sw_intr_reg;

  //=================================================
  // Assignements
  //=================================================

  assign wr_op = reg_en_i & reg_we_i;
  assign rd_op = reg_en_i & ~reg_we_i;

  assign reg_ready_o = 1'b1;

  assign irq_timer_o    = ({mtime_hi, mtime_lo} > {mtimecmp_hi, mtimecmp_lo});
  assign irq_software_o = sw_intr_reg;

  //=================================================
  // Write registers
  //=================================================
  always @(posedge clk_i or negedge rstn_i)
  begin
    if(~rstn_i) begin
      mtime_hi     <= 32'h0;
      mtime_lo     <= 32'h0;
      mtimecmp_hi  <= 32'h0;
      mtimecmp_lo  <= 32'h0;
      sw_intr_reg  <= 1'b0;
    end else begin
      if(wr_op) begin
        casez(reg_addr_i[7:2]) 
          6'h6: mtimecmp_lo <= reg_wdata_i;
          6'h7: mtimecmp_hi <= reg_wdata_i;
        endcase
      end

      mtime_lo <= mtime_lo + 1;

      if (mtime_lo == 32'hffff_ffff)
        mtime_hi <= mtime_hi + 1;

      if (wr_op && (reg_addr_i[7:2] == 6'h0)) 
        sw_intr_reg <= reg_wdata_i[0];
      // else
      //  sw_intr_reg <= 1'b0;   // can't be self-clear since ibex expect irq_software_i to stick around
      
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
          6'h0: reg_rdata_o    <= {31'h0, sw_intr_reg};
          6'h4: reg_rdata_o    <= mtime_lo;
          6'h5: reg_rdata_o    <= mtime_hi;
          6'h6: reg_rdata_o    <= mtimecmp_lo;
          6'h7: reg_rdata_o    <= mtimecmp_hi;
          default: reg_rdata_o <= 32'h0000_0000;
        endcase
      end
    end
  end

endmodule
