
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

// This File is Auto Generated do not edit
module msftDvIp_msftDvIp_cheri_axi_fabric_mgr_mux #(
    parameter APHASE_LEN=10,
    parameter WPHASE_LEN=10,
    parameter SUB_NUM=0
  )   (
     // Input From Sub 
    input                         awphase_ready_sub_i,
    input                         wphase_ready_sub_i,
    input                         arphase_ready_sub_i,

      // Mgr/Sub Request/Ready lines
    input  [3:0]     awphase_valid_mgr0_i,
    input  [3:0]     wphase_valid_mgr0_i,
    input  [3:0]     arphase_valid_mgr0_i,
    input  [3:0]     awphase_valid_mgr1_i,
    input  [3:0]     wphase_valid_mgr1_i,
    input  [3:0]     arphase_valid_mgr1_i,

    input  [APHASE_LEN-1:0]     awphase_mgr0_i,
    input  [WPHASE_LEN-1:0]     wphase_mgr0_i,
    input  [APHASE_LEN-1:0]     arphase_mgr0_i,
    input  [APHASE_LEN-1:0]     awphase_mgr1_i,
    input  [WPHASE_LEN-1:0]     wphase_mgr1_i,
    input  [APHASE_LEN-1:0]     arphase_mgr1_i,

    output reg [1:0]       awphase_ready_from_sub_o,
    output reg [1:0]       wphase_ready_from_sub_o,
    output reg [1:0]       arphase_ready_from_sub_o,

    input  [3:0]       rphase_ready_from_mgr0_i,
    input  [3:0]       bphase_ready_from_mgr0_i,
    input  [3:0]       rphase_ready_from_mgr1_i,
    input  [3:0]       bphase_ready_from_mgr1_i,

     // Outputs to Sub 
    output                        awphase_valid_sub_o,
    output                        wphase_valid_sub_o,
    output                        arphase_valid_sub_o,

    output reg [APHASE_LEN-1:0]   awphase_sub_o,
    output reg [WPHASE_LEN-1:0]   wphase_sub_o,
    output reg [APHASE_LEN-1:0]   arphase_sub_o,

    output                        rphase_ready_sub_o,
    output                        bphase_ready_sub_o

);

// Wire definitions
wire [1:0] awphase_sel;
wire [1:0] awphase_valid;

wire [1:0] wphase_sel;
wire [1:0] wphase_valid;

wire [1:0] arphase_sel;
wire [1:0] arphase_valid;

// Generate Sub Valid
assign awphase_valid[0] = awphase_valid_mgr0_i[SUB_NUM];
assign awphase_valid[1] = awphase_valid_mgr1_i[SUB_NUM];

assign wphase_valid[0] = wphase_valid_mgr0_i[SUB_NUM];
assign wphase_valid[1] = wphase_valid_mgr1_i[SUB_NUM];

assign arphase_valid[0] = arphase_valid_mgr0_i[SUB_NUM];
assign arphase_valid[1] = arphase_valid_mgr1_i[SUB_NUM];

// Priority Encoder 
assign awphase_valid_sub_o = |awphase_valid;

always @*
begin
  awphase_ready_from_sub_o = {2{1'b0}};
  casez (awphase_valid)
    2'b?1: begin awphase_sub_o = awphase_mgr0_i; awphase_ready_from_sub_o[0] = awphase_ready_sub_i; end
    2'b10: begin awphase_sub_o = awphase_mgr1_i; awphase_ready_from_sub_o[1] = awphase_ready_sub_i; end
    default: awphase_sub_o = awphase_mgr0_i;
  endcase
end

assign wphase_valid_sub_o = |wphase_valid;

always @*
begin
  wphase_ready_from_sub_o = {2{1'b0}};
  casez (wphase_valid)
    2'b?1: begin wphase_sub_o = wphase_mgr0_i; wphase_ready_from_sub_o[0] = wphase_ready_sub_i; end
    2'b10: begin wphase_sub_o = wphase_mgr1_i; wphase_ready_from_sub_o[1] = wphase_ready_sub_i; end
    default: wphase_sub_o = wphase_mgr0_i;
  endcase
end

assign arphase_valid_sub_o = |arphase_valid;

always @*
begin
  arphase_ready_from_sub_o = {2{1'b0}};
  casez (arphase_valid)
    2'b?1: begin arphase_sub_o = arphase_mgr0_i; arphase_ready_from_sub_o[0] = arphase_ready_sub_i; end
    2'b10: begin arphase_sub_o = arphase_mgr1_i; arphase_ready_from_sub_o[1] = arphase_ready_sub_i; end
    default: arphase_sub_o = arphase_mgr0_i;
  endcase
end

// Generate rready and bready
wire [3:0] bphase_ready = bphase_ready_from_mgr0_i |  bphase_ready_from_mgr1_i;
assign bphase_ready_sub_o = bphase_ready[SUB_NUM];

wire [3:0] rphase_ready = rphase_ready_from_mgr0_i |  rphase_ready_from_mgr1_i;
assign rphase_ready_sub_o = rphase_ready[SUB_NUM];

endmodule
