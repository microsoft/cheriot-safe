
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



module msftDvDebug_apb_mgr_sm 
import msftDvDebug_jtag2AxiApb_pkg::*;
  #(
  ) (
  input         clk_i,
  input         rstn_i,

  output        psel16_jtag_o,
  output        penable16_jtag_o,
  output [14:0] paddr16_jtag_o,
  output [15:0] pwdata16_jtag_o,
  output        pwrite16_jtag_o,
  input  [15:0] prdata16_jtag_i,
  input         pready16_jtag_i,
  input         psuberr16_jtag_i,

  output        psel32_jtag_o,
  output        penable32_jtag_o,
  output [31:0] paddr32_jtag_o,
  output [47:0] pwdata32_jtag_o,
  output        pwrite32_jtag_o,
  input  [47:0] prdata32_jtag_i,
  input         pready32_jtag_i,
  input         psuberr32_jtag_i,

  output        sel_jtag_o,

  input [1:0]   apb_req_i,
  output        apb_ack_i,
  input [APB_CMD_WIDTH-1:0]    apb_cmd,
  output [APB_RESP_WIDTH-1:0]   apb_resp
);

parameter APB_IDLE = 2'h0;
parameter APB_SEL  = 2'h1;
parameter APB_WAIT = 2'h2;

JTAG_APB_DATA_t apb;
JTAG_APB_RESP_t apb_r;

assign apb = apb_cmd;
assign apb_resp = apb_r;

reg [1:0]     apb_state;

reg           apb_sel;
reg           apb_enable;
reg  [31:0]   apb_addr;
reg           apb_write;
reg  [47:0]   apb_wdata;
reg           apb_32bit;

wire [47:0]   apb_rdata_mux;
reg  [47:0]   apb_rdata;
reg           apb_suberr;

wire          clk;
wire          rstn;

assign apb_rdata_mux  = (apb_32bit) ? prdata32_jtag_i   : {32'h0000_0000, prdata16_jtag_i};
assign apb_ready_mux  = (apb_32bit) ? pready32_jtag_i   : pready16_jtag_i;
assign apb_suberr_mux = (apb_32bit) ? psuberr32_jtag_i  : psuberr16_jtag_i;

assign apb_ack_i = (|apb_req_i) & apb_state == APB_IDLE;

assign apb_r.data = apb_rdata;
assign apb_r.suberr = apb_suberr;

assign sel_jtag = apb_state != APB_IDLE;

//==============================================
// APB state Machine
// This assumes that the TCK clock is slower
//==============================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    apb_sel <= 1'b0;
    apb_enable <= 1'b0;
    apb_addr <= 32'h0000_0000;
    apb_wdata <= 48'h0000_0000_0000;
    apb_write <= 1'b0;
    apb_rdata <= 48'h0000_0000_0000;
    apb_suberr <= 1'b0;

    apb_32bit <= 0;

    apb_state <= APB_IDLE;
  end else begin
    casez(apb_state)
      APB_IDLE: begin
        if(|apb_req_i & (apb.write | apb.read)) begin
          apb_sel <= 1'b1;
          apb_wdata <= apb.data;
          if(apb_req_i[0]) begin
            apb_write <= apb.write;
            apb_addr <= apb.addr;
            apb_32bit <= apb.d32bit;
          end else if(apb.write | apb.read) begin
            apb_addr <= apb_addr + ((apb_32bit) ? 3'h4 : 3'h2);
          end

          apb_state <= APB_SEL;
        end
      end
      APB_SEL: begin
        apb_enable <= 1'b1;
        apb_state <= APB_WAIT;
      end
      APB_WAIT: begin
        if(apb_ready_mux) begin
          apb_sel <= 1'b0;
          apb_enable <= 1'b0;
          if(~apb_write) begin
            apb_rdata <= apb_rdata_mux;
          end
          apb_suberr <= apb_suberr_mux;

          apb_state <= APB_IDLE;
        end
      end
    endcase
  end
end
 
//==============================================
// Input/Output pin muxing
//==============================================
assign clk = clk_i;
assign rstn = rstn_i;

assign psel32_jtag_o    = apb_sel & apb_32bit;
assign penable32_jtag_o = apb_enable & apb_32bit;
assign paddr32_jtag_o   = apb_addr[31:0];
assign pwdata32_jtag_o  = apb_wdata[47:0];
assign pwrite32_jtag_o  = apb_write;

assign psel16_jtag_o    = apb_sel & ~apb_32bit;
assign penable16_jtag_o = apb_enable & ~apb_32bit;
assign paddr16_jtag_o   = apb_addr[14:0];
assign pwdata16_jtag_o  = apb_wdata[15:0];
assign pwrite16_jtag_o  = apb_write;

assign sel_jtag_o = sel_jtag;

endmodule

