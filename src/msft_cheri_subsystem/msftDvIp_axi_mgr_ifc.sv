

module msftDvIp_axi_mgr_ifc #(
    parameter MGR_NUM=0,
    parameter AXI_MGR_ID_WIDTH=4,
    parameter AXI_ADDR_WIDTH=32,
    parameter AXI_DATA_WIDTH=32,
    parameter AXI_LEN_WIDTH=8,
    parameter AXI_USER_WIDTH=4,
    parameter MGR_ID_BITS=2,
    parameter APHASE_LEN=100,
    parameter WPHASE_LEN=50,
    parameter RPHASE_LEN=50,
    parameter BPHASE_LEN=10,
    parameter NUM_SUBS=2,
    parameter AXI_FIFO_SIZE=2
  )  (

  input                                       clk_i,
  input                                       rstn_i,

  input  [AXI_MGR_ID_WIDTH-1:0]               awid_mgr_i,
  input  [AXI_ADDR_WIDTH-1:0]                 awaddr_mgr_i,
  input  [AXI_LEN_WIDTH-1:0]                  awlen_mgr_i,
  input  [AXI_USER_WIDTH-1:0]                 awuser_mgr_i,
  input  [3:0]                                awregion_mgr_i,
  input  [2:0]                                awsize_mgr_i,
  input  [1:0]                                awburst_mgr_i,
  input  [3:0]                                awcache_mgr_i,
  input  [1:0]                                awlock_mgr_i,
  input  [2:0]                                awprot_mgr_i,
  input  [3:0]                                awqos_mgr_i,
  input                                       awvalid_mgr_i,
  output                                      awready_mgr_o,

  input  [AXI_MGR_ID_WIDTH-1:0]               wid_mgr_i,
  input  [AXI_DATA_WIDTH-1:0]                 wdata_mgr_i,
  input  [(AXI_DATA_WIDTH/8)-1:0]             wstrb_mgr_i,
  input                                       wlast_mgr_i,
  input                                       wvalid_mgr_i,
  output                                      wready_mgr_o,

  output     [AXI_MGR_ID_WIDTH-1:0]           bid_mgr_o,
  output     [1:0]                            bresp_mgr_o,
  output                                      bvalid_mgr_o,
  input                                       bready_mgr_i,
  
  input  [AXI_MGR_ID_WIDTH-1:0]               arid_mgr_i,
  input  [AXI_ADDR_WIDTH-1:0]                 araddr_mgr_i,
  input  [AXI_LEN_WIDTH-1:0]                  arlen_mgr_i,
  input  [AXI_USER_WIDTH-1:0]                 aruser_mgr_i,
  input  [3:0]                                arregion_mgr_i,
  input  [2:0]                                arsize_mgr_i,
  input  [1:0]                                arburst_mgr_i,
  input  [3:0]                                arcache_mgr_i,
  input  [1:0]                                arlock_mgr_i,
  input  [2:0]                                arprot_mgr_i,
  input  [3:0]                                arqos_mgr_i,
  input                                       arvalid_mgr_i,
  output                                      arready_mgr_o,

  output     [AXI_MGR_ID_WIDTH-1:0]           rid_mgr_o,
  output     [AXI_DATA_WIDTH-1:0]             rdata_mgr_o,
  output                                      rlast_mgr_o,
  output     [1:0]                            rresp_mgr_o,
  output                                      rvalid_mgr_o,
  input                                       rready_mgr_i,

  output [APHASE_LEN-1:0]                     awphase_o,
  output [NUM_SUBS-1:0]                       awphase_valid_o,
  input                                       awphase_ready_i,
  output [AXI_ADDR_WIDTH-1:0]                 awphase_addr_o,
  input  [NUM_SUBS-1:0]                       awphase_decode_i,

  output [WPHASE_LEN-1:0]                     wphase_o,
  output [NUM_SUBS-1:0]                       wphase_valid_o,
  input                                       wphase_ready_i,

  input  [BPHASE_LEN-1:0]                     bphase_i,
  input                                       bphase_valid_i,
  output                                      bphase_ready_o,

  output [APHASE_LEN-1:0]                     arphase_o,
  output [NUM_SUBS-1:0]                       arphase_valid_o,
  input                                       arphase_ready_i,
  output [AXI_ADDR_WIDTH-1:0]                 arphase_addr_o,
  input  [NUM_SUBS-1:0]                       arphase_decode_i,

  input  [RPHASE_LEN-1:0]                     rphase_i,
  input                                       rphase_valid_i,
  output                                      rphase_ready_o

);

