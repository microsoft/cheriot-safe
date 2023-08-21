
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

module msftDvDebug_dpi_apb_mux #(
  parameter APB_ADDR_WIDTH=32,
  parameter APB_DATA_WIDTH=32
  )  (
  input                             psel_apb_i,
  input                             penable_apb_i,
  input  [APB_ADDR_WIDTH-1:0]       paddr_apb_i,
  input  [APB_DATA_WIDTH-1:0]       pwdata_apb_i,
  input                             pwrite_apb_i,
  input  [(APB_DATA_WIDTH/8)-1:0]   pstrb_apb_i,
  output [APB_DATA_WIDTH-1:0]       prdata_apb_o,
  output                            pready_apb_o,
  output                            psuberr_apb_o,

  output                            penable_sub_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_sub_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_sub_o,
  output                            pwrite_sub_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_sub_o,


  output                            psel_jd_o,
  output                            penable_jd_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_jd_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_jd_o,
  output                            pwrite_jd_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_jd_o,
  input [APB_DATA_WIDTH-1:0]        prdata_jd_i,
  input                             pready_jd_i,
  input                             psuberr_jd_i,

  output                            psel_emu_o,
  output                            penable_emu_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_emu_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_emu_o,
  output                            pwrite_emu_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_emu_o,
  input [APB_DATA_WIDTH-1:0]        prdata_emu_i,
  input                             pready_emu_i,
  input                             psuberr_emu_i
);


  wire [APB_DATA_WIDTH-1:0]         prdata_jd_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_emu_mux;


  assign penable_sub_o = penable_apb_i;
  assign paddr_sub_o   = paddr_apb_i;
  assign pwdata_sub_o  = pwdata_apb_i;
  assign pwrite_sub_o  = pwrite_apb_i;
  assign pstrb_sub_o   = pstrb_apb_i;

  assign penable_jd_o = penable_apb_i;
  assign paddr_jd_o   = paddr_apb_i;
  assign pwdata_jd_o  = pwdata_apb_i;
  assign pwrite_jd_o  = pwrite_apb_i;
  assign pstrb_jd_o   = pstrb_apb_i;

  assign penable_emu_o = penable_apb_i;
  assign paddr_emu_o   = paddr_apb_i;
  assign pwdata_emu_o  = pwdata_apb_i;
  assign pwrite_emu_o  = pwrite_apb_i;
  assign pstrb_emu_o   = pstrb_apb_i;

  assign psel_jd_o = psel_apb_i &   (paddr_apb_i >= 32'h0000_0000 && paddr_apb_i < 32'h0000_1000);
  assign psel_emu_o = psel_apb_i &   (paddr_apb_i >= 32'h0000_8000 && paddr_apb_i < 32'h0000_9000);
  assign psel_def_o = psel_apb_i & ~(psel_jd_o | psel_emu_o);

  assign prdata_jd_mux =  {APB_DATA_WIDTH{psel_jd_o}} & prdata_jd_i;
  assign prdata_emu_mux =  {APB_DATA_WIDTH{psel_emu_o}} & prdata_emu_i;

  assign prdata_apb_o = prdata_jd_mux | prdata_emu_mux;

  assign pready_jd_mux =  psel_jd_o & pready_jd_i;
  assign pready_emu_mux =  psel_emu_o & pready_emu_i;

  assign pready_apb_o = pready_jd_mux | pready_emu_mux | psel_def_o;

  assign psuberr_jd_mux =  psel_jd_o & psuberr_jd_i;
  assign psuberr_emu_mux =  psel_emu_o & psuberr_emu_i;

  assign psuberr_apb_o = psuberr_jd_mux | psuberr_emu_mux | psel_def_o;


endmodule
