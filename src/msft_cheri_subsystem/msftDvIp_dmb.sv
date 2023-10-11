


//======================================================
// Module
//======================================================
module msftDvIp_dmb #(
  parameter ADDR_BITS=64,
  parameter DATA_BITS=64,
  parameter DSTRBS_BITS=8,
  parameter REG_LOW=18,
  parameter REG_BASE_ADDR=32'h8f0f_0000,
  parameter ID_BITS = 5,
  parameter USER_BITS=12,
  parameter DATAS_BITS=32,
  parameter STRBS_BITS_S=4

  )   (
  input                                      clk_i,
  input                                      rstn_i,

  output reg [ID_BITS-1:0]                   arid_dmb_m_o,
  output reg [ADDR_BITS-1:0]                 araddr_dmb_m_o,
  output reg [7:0]                           arlen_dmb_m_o,
  output reg [USER_BITS-1:0]                 aruser_dmb_m_o,
  output reg [3:0]                           arregion_dmb_m_o,
  output reg [2:0]                           arsize_dmb_m_o,
  output reg [1:0]                           arburst_dmb_m_o,
  output reg [3:0]                           arcache_dmb_m_o,
  output reg [1:0]                           arlock_dmb_m_o,
  output reg [2:0]                           arprot_dmb_m_o,
  output reg [3:0]                           arqos_dmb_m_o,
  output reg                                 arvalid_dmb_m_o,
  input                                      arready_dmb_m_i,

  input  [ID_BITS-1:0]                       rid_dmb_m_i,
  input  [DATA_BITS-1:0]                     rdata_dmb_m_i,
  input                                      rlast_dmb_m_i,
  input  [1:0]                               rresp_dmb_m_i,
  input                                      rvalid_dmb_m_i,
  output reg                                 rready_dmb_m_o,

  output     [ID_BITS-1:0]                   awid_dmb_m_o,
  output     [ADDR_BITS-1:0]                 awaddr_dmb_m_o,
  output     [7:0]                           awlen_dmb_m_o,
  output     [USER_BITS-1:0]                 awuser_dmb_m_o,
  output     [3:0]                           awregion_dmb_m_o,
  output     [2:0]                           awsize_dmb_m_o,
  output     [1:0]                           awburst_dmb_m_o,
  output     [3:0]                           awcache_dmb_m_o,
  output     [1:0]                           awlock_dmb_m_o,
  output     [2:0]                           awprot_dmb_m_o,
  output     [3:0]                           awqos_dmb_m_o,
  output                                     awvalid_dmb_m_o,
  input                                      awready_dmb_m_i,

  output reg [ID_BITS-1:0]                   wid_dmb_m_o,
  output reg [DATA_BITS-1:0]                 wdata_dmb_m_o,
  output reg                                 wlast_dmb_m_o,
  output reg [DSTRBS_BITS-1:0]                wstrb_dmb_m_o,
  output reg                                 wvalid_dmb_m_o,
  input                                      wready_dmb_m_i,

  input  [ID_BITS-1:0]                       bid_dmb_m_i,
  input  [1:0]                               bresp_dmb_m_i,
  input                                      bvalid_dmb_m_i,
  output reg                                 bready_dmb_m_o,

  input  [ID_BITS-1:0]                       arid_dmb_s_i,
  input  [31:0]                              araddr_dmb_s_i,
  input  [7:0]                               arlen_dmb_s_i,
  input  [USER_BITS-1:0]                     aruser_dmb_s_i,
  input  [3:0]                               arregion_dmb_s_i,
  input  [2:0]                               arsize_dmb_s_i,
  input  [1:0]                               arburst_dmb_s_i,
  input  [3:0]                               arcache_dmb_s_i,
  input  [1:0]                               arlock_dmb_s_i,
  input  [2:0]                               arprot_dmb_s_i,
  input  [3:0]                               arqos_dmb_s_i,
  input                                      arvalid_dmb_s_i,
  output                                     arready_dmb_s_o,

  output     [ID_BITS-1:0]                   rid_dmb_s_o,
  output     [DATAS_BITS-1:0]               rdata_dmb_s_o,
  output                                     rlast_dmb_s_o,
  output     [1:0]                           rresp_dmb_s_o,
  output                                     rvalid_dmb_s_o,
  input                                      rready_dmb_s_i,

  input  [ID_BITS-1:0]                       awid_dmb_s_i,
  input  [31:0]                              awaddr_dmb_s_i,
  input  [7:0]                               awlen_dmb_s_i,
  input  [USER_BITS-1:0]                     awuser_dmb_s_i,
  input  [3:0]                               awregion_dmb_s_i,
  input  [2:0]                               awsize_dmb_s_i,
  input  [1:0]                               awburst_dmb_s_i,
  input  [3:0]                               awcache_dmb_s_i,
  input  [1:0]                               awlock_dmb_s_i,
  input  [2:0]                               awprot_dmb_s_i,
  input  [3:0]                               awqos_dmb_s_i,
  input                                      awvalid_dmb_s_i,
  output                                     awready_dmb_s_o,

  input  [ID_BITS-1:0]                       wid_dmb_s_i,
  input  [DATAS_BITS-1:0]                   wdata_dmb_s_i,
  input                                      wlast_dmb_s_i,
  input  [STRBS_BITS_S-1:0]                   wstrb_dmb_s_i,
  input                                      wvalid_dmb_s_i,
  output                                     wready_dmb_s_o,

  output     [ID_BITS-1:0]                   bid_dmb_s_o,
  output reg [1:0]                           bresp_dmb_s_o,
  output                                     bvalid_dmb_s_o,
  input                                      bready_dmb_s_i
);

