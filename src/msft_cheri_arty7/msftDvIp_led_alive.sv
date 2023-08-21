
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



module msftDvIp_led_alive (
  input   clk_i,
  input   rstn_i,

  output alive_o

);



reg [31:0] led_cnt;

assign alive_o = led_cnt[26];

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    led_cnt <= 32'h0000_0000;
  end else begin
    led_cnt <= led_cnt - 1'b1;
  end
end



endmodule