`include "msftDvIp_axi_include.svh"

localparam WPHASE_RDY = 3'h0;
localparam WPHASE_ACCEPT_WRITES =3'h1;
localparam WPHASE_WAIT4SLV = 3'h2;
localparam WPHASE_ACCEPT_AND_SEND_WRITES = 3'h3;
localparam WPHASE_WAIT4DONE = 3'h4;

reg [NUM_SUBS-1:0] wreq_hld;
reg [2:0] wphase_state;

//==============================================
// Write Address phase transaction
//==============================================
ADDR_PHASE_t awphase_i;
ADDR_PHASE_t awphase_t;
reg awphase_valid;
assign wrdy = wphase_state == WPHASE_RDY;

wire awready_mgr;

assign awphase_t = awphase_o;
assign awphase_addr_o = awphase_t.addr;
assign awphase_valid_o = {NUM_SUBS{awphase_valid}} & awphase_decode_i;
assign awready_mgr_o = awready_mgr & wrdy;

assign awphase_i.id = awid_mgr_i;
assign awphase_i.region = awregion_mgr_i;
assign awphase_i.user = awuser_mgr_i;
assign awphase_i.addr = awaddr_mgr_i;
assign awphase_i.len = awlen_mgr_i;
assign awphase_i.size = awsize_mgr_i;
assign awphase_i.burst = awburst_mgr_i;
assign awphase_i.cache = awcache_mgr_i;
assign awphase_i.lock = awlock_mgr_i;
assign awphase_i.prot = awprot_mgr_i;
assign awphase_i.qos = awqos_mgr_i;
assign awphase_i.mgrnum = MGR_NUM;

msftDvIp_axi_fifo #(
    .FIFO_SIZE(AXI_FIFO_SIZE),
    .FIFO_DATA_WIDTH(APHASE_LEN)
  )  aw_addr_fifo_i (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wrReq(awvalid_mgr_i & wrdy),
    .wrAck(awready_mgr),
    .wdata(awphase_i),
    .rdReq(awphase_ready_i),
    .rdAck(awphase_valid),
    .rdata(awphase_o)
);

//==============================================
// Write Data phase transaction
//==============================================
wire wready_mgr;
wire   wphase_valid;
WDATA_PHASE_t wphase, wphase1;

assign wphase1.id = wid_mgr_i;
assign wphase1.data = wdata_mgr_i;
assign wphase1.strb = wstrb_mgr_i;
assign wphase1.last = wlast_mgr_i;
assign wphase1.mgrnum = MGR_NUM;

assign awphase_accept    =  awphase_valid & awphase_ready_i;
assign accept_mgr_writes =  wphase_state == WPHASE_ACCEPT_WRITES || wphase_state == WPHASE_ACCEPT_AND_SEND_WRITES;
assign send_slv_writes   =  awphase_accept || wphase_state == WPHASE_ACCEPT_AND_SEND_WRITES || wphase_state == WPHASE_WAIT4DONE;
assign last_write = wvalid_mgr_i & wready_mgr_o & wlast_mgr_i;

assign wphase_valid_o = {NUM_SUBS{wphase_valid & send_slv_writes}} & ((awphase_accept) ? awphase_decode_i : wreq_hld);
assign wready_mgr_o = wready_mgr && accept_mgr_writes;


always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    wphase_state <= WPHASE_RDY;
    wreq_hld <= {NUM_SUBS{1'b0}};
  end else begin
    casez (wphase_state)
      // WPHASE_RDY blocks wready and enables awready and awvalid
      WPHASE_RDY: begin
        if(awvalid_mgr_i & awready_mgr_o) begin
          wphase_state <= WPHASE_ACCEPT_WRITES;
        end
      end
      // Address transaction accepted 
      WPHASE_ACCEPT_WRITES: begin
        if(awphase_accept) begin
          wreq_hld <= awphase_decode_i;
          wphase_state <= (last_write) ? WPHASE_WAIT4DONE : WPHASE_ACCEPT_AND_SEND_WRITES;
        end else if(last_write) begin
          wphase_state <= WPHASE_WAIT4SLV;
        end
      end
      // Already have the data just waiting on the sub to accept the transaction
      WPHASE_WAIT4SLV: begin
        if(awphase_accept) begin
          wreq_hld <= awphase_decode_i;
          wphase_state <= WPHASE_WAIT4DONE;
        end
      end
      // enables wready and blocks awready and awvalid
      WPHASE_ACCEPT_AND_SEND_WRITES: begin
        if(last_write) begin
          wphase_state <= WPHASE_WAIT4DONE;
        end
      end
      // blocks wready, awready and wvalid
      // Wait here till fifo empty (~wphase valid is = fifo_empty) 
      WPHASE_WAIT4DONE: begin
        if(~wphase_valid) begin
          wphase_state <= WPHASE_RDY;
        end
      end
      default: wphase_state <= WPHASE_RDY;
    endcase
  end 
end

msftDvIp_axi_fifo #(
    .FIFO_SIZE(AXI_FIFO_SIZE),
    .FIFO_DATA_WIDTH(WPHASE_LEN)
  )  w_data_fifo_i (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wrReq(wvalid_mgr_i & wready_mgr_o),
    .wrAck(wready_mgr),
    .wdata(wphase1),
    .rdReq(wphase_ready_i),
    .rdAck(wphase_valid),
    .rdata(wphase_o)
);

//==============================================
// Write Resp phase transaction
//==============================================
RESP_PHASE_t  bphase_o;
assign bid_mgr_o = bphase_o.id;
assign bresp_mgr_o = bphase_o.resp;

msftDvIp_axi_fifo #(
    .FIFO_SIZE(AXI_FIFO_SIZE),
    .FIFO_DATA_WIDTH(BPHASE_LEN)
  )  b_data_fifo_i (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wrReq(bphase_valid_i),
    .wrAck(bphase_ready_o),
    .wdata(bphase_i),
    .rdReq(bready_mgr_i),
    .rdAck(bvalid_mgr_o),
    .rdata(bphase_o)
);

//==============================================
// Read  Address phase transaction
//==============================================
reg rd_in_progress;

ADDR_PHASE_t arphase_i;
ADDR_PHASE_t arphase_t;
wire arphase_valid;
assign arphase_t = arphase_o;
assign arphase_addr_o = arphase_t.addr;
assign arphase_valid_o = {NUM_SUBS{arphase_valid}} & arphase_decode_i;

assign arphase_i.id = arid_mgr_i;
assign arphase_i.region = arregion_mgr_i;
assign arphase_i.user = aruser_mgr_i;
assign arphase_i.addr = araddr_mgr_i;
assign arphase_i.len = arlen_mgr_i;
assign arphase_i.size = arsize_mgr_i;
assign arphase_i.burst = arburst_mgr_i;
assign arphase_i.cache = arcache_mgr_i;
assign arphase_i.lock = arlock_mgr_i;
assign arphase_i.prot = arprot_mgr_i;
assign arphase_i.qos = arqos_mgr_i;
assign arphase_i.mgrnum = MGR_NUM;

wire arready_mgr;
assign arready_mgr_o = arready_mgr & ~rd_in_progress;

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    rd_in_progress <= 1'b0;
  end else begin
    if(arvalid_mgr_i & arready_mgr_o) begin
      rd_in_progress <= 1'b1;
    end else if(rvalid_mgr_o & rready_mgr_i & rlast_mgr_o) begin
      rd_in_progress <= 1'b0;
    end
  end
end

msftDvIp_axi_fifo #(
    .FIFO_SIZE(AXI_FIFO_SIZE),
    .FIFO_DATA_WIDTH(APHASE_LEN)
  )  ar_data_fifo_i (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wrReq(arvalid_mgr_i & arready_mgr_o),
    .wrAck(arready_mgr),
    .wdata(arphase_i),
    .rdReq(arphase_ready_i),
    .rdAck(arphase_valid),
    .rdata(arphase_o)
);

//==============================================
// Read Data phase transaction
//==============================================
RDATA_PHASE_t rphase_o;
assign rid_mgr_o = rphase_o.id;
assign rdata_mgr_o = rphase_o.data;
assign rlast_mgr_o = rphase_o.last;
assign rresp_mgr_o = rphase_o.resp;

msftDvIp_axi_fifo #(
    .FIFO_SIZE(AXI_FIFO_SIZE),
    .FIFO_DATA_WIDTH(RPHASE_LEN)
  )  r_data_fifo_i (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wrReq(rphase_valid_i),
    .wrAck(rphase_ready_o),
    .wdata(rphase_i),
    .rdReq(rready_mgr_i),
    .rdAck(rvalid_mgr_o),
    .rdata(rphase_o)
);

endmodule