//=============================================
//  Parameters
//=============================================
localparam AW_IDLE     = 3'h0;
localparam AW_REG      = 3'h1;
localparam AW_DMB      = 3'h2;
localparam AW_EXEC     = 3'h3;
localparam AW_MRESP    = 3'h4;
localparam AW_RESP     = 3'h5;

localparam AR_IDLE     = 3'h0;
localparam AR_REG      = 3'h1;
localparam AR_DMB      = 3'h2;
localparam AR_EXEC     = 3'h3;
localparam AR_MRESP    = 3'h4;
localparam AR_RESP     = 3'h5;

//======================================================
// Structures
//======================================================
typedef struct packed {
  logic [ID_BITS-1:0]           id;
  logic [31:0]                  addr;
  logic [7:0]                   len;
  logic [USER_BITS-1:0]         user;
  logic [3:0]                   region;
  logic [2:0]                   size;
  logic [1:0]                   burst;
  logic [3:0]                   cache;
  logic [1:0]                   lock;
  logic [2:0]                   prot;
  logic [3:0]                   qos;
  logic                         areq;
  logic [31:0]                  data;
  logic [3:0]                   strb;
  logic                         last;
  logic                         wreq;
} AXI_A_BUS_t;

typedef struct packed {
  logic [DATAS_BITS-1:0]       data;
  logic [STRBS_BITS_S-1:0]       strb;                         
  logic                         last;
} AXI_W_BUS_t;

typedef struct packed {
  logic [63:0]                  data;
  logic [1:0]                   resp;
  logic                         last;
} AXI_R_BUS_t;

//=============================================
//  Registers/Wires
//=============================================
AXI_A_BUS_t     aw;
AXI_W_BUS_t     wd, fwd;

AXI_A_BUS_t     ar;
AXI_R_BUS_t     rd, frd;

reg [2:0]       awstate;
reg [2:0]       arstate;
reg [7:0]       awlen_cnt;
reg [7:0]       arlen_cnt;

wire [63:0]     wr_trans_addr;
wire [63:0]     rd_trans_addr;

wire            wready;
wire            wvalid;

wire            regrd_cs;
reg  [31:0]     regrd_data;


//=============================================
//  Assignments Transaction
//=============================================
assign wd.data = wdata_dmb_s_i;
assign wd.last = wlast_dmb_s_i;
assign wd.strb = wstrb_dmb_s_i;

