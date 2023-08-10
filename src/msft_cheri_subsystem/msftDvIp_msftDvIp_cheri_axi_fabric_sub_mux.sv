// Copyright (C) Microsoft Corporation. All rights reserved.

// This File is Auto Generated do not edit
module msftDvIp_msftDvIp_cheri_axi_fabric_sub_mux #(
    parameter AXI_ADDR_WIDTH=32,
    parameter RPHASE_LEN=10,
    parameter BPHASE_LEN=10,
    parameter MGR_NUM=0
  )   (

    input clk,
    input rstn,

      // Sub to Mgr Ready signals
    input  [1:0]                awphase_ready_from_sub0_i,
    input  [1:0]                wphase_ready_from_sub0_i,
    input  [1:0]                arphase_ready_from_sub0_i,

    input  [1:0]                awphase_ready_from_sub1_i,
    input  [1:0]                wphase_ready_from_sub1_i,
    input  [1:0]                arphase_ready_from_sub1_i,

    input  [1:0]                awphase_ready_from_sub2_i,
    input  [1:0]                wphase_ready_from_sub2_i,
    input  [1:0]                arphase_ready_from_sub2_i,

    input  [1:0]                awphase_ready_from_sub3_i,
    input  [1:0]                wphase_ready_from_sub3_i,
    input  [1:0]                arphase_ready_from_sub3_i,

    output                      awphase_ready_mgr_o,
    output                      wphase_ready_mgr_o,
    output                      arphase_ready_mgr_o,

    // Mgr to Sub ready
    input                       rphase_ready_mgr_i,
    input                       bphase_ready_mgr_i,

    output  [3:0]    rphase_ready_from_mgr_o,
    output  [3:0]    bphase_ready_from_mgr_o,

      // Phase signals from sub for read and write response
    input  [1:0]            bphase_valid_sub0_i,
    input  [1:0]            rphase_valid_sub0_i,
    input  [1:0]            bphase_valid_sub1_i,
    input  [1:0]            rphase_valid_sub1_i,
    input  [1:0]            bphase_valid_sub2_i,
    input  [1:0]            rphase_valid_sub2_i,
    input  [1:0]            bphase_valid_sub3_i,
    input  [1:0]            rphase_valid_sub3_i,

    output                      bphase_valid_mgr_o,
    output                      rphase_valid_mgr_o,

    input  [BPHASE_LEN-1:0]     bphase_sub0_i,
    input  [RPHASE_LEN-1:0]     rphase_sub0_i,
    input  [BPHASE_LEN-1:0]     bphase_sub1_i,
    input  [RPHASE_LEN-1:0]     rphase_sub1_i,
    input  [BPHASE_LEN-1:0]     bphase_sub2_i,
    input  [RPHASE_LEN-1:0]     rphase_sub2_i,
    input  [BPHASE_LEN-1:0]     bphase_sub3_i,
    input  [RPHASE_LEN-1:0]     rphase_sub3_i,

    output reg [BPHASE_LEN-1:0]       bphase_mgr_o,
    output reg [RPHASE_LEN-1:0]       rphase_mgr_o
);

// Generate Mgr ready signals
assign awphase_ready_mgr_o =  awphase_ready_from_sub0_i[MGR_NUM] | awphase_ready_from_sub1_i[MGR_NUM] | awphase_ready_from_sub2_i[MGR_NUM] | awphase_ready_from_sub3_i[MGR_NUM] ;
assign wphase_ready_mgr_o =  wphase_ready_from_sub0_i[MGR_NUM] | wphase_ready_from_sub1_i[MGR_NUM] | wphase_ready_from_sub2_i[MGR_NUM] | wphase_ready_from_sub3_i[MGR_NUM] ;
assign arphase_ready_mgr_o =  arphase_ready_from_sub0_i[MGR_NUM] | arphase_ready_from_sub1_i[MGR_NUM] | arphase_ready_from_sub2_i[MGR_NUM] | arphase_ready_from_sub3_i[MGR_NUM] ;

wire [3:0] bphase_sel;
assign bphase_sel[0] = bphase_valid_sub0_i[MGR_NUM];
assign bphase_sel[1] = bphase_valid_sub1_i[MGR_NUM];
assign bphase_sel[2] = bphase_valid_sub2_i[MGR_NUM];
assign bphase_sel[3] = bphase_valid_sub3_i[MGR_NUM];
assign bphase_ready_from_mgr_o = {4{bphase_ready_mgr_i}} & bphase_sel;
assign bphase_valid_mgr_o = |bphase_sel;

always @*
begin
  casez (bphase_sel)
    4'b???1: begin bphase_mgr_o = bphase_sub0_i; end
    4'b??10: begin bphase_mgr_o = bphase_sub1_i; end
    4'b?100: begin bphase_mgr_o = bphase_sub2_i; end
    4'b1000: begin bphase_mgr_o = bphase_sub3_i; end
    default: bphase_mgr_o = bphase_sub0_i;
  endcase
end

wire [3:0] rphase_sel;
assign rphase_sel[0] = rphase_valid_sub0_i[MGR_NUM];
assign rphase_sel[1] = rphase_valid_sub1_i[MGR_NUM];
assign rphase_sel[2] = rphase_valid_sub2_i[MGR_NUM];
assign rphase_sel[3] = rphase_valid_sub3_i[MGR_NUM];
assign rphase_ready_from_mgr_o = {4{rphase_ready_mgr_i}} & rphase_sel;
assign rphase_valid_mgr_o = |rphase_sel;

always @*
begin
  casez (rphase_sel)
    4'b???1: begin rphase_mgr_o = rphase_sub0_i; end
    4'b??10: begin rphase_mgr_o = rphase_sub1_i; end
    4'b?100: begin rphase_mgr_o = rphase_sub2_i; end
    4'b1000: begin rphase_mgr_o = rphase_sub3_i; end
    default: rphase_mgr_o = rphase_sub0_i;
  endcase
end

endmodule
