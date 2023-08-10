

module msftDvIp_dma_ctrl0 #(
    parameter MAX_BYTE_WIDTH=24,
    parameter AXI_ID_WIDTH=4,
    parameter AXI_ADDR_WIDTH=32,
    parameter AXI_DATA_WIDTH=32,
    parameter AXI_LEN_WIDTH=4
  )   (

  input                               clk_i,
  input                               rstn_i,

  input                               psel_i,
  input                               penable_i,
  input      [31:0]                   paddr_i,
  output reg [31:0]                   prdata_o,
  input      [31:0]                   pwdata_i,
  input                               pwrite_i,
  output                              pready_o,
  output                              psuberr_o,

  input                               req_i,
  output                              ack_o,

  output                              dma_req_o,
  input                               dma_req_ack_i,
  input                               dma_rdy_i,

  output [11:0]                       dma_bytes_o,

  output [AXI_ADDR_WIDTH:0]           dma_rd_addr_o,
  output [2:0]                        dma_rd_size_o,
  output [3:0]                        dma_rd_burst_o,
  output                              dma_rd_inc_o,
  input                               dma_rd_done_i,
  input                               dma_rd_beat_i,
  input [2:0]                         dma_rd_bytes_i,
  input [1:0]                         dma_rd_error_i,

  output [AXI_ADDR_WIDTH:0]           dma_wr_addr_o,
  output [2:0]                        dma_wr_size_o,
  output [3:0]                        dma_wr_burst_o,
  output                              dma_wr_inc_o,
  input                               dma_wr_done_i,
  input                               dma_wr_beat_i,
  input [2:0]                         dma_wr_bytes_i,
  input [1:0]                         dma_wr_error_i
);

//========================================================
// Registers
//========================================================
reg [31:0]    ctrl0;
reg [31:0]    src_addr;
reg [31:0]    dst_addr;
reg [31:0]    byte_cnt;

reg [1:0]     rdError;
reg [1:0]     wrError;

wire [31:0]   dma_status;

//========================================================
// Assignments
//========================================================
assign pready_o = 1'b1;
assign psuberr_o = 1'b0;
assign ack_o = 1'b0;


assign dma_req_o        = ctrl0[0] && byte_cnt != 20'h0_0000;
assign dma_rd_inc_o     = ctrl0[1];
assign dma_wr_inc_o     = ctrl0[2];
assign dma_rd_burst_o   = ctrl0[6:3];
assign dma_wr_burst_o   = ctrl0[10:7];
assign dma_rd_size_o    = ctrl0[13:11];
assign dma_wr_size_o    = ctrl0[16:14];

assign dma_rd_addr_o    = src_addr;
assign dma_wr_addr_o    = dst_addr;
assign dma_bytes_o      = byte_cnt[19:0];

assign dma_bus_error = (|wrError) | (|rdError);

assign dma_status = {31'h0000_00,wrError, rdError, 2'h0, dma_bus_error, dma_rdy_i};

//========================================================
// Ctrl Write 
//========================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    ctrl0     <= 32'h0000_0000;
  end else begin
    if(psel_i & penable_i & pwrite_i && paddr_i[4:2] == 3'h0) begin
      ctrl0     <= pwdata_i;
    end else if(dma_req_ack_i) begin
      ctrl0[0] <= 1'b0;
    end
  end
end

//========================================================
// SRC Write
//========================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    src_addr  <= 32'h0000_0000;
  end else begin
    if(psel_i & penable_i & pwrite_i & (paddr_i[4:2] == 3'h1)) begin
      src_addr  <= pwdata_i;
    end else if(dma_rd_beat_i & dma_rd_inc_o) begin
      src_addr <= src_addr + dma_rd_bytes_i;
    end
  end
end

//========================================================
// DST Write 
//========================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    dst_addr  <= 32'h0000_0000;
  end else begin
    if(psel_i & penable_i & pwrite_i & (paddr_i[4:2] == 3'h2)) begin
      dst_addr  <= pwdata_i;
    end else if(dma_wr_beat_i & dma_wr_inc_o) begin
      dst_addr <= dst_addr + dma_wr_bytes_i;
    end
  end
end

//========================================================
// Byte Count Write 
//========================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    byte_cnt  <= 32'h0000_0000;
  end else begin
    if(psel_i & penable_i & pwrite_i & (paddr_i[4:2] == 3'h3)) begin
      byte_cnt  <= pwdata_i;
    end else if(dma_wr_beat_i) begin
      byte_cnt <= byte_cnt - dma_wr_bytes_i;
    end
  end
end

//========================================================
// Status Register
//========================================================
assign status_rd = psel_i & penable_i & ~pwrite_i & (paddr_i[4:2] == 3'h4);
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    wrError <= 2'h0;
    rdError <= 2'h0;
  end else begin
    if(dma_wr_done_i) begin
      wrError <= dma_wr_error_i;
    end else if(status_rd) begin
      wrError <= 2'h0;
    end
    if(dma_rd_done_i) begin
      rdError <= dma_rd_error_i;
    end else if(status_rd) begin
      rdError <= 2'h0;
    end 
  end
end

//========================================================
// APB Read
//========================================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    prdata_o <= 32'h0000_0000;
  end else begin
    if(psel_i & ~penable_i & ~pwrite_i) begin
      casez (paddr_i[4:2])
        4'h0: prdata_o <= ctrl0;
        4'h1: prdata_o <= src_addr;
        4'h2: prdata_o <= dst_addr;
        4'h3: prdata_o <= byte_cnt;
        4'h4: prdata_o <= dma_status;
      endcase
    end
  end
end

endmodule
