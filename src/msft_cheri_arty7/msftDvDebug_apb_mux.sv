
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



module msftDvDebug_apb_mux #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
  ) (
  output                    psel_out_o,
  output                    penable_out_o,
  output [ADDR_WIDTH-1:0]   paddr_out_o,
  output [DATA_WIDTH-1:0]   pwdata_out_o,
  output                    pwrite_out_o,
  input  [DATA_WIDTH-1:0]   prdata_out_i,
  input                     pready_out_i,
  input                     psuberr_out_i,

  input                     psel_0_i,
  input                     penable_0_i,
  input  [ADDR_WIDTH-1:0]   paddr_0_i,
  input  [DATA_WIDTH-1:0]   pwdata_0_i,
  input                     pwrite_0_i,
  output [DATA_WIDTH-1:0]   prdata_0_o,
  output                    pready_0_o,
  output                    psuberr_0_o,

  input                     psel_1_i,
  input                     penable_1_i,
  input  [ADDR_WIDTH-1:0]   paddr_1_i,
  input  [DATA_WIDTH-1:0]   pwdata_1_i,
  input                     pwrite_1_i,
  output [DATA_WIDTH-1:0]   prdata_1_o,
  output                    pready_1_o,
  output                    psuberr_1_o,

  input                     psel_2_i,
  input                     penable_2_i,
  input  [ADDR_WIDTH-1:0]   paddr_2_i,
  input  [DATA_WIDTH-1:0]   pwdata_2_i,
  input                     pwrite_2_i,
  output [DATA_WIDTH-1:0]   prdata_2_o,
  output                    pready_2_o,
  output                    psuberr_2_o,

  input [1:0]               sel_i

);

//==========================================
// SPI/I2C 16 bit Mux
//==========================================
assign psel_out_o     = (sel_i[1])  ? psel_2_i     : (sel_i[0])  ? psel_1_i     : psel_0_i;
assign penable_out_o  = (sel_i[1])  ? penable_2_i  : (sel_i[0])  ? penable_1_i  : penable_0_i;
assign paddr_out_o    = (sel_i[1])  ? paddr_2_i    : (sel_i[0])  ? paddr_1_i    : paddr_0_i;
assign pwdata_out_o   = (sel_i[1])  ? pwdata_2_i   : (sel_i[0])  ? pwdata_1_i   : pwdata_0_i;
assign pwrite_out_o   = (sel_i[1])  ? pwrite_2_i   : (sel_i[0])  ? pwrite_1_i   : pwrite_0_i;

assign prdata_0_o  = prdata_out_i;
assign pready_0_o  = sel_i == 2'h0 && penable_0_i & pready_out_i;
assign psuberr_0_o = sel_i == 2'h0 && penable_0_i & psuberr_out_i;

assign prdata_1_o  = prdata_out_i;
assign pready_1_o  = sel_i == 2'h1 && penable_1_i & pready_out_i;
assign psuberr_1_o = sel_i == 2'h1 && penable_1_i & psuberr_out_i;

assign prdata_2_o  = prdata_out_i;
assign pready_2_o  = sel_i == 2'h2 && penable_2_i & pready_out_i;
assign psuberr_2_o = sel_i == 2'h2 && penable_2_i & psuberr_out_i;

endmodule
