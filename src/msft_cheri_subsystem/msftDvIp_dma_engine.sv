
// =====================================================
// Copyright (c) Microsoft Corporation.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//    http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =====================================================



module msftDvIp_dma_engine #(
    parameter AXI_RCHAN_ID=0,
    parameter AXI_WCHAN_ID=1,
    parameter AXI_ID_WIDTH=4,
    parameter AXI_ADDR_WIDTH=32,
    parameter AXI_DATA_WIDTH=32,
    parameter AXI_LEN_WIDTH=8,
    parameter MAX_BYTE_WIDTH=24
  )  (

  input                                               clk_i,
  input                                               rstn_i,

  output reg [AXI_ID_WIDTH-1:0]                       awid_dma_m_o,
  output reg [AXI_ADDR_WIDTH-1:0]                     awaddr_dma_m_o,
  output reg [AXI_LEN_WIDTH-1:0]                      awlen_dma_m_o,
  output reg [2:0]                                    awsize_dma_m_o,
  output reg [1:0]                                    awburst_dma_m_o,
  output reg [3:0]                                    awcache_dma_m_o,
  output reg [1:0]                                    awlock_dma_m_o,
  output reg [2:0]                                    awprot_dma_m_o,
  output reg [3:0]                                    awqos_dma_m_o,
  output reg                                          awvalid_dma_m_o,
  input                                               awready_dma_m_i,

  output reg [AXI_ID_WIDTH-1:0]                       wid_dma_m_o,
  output     [AXI_DATA_WIDTH-1:0]                     wdata_dma_m_o,
  output reg                                          wlast_dma_m_o,
  output     [(AXI_DATA_WIDTH/8)-1:0]                 wstrb_dma_m_o,
  output                                              wvalid_dma_m_o,
  input                                               wready_dma_m_i,

  input  [AXI_ID_WIDTH-1:0]                           bid_dma_m_i,
  input  [1:0]                                        bresp_dma_m_i,
  input                                               bvalid_dma_m_i,
  output reg                                          bready_dma_m_o, 
  
  output reg [AXI_ID_WIDTH-1:0]                       arid_dma_m_o,
  output reg [AXI_ADDR_WIDTH-1:0]                     araddr_dma_m_o,
  output reg [AXI_LEN_WIDTH-1:0]                      arlen_dma_m_o,
  output reg [2:0]                                    arsize_dma_m_o,
  output reg [1:0]                                    arburst_dma_m_o,
  output reg [3:0]                                    arcache_dma_m_o,
  output reg [1:0]                                    arlock_dma_m_o,
  output reg [2:0]                                    arprot_dma_m_o,
  output reg [3:0]                                    arqos_dma_m_o,
  output reg                                          arvalid_dma_m_o,
  input                                               arready_dma_m_i,

  input [AXI_ID_WIDTH-1:0]                            rid_dma_m_i,
  input [AXI_DATA_WIDTH-1:0]                          rdata_dma_m_i,
  input                                               rlast_dma_m_i,
  input  [1:0]                                        rresp_dma_m_i,
  input                                               rvalid_dma_m_i,
  output                                              rready_dma_m_o,

  input                                               dma_req_i,
  output                                              dma_req_ack_o,
  output                                              dma_rdy_o,
  output reg [1:0]                                    dma_rd_error_o,
  output reg [1:0]                                    dma_wr_error_o,

  input [11:0]                                        dma_bytes_i,

  input [AXI_ADDR_WIDTH:0]                            dma_rd_addr_i,
  input [2:0]                                         dma_rd_size_i,
  input [3:0]                                         dma_rd_burst_i,
  input                                               dma_rd_inc_i,
  output reg                                          dma_rd_done_o,
  output reg                                          dma_rd_beat_o,
  output reg [2:0]                                    dma_rd_bytes_o,

  input [AXI_ADDR_WIDTH:0]                            dma_wr_addr_i,
  input [2:0]                                         dma_wr_size_i,
  input [3:0]                                         dma_wr_burst_i,
  input                                               dma_wr_inc_i,
  output reg                                          dma_wr_done_o,
  output reg                                          dma_wr_beat_o,
  output reg [2:0]                                    dma_wr_bytes_o
);


//===================================================================
// Parameters
//===================================================================
localparam RD_ADDR_IDLE             = 3'h0;
localparam RD_ADDR_SETUP            = 3'h1;
localparam RD_ADDR_WAIT             = 3'h2;
localparam RD_DATA                  = 3'h3;

