
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


// This File is Auto Generated do not edit
module msftDvIp_msftDvIp_cheri_axi_fabric_addr_decode #(
    parameter ENABLE_SUB0=2'h3,
    parameter ENABLE_SUB1=2'h3,
    parameter ENABLE_SUB2=2'h3,
    parameter AXI_ADDR_WIDTH=32
  )   (
    input  [AXI_ADDR_WIDTH-1:0]   awphase_addr_mgr_i,
    input  [AXI_ADDR_WIDTH-1:0]   arphase_addr_mgr_i,

    output [3:0]       awphase_decode_mgr_o,
    output [3:0]       arphase_decode_mgr_o
);
assign awphase_decode_mgr_o[0] =  (awphase_addr_mgr_i >= 'h8f0f0000 && awphase_addr_mgr_i < 'hffffffff)  & ENABLE_SUB0[0];
assign arphase_decode_mgr_o[0] =  (arphase_addr_mgr_i >= 'h8f0f0000 && arphase_addr_mgr_i < 'hffffffff)  & ENABLE_SUB0[1];
assign awphase_decode_mgr_o[1] =  (awphase_addr_mgr_i >= 'h8f000000 && awphase_addr_mgr_i < 'h8f010000)  & ENABLE_SUB1[0];
assign arphase_decode_mgr_o[1] =  (arphase_addr_mgr_i >= 'h8f000000 && arphase_addr_mgr_i < 'h8f010000)  & ENABLE_SUB1[1];
assign awphase_decode_mgr_o[2] =  (awphase_addr_mgr_i >= 'h8f020000 && awphase_addr_mgr_i < 'h8f022000)  & ENABLE_SUB2[0];
assign arphase_decode_mgr_o[2] =  (arphase_addr_mgr_i >= 'h8f020000 && arphase_addr_mgr_i < 'h8f022000)  & ENABLE_SUB2[1];

// Generate default
assign awphase_decode_mgr_o[3] = ~(|awphase_decode_mgr_o[2:0]);
assign arphase_decode_mgr_o[3] = ~(|arphase_decode_mgr_o[2:0]);

endmodule
