
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



module msftDvIp_creg_timer (
  input               clk_i,
  input               rstn_i,

  input               psel_i,
  input               penable_i,
  input [31:0]        paddr_i,
  input [31:0]        pwdata_i,
  input               pwrite_i,
  output reg [31:0]   prdata_o,
  output              pready_o,
  output              psuberr_o,

  output              irq_o,
  output              err_o,
  output              sticky_err_o
);


wire [31:0]     pwdata;

assign pready_o = 1'b1;
assign psuberr_o = 1'b0;

assign clk = clk_i;
assign rstn = rstn_i;
assign psel = psel_i;
assign penable = penable_i;
assign pwrite = pwrite_i;
assign pwdata = pwdata_i;

//=========================================
// Timer Registers
//=========================================
reg [5:0]   tmr_ctrl0;
reg [1:0]   tmr_ctrl1;
reg [3:0]   tmr_inc;
reg [31:0]  tmr_ocmp0, shadow_tmr_ocmp0;
reg [31:0]  tmr_cnt;
reg [31:0]  tmr_sat;
reg         tmr_stat;
reg [31:0]  tmr_div;
reg [31:0]  tmr_div_cnt;

wire tmr_div_match;
wire start          = tmr_ctrl0[0];
wire clear          = tmr_ctrl0[1];
wire dec            = tmr_ctrl0[2];
wire int_en         = tmr_ctrl0[3];
wire err_en         = tmr_ctrl0[4];
wire sticky_err_en  = tmr_ctrl0[5];

wire tslice         = tmr_ctrl1[0];
wire saturation     = tmr_ctrl1[1];

wire auto_inc       = tmr_inc[0];

assign tmr_div_match = tmr_div_cnt == tmr_div;
assign tmr_eq_ocmp0  = tmr_cnt == tmr_ocmp0;
assign tmr_eq_sat    = tmr_cnt == tmr_sat;
assign tmr_eq_0      = tmr_cnt == 32'h0000_0000;

assign tslice_reload  = start & tslice & dec & tmr_div_match & tmr_eq_0;
assign tmr_sat_stop   = start & tmr_eq_sat   & tmr_div_match & dec;
assign auto_incr      = start & tmr_eq_ocmp0 & tmr_div_match & auto_inc;

assign irq          = tmr_sat_stop | auto_incr | tslice_reload;
assign irq_o        = int_en & irq;
assign err_o        = irq & tmr_stat & err_en; 
assign sticky_err_o = irq & tmr_stat & sticky_err_en; 

assign wr_ctrl0     = psel & penable & pwrite & paddr_i[5:2] == 4'h0;
assign wr_ocmp0     = psel & penable & pwrite & paddr_i[5:2] == 4'h3;
assign wr_tmr_stat  = psel & penable & pwrite & paddr_i[5:2] == 4'h6 & pwdata[0];

//=========================================
// Write Registers
//=========================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    tmr_ctrl0 <= 6'h0;
    tmr_ctrl1 <= 2'h0;
    tmr_inc <= 4'h0;
    tmr_ocmp0 <= 32'h0000_0000;
    shadow_tmr_ocmp0 <= 32'h0000_0000;
    tmr_sat <= 32'hffff_ffff;
    tmr_stat <= 1'b0;
    tmr_div <= 32'hffff_ffff;
  end else begin
    if(psel & penable & pwrite) begin
      casez(paddr_i[5:2])
        4'h0: tmr_ctrl0[5:2] <= pwdata[5:2];
        4'h1: tmr_ctrl1      <= pwdata[1:0];
        4'h2: tmr_inc        <= pwdata[3:0];
        // 3  TMR_OCMP0
        // 4  TMR_CNT
        4'h5: tmr_sat      <= pwdata;
        // 6  TMR_INTSTS
        4'h7: tmr_div      <= (start) ? tmr_div : pwdata;
      endcase
    end

    // Timer Start Bit
    if(wr_ctrl0) begin
      tmr_ctrl0[0] <= pwdata[0];
    end else if(tmr_sat_stop) begin
      tmr_ctrl0[0] <= 1'b0;
    end

    // Timer clear bit
    if(wr_ctrl0) begin
      tmr_ctrl0[1] <= pwdata[1];
    end else begin
      tmr_ctrl0[1] <= 1'b0;
    end

    // Updated Shadow register
    if(wr_ocmp0) begin
      tmr_ocmp0 <= pwdata;
      shadow_tmr_ocmp0 <= pwdata;
    end else if(auto_incr) begin
      tmr_ocmp0 <= tmr_ocmp0 + shadow_tmr_ocmp0;
    end 

    // Int Status
    if(wr_tmr_stat) begin
      tmr_stat <= 1'b0;
    end else if(irq) begin
      tmr_stat <= 1'b1;
    end 
  end
end

//=========================================
// Timer
//=========================================
reg start_edge;
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    tmr_cnt <= 32'h0000_0000;
    start_edge <= 1'b0;
  end else begin
    if(clear) begin
      tmr_cnt <= 32'h0000_0000;
    end else if(start) begin
      if(tslice_reload) begin
        tmr_cnt <= tmr_ocmp0;
      end else if(tmr_div_match) begin
        tmr_cnt <= tmr_cnt + ((dec) ? 32'hffff_ffff :  32'h0000_0001);
      end
    end else begin
      start_edge <= 1'b0;
    end
  end
end

//=========================================
// Divider
//=========================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    tmr_div_cnt <= 32'h0000_0000;
  end else begin
    if(start) begin
      if(tmr_div_match | clear) begin
        tmr_div_cnt <= 32'h0000_0000;
      end else begin
        tmr_div_cnt <= tmr_div_cnt + 1'b1;
      end
    end
  end
end

//=========================================
// Read Registers
//=========================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    prdata_o <= 32'h0000_0000;
  end else begin
    prdata_o <= 32'h0000_0000;
    if(psel & ~penable & ~pwrite) begin
      casez(paddr_i[5:2])
        4'h0: prdata_o <= {27'h000_0000,  tmr_ctrl0};
        // 6'h1: prdata_o <= {30'h0000_0000, tmr_ctrl1}; // Write Only
        4'h2: prdata_o <= {28'h000_0000,  tmr_inc};
        4'h3: prdata_o <= tmr_ocmp0;
        4'h4: prdata_o <= tmr_cnt;
        4'h5: prdata_o <= tmr_sat;
        4'h6: prdata_o <= {31'h0000_0000,  tmr_stat};
        4'h7: prdata_o <= tmr_div;
      endcase
    end
  end
end

endmodule
