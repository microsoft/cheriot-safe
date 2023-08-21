
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

/*========================================================
 AXI slave memory

*/

module msftDvIp_axi_mem_bit_write #(
    parameter INIT_FILE="",
    parameter AXI_ADDR_WIDTH=32,
    parameter AXI_DATA_WIDTH=32,
    parameter AXI_ID_WIDTH=6,
    parameter AXI_LEN_WIDTH=8,
    parameter AXI_LOCK_WIDTH=1,
    parameter AXI_FIFO_BITS=2,              // 1=1 deep, 2=2 deep, 3=4 deep, 4=8 deep etc...
    parameter MEM_SIZE='h3FFF_FFFF          // 1GB
 ) (
    input                           s_axi_clk,
    input                           s_axi_rst_n,

    // Slave Interface Write Address Ports
    input [AXI_ID_WIDTH-1:0]        s_axi_awid,
    input [AXI_ADDR_WIDTH-1:0]      s_axi_awaddr,
    input [AXI_LEN_WIDTH-1:0]       s_axi_awlen,
    input [2:0]                     s_axi_awsize,
    input [1:0]                     s_axi_awburst,
    input [AXI_LOCK_WIDTH-1:0]      s_axi_awlock,
    input [3:0]                     s_axi_awcache,
    input [2:0]                     s_axi_awprot,
    input [3:0]                     s_axi_awqos,
    input                           s_axi_awvalid,
    output reg                      s_axi_awready,

    // Slave Interface Write Data Ports
    input [AXI_DATA_WIDTH-1:0]      s_axi_wdata,
    input [(AXI_DATA_WIDTH/8)-1:0]  s_axi_wstrb,
    input                           s_axi_wlast,
    input                           s_axi_wvalid,
    output                          s_axi_wready,

    // Slave Interface Write Response Ports
    input                           s_axi_bready,
    output reg [AXI_ID_WIDTH-1:0]   s_axi_bid,
    output reg [1:0]                s_axi_bresp,
    output reg                      s_axi_bvalid,

    // Slave Interface Read Address Ports
    input [AXI_ID_WIDTH-1:0]        s_axi_arid,
    input [AXI_ADDR_WIDTH-1:0]      s_axi_araddr,
    input [AXI_LEN_WIDTH-1:0]       s_axi_arlen,
    input [2:0]                     s_axi_arsize,
    input [1:0]                     s_axi_arburst,
    input [AXI_LOCK_WIDTH-1:0]      s_axi_arlock,
    input [3:0]                     s_axi_arcache,
    input [2:0]                     s_axi_arprot,
    input [3:0]                     s_axi_arqos,
    input                           s_axi_arvalid,
    output reg                      s_axi_arready,

    // Slave Interface Read Data Ports
    input                           s_axi_rready,
    output reg [AXI_ID_WIDTH-1:0]   s_axi_rid,
    output reg [AXI_DATA_WIDTH-1:0] s_axi_rdata,
    output reg [1:0]                s_axi_rresp,
    output reg                      s_axi_rlast,
    output reg                      s_axi_rvalid

  );

//=============================================
// Parameters
//=============================================
localparam RD_STATE        = 1'h0;
localparam WR_STATE        = 1'h1;

localparam VALID_ADDR_BITS = $clog2(MEM_SIZE/(AXI_DATA_WIDTH/8));
localparam MEM_ROWS = MEM_SIZE/(AXI_DATA_WIDTH/8);

localparam RD_ADDR_RDY = 1'h1;
localparam RD_ADDR_ACTIVE = 1'h0;

localparam WR_ADDR_RDY = 2'h0;
localparam WR_ADDR_ACTIVE = 2'h1;
localparam WR_WAIT=2'h2;
localparam WR_RESP= 2'h3;


//=============================================
// Register/Wires
//=============================================
reg                           arb_state;
reg [3:0]                     arb_cnt;

// Write Signals
reg [1:0]                     wr_state;
reg [AXI_ID_WIDTH-1:0]        awid; 		
reg [AXI_ADDR_WIDTH-1:0]      awaddr; 	
reg [2:0]                     awsize; 				
reg [1:0]                     awburst; 				

