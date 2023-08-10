
module msftDvIp_axi_def_sub #(
    parameter AXI_SUB_ID_WIDTH=4,
    parameter AXI_ADDR_WIDTH=32,
    parameter AXI_DATA_WIDTH=32,
    parameter AXI_LEN_WIDTH=8
  ) (
  input                                               clk_i,
  input                                               rstn_i,

  input      [AXI_SUB_ID_WIDTH-1:0]                   awid_sub_i,
  input      [AXI_ADDR_WIDTH-1:0]                     awaddr_sub_i,
  input      [AXI_LEN_WIDTH-1:0]                      awlen_sub_i,
  input      [2:0]                                    awsize_sub_i,
  input      [1:0]                                    awburst_sub_i,
  input      [3:0]                                    awcache_sub_i,
  input      [1:0]                                    awlock_sub_i,
  input      [2:0]                                    awprot_sub_i,
  input      [3:0]                                    awqos_sub_i,
  input                                               awvalid_sub_i,
  output reg                                          awready_sub_o,

  input      [AXI_SUB_ID_WIDTH-1:0]                   wid_sub_i,
  input      [AXI_DATA_WIDTH-1:0]                     wdata_sub_i,
  input                                               wlast_sub_i,
  input      [(AXI_DATA_WIDTH/8)-1:0]                 wstrb_sub_i,
  input                                               wvalid_sub_i,
  output                                              wready_sub_o,

  output reg [AXI_SUB_ID_WIDTH-1:0]                   bid_sub_o,
  output     [1:0]                                    bresp_sub_o,
  output reg                                          bvalid_sub_o,
  input                                               bready_sub_i, 
  
  input      [AXI_SUB_ID_WIDTH-1:0]                   arid_sub_i,
  input      [AXI_ADDR_WIDTH-1:0]                     araddr_sub_i,
  input      [AXI_LEN_WIDTH-1:0]                      arlen_sub_i,
  input      [2:0]                                    arsize_sub_i,
  input      [1:0]                                    arburst_sub_i,
  input      [3:0]                                    arcache_sub_i,
  input      [1:0]                                    arlock_sub_i,
  input      [2:0]                                    arprot_sub_i,
  input      [3:0]                                    arqos_sub_i,
  input                                               arvalid_sub_i,
  output reg                                          arready_sub_o,

  output reg [AXI_SUB_ID_WIDTH-1:0]                   rid_sub_o,
  output     [AXI_DATA_WIDTH-1:0]                     rdata_sub_o,
  output reg                                          rlast_sub_o,
  output     [1:0]                                    rresp_sub_o,
  output reg                                          rvalid_sub_o,
  input                                               rready_sub_i

);

localparam AXI_DECODE_ERROR     = 2'h3;

assign wready_sub_o = 1'b1;
assign bresp_sub_o = AXI_DECODE_ERROR;

assign rdata_sub_o = {AXI_DATA_WIDTH{1'b0}};
assign rresp_sub_o = AXI_DECODE_ERROR;

reg [AXI_LEN_WIDTH-1:0] rlen;
reg [AXI_LEN_WIDTH-1:0] wlen;
 
//=========================================
// AXI Slave Write Error
//=========================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    awready_sub_o <= 1'b1;
    bvalid_sub_o <= 1'b0;
    bid_sub_o <= {AXI_SUB_ID_WIDTH{1'b0}};
  end else if(awvalid_sub_i & awready_sub_o) begin
    awready_sub_o <= 1'b0;
    bid_sub_o <= awid_sub_i;
  end else if(wvalid_sub_i & wready_sub_o & wlast_sub_i) begin
    bvalid_sub_o <= 1'b1;
  end else if(bvalid_sub_o & bready_sub_i) begin
    awready_sub_o <= 1'b1;
    bvalid_sub_o <= 1'b0;
  end
end

//=========================================
// AXI Slave Read Error
//=========================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    arready_sub_o <= 1'b1;
    rvalid_sub_o <= 1'b0;
    rid_sub_o <= {AXI_SUB_ID_WIDTH{1'b0}};
    rlen <= {AXI_LEN_WIDTH{1'b0}};
    rlast_sub_o <= 1'b0;
  end else if(arvalid_sub_i & arready_sub_o) begin
    arready_sub_o <= 1'b0;
    rvalid_sub_o <= 1'b1;
    rid_sub_o <= arid_sub_i;
    rlen <= arlen_sub_i;
    rlast_sub_o <= arlen_sub_i == {AXI_LEN_WIDTH{1'b0}};
  end else if(rvalid_sub_o & rready_sub_i) begin
    arready_sub_o <= 1'b1;
    rvalid_sub_o <= |rlen;
    rlast_sub_o <= ~(|(rlen-1'b1));
    rlen <= rlen -1'b1;
  end
end

endmodule
