// Copyright (C) Microsoft Corporation. All rights reserved.


//=====================================
// Debug Module Interface Access
//=====================================
// Update Value
// ADDR   40-34   7 Bits Address
// DATA   33-2
// OP      1-0    0=NOP  1=RD  2=WR
// 
// Return 
// ADDR   40-34   Unused
// DATA   33-2    Return Data
// OP      1-0    0=Success  1=Reserved  2=failed  3=busy
 
module msftDvIp_riscv_cheri_dmibus #(
    parameter IR_WIDTH=5,
    parameter IDCODE=32'ha55a5aa5,
    parameter IDCODE_IR='h1,
    parameter DMI_ADDR_BITS=7,
    parameter DMI_DATA_BITS=33 
  ) (

  input                               TCK_i,
  input                               TMS_i,
  input                               TDI_i,
  input                               TRSTn_i,

  output reg                          TDO_o,
  output                              TDOoen_o,

  input                               clk_i,
  input                               rstn_i,

  output reg                          psel_dmi_o,
  output reg                          penable_dmi_o,
  output reg  [DMI_ADDR_BITS-1:0]     paddr_dmi_o,
  output reg  [DMI_DATA_BITS-1:0]     pwdata_dmi_o,
  output reg                          pwrite_dmi_o,
  
  input       [DMI_DATA_BITS-1:0]     prdata_dmi_i,
  input                               pready_dmi_i,
  input                               pslverr_dmi_i

);

//========================================================
// Parameters
//========================================================
localparam  JTAG_RESET       = 4'hf;
localparam  JTAG_RUN_IDLE    = 4'hc;

localparam  JTAG_DRSELECT    = 4'h7;
localparam  JTAG_DRCAPTURE   = 4'h6;
localparam  JTAG_DRSHIFT     = 4'h2;
localparam  JTAG_DREXIT1     = 4'h1;
localparam  JTAG_DRPAUSE     = 4'h3;
localparam  JTAG_DREXIT2     = 4'h0;
localparam  JTAG_DRUPDATE    = 4'h5;


localparam  JTAG_IRSELECT    = 4'h4;
localparam  JTAG_IRCAPTURE   = 4'he;
localparam  JTAG_IRSHIFT     = 4'ha;
localparam  JTAG_IREXIT1     = 4'h9;
localparam  JTAG_IRPAUSE     = 4'hb;
localparam  JTAG_IREXIT2     = 4'h8;
localparam  JTAG_IRUPDATE    = 4'hd;

localparam IDCODE_INSTR      = 5'h01;
localparam DTM_CTRL_INSTR    = 5'h10;
localparam DBG_MOD_IF_RV32   = 5'h11;                                                     // Cheri Add
localparam DBG_MOD_IF_CHERI  = 5'h12;                                                     // Cheri Add

localparam APB_IDLE          = 2'h0;
localparam APB_PSEL          = 2'h1;
localparam APB_PENABLE       = 2'h2;

localparam DMI_BITS          = DMI_ADDR_BITS + DMI_DATA_BITS + 2;

localparam DMI_VERSION       = 4'h1;
localparam DMI_IDLE          = 3'h0;


//========================================================
// Registers/Wires
//========================================================
reg [3:0]           jtag_state, jtag_state_nxt;
reg [IR_WIDTH-1:0]  ir_reg, ir_shift_reg;
reg [DMI_BITS-1:0]  dr_shift_reg;
reg                 bypass;
reg                 TDO_reg;

reg                 apb_req_rv32;                                                       // Cheri Add
reg                 apb_req_cheri;                                                      // Cheri Add
reg                 req_ack;
reg [1:0]           apb_state;
reg [1:0]           apb_req_rv32_sclk;                                                  // Cheri Add
reg [1:0]           apb_req_cheri_sclk;                                                 // Cheri Add
reg [DMI_DATA_BITS-1:0]  rdata;
reg                 slverr;

reg                 dmireset;
reg                 dmihardreset;

wire [DMI_BITS-1:0] dmi_return;
wire [31:0]         dmi_status;
wire [5:0]          addr_bits;
wire [1:0]          dmistat;

assign dr_update  = jtag_state == JTAG_DRUPDATE;

assign TDOoen_o   = jtag_state == JTAG_DRSHIFT || jtag_state == JTAG_IRSHIFT;

