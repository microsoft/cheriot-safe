
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



module msftDvIp_gpio #( 
    parameter DEF_ALT_FUNC=32'h0000_0000,
    parameter DEF_ALT1_FUNC=32'h0000_0000
  ) (

  input           pclk_i,
  input           prstn_i,

  input           psel_i,
  input           penable_i,
  input [31:0]    paddr_i,
  input [31:0]    pwdata_i,
  input           pwrite_i,
  
  output [31:0]   prdata_o,
  output          pready_o,
  output          psuberr_o,

  input  [31:0]   gpio_in_i,
  output [31:0]   gpio_out_o,
  output [31:0]   gpio_oen_o,

  output [31:0]   gpio_alt_sel_o,
  output [31:0]   gpio_alt1_sel_o,

  input  [31:0]   gpio_alt_in_i,
  input  [31:0]   gpio_alt_oen_i,
  output [31:0]   gpio_alt_out_o,

  input  [31:0]   gpio_alt1_in_i,
  input  [31:0]   gpio_alt1_oen_i,
  output [31:0]   gpio_alt1_out_o,

  input  [31:0]   gpio_alt2_in_i,
  input  [31:0]   gpio_alt2_oen_i,
  output [31:0]   gpio_alt2_out_o
);

//=================================================
// Registers/Wires
//=================================================
reg [31:0]        gpio_out;
reg [31:0]        gpio_oe; //output enable
reg [31:0]        gpio_alt_sel; // alt mode
reg [31:0]        gpio_od; // open-drain
reg [31:0]        gpio_os; //open-source
reg [31:0]        gpio_pu; //pull up
reg [31:0]        gpio_alt1_sel; // alt mode


reg [31:0]        prdata;


reg [31:0]        gpio_dly0;
reg [31:0]        gpio_dly1;
reg [31:0]        gpio_re; //rising-edge
reg [31:0]        gpio_fe; //falling-edge

reg [2:0]         gpio_spi_clk_delay;
reg [31:0]        gpio_spi_clk_event; //gpio event during spi clk

wire [31:0]       rising_oneshot;
wire [31:0]       falling_oneshot;

wire [31:0]       gpio_in;
wire [31:0]       gpio_oen;

wire [31:0]       clr_re;
wire [31:0]       clr_fe;

wire              spi_clk;

//=================================================
// Assignements
//=================================================
assign prdata_o = prdata;
assign pready_o = 1'b1;
assign psuberr_o = 1'b0;

assign rising_oneshot  = ( gpio_dly0 & ~gpio_dly1);
assign falling_oneshot = (~gpio_dly0 &  gpio_dly1);

assign gpio_alt_sel_o  	= gpio_alt_sel;
assign gpio_alt1_sel_o  = gpio_alt1_sel;
assign gpio_in         	= gpio_in_i;
assign gpio_oen        	= gpio_oe & ((gpio_out ^ gpio_os) | ~gpio_od);

