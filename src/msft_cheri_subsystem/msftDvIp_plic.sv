// Copyright (C) Microsoft Corporation. All rights reserved.

module msftDvIp_plic #(
  parameter int unsigned nIntrSrc = 32         // max 32 sources for now
) (
  input  logic                 clk_i,
  input  logic                 rstn_i,

  input  logic                 reg_en_i,
  input  logic [31:0]          reg_addr_i,
  input  logic [31:0]          reg_wdata_i,
  input  logic                 reg_we_i,
  output logic [31:0]          reg_rdata_o,
  output logic                 reg_ready_o,

  
  input  logic [nIntrSrc-1:0]  irqs_i,
  output logic                 irq_external_o
);

  localparam IntrIdW      = $clog2(nIntrSrc)+1;

  localparam PriRegAddrBase = 26'h0 >> 2; 
  localparam EnableRegAddr  = 26'h2000 >> 2;
  localparam ThresRegAddr   = 26'h200000 >> 2;
  localparam ClaimRegAddr   = 26'h200004 >> 2;
  localparam SrcTypeRegAddr = 26'h0 >> 2;        // reserved address

  logic [2:0]          intr_pri_reg[0:nIntrSrc-1];
  logic [2:0]          intr_thres_reg;
  logic [nIntrSrc-1:0] intr_src_type_reg, intr_enable_reg;

  logic [nIntrSrc-1:0] intr_pending, irqs_q, irq_sig, intr_blocked;
  logic [nIntrSrc-1:0] claim_dec, completion_dec;

  logic [IntrIdW-1:0]  intr_id;
  logic [IntrIdW-1:0]  id_tree[0:5][0:31];
  logic [2:0]          pri_tree[0:5][0:31];

  logic                notif_locked;
  logic                claim_event, completion_event;

  assign reg_ready_o = 1'b1;


  // Mapping to the PLIC spec,
  //   signal           => irq_sig 
  //   request/IP       => intr_pending
  //   notification/EIP => irq_external

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      irq_external_o <= 1'b0;
      intr_id        <= 0;
      notif_locked   <= 1'b0;
    end else begin
      if (pri_tree[5][0] > intr_thres_reg) begin
        irq_external_o <= 1'b1;
      end else begin
        irq_external_o <= 1'b0;
      end
      
      // since the core can only handle 1 notification at a time 
      // don't allow intr_id to change between claim and complete
      if ((intr_id !=0 ) && claim_event)
        notif_locked <= 1'b1;
      else if (completion_event)
        notif_locked <= 1'b0; 

      //  don't update intr ID when a claim read is ongoing, otherwise may cause
      //  mismatch between claim_dec and read data
      if (~notif_locked && ~claim_event)
        intr_id <= (pri_tree[5][0] != 0) ? id_tree[5][0] : 0;   // 0 == no interrupt
    end
  end

  assign claim_event      = reg_en_i & ~reg_we_i && (reg_addr_i[25:2] == ClaimRegAddr);
  assign completion_event = reg_en_i & reg_we_i  && (reg_addr_i[25:2] == ClaimRegAddr);

  for (genvar i = 0; i < nIntrSrc; i++) begin : g_pending
    assign irq_sig[i] = intr_src_type_reg[i] ? irqs_i[i] & ~irqs_q[i] : irqs_i[i];   // edge or level triggering

    assign claim_dec[i]      = claim_event && (intr_id == i+1);
    assign completion_dec[i] = completion_event  && (reg_wdata_i[IntrIdW-1:0] == i+1);

    always_ff @(posedge clk_i or negedge rstn_i) begin
      if (!rstn_i) begin
        intr_pending[i] <= 1'b0;
        irqs_q[i]       <= 1'b0;
        intr_blocked[i] <= 1'b0;
      end else begin
        // note that intr_pending is cleared after claiming. In the case a high-priority interrupt 
        // stays active after a completion event, it takes 2 cycles for intr_pending to update and 
        // propagate to intr ID. If a claim event happens during the time, lower-priority interrupts 
        // may get into the PLIC core and block the high-priority interrupt till the next completion. 
        // is this actually an issue? if yes we can extend the notif_blocked to match update time -- QQQ
        //  
        // 
        if (irq_sig[i] && ~intr_blocked[i]) intr_pending[i] <= 1'b1;
        else if (claim_dec[i]) intr_pending[i] <= 1'b0;

        irqs_q[i] <= irqs_i[i];

        if (irq_sig[i] && ~intr_blocked[i]) intr_blocked[i] <= 1'b1;
        else if (completion_dec[i]) intr_blocked[i] <= 1'b0;
      end
    end
  end

  //
  // compare priorities and propagate ID of the max priority request
  //

  for (genvar i = 0; i < 32; i++) begin : gen_tree_inputs
    if (i < nIntrSrc) begin
      assign id_tree[0][i]  = i+1;
      assign pri_tree[0][i] = (intr_pending[i] & intr_enable_reg[i]) ? intr_pri_reg[i] : 0;
    end else begin
      assign id_tree[0][i]  = 0;
      assign pri_tree[0][i] = 0;
    end
  end 

  for (genvar i = 0; i < 5; i++) begin : gen_tree
    always_comb begin 
      int j;

      for (j = 0; j < 2**(4-i); j++) begin : gen_comp
        if (pri_tree[i][2*j] >= pri_tree[i][2*j+1]) begin
           pri_tree[i+1][j] = pri_tree[i][2*j];     // favor lower ID if same priority
           id_tree[i+1][j]  = id_tree[i][2*j];
        end else begin
           pri_tree[i+1][j] = pri_tree[i][2*j+1];
           id_tree[i+1][j]  = id_tree[i][2*j+1];
        end

      end
    end 
  end
  

  //
  // MMIO software writable registers
  //
  logic [31:0]         reg_addr_q;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      intr_src_type_reg <= 0;
      intr_enable_reg   <= 0;
      intr_thres_reg    <= 0;
      reg_addr_q        <= 0;
    end else begin
      if (reg_en_i & reg_we_i && (reg_addr_i[25:2] == EnableRegAddr)) 
        intr_enable_reg <= reg_wdata_i[nIntrSrc-1:0];

      if (reg_en_i & reg_we_i && (reg_addr_i[25:2] == SrcTypeRegAddr)) 
        intr_src_type_reg <= reg_wdata_i[nIntrSrc-1:0];

      if (reg_en_i & reg_we_i && (reg_addr_i[25:2] == ThresRegAddr)) 
       intr_thres_reg <= reg_wdata_i[2:0];

      reg_addr_q <= reg_addr_i;
    end
  end

  for (genvar i = 0; i < nIntrSrc; i++) begin : g_pri_reg

    always_ff @(posedge clk_i or negedge rstn_i) begin
      if (!rstn_i) 
        intr_pri_reg[i] <= 0;
      else if (reg_en_i & reg_we_i && (reg_addr_i[25:2] == PriRegAddrBase+i)) 
        intr_pri_reg[i] <= reg_wdata_i[2:0];
    end
  end

  //
  // read mux for MMIO registers
  //
  logic src_type_reg_rd, enable_reg_rd, thres_reg_rd, claim_reg_rd;
  logic [nIntrSrc-1:0] pri_reg_rd;

  assign src_type_reg_rd = (reg_addr_q[25:2] == SrcTypeRegAddr);
  assign enable_reg_rd   = (reg_addr_q[25:2] == EnableRegAddr);
  assign thres_reg_rd    = (reg_addr_q[25:2] == ThresRegAddr);
  assign claim_reg_rd    = (reg_addr_q[25:2] == ClaimRegAddr);
  
  logic[2:0] reg_rdata_pri;
  for (genvar i = 0; i < nIntrSrc; i++) begin 
    assign pri_reg_rd[i] = (reg_addr_q[25:2] == PriRegAddrBase+i);
  end

  always_comb begin
    reg_rdata_pri = 0;
    for (int i = 0; i < nIntrSrc; i++)
      reg_rdata_pri = reg_rdata_pri | (intr_pri_reg[i] & {3{pri_reg_rd[i]}});
  end

  always_comb begin
   reg_rdata_o = 32'h0;
   case (1'b1)
     src_type_reg_rd: reg_rdata_o = intr_src_type_reg;
     enable_reg_rd:   reg_rdata_o = intr_enable_reg;
     thres_reg_rd:    reg_rdata_o = intr_thres_reg;
     claim_reg_rd:    reg_rdata_o = intr_id;
     (|pri_reg_rd):   reg_rdata_o = reg_rdata_pri;
     default:         reg_rdata_o = 32'h0;
   endcase
  end
  
   // synthesis translate_off
  initial begin
    assert (nIntrSrc <= 32) else $error ("nIntrSrc must be <= 32");
  end
   // synthesis translate_on

endmodule

