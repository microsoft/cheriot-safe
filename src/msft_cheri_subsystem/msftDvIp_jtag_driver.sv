
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



module msftDvIp_jtag_driver (
  input               pclk_i,
  input               prstn_i,

  input               psel_i,
  input               penable_i,
  input  [ 7:0]       paddr_i,
  input  [31:0]       pwdata_i,
  input               pwrite_i,

  output [31:0]       prdata_o,
  output              pready_o,
  output              psuberr_o,
  
  output              TCK_o,
  output              TMS_o,
  output              TDO_o,
  output              TDOoen_o,
  input               TDI_i,
  output              TRSTn_o,

  output              jtag_ext_cg_o,
  output              jtag_mux_sel_o

);

parameter       BURST_IDLE            = 3'h0;
parameter       TMS_BURST_ACT_HIGH    = 3'h1;
parameter       TMS_BURST_ACT_LOW     = 3'h2;
parameter       TDO_BURST_ACT_HIGH    = 3'h3;
parameter       TDO_BURST_ACT_LOW     = 3'h4;

reg [2:0]             burst_state;

reg [4:0]             tdo_burst_count;
reg [4:0]             tms_burst_count;
reg                   tms_on_last_bit;
reg [7:0]             tclk_half_period;
reg [31:0]            tdo_data;
reg [31:0]            tms_data;
reg [7:0]             tclk_cnt;
reg [5:0]             burst_cnt;
reg                   ext_cg_okay;

wire                  pclk;
wire                  prstn;

wire                  psel;
wire                  penable;
wire     [ 7:0]       paddr;
wire     [31:0]       pwdata;
reg      [31:0]       prdata;
wire                  pwrite;
wire                  pready;
wire                  psuberr;

reg                   TCK;
reg                   TDO;
wire                  TDOoen;
wire                  TDI;

reg                   TMS;
reg                   TRSTn;

reg                   jtag_ext_cg;
reg                   jtag_mux_sel;

assign active = ~(burst_state == BURST_IDLE);
assign pready = 1'b1;
assign psuberr = 1'b0;
assign TDOoen = 1'b1;

assign shift_tms = burst_state == TMS_BURST_ACT_LOW && tclk_cnt == 8'h00;
assign shift_tdo = burst_state == TDO_BURST_ACT_LOW && tclk_cnt == 8'h00;

assign paccess = psel & penable;
assign wr_reg = paccess & pwrite;
assign wrTdoBurst = wr_reg && paddr[7:0] == 8'h10;
assign wrTmsBurst = wr_reg && paddr[7:0] == 8'h14;

assign tms_in = 1'b0;

// ================================
// Read Registers
// ================================
always @(posedge pclk or negedge prstn)
begin
  if(~prstn) begin
    prdata <= 32'h0000_0000;
  end else begin
    prdata <= 32'h0000_0000;
    if(psel & ~penable & ~pwrite) begin
      case(paddr[7:2])
        6'h0: begin prdata[16] <= TRSTn; prdata[1] <= jtag_mux_sel; prdata[0] <= jtag_ext_cg; end
        6'h1: begin prdata[5] <= tms_on_last_bit; prdata[4:0] <= tdo_burst_count[4:0]; end
        6'h2: begin prdata[4:0] <= tms_burst_count[4:0]; end
        6'h3: begin prdata[17] <= active; prdata[16] <= ext_cg_okay; prdata[7:0] <= tclk_half_period; end
        6'h4: prdata <= tdo_data;
        6'h5: prdata <= tms_data;
      endcase
    end
  end
end

