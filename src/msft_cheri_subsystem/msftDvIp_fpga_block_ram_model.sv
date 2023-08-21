
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


module msftDvIp_fpga_block_ram_model #(
  parameter integer RAM_WIDTH = 32,
  parameter RAM_BACK_DOOR_ENABLE = 0,
  parameter RAM_DEPTH = 1024,
  parameter INIT_FILE = ""
  ) (
  input                               clk,
  input                               cs,
  input [$clog2(RAM_DEPTH)-1:0]       addr,
  input                               we,
  input  [RAM_WIDTH-1:0]              din,
  output [RAM_WIDTH-1:0]              dout
);

// Always Align to 8 bits wide

reg [RAM_WIDTH-1:0]    ram [RAM_DEPTH-1:0];
reg [RAM_WIDTH-1:0]    ram_rd_data;

assign dout = ram_rd_data[RAM_WIDTH-1:0];

//==================================
// Init Memory
//==================================
generate
  if (INIT_FILE != "") begin: use_init_file
    initial
    begin
			$display("Reading %s", INIT_FILE);
      $readmemh(INIT_FILE, ram, 0, RAM_DEPTH-1);
    end
  end else begin: init_bram_to_zero
    integer ram_index;
    initial
    begin
      for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1) begin
        ram[ram_index] = {RAM_WIDTH{1'b0}};
      end
    end
  end
endgenerate

//==================================
// Backdoor Mux
//==================================
wire                          cs_bkdr;
wire [$clog2(RAM_DEPTH)-1:0]  addr_bkdr;
wire                          we_bkdr;
wire [RAM_WIDTH-1:0]          din_bkdr;
wire                          accen_bkdr;
wire                          rdy_bkdr = ~cs | ~accen_bkdr;

genvar i;
generate
  if(!RAM_BACK_DOOR_ENABLE) begin
    assign cs_bkdr    = 1'b0;
    assign addr_bkdr  = {$clog2(RAM_DEPTH){1'b0}};  
    assign we_bkdr    = 1'b0;  
    assign din_bkdr   = {RAM_WIDTH-1{1'b0}};
    assign accen_bkdr = 1'b1;
  end
endgenerate

wire                          cs_ram;
wire [$clog2(RAM_DEPTH)-1:0]  addr_ram;
wire                          we_ram;
wire [RAM_WIDTH-1:0]          din_ram;

assign cs_ram   = (RAM_BACK_DOOR_ENABLE & cs_bkdr & rdy_bkdr) ? cs_bkdr   : cs & accen_bkdr;
assign addr_ram = (RAM_BACK_DOOR_ENABLE & cs_bkdr & rdy_bkdr) ? addr_bkdr : addr;
assign we_ram   = (RAM_BACK_DOOR_ENABLE & cs_bkdr & rdy_bkdr) ? we_bkdr   : we;
assign din_ram  = (RAM_BACK_DOOR_ENABLE & cs_bkdr & rdy_bkdr) ? din_bkdr  : din;

//==================================
// Do Read and Write
//==================================
always @(posedge clk)
begin
  if(cs_ram) begin
    if(we_ram) begin
      ram[addr_ram] <= din_ram;
    end else begin
      ram_rd_data <= ram[addr_ram];
    end
  end
end

endmodule:msftDvIp_fpga_block_ram_model

