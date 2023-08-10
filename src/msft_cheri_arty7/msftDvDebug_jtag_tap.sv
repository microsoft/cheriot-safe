// Copyright (C) Microsoft Corporation. All rights reserved.




module msftDvDebug_jtag_tap #(
    parameter IR_WIDTH=5,
    parameter IDCODE=32'ha55a5aa5,
    parameter IDCODE_IR='h1
  ) (

  input TCLK,
  input TMS,
  input TDI,
  input TRSTn,

  output reg TDO,
  output TDOen,

  output [IR_WIDTH-1:0] ir,

  output dr_shift,
  output dr_capture,
  output dr_update,
  input dr_tdo

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

//========================================================
// Registers/Wires
//========================================================
reg [3:0]   jtag_state, jtag_state_nxt;
reg [IR_WIDTH-1:0]   ir_reg, ir_reg_shift;
reg [31:0]    dr_shift_reg;
reg           bypass;
reg           TDO_reg;

assign dr_shift = jtag_state == JTAG_DRSHIFT;
assign dr_capture = jtag_state == JTAG_DRCAPTURE;
assign dr_update = jtag_state == JTAG_DRUPDATE;

assign ir = ir_reg;
assign ir = ir_reg;
assign TDOen = jtag_state == JTAG_DRSHIFT || jtag_state == JTAG_IRSHIFT;

always @(negedge TCLK)
begin
  TDO <= TDO_reg;
end

always @*
begin
  casez(jtag_state)
    JTAG_IRSHIFT: TDO_reg = ir_reg_shift[0];
    JTAG_DRSHIFT: TDO_reg = (&ir_reg) ? bypass : (ir_reg == IDCODE_IR) ? dr_shift_reg[0] : dr_tdo;
         default: TDO_reg = 1'b0;
  endcase
end

//========================================================
// Bypass bit
//========================================================
always @(posedge TCLK)
begin
  bypass <= TDI;
end

//========================================================
// State Machine next state
//========================================================
always @* begin
    jtag_state_nxt = jtag_state;
    casez (jtag_state)
      JTAG_RESET    : jtag_state_nxt = (TMS) ? JTAG_RESET    : JTAG_RUN_IDLE;
      JTAG_RUN_IDLE : jtag_state_nxt = (TMS) ? JTAG_DRSELECT : JTAG_RUN_IDLE;

      JTAG_DRSELECT : jtag_state_nxt = (TMS) ? JTAG_IRSELECT : JTAG_DRCAPTURE;
      JTAG_DRCAPTURE: jtag_state_nxt = (TMS) ? JTAG_DREXIT1  : JTAG_DRSHIFT;
      JTAG_DRSHIFT  : jtag_state_nxt = (TMS) ? JTAG_DREXIT1  : JTAG_DRSHIFT;
      JTAG_DREXIT1  : jtag_state_nxt = (TMS) ? JTAG_DRUPDATE : JTAG_DRPAUSE;
      JTAG_DRPAUSE  : jtag_state_nxt = (TMS) ? JTAG_DREXIT2  : JTAG_DRPAUSE;
      JTAG_DREXIT2  : jtag_state_nxt = (TMS) ? JTAG_DRUPDATE : JTAG_DRSHIFT;
      JTAG_DRUPDATE : jtag_state_nxt = (TMS) ? JTAG_DRSELECT : JTAG_RUN_IDLE;

      JTAG_IRSELECT : jtag_state_nxt = (TMS) ? JTAG_RESET    : JTAG_IRCAPTURE;
      JTAG_IRCAPTURE: jtag_state_nxt = (TMS) ? JTAG_IREXIT1  : JTAG_IRSHIFT;
      JTAG_IRSHIFT  : jtag_state_nxt = (TMS) ? JTAG_IREXIT1  : JTAG_IRSHIFT;
      JTAG_IREXIT1  : jtag_state_nxt = (TMS) ? JTAG_IRUPDATE : JTAG_IRPAUSE;
      JTAG_IRPAUSE  : jtag_state_nxt = (TMS) ? JTAG_IREXIT2  : JTAG_IRPAUSE;
      JTAG_IREXIT2  : jtag_state_nxt = (TMS) ? JTAG_IRUPDATE : JTAG_IRSHIFT;
      JTAG_IRUPDATE : jtag_state_nxt = (TMS) ? JTAG_DRSELECT : JTAG_RUN_IDLE;
    endcase
end

//========================================================
// State Machine state
//========================================================
wire [IR_WIDTH-1:0] irsft = {TDI, ir_reg_shift[IR_WIDTH-1:1]};
always @(posedge TCLK or negedge TRSTn) begin
  if(~TRSTn) begin
    ir_reg <= 'h1;
    ir_reg_shift <= 'h0;
    dr_shift_reg <= 32'h0000_0000;
  end else begin
    casez(jtag_state)
          JTAG_RESET: ir_reg       <= 'h1;
      JTAG_DRCAPTURE: dr_shift_reg <= IDCODE;
        JTAG_DRSHIFT: dr_shift_reg <= {TDI,dr_shift_reg[31:1]};
      JTAG_IRCAPTURE: ir_reg_shift <= ir_reg;
       JTAG_IRUPDATE: ir_reg       <= ir_reg_shift; 
        JTAG_IRSHIFT: ir_reg_shift <= {TDI, ir_reg_shift[IR_WIDTH-1:1]};
    endcase
  end
end

//========================================================
// State Machine state
//========================================================
always @(posedge TCLK or negedge TRSTn) begin
  if(~TRSTn) begin
    jtag_state <= JTAG_RESET;
  end else begin
    jtag_state <= jtag_state_nxt;
  end
end

endmodule
