// Copyright (C) Microsoft Corporation. All rights reserved.

//===============================================
//      Self contained memories for DVP
//===============================================
module msftDvIp_fpga_block_ram_2port_model #(
  parameter RAM_BACK_DOOR_ENABLE = 0,
  parameter integer RAM_WIDTH = 32,
  parameter RAM_DEPTH = 1024,
  parameter INIT_FILE = ""
  ) (
  input                               clk,
  input                               cs,
  input [$clog2(RAM_DEPTH)-1:0]       addr,
  input                               we,
  input  [RAM_WIDTH-1:0]              wstrb,
  input  [RAM_WIDTH-1:0]              din,
  output [RAM_WIDTH-1:0]              dout,
  output                              ready,
  // read only port
  input                               cs2,
  input [$clog2(RAM_DEPTH)-1:0]       addr2,
  output reg [RAM_WIDTH-1:0]          dout2
);

reg [RAM_WIDTH-1:0]    ram [RAM_DEPTH-1:0];
reg [RAM_WIDTH-1:0]    ram_rd_data;
reg [RAM_WIDTH-1:0]    ram_wr_data;

assign dout = ram_rd_data[RAM_WIDTH-1:0];
assign ready = 1'b1;

//==================================
// Init Memory
//==================================
generate
  if (INIT_FILE != "") begin: use_init_file
    initial
    begin
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
wire [RAM_WIDTH-1:0]          wstrb_bkdr;
wire [RAM_WIDTH-1:0]          din_bkdr;

wire                          cs_ram;
wire [$clog2(RAM_DEPTH)-1:0]  addr_ram;
wire                          we_ram;
wire [RAM_WIDTH-1:0]          wstrb_ram;
wire [RAM_WIDTH-1:0]          din_ram;

assign cs_ram      = (RAM_BACK_DOOR_ENABLE & cs_bkdr) ? cs_bkdr      : cs;
assign addr_ram    = (RAM_BACK_DOOR_ENABLE & cs_bkdr) ? addr_bkdr    : addr;
assign we_ram      = (RAM_BACK_DOOR_ENABLE & cs_bkdr) ? we_bkdr      : we;
assign wstrb_ram   = (RAM_BACK_DOOR_ENABLE & cs_bkdr) ? wstrb_bkdr   : wstrb;
assign din_ram     = (RAM_BACK_DOOR_ENABLE & cs_bkdr) ? din_bkdr     : din;

//==================================
// Do Read and Write
//==================================
always @(posedge clk)
begin
  if(cs_ram) begin
    if(we_ram) begin
      integer i;
      for(i=0;i<RAM_WIDTH;i=i+1) begin
        if(wstrb_ram[i]) begin
          ram[addr_ram][i] = din_ram[i];
        end 
      end
    end else begin
      ram_rd_data <= ram[addr_ram];
    end
  end
end

always @(posedge clk)
begin
  if(cs2) 
    dout2 <= ram[addr2];
  else
    dout2 <= 0;
end

endmodule