assign awready_dmb_s_o = awstate == AW_IDLE;
assign arready_dmb_s_o = arstate == AR_IDLE;

// assign aw.wreq = (awstate == AW_EXEC) && wready;  //QQQ kliu: is this actually used?

assign wready = (awstate == AW_REG) | (awstate == AW_EXEC);

assign awid_dmb_m_o = aw.id;
assign awaddr_dmb_m_o = wr_trans_addr;
assign awlen_dmb_m_o = aw.len;
assign awuser_dmb_m_o = aw.user;
assign awregion_dmb_m_o = aw.region;
assign awsize_dmb_m_o = aw.size;
assign awburst_dmb_m_o = aw.burst;
assign awcache_dmb_m_o = aw.cache;
assign awlock_dmb_m_o = aw.lock;
assign awprot_dmb_m_o = aw.prot;
assign awqos_dmb_m_o = aw.qos;
assign awvalid_dmb_m_o = awstate == AW_DMB;

generate
  if(DATAS_BITS == 32) begin
    assign wdata_dmb_m_o = {fwd.data, fwd.data};
    assign wstrb_dmb_m_o = (aw.addr[2]) ? {fwd.strb, 4'h0} : {4'h0, fwd.strb};
  end else if(DATAS_BITS == 64) begin
    assign wdata_dmb_m_o = fwd.data;
    assign wstrb_dmb_m_o = fwd.strb;
  end else begin
    //$error("Invalid number of DATA Bits");
  end
endgenerate

