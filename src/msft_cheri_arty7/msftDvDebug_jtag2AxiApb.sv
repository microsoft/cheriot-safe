// Copyright (C) Microsoft Corporation. All rights reserved.




module msftDvDebug_jtag2AxiApb 
  import msftDvDebug_jtag2AxiApb_pkg::*;
  #(
    parameter IR_WIDTH=5,
    parameter bit [3:0] REV_ID = 0,
    parameter bit [15:0] PART_NUM = 16'hC000,
    parameter bit [10:0] MFG_ID = 11'h255 
  ) (
  input                       clk_i,
  input                       rstn_i,
  input                       disabled,

  input                       TCK_i,
  input                       TMS_i,
  input                       TDI_i,
  input                       TRSTn_i,
  output                      TDO_o,
  output                      TDOen_o,

  output [1:0]                axi_req_o,
  input                       axi_ack_i,
  output [AXI_CMD_WIDTH-1:0]  axi_cmd_o,
  input  [AXI_RESP_WIDTH-1:0] axi_resp_i,

  output [1:0]                apb_req_o,
  input                       apb_ack_i,
  output [APB_CMD_WIDTH-1:0]  apb_cmd_o,
  input  [APB_RESP_WIDTH-1:0] apb_resp_i

);


localparam IR_APB_ACCESS = 'hA;
localparam IR_APB_RD_WR  = 'hB;
localparam IR_AXI_ACCESS = 'hC;
localparam IR_AXI_RD_WR  = 'hD;

//==============================================
// Tap Controller wires
//==============================================
wire                        clk;
wire                        rstn;

wire                        TCK;
wire                        TMS;
wire                        TDI;
wire                        TRSTn;
wire                        TDO;
wire                        TDOen;

reg [DR_MAX_WIDTH-1:0]      jtag_shift;
reg [DR_MAX_WIDTH-1:0]      jtag_capture;

wire [IR_WIDTH-1:0]         ir;
wire                        dr_shift;
wire                        dr_capture;
wire                        dr_update;
wire                        dr_tdo;

wire [1:0]                  axi_req;
wire                        axi_ack;
wire [AXI_CMD_WIDTH-1:0]    axi_cmd;
wire [AXI_RESP_WIDTH-1:0]   axi_resp;

wire [1:0]                  apb_req;
wire                        apb_ack;
wire [APB_CMD_WIDTH-1:0]    apb_cmd;
wire [APB_RESP_WIDTH-1:0]   apb_resp;

reg           jcpt_os;
reg [3:0]     jcpt;
reg           dr_hld;

