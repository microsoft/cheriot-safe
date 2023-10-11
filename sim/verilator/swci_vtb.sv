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

module swci_vtb (
  input logic       sysclk_i,
  input logic       rstn_i
);

msftDvIp_cheri_arty7_fpga dut (
  .board_clk_i    (sysclk_i),
  .board_rstn_i   (rstn_i),
  .ssel0_i        (1'b0),
  .sck0_i         (1'b0),
  .mosi0_i        (1'b0),
  .miso0_o        (),
  .TRSTn_i        (1'b0),
  .TCK_i          (1'b0),
  .TMS_i          (1'b0),
  .TDI_i          (1'b0),
  .TDO_io         (),
  .alive_o        (),
  .TRSTn_mux_o    (),
  .txd_dvp_o      (),
  .rxd_dvp_i      (1'b0),
  .i2c0_scl_io    (),
  .i2c0_sda_io    (),
  .i2c0_scl_pu_en_o(),
  .i2c0_sda_pu_en_o(),
  .gpio0_io        (),
  .PMODA_io        (),
  .PMODB_io        (),
  .PMODC_io        (),
  .PMODD_io        ()
);

  logic       uart_tx_fifo_wr;
  logic [7:0] uart_tx_fifo_wdata;

  assign uart_tx_fifo_wr = dut.msftDvIp_cheri0_subsystem_i.msftDvIp_periph_wrapper_v0_i.msftDvIp_uart_i.msftDvIp_uart_tx_fifo_i.wr_i;
  assign uart_tx_fifo_wdata = dut.msftDvIp_cheri0_subsystem_i.msftDvIp_periph_wrapper_v0_i.msftDvIp_uart_i.msftDvIp_uart_tx_fifo_i.wdata_i;
  always @(posedge sysclk_i) begin
    if (uart_tx_fifo_wr) $write("%c", uart_tx_fifo_wdata);
  end

endmodule