localparam WR_ADDR_IDLE             = 3'h0;
localparam WR_ADDR_SETUP            = 3'h1;
localparam WR_ADDR_WAIT             = 3'h2;
localparam WR_DATA                  = 3'h3;
localparam WR_RESP                  = 3'h4;

//===================================================================
// Register/Wires
//===================================================================
reg                                         rvalid_o;
wire                                        rready_i;
wire  [31:0]                                rdata_o;
reg   [2:0]                                 rsize_o;

wire                                        wvalid_o;
wire                                        wready_i;
wire  [31:0]                                wdata_i;

reg   [2:0]                                 rdAddrState;
reg   [2:0]                                 wrAddrState;

reg [1:0]                                   rladdr;
reg [1:0]                                   wladdr;

reg [MAX_BYTE_WIDTH-1:0]                    wrBytes;
reg [AXI_LEN_WIDTH-1:0]                     w_len;
wire [7:0]                                  wbeats;
wire [3:0]                                  w_addr_inc;
wire [10:0]                                 wr_beat_bytes;
reg  [3:0]                                  wburst;
reg                                         wrInc;

reg [MAX_BYTE_WIDTH-1:0]                    rdBytes;
reg [AXI_LEN_WIDTH-1:0]                     r_len;
wire [7:0]                                  rbeats;
wire [3:0]                                  r_addr_inc;
wire [10:0]                                 rd_beat_bytes;
reg  [3:0]                                  rburst;
reg  [1:0]                                  rdInc;
reg  [1:0]                                  rdError;

wire                                        rstn_fifo;
wire                                        wvalid_dma_m;

//===================================================================
// Assignments
//===================================================================
assign dma_rd_idle  = rdAddrState == RD_ADDR_IDLE;
assign dma_wr_idle  = wrAddrState == WR_ADDR_IDLE;
assign dma_wr_state = wrAddrState == WR_DATA;

assign dma_rdy_o = dma_rd_idle & dma_wr_idle;
assign dma_req_ack_o = dma_rdy_o & dma_req_i;

assign awid_dma_m_o = AXI_WCHAN_ID;
assign awcache_dma_m_o = 4'h0;
assign awlock_dma_m_o = 2'h0;
assign awprot_dma_m_o = 3'h0;
assign awqos_dma_m_o = 4'h0;

assign arid_dma_m_o = AXI_RCHAN_ID;
assign arcache_dma_m_o = 4'h0;
assign arlock_dma_m_o = 2'h0;
assign arprot_dma_m_o = 3'h0;
assign arqos_dma_m_o = 4'h0;

assign r_addr_inc = f_addr_inc(arsize_dma_m_o);
assign w_addr_inc = f_addr_inc(awsize_dma_m_o);

assign rd_last = (rdBytes - r_addr_inc) == 20'h0_0000;
assign wr_last = (wrBytes - w_addr_inc) == 20'h0_0000;
assign wr_last_burst = (wrBytes - (w_addr_inc<<1)) == 20'h0_0000;

assign rbeats = f_get_beats(araddr_dma_m_o, rdBytes, arsize_dma_m_o, rburst);
assign wbeats = f_get_beats(awaddr_dma_m_o, wrBytes, awsize_dma_m_o, wburst);

assign rd_beat_bytes = getBytesFromBeats(rbeats, arsize_dma_m_o);
assign wr_beat_bytes = getBytesFromBeats(wbeats, awsize_dma_m_o);

assign rd_burst = |rburst;
assign wr_burst = |wburst;

assign rstn_fifo = ~dma_wr_done_o;

// Force wvalid once DMA RD error occurs until write burst is complete
assign wvalid_dma_m_o = wvalid_dma_m | (dma_rd_error_o & dma_wr_state);

//==========================================
//  Functions
//==========================================
function bit [3:0] f_addr_inc(input [2:0] size);
  casez(size)
    3'h0: f_addr_inc = 4'h1;
    3'h1: f_addr_inc = 4'h2;
    3'h2: f_addr_inc = 4'h4;
    3'h3: f_addr_inc = 4'h8;
  endcase
endfunction

