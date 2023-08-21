
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

/*
  miso_oen is active high

*/


module msftDvDebug_spiSlave(

  input         sclk,
  input         mosi,
  output        miso,
  input         ss0n,
  output        miso_oen,

  input         clk,
  input         rstn,

  output        psel16_spi,
  output        penable16_spi,
  output [14:0] paddr16_spi,
  output [15:0] pwdata16_spi,
  output        pwrite16_spi,
  input  [15:0] prdata16_spi,
  input         pready16_spi,
  input         psuberr16_spi,

  output        psel32_spi,
  output        penable32_spi,
  output [31:0] paddr32_spi,
  output [47:0] pwdata32_spi,
  output        pwrite32_spi,
  input  [47:0] prdata32_spi,
  input         pready32_spi,
  input         psuberr32_spi
);

// Parameters
parameter APB_IDLE = 0;
parameter APB_ENABLE = 1;
parameter APB_WAIT = 2;

parameter SPI_INCR  = 14;
parameter SPI_WRITE = 15;

// SCLK domain
reg [15:0]  spi_addr;
reg [15:0]  spi_wr_addr;
reg [13:0]  spi_addr_hld;
reg [15:0]  spi_data;
reg [15:0]  spi_apb_wdata;
reg [4:0]   spi_cnt;
reg [4:0]   spi_cntn;
reg [15:0]  spi_rdata_ff;
reg         miso_oen_ff;

// Clock Domain Crossing 
reg [1:0]   apb_rd_rdy;
reg [1:0]   apb_wr_rdy;
reg         spi_wr_rdy;
reg         spi_rd_rdy;

wire        spi_rd_srff_rstn;
wire        spi_wr_srff_rstn;

// PCLK domain 
reg         penable_ff;
reg         psel_ff;
reg [15:0]  prdata_ff;

wire [15:0] prdata_mux; 
wire        pready_mux;
wire        psuberr_mux;

wire        psel16_int;
wire [15:0] prdata16_int;
wire        pready16_int;
wire        psuberr16_int;

reg [1:0]   apb_state;
reg [15:0]  apb_addr;
reg [15:0]  apb_data;

wire [31:0] ctrl;
reg  [1:0] cs_edge;