assign wid_dmb_m_o = {ID_BITS{1'b0}};
assign wlast_dmb_m_o = fwd.last;
assign wvalid_dmb_m_o = (awstate == AW_EXEC) & wvalid;

assign bready_dmb_m_o = (awstate == AW_MRESP);
assign bid_dmb_s_o = aw.id;
assign bvalid_dmb_s_o = awstate == AW_RESP;

//=============================================
//  Address Write Transaction
//=============================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    aw.id <= {ID_BITS{1'b0}};
    aw.addr <= 32'h0000_0000;
    aw.len  <= 8'h00;
    aw.user <= {USER_BITS{1'b0}};
    aw.region <= 4'h0;
    aw.size <= 3'h0;
    aw.burst <= 2'h0;
    aw.cache <=4'h0 ;
    aw.lock <= 2'h0;
    aw.prot <= 3'h0;
    aw.qos  <= 4'h0;
    awstate <= AW_IDLE;
    bresp_dmb_s_o <= 2'h0;
    awlen_cnt <= 8'h00;
  end else begin
    casez(awstate)
    AW_IDLE: begin
      if(awvalid_dmb_s_i & awready_dmb_s_o)begin
        aw.id <= awid_dmb_s_i;
        aw.addr <= awaddr_dmb_s_i;
        aw.len  <= awlen_dmb_s_i;
        awlen_cnt <= awlen_dmb_s_i;
        aw.user <= awuser_dmb_s_i;
        aw.region <= awregion_dmb_s_i;
        aw.size <= awsize_dmb_s_i;
        aw.burst <= awburst_dmb_s_i;
        aw.cache <= awcache_dmb_s_i;
        aw.lock <= awlock_dmb_s_i;
        aw.prot <= awprot_dmb_s_i;
        aw.qos  <= awqos_dmb_s_i;
        awstate <= (vldDmbAddr(awaddr_dmb_s_i)) ? AW_DMB : AW_REG;
      end
    end
    AW_REG: begin
      if(wvalid) begin
        bresp_dmb_s_o <= (vldRegAddr(aw.addr)) ? 2'h0 : 2'h2;
        awstate <= AW_RESP;
      end
    end
    AW_DMB: begin
      if(awready_dmb_m_i) begin
        awstate <= AW_EXEC;
      end
    end
    AW_EXEC: begin
      if(wvalid_dmb_m_o & wready_dmb_m_i) begin
        awlen_cnt <= awlen_cnt - 1'b1;
        if(awlen_cnt == 8'h00) begin
          awstate <= AW_MRESP;
        end
      end
    end
    AW_MRESP: begin
      if(bvalid_dmb_m_i) begin
        bresp_dmb_s_o <= bresp_dmb_m_i; 
        awstate <= AW_RESP;
      end
    end
    AW_RESP: begin
      if(bvalid_dmb_s_o & bready_dmb_s_i) begin
        bresp_dmb_s_o <= 2'h0;
        awstate <= AW_IDLE;
      end
    end
    endcase
  end
end


//=============================================
//  Data Write Fifo
//=============================================
msftDvIp_dmb_fifo #(
  .FIFO_SIZE(4),
  .FIFO_DATA_WIDTH(DATAS_BITS+STRBS_BITS_S+1)
  )  wdata_fifo_i (
  .clk_i(clk_i),
  .rstn_i(rstn_i),

  .wrReq(wvalid_dmb_s_i),
  .wrAck(wready_dmb_s_o),
  .wdata(wd),

  .rdReq(wready),
  .rdAck(wvalid),
  .rdata(fwd)
);

//=============================================
//  Read Wires
//=============================================
assign arid_dmb_m_o = ar.id;
assign araddr_dmb_m_o = rd_trans_addr;
assign arlen_dmb_m_o = ar.len;
assign aruser_dmb_m_o = ar.user;
assign arregion_dmb_m_o = ar.region;
assign arsize_dmb_m_o = ar.size;
assign arburst_dmb_m_o = ar.burst;
assign arcache_dmb_m_o = ar.cache;
assign arlock_dmb_m_o = ar.lock;
assign arprot_dmb_m_o = ar.prot;
assign arqos_dmb_m_o = ar.qos;
assign arvalid_dmb_m_o = arstate == AW_DMB;

generate
  if(DATAS_BITS == 32) begin
    assign rdata_dmb_s_o = (ar.addr[2]) ? frd.data[63:32] : frd.data[31:0];
  end else if(DATAS_BITS == 64) begin
    assign rdata_dmb_s_o = frd.data;
  end else begin
    //$error("Invalid number of DATA Bits");
  end
endgenerate

assign sel_dmb = vldDmbAddr(ar.addr);
assign rid_dmb_s_o = ar.id;
assign rlast_dmb_s_o = frd.last;
assign rresp_dmb_s_o = frd.resp;

assign rd.data = (sel_dmb) ? rdata_dmb_m_i : {regrd_data, regrd_data};
assign rd.last = (sel_dmb) ? rlast_dmb_m_i : 1'b1;
assign rd.resp = (sel_dmb) ? rresp_dmb_m_i : (vldRegAddr(ar.addr)) ? 2'h0 : 2'h2;

//=============================================
//  Read Transaction
//=============================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    ar.id <= {ID_BITS{1'b0}};
    ar.addr <= 32'h0000_0000;
    ar.len  <= 8'h00;
    ar.user <= {USER_BITS{1'b0}};
    ar.region <= 4'h0;
    ar.size <= 3'h0;
    ar.burst <= 2'h0;
    ar.cache <=4'h0 ;
    ar.lock <= 2'h0;
    ar.prot <= 3'h0;
    ar.qos  <= 4'h0;
    arstate <= AR_IDLE;
    arlen_cnt <= 8'h00;
  end else begin
    casez(arstate)
    AR_IDLE: begin
      if(arvalid_dmb_s_i & arready_dmb_s_o)begin
        ar.id <= arid_dmb_s_i;
        ar.addr <= araddr_dmb_s_i;
        ar.len  <= arlen_dmb_s_i;
        arlen_cnt <= arlen_dmb_s_i;
        ar.user <= aruser_dmb_s_i;
        ar.region <= arregion_dmb_s_i;
        ar.size <= arsize_dmb_s_i;
        ar.burst <= arburst_dmb_s_i;
        ar.cache <= arcache_dmb_s_i;
        ar.lock <= arlock_dmb_s_i;
        ar.prot <= arprot_dmb_s_i;
        ar.qos  <= arqos_dmb_s_i;
        arstate <= (vldDmbAddr(araddr_dmb_s_i)) ? AR_DMB : AR_REG;
      end
    end
    AR_REG: begin
      if(regrd_cs) begin
        arstate <= AR_RESP;
      end
    end
    AR_DMB: begin
      if(arready_dmb_m_i) begin
        arstate <= AR_RESP;
      end
    end
    AR_RESP: begin
      if(rvalid_dmb_s_o & rready_dmb_s_i) begin
        arlen_cnt <= arlen_cnt - 1'b1;
        if(arlen_cnt == 8'h00) begin
          arstate <= AR_IDLE;
        end
      end
    end
    endcase
  end
end

//=============================================
//  Data Read Fifo
//=============================================
msftDvIp_dmb_fifo #(
  .FIFO_SIZE(4),
  .FIFO_DATA_WIDTH(67)
  )  rdata_fifo_i (
  .clk_i(clk_i),
  .rstn_i(rstn_i),

  .wrReq(rvalid_dmb_m_i | regrd_cs),
  .wrAck(rready_dmb_m_o),
  .wdata(rd),

  .rdReq(rready_dmb_s_i),
  .rdAck(rvalid_dmb_s_o),
  .rdata(frd)
);

//===================================================
//===================================================
// Register Section
//===================================================
//===================================================
localparam SEG_BASE  = 12'h000;
localparam ATR_BASE  = 12'h080;
localparam UPR_BASE  = 12'h180;
localparam CFG_BASE  = 12'h200;
localparam UDF_BASE  = 12'h280;
localparam PRM_BASE  = 12'h300;
localparam PRM_END   = 12'h318;

localparam SEG_LOW   = (REG_LOW<<2) + SEG_BASE;
localparam ATR_LOW   = (REG_LOW<<3) + ATR_BASE;
localparam UPR_LOW   = (REG_LOW<<2) + UPR_BASE;
localparam CFG_LOW   = (REG_LOW<<2) + CFG_BASE;


reg [31:0]    seg         [31:REG_LOW];
reg [31:0]    attrh       [31:REG_LOW];
reg [31:0]    attrl       [31:REG_LOW];
reg [31:0]    upadr       [31:REG_LOW];
reg [31:0]    xcfg        [31:REG_LOW];
reg [31:0]    perm        [6];

wire [11:0]         regwr_addr;
wire [31:0]         regwr_data;
wire [11:0]         regrd_addr;

wire [4:0]          wr_seg_sel;
wire [31:0]         wr_segment_sel;
wire [1:0]          wr_seg_attr_sel;
wire [31:0]         wr_upper_sel;

wire [4:0]          rd_seg_sel;
wire [31:0]         rd_segment_sel;
wire [1:0]          rd_seg_attr_sel;
wire [31:0]         rd_upper_sel;

assign regwr_cs = wready & wvalid && vldRegAddr(aw.addr);
assign regwr_addr = aw.addr[11:0];

generate
  if (DATAS_BITS == 32) begin
    assign regwr_data = fwd.data;
  end else if (DATAS_BITS == 64) begin
    assign regwr_data = aw.addr[2] ? fwd.data[63:32] : fwd.data[31:0] ;
  end else begin
    //$error("Invalid number of DATA Bits");
  end
endgenerate

assign regrd_cs = arstate == AR_REG && vldRegAddr(ar.addr);
assign regrd_addr = ar.addr[11:0];

wire vld_aw_dmb = vldDmbAddr(aw.addr);
wire vld_ar_dmb = vldDmbAddr(ar.addr);

//===================================================
// Functions
//===================================================
reg [31:0] vldAddr;
function bit vldRegAddr(input [31:0] addr);
  reg vld_seg, vld_attr, vld_upr, vld_cfg, vld_perm, vld_base;
  vldAddr = addr;
  vld_seg  = (addr[11:0] >= SEG_LOW)  && (addr[11:0] < ATR_BASE);     // Segments   0x000 - 0x080
  vld_attr = (addr[11:0] >= ATR_LOW)  && (addr[11:0] < UPR_BASE);     // Attribute  0x080 - 0x180
  vld_upr  = (addr[11:0] >= UPR_LOW)  && (addr[11:0] < CFG_BASE);     // Addr Upper 0x180 - 0x200
  vld_cfg  = (addr[11:0] >= CFG_LOW)  && (addr[11:0] < UDF_BASE);     // Config     0x200 - 0x280
  vld_perm = (addr[11:0] >= PRM_BASE) && (addr[11:0] < PRM_END);      // Permisions 0x300 - 0x314
  vld_base = (addr[31:12] == REG_BASE_ADDR[31:12]); 
  vldRegAddr = (vld_seg | vld_attr | vld_upr | vld_cfg | vld_perm) & vld_base;
endfunction

function bit vldDmbAddr(input [31:0] addr);
    vldDmbAddr = addr[31:27] >= REG_LOW;
endfunction

//===================================================
// Write Registers
//===================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    for(int i=REG_LOW;i<32;i+=1) begin
      seg[i]   <= 32'h0000_0000;
      attrh[i] <= 32'h0000_0000;
      attrl[i] <= 32'h0000_0000;
      upadr[i] <= 32'h0000_0000;
      xcfg[i]  <= 32'h0000_0000;
    end
    for(int i=0;i<6;i+=1) begin
      perm[i] <= 32'h0000_0000;
    end
  end else begin
    if(regwr_cs) begin
      if(regwr_addr < ATR_BASE) begin
        seg[regwr_addr[6:2]] <= regwr_data;
      end else if(regwr_addr < UPR_BASE && ~regwr_addr[2]) begin
        attrh[regwr_addr[7:3]] <= regwr_data;
      end else if(regwr_addr < UPR_BASE &&  regwr_addr[2]) begin
        attrl[regwr_addr[7:3]] <= regwr_data;
      end else if(regwr_addr < CFG_BASE) begin
        upadr[regwr_addr[6:2]] <= regwr_data;
      end else if(regwr_addr < UDF_BASE) begin
        xcfg[regwr_addr[6:2]] <= regwr_data;
      end else if(regwr_addr < PRM_END) begin
        perm[regwr_addr[4:2]] <= regwr_data;
      end
    end
  end
end

//===================================================
// Read Registers
//===================================================
always @*
begin
  regrd_data = 32'h0000_0000;
  if(regrd_cs) begin
    if(regrd_addr < ATR_BASE) begin
      regrd_data = seg[regrd_addr[6:2]];
    end else if(regrd_addr < UPR_BASE && ~regrd_addr[2]) begin
      regrd_data = attrh[regrd_addr[7:3]];
    end else if(regrd_addr < UPR_BASE &&  regrd_addr[2]) begin
      regrd_data = attrl[regrd_addr[7:3]];
    end else if(regrd_addr < CFG_BASE) begin
      regrd_data = upadr[regrd_addr[6:2]];
    end else if(regrd_addr < UDF_BASE) begin
      regrd_data = xcfg[regrd_addr[6:2]];
    end else if(regrd_addr < PRM_END) begin
      regrd_data = perm[regrd_addr[4:2]];
    end
  end
end

//==============================================
// Address Generation
//==============================================
assign wr_seg_sel = aw.addr[31:27];
assign wr_segment_sel = seg[wr_seg_sel];
assign wr_upper_sel   = upadr[wr_seg_sel];
assign wr_trans_addr = { wr_upper_sel[23:0], wr_segment_sel[12:0], aw.addr[26:0]};

assign rd_seg_sel = ar.addr[31:27];
assign rd_segment_sel = seg[rd_seg_sel];
assign rd_upper_sel   = upadr[rd_seg_sel];
assign rd_trans_addr = { rd_upper_sel[23:0], rd_segment_sel[12:0], ar.addr[26:0]};

endmodule
