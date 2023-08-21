
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

// Copyright (C) Microsoft Corporation. All rights reserved.



module msftDvIp_axi2apb #(
    parameter ADDR_BUS_WIDTH=32,
    parameter DATA_BUS_WIDTH=32,
    parameter AXI_ID_WIDTH = 4,
    parameter WR_STROBE_WIDTH = DATA_BUS_WIDTH/8,
    parameter AXI_LEN_WIDTH = 8
  ) (
  input                                 clk_i,
  input                                 rstn_i,

  input [AXI_ID_WIDTH-1:0]              arid_m_i,
  input [ADDR_BUS_WIDTH-1:0]            araddr_m_i,
  input [2:0]                           arprot_m_i,
  input [AXI_LEN_WIDTH-1:0]             arlen_m_i,
  input [2:0]                           arsize_m_i,
  input [1:0]                           arburst_m_i,
  input                                 arvalid_m_i,
  output reg                            arready_m_o,

  output reg [DATA_BUS_WIDTH-1:0]       rdata_m_o,
  output reg                            rlast_m_o,
  output reg [AXI_ID_WIDTH-1:0]         rid_m_o,
  input                                 rready_m_i,
  output reg                            rvalid_m_o,
  output reg [1:0]                      rresp_m_o,


  input  [AXI_ID_WIDTH-1:0]             awid_m_i,
  input  [ADDR_BUS_WIDTH-1:0]           awaddr_m_i,
  input  [2:0]                          awprot_m_i,
  input  [AXI_LEN_WIDTH-1:0]            awlen_m_i,
  input  [2:0]                          awsize_m_i,
  input  [1:0]                          awburst_m_i,
  input                                 awvalid_m_i,
  output reg                            awready_m_o,

  input  [DATA_BUS_WIDTH-1:0]           wdata_m_i,
  input  [WR_STROBE_WIDTH-1:0]          wstrb_m_i,
  input                                 wvalid_m_i,
  output reg                            wready_m_o,
  input                                 wlast_m_i,

  output reg [AXI_ID_WIDTH-1:0]         bid_m_o,
  output reg [1:0]                      bresp_m_o,
  output reg                            bvalid_m_o,
  input                                 bready_m_i,

  output reg                            psel_mgr_o,
  output reg                            penable_mgr_o,
  output reg  [ADDR_BUS_WIDTH-1:0]      paddr_mgr_o,
  output reg  [2:0]                     pprot_mgr_o,
  output reg  [(DATA_BUS_WIDTH/8)-1:0]  pstrb_mgr_o,
  input       [DATA_BUS_WIDTH-1:0]      prdata_mgr_i,
  output reg  [DATA_BUS_WIDTH-1:0]      pwdata_mgr_o,
  output reg                            pwrite_mgr_o,
  input                                 pready_mgr_i,
  input                                 psuberr_mgr_i

);


reg [ADDR_BUS_WIDTH-1:0]      praddr;
reg [AXI_LEN_WIDTH-1:0]       prlen;
reg [2:0]                     prsize;
reg [1:0]                     prburst;

reg [ADDR_BUS_WIDTH-1:0]      pwaddr;
reg [AXI_LEN_WIDTH-1:0]       pwlen;
reg [2:0]                     pwsize;
reg [1:0]                     pwburst;
reg [WR_STROBE_WIDTH-1:0]     pwstrb;

wire                          apbRdDone;
wire                          apbWrDone;

assign paddr_mgr_o = (pwrite_mgr_o) ? pwaddr : praddr;
assign pprot_mgr_o = (pwrite_mgr_o) ? awprot_m_i : arprot_m_i;
assign pstrb_mgr_o = (pwrite_mgr_o) ? pwstrb : 'h0;