assign dmi_busy   = apb_state != APB_IDLE;
assign dmistat    = {dmi_busy, dmi_busy | slverr};
assign addr_bits  = DMI_ADDR_BITS;
assign dmi_status = {14'h0000, 1'b0, 1'b0, 1'b0, DMI_IDLE, dmistat, addr_bits, DMI_VERSION};

assign dmi_return = {7'h00, rdata[DMI_DATA_BITS-1:0], dmistat};

assign updateRstn = TRSTn_i & ~req_ack;

//===================================================
// Mux with Negative edge output
//===================================================
always @(negedge TCK_i)
begin
  casez(jtag_state)
    JTAG_IRSHIFT: TDO_o <= ir_shift_reg[0];
    JTAG_DRSHIFT: TDO_o <= (&ir_reg) ? bypass : dr_shift_reg[0]; 
         default: TDO_o <= 1'b0;
  endcase
end

//========================================================
// State Machine next state
//========================================================
always @* begin
    jtag_state_nxt = jtag_state;
    casez (jtag_state)
      JTAG_RESET    : jtag_state_nxt = (TMS_i) ? JTAG_RESET    : JTAG_RUN_IDLE;
      JTAG_RUN_IDLE : jtag_state_nxt = (TMS_i) ? JTAG_DRSELECT : JTAG_RUN_IDLE;

      JTAG_DRSELECT : jtag_state_nxt = (TMS_i) ? JTAG_IRSELECT : JTAG_DRCAPTURE;
      JTAG_DRCAPTURE: jtag_state_nxt = (TMS_i) ? JTAG_DREXIT1  : JTAG_DRSHIFT;
      JTAG_DRSHIFT  : jtag_state_nxt = (TMS_i) ? JTAG_DREXIT1  : JTAG_DRSHIFT;
      JTAG_DREXIT1  : jtag_state_nxt = (TMS_i) ? JTAG_DRUPDATE : JTAG_DRPAUSE;
      JTAG_DRPAUSE  : jtag_state_nxt = (TMS_i) ? JTAG_DREXIT2  : JTAG_DRPAUSE;
      JTAG_DREXIT2  : jtag_state_nxt = (TMS_i) ? JTAG_DRUPDATE : JTAG_DRSHIFT;
      JTAG_DRUPDATE : jtag_state_nxt = (TMS_i) ? JTAG_DRSELECT : JTAG_RUN_IDLE;

      JTAG_IRSELECT : jtag_state_nxt = (TMS_i) ? JTAG_RESET    : JTAG_IRCAPTURE;
      JTAG_IRCAPTURE: jtag_state_nxt = (TMS_i) ? JTAG_IREXIT1  : JTAG_IRSHIFT;
      JTAG_IRSHIFT  : jtag_state_nxt = (TMS_i) ? JTAG_IREXIT1  : JTAG_IRSHIFT;
      JTAG_IREXIT1  : jtag_state_nxt = (TMS_i) ? JTAG_IRUPDATE : JTAG_IRPAUSE;
      JTAG_IRPAUSE  : jtag_state_nxt = (TMS_i) ? JTAG_IREXIT2  : JTAG_IRPAUSE;
      JTAG_IREXIT2  : jtag_state_nxt = (TMS_i) ? JTAG_IRUPDATE : JTAG_IRSHIFT;
      JTAG_IRUPDATE : jtag_state_nxt = (TMS_i) ? JTAG_DRSELECT : JTAG_RUN_IDLE;
    endcase
end

//========================================================
// State Machine state
//========================================================
wire [IR_WIDTH-1:0] irsft = {TDI_i, ir_shift_reg[IR_WIDTH-1:1]};
always @(posedge TCK_i or negedge TRSTn_i) begin
  if(~TRSTn_i) begin
    ir_reg <= 'h1;
    ir_shift_reg <= 'h0;
    dr_shift_reg <= 'h0;
    jtag_state <= JTAG_RESET;
    bypass <= 1'b0;
  end else begin
    bypass <= TDI_i;
    jtag_state <= jtag_state_nxt;
    casez(jtag_state)
          JTAG_RESET: ir_reg       <= 'h1;
      JTAG_DRCAPTURE: dr_shift_reg <= (ir_reg == IDCODE_IR) ? IDCODE : (ir_reg == DTM_CTRL_INSTR) ?  dmi_status : dmi_return;
        JTAG_DRSHIFT: dr_shift_reg <= ((ir_reg == DBG_MOD_IF_CHERI) | (ir_reg == DBG_MOD_IF_RV32)) ? {TDI_i,dr_shift_reg[DMI_BITS-1:1]} : {TDI_i, dr_shift_reg[31:1]};  // Cheri Diff
      JTAG_IRCAPTURE: ir_shift_reg <= ir_reg;
       JTAG_IRUPDATE: ir_reg       <= ir_shift_reg; 
        JTAG_IRSHIFT: ir_shift_reg <= {TDI_i, ir_shift_reg[IR_WIDTH-1:1]};
    endcase
  end
end

//=====================================
// Clock domain crossing
//=====================================
always @(posedge TCK_i or negedge updateRstn)
begin
  if(~updateRstn) begin
    apb_req_rv32  <= 1'b0;                                                              // Cheri Add
    apb_req_cheri <= 1'b0;                                                              // Cheri Add
  end else begin
    if((ir_reg == DBG_MOD_IF_CHERI) && dr_update)                                       // Cheri Add
      apb_req_cheri <= |dr_shift_reg[1:0];                                              // Cheri Add

    if ((ir_reg == DBG_MOD_IF_RV32) && dr_update)                                       // Cheri Add
      apb_req_rv32 <= |dr_shift_reg[2:1];                                               // Cheri Add
  end  
end

//=====================================
//=====================================
// System Clock domain
//=====================================
//=====================================

//=====================================
// APB State Machine
//=====================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    apb_state           <= APB_IDLE;
    psel_dmi_o          <= 1'b0;
    penable_dmi_o       <= 1'b0;
    paddr_dmi_o         <= 32'h0000_0000;
    pwdata_dmi_o        <= 32'h0000_0000;
    pwrite_dmi_o        <= 1'b0;
    rdata               <= 32'h0000_0000;
    slverr              <= 1'b0;
    req_ack             <= 1'b0; 
    apb_req_rv32_sclk   <= 2'b00;                                                       // Cheri Add
    apb_req_cheri_sclk  <= 1'b0;                                                        // Cheri Add
  end else begin
    apb_req_cheri_sclk <= {apb_req_cheri, apb_req_cheri_sclk[1]};                       // Cheri Add
    apb_req_rv32_sclk  <= {apb_req_rv32, apb_req_rv32_sclk[1]};                         // Cheri Add
    casez(apb_state)
      APB_IDLE: begin
        if(apb_req_cheri_sclk[0]) begin                                                 // Cheri Diff
          psel_dmi_o   <= 1'b1;
          paddr_dmi_o  <= dr_shift_reg[DMI_BITS-1:DMI_DATA_BITS+2];                     // Cheri Diff
          pwdata_dmi_o <= dr_shift_reg[DMI_DATA_BITS+1:2];                              // Cheri Diff
          pwrite_dmi_o <= dr_shift_reg[1];
          req_ack <= 1'b1;                                                              // Cheri Add
          apb_state <= APB_PSEL;                                                        // Cheri Add
        end else if(apb_req_rv32_sclk[0]) begin                                         // Cheri Add
          psel_dmi_o   <= 1'b1;                                                         // Cheri Add
          paddr_dmi_o  <= dr_shift_reg[DMI_BITS-1:DMI_DATA_BITS+2];                     // Cheri Add
          pwdata_dmi_o <= dr_shift_reg[DMI_DATA_BITS+1:3];                              // Cheri Add
          pwrite_dmi_o <= dr_shift_reg[2];                                              // Cheri Add
          req_ack <= 1'b1;
          apb_state <= APB_PSEL;
        end
      end 
      APB_PSEL: begin
        penable_dmi_o <= 1'b1;
        apb_state <= APB_PENABLE;
        req_ack <= 1'b0;
      end
      APB_PENABLE: begin
        if(pready_dmi_i) begin
          rdata <= prdata_dmi_i;
          slverr <= pslverr_dmi_i;
          psel_dmi_o <= 1'b0;
          penable_dmi_o <= 1'b0;
          apb_state <= APB_IDLE;
        end
      end
      default: apb_state <= APB_IDLE;
    endcase
  end  
end

endmodule