assign wr_op = psel_i &  penable_i &  pwrite_i & pready_o;
assign rd_op = psel_i & ~penable_i & ~pwrite_i;
assign rd_clr_spi_detect = psel_i & penable_i & ~pwrite_i & (paddr_i[7:2] == 6'h9);

assign clr_re = {32{wr_op & paddr_i[7:2] == 6'h7}} & pwdata_i; // Write 1 to clear rising-edge register
assign clr_fe = {32{wr_op & paddr_i[7:2] == 6'h8}} & pwdata_i; // Write 1 to clear falling-edge register

assign spi_clk = gpio_dly0[16];

genvar i;
generate
  for(i=0;i<32;i+=1) begin
    assign gpio_out_o[i]      = ( gpio_alt1_sel[i] & gpio_alt_sel[i]) ? gpio_alt2_in_i[i]  : (gpio_alt1_sel[i]) ? gpio_alt1_in_i[i]  : (gpio_alt_sel[i]) ? gpio_alt_in_i[i]  : gpio_out[i];
    assign gpio_oen_o[i]      = ( gpio_alt1_sel[i] & gpio_alt_sel[i]) ? gpio_alt2_oen_i[i] : (gpio_alt1_sel[i]) ? gpio_alt1_oen_i[i] : (gpio_alt_sel[i]) ? gpio_alt_oen_i[i] : gpio_oen[i];

    assign gpio_alt_out_o[i]  = (~gpio_alt1_sel[i] &  gpio_alt_sel[i]) ? gpio_in[i]         : 1'b0;
    assign gpio_alt1_out_o[i] = ( gpio_alt1_sel[i] & ~gpio_alt_sel[i]) ? gpio_in[i]         : 1'b0;
    assign gpio_alt2_out_o[i] = ( gpio_alt1_sel[i] &  gpio_alt_sel[i]) ? gpio_in[i]         : 1'b0;
  end
endgenerate

//=================================================
// Edge Detect 
//=================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    gpio_dly0 <= 32'h00;
    gpio_dly1 <= 32'h00;
    gpio_re   <= 32'h00;
    gpio_fe   <= 32'h00;
  end else begin
    gpio_dly0 <= gpio_in;
    gpio_dly1 <= gpio_dly0;
    for(int i=0;i<32;i+=1) begin
      gpio_re[i] <= (clr_re[i]) ? 1'b0 : (rising_oneshot[i])  ? 1'b1 : gpio_re[i];
      gpio_fe[i] <= (clr_fe[i]) ? 1'b0 : (falling_oneshot[i]) ? 1'b1 : gpio_fe[i];
    end
  end
end

//=================================================
// Detect GPIO Event During SPI Clock
//=================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    gpio_spi_clk_event <= 32'h00;
    gpio_spi_clk_delay <= 3'h0;
  end else begin
    gpio_spi_clk_delay <= {gpio_spi_clk_delay[1], gpio_spi_clk_delay[0], spi_clk};
    if (rd_clr_spi_detect) begin
      gpio_spi_clk_event <= 32'h00;
    end else if (gpio_spi_clk_delay == 3'h7) begin
      for(int i=0;i<16;i+=1) begin
        gpio_spi_clk_event[i] <= (gpio_spi_clk_event[i]) ? 1'b1 : gpio_re[i];
      end
    end
  end
end

//=================================================
// Write registers
//=================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    gpio_out      <= 32'h0000_0000;
    gpio_oe       <= 32'h0000_0000;
    gpio_alt_sel  <= DEF_ALT_FUNC;
    gpio_od       <= 32'h0000_0000;
    gpio_os       <= 32'h0000_0000;
    gpio_pu       <= 32'h0000_0000;
    gpio_alt1_sel <= DEF_ALT1_FUNC;
  end else begin

    if(wr_op) begin
      //gpio_out_dly <= gpio_out;
      casez(paddr_i[7:2]) 
        6'h1: gpio_out      <= pwdata_i;
        6'h2: gpio_oe       <= pwdata_i;
        6'h3: gpio_alt_sel  <= pwdata_i;
        6'h4: gpio_od       <= pwdata_i;
        6'h5: gpio_os       <= pwdata_i;
        6'h6: gpio_pu       <= pwdata_i;

        6'ha: gpio_alt1_sel <= pwdata_i;
      endcase
    end
  end
end

//=================================================
// Read registers
//=================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    prdata <= 32'h0000_0000;
  end else begin
    if(rd_op) begin 
      casez(paddr_i[7:2]) 
        6'h0: prdata <= gpio_in;
        6'h1: prdata <= gpio_out;
        6'h2: prdata <= gpio_oe;
        6'h3: prdata <= gpio_alt_sel;
        6'h4: prdata <= gpio_od;
        6'h5: prdata <= gpio_os;
        6'h6: prdata <= gpio_pu;
        6'h7: prdata <= gpio_re;
        6'h8: prdata <= gpio_fe;
        6'h9: prdata <= gpio_spi_clk_event;
        6'ha: prdata <= gpio_alt1_sel;
        default: prdata <= 32'h0000_0000;
      endcase
    end else begin
      prdata <= 32'h0000_0000;
    end
  end
end

endmodule