//===================================
// AXI Read 
//===================================
localparam AXI_RD_IDLE     = 0;
localparam AXI_RD_REQ      = 1;
localparam AXI_RD_RESP     = 2;
reg [1:0] rdState;
wire apbRdReq = rdState == AXI_RD_REQ;
always @(posedge clk_i or negedge rstn_i)
begin
  if(!rstn_i) begin
    praddr <= {DATA_BUS_WIDTH{1'b0}};
    arready_m_o <= 1'b1;
    rid_m_o <= {AXI_ID_WIDTH{1'b0}};
    rlast_m_o <= 1'b0;
    rvalid_m_o <= 1'b0;
    rresp_m_o <= 2'h0;
    rdState <= AXI_RD_IDLE;
    prlen   <= 0;
    prsize  <= 0;
    prburst <= 0;
    rdata_m_o <= 0;
  end else begin
    case (rdState)
      AXI_RD_IDLE: begin
        if(arvalid_m_i) begin
          rid_m_o <= arid_m_i;
          praddr <= araddr_m_i;
          prlen <= arlen_m_i;
          prsize <= arsize_m_i;
          prburst <= arburst_m_i;
          arready_m_o <= 1'b0;
          rvalid_m_o <= 1'b0;
          rdState <= AXI_RD_REQ;
        end
      end
      AXI_RD_REQ: begin
        if(apbRdDone) begin
          rvalid_m_o <= 1'b1;
          rlast_m_o <= prburst == 2'h0 || prlen == 0;
          rresp_m_o <= {psuberr_mgr_i, 1'b0};
          rdata_m_o <= prdata_mgr_i;
          rdState <= AXI_RD_RESP; 
        end
      end
      AXI_RD_RESP: begin
        if(rready_m_i) begin
          rvalid_m_o <= 1'b0;
          rlast_m_o <= 1'b0;
          rresp_m_o <= 2'h0;
          if(prburst == 2'h1 && prlen != 0) begin
            prlen <= prlen - 1'b1;
            praddr <= praddr + axiIncr(prsize); 
            rdState <= AXI_RD_REQ;
          end else begin
            arready_m_o <= 1'b1;
            rdState <= AXI_RD_IDLE;
          end
        end
      end
    endcase
  end
end

//===================================
// AXI Write 
//===================================
localparam AXI_WR_IDLE     = 0;
localparam AXI_WDATA_WAIT  = 1;
localparam AXI_WR_REQ      = 2;
localparam AXI_WR_RESP     = 3;
reg [1:0] wrState;
wire apbWrReq = wrState == AXI_WR_REQ;
always @(posedge clk_i or negedge rstn_i)
begin
  if(!rstn_i) begin
    pwaddr <= {DATA_BUS_WIDTH{1'b0}};
    pwdata_mgr_o <= {DATA_BUS_WIDTH{1'b0}};
    awready_m_o <= 1'b1;
    wready_m_o <= 1'b1;
    bresp_m_o <= 2'h0;
    bid_m_o <= {AXI_ID_WIDTH{1'b0}};
    bvalid_m_o <= 1'b0;
    wrState <= AXI_WR_IDLE;
    pwlen   <= 0;
    pwsize  <= 0;
    pwstrb  <= 0;
    pwburst <= 0;
  end else begin
    case (wrState)
      AXI_WR_IDLE: begin
        if(awvalid_m_i) begin
          bid_m_o <= awid_m_i;
          pwaddr <= awaddr_m_i;
          pwlen <= awlen_m_i;
          pwsize <= awsize_m_i;
          pwburst <= awburst_m_i;
          awready_m_o <= 1'b0;
          if(wvalid_m_i) begin
            pwdata_mgr_o <= wdata_m_i;
            wready_m_o <= 1'b0;
            wrState <= AXI_WR_REQ;
            pwstrb <= wstrb_m_i;
          end else begin
            wrState <= AXI_WDATA_WAIT;
          end
        end
      end
      AXI_WDATA_WAIT: begin
        if(wvalid_m_i) begin
          pwdata_mgr_o <= wdata_m_i;
          pwstrb <= wstrb_m_i;
          wrState <= AXI_WR_REQ;
        end
      end
      AXI_WR_REQ: begin
        if(apbWrDone) begin
          bvalid_m_o <= 1'b1;
          bresp_m_o <= {psuberr_mgr_i, 1'b0};
          wrState <= AXI_WR_RESP; 
        end
      end
      AXI_WR_RESP: begin
        if(bready_m_i) begin
          bvalid_m_o <= 1'b0;
          bresp_m_o <= 2'h0;
          // if(pwburst == 2'h1 && prlen != 0) begin
          if(pwburst == 2'h1 && pwlen != 0) begin   // kliu 09042022
            pwlen <= pwlen - 1'b1;
            pwaddr <= pwaddr + axiIncr(pwsize); 
            wrState <= AXI_WR_REQ;
          end else begin
            awready_m_o <= 1'b1;
            wready_m_o <= 1'b1;
            wrState <= AXI_WR_IDLE;
          end
        end
      end
    endcase
  end
end

//===================================
// APB BUS
// pwrite is used to ping pong the APB access
//===================================
localparam APB_IDLE  = 0;
localparam APB_ENABLE = 1;
localparam APB_WAIT = 2;
reg [1:0] apbState;
assign apbRdDone = apbState == APB_WAIT & pready_mgr_i & ~pwrite_mgr_o;
assign apbWrDone = apbState == APB_WAIT & pready_mgr_i &  pwrite_mgr_o;
always @(posedge clk_i or negedge rstn_i)
begin
  if(!rstn_i) begin
    psel_mgr_o <= 1'b0;
    penable_mgr_o <= 1'b0;
    pwrite_mgr_o <= 1'b0;
    apbState <= APB_IDLE;
  end else begin
    case(apbState)
      APB_IDLE: begin
        if(apbRdReq & (~apbWrReq | pwrite_mgr_o) ) begin
          psel_mgr_o <= 1'b1;
          pwrite_mgr_o <= 1'b0;
          apbState <= APB_ENABLE;
        end else if(apbWrReq & (~apbRdReq | ~pwrite_mgr_o) ) begin
          psel_mgr_o <= 1'b1;
          pwrite_mgr_o <= 1'b1;
          apbState <= APB_ENABLE;
        end
      end
      APB_ENABLE: begin
         penable_mgr_o <= 1'b1;
         apbState <= APB_WAIT;
      end
      APB_WAIT: begin
        if(pready_mgr_i) begin
          psel_mgr_o <= 1'b0;
          penable_mgr_o <= 1'b0;
          apbState <= APB_IDLE;
        end
      end
    endcase
  end
end

//=========================================
// AXI Increment Calculation
//=========================================
function int axiIncr(input [2:0] size);
  case (size)
    3'h0: axiIncr = 1;
    3'h1: axiIncr = 2;
    3'h2: axiIncr = 4;
    3'h4: axiIncr = 8;
    3'h5: axiIncr = 16;
    3'h6: axiIncr = 32;
    3'h7: axiIncr = 64;
  endcase
endfunction 

endmodule