wire                          wr_req;
wire                          cs_wr;
wire [AXI_DATA_WIDTH-1:0]     wdata;		
wire [AXI_DATA_WIDTH/8-1:0]   wstrb;	
wire                          wready;
wire                          wlimit;

wire [VALID_ADDR_BITS-1:0]    mem_addr;

reg [AXI_ADDR_WIDTH-1:0]      araddr;
reg [AXI_LEN_WIDTH-1:0]       arlen;
reg [2:0]                     arsize;
reg [1:0]                     arburst;
reg                           cs_rd_req;
reg                           rlast_dly;

wire                          rd_req;
wire                          cs_rd;
wire [AXI_DATA_WIDTH-1:0]     data_out_mem;
wire                          rlimit;

assign rd_priority = arb_state == RD_STATE;
assign wr_priority = arb_state == WR_STATE;

assign rd_req = ~s_axi_arready & ~rlimit;
//assign s_axi_wready = wready & (wr_state == WR_ADDR_ACTIVE) | (wr_state == WR_ADDR_RDY);
// Only accept data after we get an address
assign s_axi_wready = wready & ~s_axi_awready & (wr_state == WR_ADDR_ACTIVE);

//=============================================
// Arbitration
//=============================================
always @(posedge s_axi_clk or negedge s_axi_rst_n)
begin
  if(~s_axi_rst_n) begin
    arb_state <= RD_STATE;
    arb_cnt <= 'hf;
  end else begin
    case (arb_state)
      RD_STATE: begin
        if(rd_req) begin
          if(arb_cnt != 'h0) begin
            arb_cnt <= arb_cnt - 'h1;
          end else begin
            if(wr_req) begin
              arb_state <= WR_STATE;
              arb_cnt <= 'hf;
            end
          end
        end
      end
      WR_STATE: begin
        if(wr_req) begin
          if(arb_cnt != 'h0) begin
            arb_cnt <= arb_cnt - 'h1;
          end else begin
            if(rd_req) begin
              arb_state <= RD_STATE;
              arb_cnt <= 'hf;
            end
          end
        end
      end
    endcase
  end
end

//=============================================
// Read Address State Machine
//=============================================
always @(posedge s_axi_clk or negedge s_axi_rst_n)
begin
  if(~s_axi_rst_n) begin
    s_axi_rresp <= 2'h0;
    s_axi_rid <= {AXI_ID_WIDTH{1'b0}};
    arsize <= 3'h0;
    arburst <= 2'h0;
    araddr <= {AXI_ADDR_WIDTH{1'b0}};
    arlen <= {AXI_LEN_WIDTH{1'b0}};
    cs_rd_req <= 1'b0;
    s_axi_arready <= RD_ADDR_RDY;
    rlast_dly <= 1'b0;
  end else begin
    rlast_dly <= 1'b0;
    cs_rd_req <= cs_rd;
    casez (s_axi_arready)
      RD_ADDR_RDY: begin
        if(s_axi_arready & s_axi_arvalid) begin
          araddr <= s_axi_araddr;
          s_axi_rid <= s_axi_arid;
          arlen <= s_axi_arlen;
          arsize <= s_axi_arsize;
          arburst <= s_axi_arburst;
          s_axi_arready <= RD_ADDR_ACTIVE;
        end        
      end
      RD_ADDR_ACTIVE: begin
        if(cs_rd) begin
          if(arlen == 0) begin
            rlast_dly <= 1'b1;
            s_axi_arready <= RD_ADDR_RDY;
          end else begin
            if(arburst[0]) begin
              araddr <= araddr + (1<<arsize);
              arlen <= arlen - 1'b1;
            end
          end
        end
      end
    endcase
  end
end

//=============================================
// Read Data FIFO
//=============================================
msftDvIp_axi_memory_fifo #(
    .FIFO_SIZE(4),
    .FIFO_DATA_WIDTH(AXI_DATA_WIDTH+1)
  )  rd_fifo (
  .clk_i(s_axi_clk),
  .rstn_i(s_axi_rst_n),
  .wrReq(cs_rd_req),
  .wrAck(rfifo_wack),
  .wdata({rlast_dly, data_out_mem}),
  .rdReq(s_axi_rready),
  .rdAck(s_axi_rvalid),
  .rdata({s_axi_rlast, s_axi_rdata}),
  .limit(rlimit)
);


//=============================================
// Write Address State Machine
//=============================================
always @(posedge s_axi_clk or negedge s_axi_rst_n)
begin
  if(~s_axi_rst_n) begin
    awaddr <= {AXI_ADDR_WIDTH{1'b0}};
    awsize <= 3'h0;
    awburst <= 2'h0;
    s_axi_awready <= 1'b1;
    s_axi_bresp <= 2'h0;
    s_axi_bvalid <= 1'b0;
    s_axi_bid <= {AXI_ID_WIDTH{1'h0}};
    wr_state <= WR_ADDR_RDY; 
  end else begin
    case (wr_state)
      WR_ADDR_RDY: begin
        if(s_axi_awvalid) begin
          awaddr <= s_axi_awaddr;
          awsize <= s_axi_awsize;
          awburst <= s_axi_awburst;
          s_axi_bid <= s_axi_awid;
          s_axi_bresp <= 2'h0;
          s_axi_awready <= 1'b0;
          // If we get write data on the same cycle and it is the last bypass the active state
          if(s_axi_wvalid & s_axi_wready & s_axi_wlast) begin
            wr_state <= WR_WAIT;
          end else begin
            wr_state <= WR_ADDR_ACTIVE;
          end
        end        
      end
      WR_ADDR_ACTIVE: begin
        if(cs_wr & awburst[0]) begin
          awaddr <= awaddr + (1<<awsize);
        end
        if(s_axi_wvalid & s_axi_wready & s_axi_wlast) begin
          wr_state <= WR_WAIT;
        end
      end
      WR_WAIT: begin
        if(cs_wr & awburst[0]) begin
          awaddr <= awaddr + (1<<awsize);
        end
        if(~wr_req) begin
          s_axi_bvalid <= 1'b1;
          wr_state <= WR_RESP; 
        end
      end
      WR_RESP: begin
        if(s_axi_bready) begin
          s_axi_bvalid <= 1'b0;
          s_axi_awready <= 1'b1;
          wr_state <= WR_ADDR_RDY;
        end
      end
    endcase
  end
end

//=============================================
// Write Data FIFO
//=============================================
msftDvIp_axi_memory_fifo #(
    .FIFO_SIZE(2),
    .FIFO_DATA_WIDTH(AXI_DATA_WIDTH+(AXI_DATA_WIDTH/8))
  )  wr_fifo (
  .clk_i(s_axi_clk),
  .rstn_i(s_axi_rst_n),
  .wrReq(s_axi_wvalid & s_axi_wready),
  .wrAck(wready),
  .wdata({s_axi_wstrb, s_axi_wdata}),
  .rdReq(cs_wr),
  .rdAck(wr_req),
  .rdata({wstrb, wdata}),
  .limit(wlimit)
);

//=============================================
// Write Mux
//=============================================
wire [AXI_DATA_WIDTH-1:0] write_strobe;
genvar i;
generate 
for(i=0;i<AXI_DATA_WIDTH/8;i+=1) begin : write_mux
    assign write_strobe[((i+1)*8)-1:(i*8)] = (wstrb[i]) ?  8'hff : 8'h00;
end
endgenerate

//=============================================
// Address Mux
//=============================================
assign mem_addr = (cs_wr) ? awaddr/(AXI_DATA_WIDTH/8) : araddr/(AXI_DATA_WIDTH/8);
assign cs_wr = wr_req & (wr_priority | ~rd_req);
assign cs_rd = rd_req & (rd_priority | ~wr_req);
assign cs_mem = cs_wr | cs_rd;

//=============================================
// Block RAM Instance
//=============================================
axi_fpga_block_ram_bit_wr_model_axi_mem #(
    .INIT_FILE(INIT_FILE),
    .RAM_WIDTH(AXI_DATA_WIDTH),
    .RAM_DEPTH(MEM_ROWS)
  ) fpga_block_ram (
  .clk(s_axi_clk),
  .cs(cs_mem),
  .addr(mem_addr),
  .we(cs_wr),
  .wstrb(write_strobe),
  .din(wdata),
  .dout(data_out_mem),
  .ready()
);

endmodule


//======================================================
// FIFO 
//======================================================
module msftDvIp_axi_memory_fifo #(
  parameter FIFO_SIZE=4,
  parameter FIFO_DATA_WIDTH=32,
  parameter FIFO_LIMIT=FIFO_SIZE-1
  )  (
  input                         clk_i,
  input                         rstn_i,

  input                         wrReq,
  output                        wrAck,
  input [FIFO_DATA_WIDTH-1:0]   wdata,

  input                         rdReq,
  output                        rdAck,
  output [FIFO_DATA_WIDTH-1:0]  rdata,

  output                        limit
);

localparam FIFO_PTR_BITS = $clog2(FIFO_SIZE);

reg [FIFO_DATA_WIDTH-1:0]           fifo    [FIFO_SIZE-1:0];
reg [FIFO_PTR_BITS-1:0]             fifo_hptr;
reg [FIFO_PTR_BITS-1:0]             fifo_tptr;
reg [FIFO_PTR_BITS:0]               fifo_cnt;


assign fifo_inc = wrReq & wrAck & ~(rdReq & rdAck); 
assign fifo_dec = rdReq & rdAck & ~(wrReq & wrAck);
assign fifo_full  = fifo_cnt[FIFO_PTR_BITS];
assign fifo_empty = ~(|fifo_cnt);

assign limit = fifo_cnt >= FIFO_LIMIT;

assign wrAck = ~fifo_full;
assign rdAck = ~fifo_empty;

assign rdata = fifo[fifo_tptr];

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    for(int i=0;i<FIFO_SIZE;i=i+1) begin
      fifo[i] <= {FIFO_DATA_WIDTH{1'b0}};
    end
    fifo_hptr <= {FIFO_PTR_BITS+1{1'b0}};
    fifo_tptr <= {FIFO_PTR_BITS+1{1'b0}};
    fifo_cnt <=  {FIFO_PTR_BITS+1{1'b0}};
  end else begin
    if(wrReq & wrAck) begin
      fifo[fifo_hptr] <= wdata;
      fifo_hptr  <= fifo_hptr + 1'b1;
    end
    if(rdReq & rdAck) begin
      fifo_tptr  <= fifo_tptr + 1'b1;
    end

    if(fifo_inc) begin
      fifo_cnt <= fifo_cnt + 1'b1;
    end else if(fifo_dec) begin
      fifo_cnt <= fifo_cnt - 1'b1;
    end
  end
end
endmodule


//======================================================
// RAM Model
//======================================================
module axi_fpga_block_ram_bit_wr_model_axi_mem #(
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
  output                              ready
);

// Always Align to 8 bits wide
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

assign cs_ram     = (RAM_BACK_DOOR_ENABLE & cs_bkdr) ? cs_bkdr      : cs;
assign addr_ram   = (RAM_BACK_DOOR_ENABLE & cs_bkdr) ? addr_bkdr    : addr;
assign we_ram     = (RAM_BACK_DOOR_ENABLE & cs_bkdr) ? we_bkdr      : we;
assign wstrb_ram  = (RAM_BACK_DOOR_ENABLE & cs_bkdr) ? wstrb_bkdr   : wstrb;
assign din_ram    = (RAM_BACK_DOOR_ENABLE & cs_bkdr) ? din_bkdr     : din;

//==================================
// Do Read and Write
//==================================
integer i;
always @(posedge clk)
begin
  if(cs_ram) begin
    if(we_ram) begin
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

endmodule