// ================================
// Write Registers
// ================================
always @(posedge pclk or negedge prstn)
begin
  if(~prstn) begin
    jtag_ext_cg <= 1'b0;
    jtag_mux_sel <= 1'b0;
    TRSTn <= 1'b1;
    tdo_burst_count <= 5'h00;
    tms_on_last_bit <= 1'b0;
    tms_burst_count <= 5'h00;
    tclk_half_period <= 8'h9;
    tdo_data <= 32'h0000_0000;
    tms_data <= 32'h0000_0000;
    ext_cg_okay <= 1'b0;
  end else begin
    if(wr_reg) begin
      case(paddr)
        8'h0: begin
          jtag_ext_cg <= pwdata[0];
          jtag_mux_sel <= pwdata[1];
          TRSTn <= pwdata[16];
        end
        8'h4: begin
          tdo_burst_count <= pwdata[4:0];
          tms_on_last_bit <= pwdata[5];
        end
        8'h8: tms_burst_count <= pwdata[4:0];
        8'hC: tclk_half_period <= pwdata[7:0];
        8'h10: tdo_data <= pwdata;
        8'h14: tms_data <= pwdata;
      endcase
    end

    ext_cg_okay <= jtag_ext_cg;

    if(shift_tms) begin
      tms_data <= {tms_in, tms_data[31:1]};
    end
    if(shift_tdo) begin
      tdo_data <= {TDI, tdo_data[31:1]};
    end
  end
end

// ================================
// Burst State Machine
// ================================
always @(posedge pclk or negedge prstn)
begin
  if(~prstn) begin
    burst_state <= BURST_IDLE;
    burst_cnt <= 6'h0;
    TDO <= 1'b0;
    TMS <= 1'b0;
    TCK <= 1'b0;
    tclk_cnt <= 8'h0;
  end else begin
    casez(burst_state)
      BURST_IDLE: begin
        if(wrTmsBurst) begin
          tclk_cnt <= tclk_half_period;
          TCK <= 1'b0;
          burst_cnt <= tms_burst_count+1'b1;
          burst_state <= TMS_BURST_ACT_HIGH;
        end else if(wrTdoBurst) begin
          tclk_cnt <= tclk_half_period;
          burst_cnt <= tdo_burst_count+1'b1;
          burst_state <= TDO_BURST_ACT_HIGH;
        end
      end
      TMS_BURST_ACT_HIGH: begin
        tclk_cnt <= tclk_cnt - 1'b1;
        if(tclk_cnt == 8'h0) begin
          tclk_cnt <= tclk_half_period;
          TCK <= 1'b0;
          if(burst_cnt == 5'h0) begin
            burst_state <= BURST_IDLE; 
          end else begin
            TMS <= tms_data[0];
            burst_state <= TMS_BURST_ACT_LOW;
          end
        end
      end
      TMS_BURST_ACT_LOW: begin
        tclk_cnt <= tclk_cnt - 1'b1;
        if(tclk_cnt == 8'h00) begin
          TCK <= 1'b1; 
          burst_cnt <= burst_cnt - 1'b1;
          tclk_cnt <= tclk_half_period;
          burst_state <= TMS_BURST_ACT_HIGH;
        end
      end
      TDO_BURST_ACT_HIGH: begin
        tclk_cnt <= tclk_cnt - 1'b1;
        if(tclk_cnt == 8'h0) begin
          tclk_cnt <= tclk_half_period;
          TCK <= 1'b0;
          if (tms_on_last_bit && burst_cnt == 5'h1) begin
            TMS <= 1'b1;
          end
          if(burst_cnt == 5'h0) begin
            burst_state <= BURST_IDLE; 
          end else begin
            TDO <= tdo_data[0];
            burst_state <= TDO_BURST_ACT_LOW;
          end
        end
      end
      TDO_BURST_ACT_LOW: begin
        tclk_cnt <= tclk_cnt - 1'b1;
        if(tclk_cnt == 8'h00) begin
          TCK <= 1'b1; 
          burst_cnt <= burst_cnt - 1'b1;
          tclk_cnt <= tclk_half_period;
          burst_state <= TDO_BURST_ACT_HIGH;
        end
      end
    default: burst_state <= BURST_IDLE;
    endcase
  end
end


assign pclk = pclk_i;
assign prstn = prstn_i;

assign psel = psel_i;
assign penable = penable_i;
assign paddr = paddr_i;
assign prdata_o = prdata;
assign pwdata = pwdata_i;
assign pwrite = pwrite_i;
assign pready_o = pready;
assign psuberr_o = psuberr;
  
assign TCK_o = TCK;
assign TDO_o = TDO;
assign TDOOen_o = TDOoen;
assign TDI = TDI_i;
assign TMS_o = TMS;
assign TRSTn_o = TRSTn;

assign jtag_ext_cg_o = jtag_ext_cg;
assign jtag_mux_sel_o = jtag_mux_sel;

endmodule