function bit [7:0] f_get_beats(input [31:0] addr, input [19:0] cnt, input [2:0] size, input [3:0] bsize);
  reg [12:0] beats2edge, beats24Kedge;
  reg [19:0] tot_beats;
  logic [3:0] maxBeats;

  casex(bsize)
    4'h0: maxBeats = 8'h00;
    4'h1: maxBeats = 8'h01;
    4'h2: maxBeats = 8'h03;
    4'h3: maxBeats = 8'h07;
    4'h4: maxBeats = 8'h0f;
    4'h5: maxBeats = 8'h1f;
    4'h6: maxBeats = 8'h3f;
    4'h7: maxBeats = 8'h7f;
    4'h8: maxBeats = 8'hff;
  endcase
    
  tot_beats  = cnt>>size;
  beats2edge = (4096 - addr[11:0])>>size;

  beats24Kedge = (tot_beats >= beats2edge) ? beats2edge : tot_beats[11:0];
  f_get_beats  = (beats24Kedge > maxBeats) ? maxBeats : (beats24Kedge[7:0] == 8'h00) ? 8'h00 : beats24Kedge[7:0]-1'b1;
endfunction

function bit [10:0] getBytesFromBeats(input [11:0] beats, input [2:0] size);
  getBytesFromBeats = (beats+1)<<size;
endfunction

//==========================================
//  Read Address State
//==========================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    araddr_dma_m_o <= {AXI_ADDR_WIDTH{1'b0}};
    arlen_dma_m_o  <= {AXI_LEN_WIDTH{1'b0}};
    arvalid_dma_m_o <= 1'b0;
    arsize_dma_m_o <= 3'h0;
    arburst_dma_m_o <= 2'h0;

    rburst <= 4'h0;
    rladdr <= 2'h0;
    rdAddrState <= RD_ADDR_IDLE;
    rdBytes <= {MAX_BYTE_WIDTH{1'b0}};
    rdInc <= 1'b0;
    r_len <= 8'h00;
    dma_rd_error_o <= 2'b0;
    dma_rd_done_o  <= 1'b0;
    dma_rd_beat_o  <= 1'b0;
    dma_rd_bytes_o  <= 3'h0;
  end else begin
    dma_rd_beat_o <= 1'b0;
    casez(rdAddrState)
      RD_ADDR_IDLE: begin
        if(dma_req_i & dma_rdy_o) begin
          dma_rd_done_o  <= 1'b0;
          dma_rd_error_o <= 2'b0;
          araddr_dma_m_o <= dma_rd_addr_i;
          rladdr <= dma_rd_addr_i[1:0];
          arsize_dma_m_o <= dma_rd_size_i; 
          arburst_dma_m_o <= {1'b0, dma_rd_inc_i};
          rburst <= dma_rd_burst_i;
          rdBytes <= dma_bytes_i;
          rdInc <= dma_rd_inc_i;
          rdAddrState <= RD_ADDR_SETUP;
        end
      end
      RD_ADDR_SETUP: begin
        arvalid_dma_m_o <= 1'b1;
        arlen_dma_m_o <= rbeats;
        r_len <= rbeats;
        rdAddrState <= RD_ADDR_WAIT;
      end
      RD_ADDR_WAIT: begin
        if(arvalid_dma_m_o & arready_dma_m_i) begin
          arvalid_dma_m_o <= 1'b0;
          rdAddrState <= RD_DATA;
          araddr_dma_m_o <= (rdInc) ? araddr_dma_m_o + rd_beat_bytes : araddr_dma_m_o;
        end
      end
      RD_DATA: begin
        if(rvalid_dma_m_i & rready_dma_m_o) begin
          if(rresp_dma_m_i[1]) begin
            dma_rd_error_o <= rresp_dma_m_i;
          end
          dma_rd_beat_o <= 1'b1;
          dma_rd_bytes_o <= r_addr_inc;
          if(~rd_last) begin
            // If we get an error or an error has occured terminate the transfer on a burst boundary
            if(rresp_dma_m_i[1] || dma_rd_error_o[1]) begin
              rdBytes <= {MAX_BYTE_WIDTH{1'b0}};
              dma_rd_done_o <= 1'b1;
              rdAddrState <= RD_ADDR_IDLE;
            end else begin
              rdBytes <= rdBytes - r_addr_inc;
              rladdr  <= (rdInc) ? rladdr + r_addr_inc : rladdr;
              r_len   <= r_len - 1'b1;
              if(r_len == 8'h00) begin
                rdAddrState <= RD_ADDR_SETUP;
              end
            end
          end else begin
            dma_rd_done_o  <= 1'b1;
            rdAddrState <= RD_ADDR_IDLE;
          end
        end
      end 
    endcase
  end
end

//==========================================
//  Write State
//==========================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    awaddr_dma_m_o <= {AXI_ADDR_WIDTH{1'b0}};
    awvalid_dma_m_o <= 1'b0;
    awsize_dma_m_o <= 3'h0;
    awlen_dma_m_o  <= {AXI_LEN_WIDTH{1'b0}};
    awburst_dma_m_o <= 2'h0;;

    wid_dma_m_o <= 4'h0;
    wlast_dma_m_o <= 1'b0;

    bready_dma_m_o <= 1'b0;

    wburst <= 4'h0;
    wrInc <= 1'b0;
    wrBytes <= {MAX_BYTE_WIDTH{1'b0}};
    wrAddrState <= RD_ADDR_IDLE;
    dma_wr_done_o <= 1'b1;
    wladdr <= 2'h0;
    w_len <= {AXI_LEN_WIDTH{1'b0}};
    dma_wr_error_o <= 2'h0;
    dma_wr_beat_o <= 2'h0;
  end else begin
    casez(wrAddrState)
      WR_ADDR_IDLE: begin
        if(dma_req_i & dma_rdy_o) begin
          dma_wr_done_o <= 1'b0;
          dma_wr_error_o <= 2'h0;
          dma_wr_beat_o <= 1'b0;
          dma_wr_bytes_o <= 3'h0;
          awaddr_dma_m_o <= dma_wr_addr_i;
          wladdr <= dma_wr_addr_i[1:0];
          awsize_dma_m_o <= dma_wr_size_i; 
          awburst_dma_m_o <= {1'b0, dma_wr_inc_i};
          wburst <= dma_wr_burst_i;
          wrBytes <= dma_bytes_i;
          wrInc <= dma_wr_inc_i;
          wrAddrState <= RD_ADDR_SETUP;
        end
      end

      WR_ADDR_SETUP: begin
        awvalid_dma_m_o <= 1'b1;
        awlen_dma_m_o <= wbeats;
        w_len <= wbeats;
        wrAddrState <= WR_ADDR_WAIT;
      end

      WR_ADDR_WAIT: begin
        if(awvalid_dma_m_o & awready_dma_m_i) begin
          awvalid_dma_m_o <= 1'b0;
          wlast_dma_m_o <= w_len == 8'h00;
          wrAddrState <= WR_DATA;
          awaddr_dma_m_o <= (wrInc) ? awaddr_dma_m_o + wr_beat_bytes : awaddr_dma_m_o;
        end
      end

      WR_DATA: begin
        dma_wr_beat_o <= 1'b0;
        if(wvalid_dma_m_o & wready_dma_m_i) begin
          dma_wr_beat_o <= 1'b1;
          dma_wr_bytes_o <= w_addr_inc;
          wrBytes <= wrBytes - w_addr_inc;
          w_len <= w_len - 1'b1;
          wlast_dma_m_o <= w_len == 8'h01;
          wladdr <= (wrInc) ? wladdr + w_addr_inc : wladdr;
          if(w_len == 8'h00) begin
            bready_dma_m_o <= 1'b1;
            wrAddrState <= WR_RESP;
          end
        end
      end

      WR_RESP: begin
        dma_wr_beat_o <= 1'b0;
        if(bvalid_dma_m_i & bready_dma_m_o) begin
          bready_dma_m_o <= 1'b0;
          if(|wrBytes & ~bresp_dma_m_i[1] & ~dma_rd_error_o) begin
            w_len <= wbeats;
            awvalid_dma_m_o <= 1'b1;
            wrAddrState <= WR_ADDR_WAIT;
          end else begin
            dma_wr_error_o <= bresp_dma_m_i;
            dma_wr_done_o <= 1'b1;
            wrAddrState <= WR_ADDR_IDLE;
          end
        end
      end
    endcase
  end
end

//=============================================================
// DMA Fifo
//=============================================================
msftDvIp_dma_fifo #(
    .FIFO_BYTES(16)
  ) msftDvIp_dma_fifo_i (
  .clk_i(clk_i),
  .rstn_i(rstn_i),
  .rstn_fifo_i(rstn_fifo),

  .rvalid_i(rvalid_dma_m_i),
  .rready_o(rready_dma_m_o),
  .rdata_i(rdata_dma_m_i),
  .rsize_i(arsize_dma_m_o),
  .rladdr_i(rladdr),

  .wvalid_i(wready_dma_m_i),
  .wready_o(wvalid_dma_m),
  .wsize_i(awsize_dma_m_o),
  .wladdr_i(wladdr),
  .wdata_o(wdata_dma_m_o),
  .wstrb_o(wstrb_dma_m_o)
 );
 
endmodule