localparam bit [31:0] IDCODE = {REV_ID, PART_NUM, MFG_ID, 1'b1};

assign apb_access = ir == IR_APB_ACCESS;
assign apb_rd_wr  = ir == IR_APB_RD_WR;
assign axi_access = ir == IR_AXI_ACCESS;
assign axi_rd_wr  = ir == IR_AXI_RD_WR;
assign local_access = apb_access | apb_rd_wr | axi_access | axi_rd_wr;

assign apb_req = {jcpt_os & apb_access, jcpt_os & apb_rd_wr};
assign axi_req = {jcpt_os & axi_access, jcpt_os & axi_rd_wr}; 
assign jcpt_rst = ((|apb_req) & apb_ack) | ((|axi_req) & axi_ack);

assign dr_tdo = jtag_shift[0];

assign apb_cmd = jtag_capture[APB_CMD_WIDTH-1:0];
assign axi_cmd = jtag_capture[AXI_CMD_WIDTH-1:0];

//==============================================
// Shifter
//==============================================
always @(posedge TCK or negedge TRSTn)
begin
  if(~TRSTn) begin
    jtag_shift   <= {DR_MAX_WIDTH{1'b0}};
    jtag_capture <= {DR_MAX_WIDTH{1'b0}};
  end else if(apb_access) begin
    if(dr_shift) begin
      jtag_shift[APB_SCMD_SHIFT_WIDTH-1:0] <= {TDI, jtag_shift[APB_SCMD_WIDTH-1:1]};
    end else if(dr_capture) begin
      jtag_shift[APB_RESP_WIDTH-1:0] = apb_resp;
    end else if(dr_update) begin
      jtag_capture[APB_SCMD_WIDTH-1:0] <= jtag_shift[APB_SCMD_WIDTH-1:0];
    end
  end else if(apb_rd_wr) begin
    if(dr_shift) begin
      jtag_shift[APB_CMD_SHIFT_WIDTH-1:0] <= {TDI, jtag_shift[APB_CMD_WIDTH-1:1]};
    end else if(dr_capture) begin
      jtag_shift[APB_RESP_WIDTH-1:0] = apb_resp;
    end else if(dr_update) begin
      jtag_capture[APB_CMD_WIDTH-1:0] <= jtag_shift[APB_CMD_WIDTH-1:0];
    end
  end else if(axi_access) begin
    if(dr_shift) begin
      jtag_shift[AXI_SCMD_WIDTH-1:0] <= {TDI, jtag_shift[AXI_SCMD_WIDTH-1:1]};
    end else if(dr_capture) begin
      jtag_shift[AXI_RESP_WIDTH-1:0] = axi_resp;
    end else if(dr_update) begin
      jtag_capture[AXI_SCMD_WIDTH-1:0] <= jtag_shift[AXI_SCMD_WIDTH-1:0];
    end
  end else if(axi_rd_wr) begin
    if(dr_shift) begin
      jtag_shift[AXI_CMD_WIDTH-1:0] <= {TDI, jtag_shift[AXI_CMD_WIDTH-1:1]};
    end else if(dr_capture) begin
      jtag_shift[AXI_RESP_WIDTH-1:0] = axi_resp;
    end else if(dr_update) begin
      jtag_capture[AXI_CMD_WIDTH-1:0] <= jtag_shift[AXI_CMD_WIDTH-1:0];
    end
  end
end

//==============================================
// Tap Controller
//==============================================
msftDvDebug_jtag_tap #(
    .IR_WIDTH(IR_WIDTH),
    .IDCODE(IDCODE) 
    ) msftDvDebug_jtag_tap_i (
  .TCLK                          ( TCK                                     ),
  .TMS                           ( TMS                                      ),
  .TDI                           ( TDI                                      ),
  .TRSTn                         ( TRSTn                                    ),
  .TDO                           ( TDO                                      ),
  .TDOen                         ( TDOen                                    ),
  .ir                            ( ir                                       ),
  .dr_shift                      ( dr_shift                                 ),
  .dr_capture                    ( dr_capture                               ),
  .dr_update                     ( dr_update                                ),
  .dr_tdo                        ( dr_tdo                                   )
);

//==============================================
// Clock Domain Crossing
//==============================================
assign dr_update_rst = TRSTn & ~jcpt_os;

always @(posedge TCK or negedge dr_update_rst)
begin
  if(~dr_update_rst) begin
    dr_hld <= 1'b0;
  end else begin
    if(dr_update & local_access) begin
      dr_hld <= 1'b1;
    end
  end
end

always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    jcpt_os <= 1'b0;
    jcpt <= 3'b000;
  end else begin
    jcpt <= {jcpt[1:0], dr_hld};
    if(~jcpt_os && jcpt == 3'h7) begin
      jcpt_os <= 1'b1;
    end else if(jcpt_rst) begin
      jcpt_os <= 1'b0;
    end
  end
end

//==============================================
// Input/Output pin muxing
//==============================================
assign clk          = clk_i;
assign rstn         = rstn_i;

assign TCK         = TCK_i;
assign TMS          = disabled ? 1'b1 : TMS_i;
assign TDI          = TDI_i;
assign TRSTn        = TRSTn_i;
assign TDO_o        = disabled ? TDI : TDO;
assign TDOen_o      = ~TDOen;

assign axi_req_o    = axi_req;
assign axi_ack      = axi_ack_i;
assign axi_cmd_o    = axi_cmd;
assign axi_resp     = axi_resp_i;

assign apb_req_o    = apb_req;
assign apb_ack      = apb_ack_i;
assign apb_cmd_o    = apb_cmd;
assign apb_resp     = apb_resp_i;

endmodule