// APB signals
assign penable16_spi = penable_ff;
assign psel16_spi    = psel_ff & !psel16_int;
assign paddr16_spi   = {apb_addr, 1'b0};
assign pwdata16_spi  = apb_data;
assign pwrite16_spi  = apb_addr[SPI_WRITE] & psel_ff;

assign miso = spi_rdata_ff[15];
assign miso_oen = miso_oen_ff;

assign prdata_mux  = (psel16_int) ? prdata16_int : prdata16_spi;
assign pready_mux  = (psel16_int) ? pready16_int : pready16_spi;
assign psuberr_mux = (psel16_int) ? psuberr16_int : psuberr16_spi;

//=====================================
// SPI Clock Domain
//=====================================

//=====================================
// Generate MISO
//=====================================
always @(negedge sclk or posedge ss0n) begin
  if(ss0n) begin
    miso_oen_ff <= 1'b0;
    spi_rdata_ff <= 16'h0000;
  end else begin
    miso_oen_ff <= spi_cnt[4];
    if(spi_cnt == 5'h10) begin
      spi_rdata_ff <= prdata_ff;
    end else if(spi_cnt[4]) begin
      spi_rdata_ff <= {spi_rdata_ff[14:0], 1'b0};
    end
  end
end

//=====================================
// Capture SPI Address/Data
//=====================================
always @(posedge sclk or posedge ss0n)
begin
  if(ss0n) begin
    spi_cnt <= 'h0;
    spi_addr <= 16'h0000;
    spi_addr_hld <= 14'h0000;
    spi_data <= 16'h0000;
  end else begin
    if(spi_cnt < 16) begin
      spi_addr <= {spi_addr[14:0], mosi};
      spi_addr_hld <= {spi_addr[12:0], mosi};
      spi_cnt <= spi_cnt + 1'b1;
    end else if(spi_cnt > 15) begin
      spi_data <= {spi_data[14:0], mosi};
      if(spi_cnt == 31) begin
        spi_apb_wdata <= {spi_data[14:0], mosi};
        spi_wr_addr <= spi_addr;
        // Increment address
        if(spi_addr[SPI_INCR]) begin
          if(spi_addr[13:0] == 14'h3fff) begin
            spi_addr[13:0] <= spi_addr_hld; 
          end else begin
            spi_addr[13:0] <= spi_addr[13:0] + 1'b1;
          end
        end
        spi_cnt <= 16;
      end else begin
        spi_cnt <= spi_cnt + 1'b1;
      end
    end
  end
end

//=====================================
// PCLK <-> SCLK Domain Crossing
//=====================================

//=====================================
// SPI Read Ready
//=====================================
assign spi_rd_rdy_nxt = spi_cnt == 5'h11 && ~spi_addr[SPI_WRITE];
assign spi_rd_srff_rstn = rstn & ~apb_rd_rdy[1];
always @(posedge sclk or negedge spi_rd_srff_rstn)
begin
  if(~spi_rd_srff_rstn) begin
    spi_rd_rdy <= 1'b0;
  end else begin
    spi_rd_rdy <= (spi_rd_rdy_nxt) ? 1'b1 : spi_rd_rdy;
  end
end

//=====================================
// SPI Write Ready
//=====================================
assign spi_wr_rdy_nxt = spi_cnt == 5'h1f && spi_addr[SPI_WRITE];
assign spi_wr_srff_rstn = rstn & ~apb_wr_rdy[1];
always @(posedge sclk or negedge spi_wr_srff_rstn)
begin
  if(~spi_wr_srff_rstn) begin
    spi_wr_rdy <= 1'b0;
  end else begin
    spi_wr_rdy <= (spi_wr_rdy_nxt) ? 1'b1 : spi_wr_rdy;
  end
end

//=====================================
// PCLK Domain
//=====================================

//=====================================
// APB Read Ready
//=====================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    apb_rd_rdy <= 2'h0;
  end else begin
    apb_rd_rdy <= (apb_rd_rdy[1]) ? 2'h0 : {apb_rd_rdy[0] & spi_rd_rdy, spi_rd_rdy};
  end
end

//=====================================
// APB Write Ready
//=====================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    apb_wr_rdy <= 2'h0;
  end else begin
    apb_wr_rdy <= (apb_wr_rdy[1]) ? 2'h0 : {apb_wr_rdy[0] & spi_wr_rdy, spi_wr_rdy};
  end
end

//=====================================
// Create Oneshot to pass Slave Select 
// info to APB for holding address
//=====================================
assign cs_posedge = cs_edge == 2'b01;
assign cs_negedge = cs_edge == 2'b10;

always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    cs_edge <= 2'b00;
  end else begin
    cs_edge <= {cs_edge[0],ss0n};
  end
end

//=====================================
// APB Command 
//=====================================
assign dodo = apb_state == APB_IDLE && apb_rd_rdy[1];
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    apb_state <= APB_IDLE;
    apb_addr <= 'h0;
    apb_data <= 'h0;
    penable_ff <= 1'b0;
    psel_ff <= 1'b0;
    prdata_ff <= 16'hffff;
  end else begin
    case (apb_state)
      APB_IDLE: begin
        if(apb_rd_rdy[1]) begin 
          apb_addr <= spi_addr;
          psel_ff <= 1'b1;
          apb_state <= APB_ENABLE;
        end else if(apb_wr_rdy[1]) begin
          apb_addr <= spi_wr_addr;
          apb_data <= spi_apb_wdata;
          psel_ff <= 1'b1;
          apb_state <= APB_ENABLE;
        end
      end
      APB_ENABLE: begin
        penable_ff <= 1'b1;
        apb_state <= APB_WAIT;
      end
      APB_WAIT: begin
        if(pready_mux) begin
          psel_ff <= 1'b0;
          penable_ff <= 1'b0;
          if(~apb_addr[SPI_WRITE]) begin
            prdata_ff <= prdata_mux;
          end
          apb_state <= APB_IDLE;
        end
      end
    endcase
  end
end

assign psel16_int = paddr16_spi[14:5] == ('h7ffe>>5) && psel_ff;
msftDvDebug_apb_16_2_32 dv_apb_16_2_32(
  .clk(clk),
  .rstn(rstn),
  .psel(psel16_int),
  .penable(penable16_spi),
  .paddr(paddr16_spi),
  .prdata(prdata16_int),
  .pwdata(pwdata16_spi),
  .pwrite(pwrite16_spi),
  .pready(pready16_int),
  .psuberr(psuberr16_int),

  .psel32(psel32_spi),
  .penable32(penable32_spi),
  .paddr32(paddr32_spi),
  .prdata32(prdata32_spi),
  .pwdata32(pwdata32_spi),
  .pwrite32(pwrite32_spi),
  .pready32(pready32_spi),
  .psuberr32(psuberr32_spi),

  .ctrl(ctrl),
  .cs_posedge(cs_posedge)
);

endmodule



module msftDvDebug_apb_16_2_32( 
  input         clk,
  input         rstn,
  input         psel,
  input         penable,
  input  [14:0] paddr,
  output [15:0] prdata,
  input  [15:0] pwdata,
  input         pwrite,
  output        pready,
  output        psuberr,


  output        psel32,
  output        penable32,
  output [31:0] paddr32,
  input  [47:0] prdata32,
  output [47:0] pwdata32,
  output        pwrite32,
  input         pready32,
  input         psuberr32,

  output [31:0] ctrl,
  input         cs_posedge 
);

parameter APB_IDLE = 0;
parameter APB_ENABLE = 1;
parameter APB_WAIT = 2;
parameter APB_RELEASE_PREADY = 3;

wire cs = psel & penable;

reg [1:0]       apb_state;
reg             pready_ff;
reg             psuberr_ff;
reg [15:0]      prdata_ff;

reg             psel32_ff;
reg             penable32_ff;
reg             pwrite32_ff;
reg [31:0]      paddr32_ff;
reg [47:0]      pwdata32_ff;
reg [47:0]      prdata32_ff;
reg [31:0]      ctrl_ff;
reg             incr_addr;
reg             wideRead;
reg             incr_occured;

assign ctrl = ctrl_ff;
assign prdata     = prdata_ff;
assign pready     = pready_ff;
assign psuberr    = psuberr_ff & cs;

assign psel32     = psel32_ff;
assign penable32  = penable32_ff;
assign paddr32    = paddr32_ff;
assign pwdata32   = pwdata32_ff;
assign pwrite32   = pwrite & psel32;

assign wideRdAddr = paddr[4:1] == 4'hd; 
assign normRdAddr = paddr[4:1] == 4'he & ~wideRead;

//==========================================
// Write Registers
//==========================================
always @(posedge clk)
begin
  if(~rstn) begin
    paddr32_ff <= 32'h0000_0000;
    pwdata32_ff <= 48'h0000_0000_0000;
    pwrite32_ff <= 1'b0;
    ctrl_ff <= 32'h0000_0001;
    wideRead <= 1'b0;
    incr_occured <= 1'b0;
  end else begin
    pwrite32_ff <= pwrite32;

    if(cs_posedge && ctrl_ff[0] && incr_occured) begin
      paddr32_ff <= paddr32_ff - 3'h4;
      incr_occured <= 1'b0;
    end
    
    if(cs & pwrite && paddr[4:1] == 4'h6) begin
      paddr32_ff[31:16]  <= pwdata;
    end else if(cs & pwrite && paddr[4:1] == 4'h7) begin
      paddr32_ff[15:0]   <= pwdata;
    end else if(incr_addr) begin
      paddr32_ff <= paddr32_ff + 3'h4;
      incr_occured <= ~pwrite32_ff;
    end

    if(cs & ~pwrite & pready) begin
      if(wideRdAddr) begin
        wideRead <= 1'b1;
      end else begin
        wideRead <= 1'b0;;
      end
    end else if(cs & pready) begin
      wideRead <= 1'b0;
    end
    if(cs & pwrite) begin
      case (paddr[4:1])
        4'h1: ctrl_ff[31:16]     <= pwdata;
        4'hd: pwdata32_ff[47:32] <= pwdata;
        4'he: pwdata32_ff[31:16] <= pwdata;
        4'hf: pwdata32_ff[15:0]  <= pwdata;
      endcase
    end
    if(apb_state ==APB_WAIT) begin
      ctrl_ff[2] <= psuberr32;
    end
    else if((cs & pwrite) && (paddr[4:1] == 4'h0)) begin
      ctrl_ff[14:0]  <= {1'b0,pwdata[14:0]};
    end
  end
end

//==========================================
// Read Registers
//==========================================
always @*
begin
  prdata_ff = 16'h0000;
  if(cs) begin
    case (paddr[4:1])
      4'h0: prdata_ff = ctrl_ff[15:0];
      4'h1: prdata_ff = ctrl_ff[31:16];
      4'h4: prdata_ff = 16'hC001;
      4'h5: prdata_ff = 16'hC0DE;
      4'h6: prdata_ff = paddr32_ff[31:16];
      4'h7: prdata_ff = paddr32_ff[15:0];
      4'hd: prdata_ff = prdata32_ff[47:32];
      4'he: prdata_ff = prdata32_ff[31:16];
      4'hf: prdata_ff = prdata32_ff[15:0];
   default: prdata_ff = 16'h0000;
    endcase
  end
end

//==========================================
// APB State Machine
//==========================================
always @(posedge clk)
begin
  if(~rstn) begin
    apb_state <= APB_IDLE;
    psel32_ff <= 1'b0; 
    penable32_ff <= 1'b0; 
    pready_ff <= 1'b0;
    psuberr_ff <= 1'b0;
    prdata32_ff <= 48'h0000_0000_0000;
    incr_addr <= 1'b0;
  end else begin
    case(apb_state)
      APB_IDLE: begin
        if(cs & ((pwrite & paddr[4:1] == 4'hf) | (~pwrite & (wideRdAddr | normRdAddr))) ) begin
          psel32_ff <= 1'b1;
          apb_state <= APB_ENABLE;
        end else if(cs) begin
          pready_ff <= 1'b1;
          apb_state <= APB_RELEASE_PREADY; 
        end
      end
      APB_ENABLE: begin
        apb_state <= APB_WAIT;
        penable32_ff <= 1'b1;
      end
      APB_WAIT: begin
        if(pready32) begin
          pready_ff <= 1'b1;
          penable32_ff <= 1'b0;
          psel32_ff <= 1'b0;
          psuberr_ff <= psuberr32;
          incr_addr <= ctrl_ff[0];
          if(~pwrite32) begin
            prdata32_ff <= prdata32;
          end
          apb_state <= APB_RELEASE_PREADY;
        end
      end
      APB_RELEASE_PREADY: begin
        incr_addr <= 1'b0;
        pready_ff <= 1'b0;
        apb_state <= APB_IDLE;
      end
    endcase
  end
end

endmodule
