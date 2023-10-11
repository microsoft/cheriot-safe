// Copyright (C) Microsoft Corporation. All rights reserved.



module msftDvDebug_backdoor_v0 #(
    parameter CPU_TYPE=8'h0,
    parameter bit IROM_ENABLE=1,
    parameter IROM_AWIDTH=32,
    parameter IROM_DWIDTH=48,
    parameter IROM_SWIDTH=48,
    parameter bit IRAM_ENABLE=1,
    parameter IRAM_AWIDTH=32,
    parameter IRAM_DWIDTH=48,
    parameter IRAM_SWIDTH=48,
    parameter bit DRAM_ENABLE=1,
    parameter DRAM_AWIDTH=32,
    parameter DRAM_DWIDTH=48,
    parameter DRAM_SWIDTH=48,
    parameter bit EFUSE_ENABLE=1,
    parameter EFUSE_AWIDTH=16,
    parameter EFUSE_DWIDTH=32,
    parameter EFUSE_SWIDTH=32,
    parameter bit KSU_ENABLE=1,
    parameter KSU_AWIDTH=16,
    parameter KSU_DWIDTH=32,
    parameter KSU_SWIDTH=32,
    parameter TRACE_WORDS=1024
  ) (
  input                       clk_i,
  input                       rstn_i,
  input                       cpu_rst_i,

  input [31:0]                pc_i,
  input                       inst_val_i,
  input                       branch_i,

  output                      rstn_bkdr_o,
  output                      enable_cpu_o,
  output                      enable_tap_o,
  output                      enable_tap_tdr_o,
  output                      sss_o,

  input [31:0]                status,
  
  input                       psel_bkd_i,
  input                       penable_bkd_i,
  input [31:0]                paddr_bkd_i,
  input [47:0]                pwdata_bkd_i,
  input                       pwrite_bkd_i,
  output reg [47:0]           prdata_bkd_o,
  output reg                  pready_bkd_o,
  output reg                  psuberr_bkd_o,

  output                      accen_irom_o,
  output                      enable_irom_o,
  output [IROM_AWIDTH-1:2]    addr_irom_o,
  output [IROM_DWIDTH-1:0]    wdata_irom_o,
  output                      write_irom_o,
  output [IROM_SWIDTH-1:0]    wstrb_irom_o,
  input  [IROM_DWIDTH-1:0]    rdata_irom_i,
  input                       ready_irom_i,

  output                      accen_iram_o,
  output                      enable_iram_o,
  output [IRAM_AWIDTH-1:2]    addr_iram_o,
  output [IRAM_DWIDTH-1:0]    wdata_iram_o,
  output                      write_iram_o,
  output [IRAM_SWIDTH-1:0]    wstrb_iram_o,
  input  [IRAM_DWIDTH-1:0]    rdata_iram_i,
  input                       ready_iram_i,

  output                      accen_dram_o,
  output                      enable_dram_o,
  output [DRAM_AWIDTH-1:2]    addr_dram_o,
  output [DRAM_DWIDTH-1:0]    wdata_dram_o,
  output                      write_dram_o,
  output [DRAM_SWIDTH-1:0]    wstrb_dram_o,
  input  [DRAM_DWIDTH-1:0]    rdata_dram_i,
  input                       ready_dram_i,

  output                      accen_efuse_o,
  output                      enable_efuse_o,
  output [EFUSE_AWIDTH-1:2]   addr_efuse_o,
  output [EFUSE_DWIDTH-1:0]   wdata_efuse_o,
  output                      write_efuse_o,
  output [EFUSE_SWIDTH-1:0]   wstrb_efuse_o,
  input  [EFUSE_DWIDTH-1:0]   rdata_efuse_i,
  input                       ready_efuse_i,
  
  output                      accen_ksu_o,
  output                      enable_ksu_o,
  output [KSU_AWIDTH-1:0]     addr_ksu_o,
  output [KSU_DWIDTH-1:0]     wdata_ksu_o,
  output                      write_ksu_o,
  output [KSU_SWIDTH-1:0]     wstrb_ksu_o,
  input  [KSU_DWIDTH-1:0]     rdata_ksu_i,
  input                       ready_ksu_i
  
);

//==================================================
// Parameters
//==================================================
localparam bit TRACE_ENABLE = TRACE_WORDS!=0;

function automatic [15:0] calcMemSize(input integer awidth, input integer dwidth, input enable);
  reg [31:0] size = (1'b1<<awidth)*(dwidth/8);
  //automatic reg [31:0] size = $pow(awidth,2)*(dwidth/8);
  if(enable) begin
    calcMemSize[15:14] = (|size[31:20]) ? 2'h2 : (size[31:10]) ? 2'h1 : 2'h0;
    calcMemSize [13:0] = (calcMemSize == 2'h2) ? {2'h0, size[31:20]} : (calcMemSize[15:14] == 2'h1) ? size[24:10] : size[13:0];
  end else begin
    calcMemSize[15:0] = 16'h0000;
  end
endfunction

//==================================================
// Registers/Wires
//==================================================
wire [15:0]       irom_size;
wire [15:0]       iram_size;
wire [15:0]       dram_size;
wire [15:0]       fuse_size;
wire [15:0]       ksu_size;

wire [31:0]       memsize0;
wire [31:0]       memsize1;
wire [31:0]       memsize2;

wire              irom_cs;
wire              iram_cs;
wire              dram_cs;
wire              efuse_cs;
wire              ksu_cs;
wire              info_cs;
wire              trace_cs;

wire [9:0]        msubsel;
reg [47:0]        rdata_info;

wire [31:0]       enable;
wire [31:0]       core;

reg [31:0]        ctrl;
reg [31:0]        scratch;
reg [31:0]        sss;

reg               pready_irom_dly;
reg               pready_iram_dly;
reg               pready_dram_dly;
reg               pready_efuse_dly;
reg               pready_ksu_dly;

wire [47:0]       prdata_trace;
wire              pready_trace;
wire              psuberr_trace;

wire              erase_disable;

//==================================================
// Assignments
//==================================================
assign accen_irom_o  = 1'b1;
assign enable_irom_o = irom_cs & (pwrite_bkd_i | ~pready_irom_dly);
assign addr_irom_o   = paddr_bkd_i[IROM_AWIDTH-1:2];
assign wdata_irom_o  = pwdata_bkd_i[IROM_DWIDTH-1:0];
assign write_irom_o  = pwrite_bkd_i;
assign wstrb_irom_o  = {IROM_SWIDTH{1'b1}};

assign accen_iram_o  = ~(erase_disable & cpu_rst_i);
assign enable_iram_o = iram_cs & (pwrite_bkd_i | ~pready_iram_dly);
assign addr_iram_o   = paddr_bkd_i[IRAM_AWIDTH-1:2];
assign wdata_iram_o  = pwdata_bkd_i[IRAM_DWIDTH-1:0];
assign write_iram_o  = pwrite_bkd_i;
assign wstrb_iram_o  = {IRAM_SWIDTH{1'b1}};

assign accen_dram_o  = ~(erase_disable & cpu_rst_i);
assign enable_dram_o = dram_cs & (pwrite_bkd_i | ~pready_dram_dly);
assign addr_dram_o   = paddr_bkd_i[DRAM_AWIDTH-1:2];
assign wdata_dram_o  = pwdata_bkd_i[DRAM_DWIDTH-1:0];
assign write_dram_o  = pwrite_bkd_i;
assign wstrb_dram_o  = {DRAM_SWIDTH{1'b1}};

assign accen_efuse_o  = 1'b1;
assign enable_efuse_o = efuse_cs & (pwrite_bkd_i | ~pready_efuse_dly);
assign addr_efuse_o   = paddr_bkd_i[EFUSE_AWIDTH-1:2];
assign wdata_efuse_o  = pwdata_bkd_i[EFUSE_DWIDTH-1:0];
assign write_efuse_o  = pwrite_bkd_i;
assign wstrb_efuse_o  = {EFUSE_SWIDTH{1'b1}};

assign accen_ksu_o    = 1'b1;
assign enable_ksu_o   = ksu_cs & (pwrite_bkd_i | ~pready_ksu_dly);
assign addr_ksu_o     = paddr_bkd_i[KSU_AWIDTH-1:2];
assign wdata_ksu_o    = pwdata_bkd_i[KSU_DWIDTH-1:0];
assign write_ksu_o    = pwrite_bkd_i;
assign wstrb_ksu_o    = {KSU_SWIDTH{1'b1}};

assign msubsel = {trace_cs, info_cs, ksu_cs, efuse_cs, dram_cs, iram_cs, irom_cs};

assign pready_irom  = (pwrite_bkd_i) ? ready_irom_i  : pready_irom_dly;
assign pready_iram  = (pwrite_bkd_i) ? ready_iram_i  : pready_iram_dly;
assign pready_dram  = (pwrite_bkd_i) ? ready_dram_i  : pready_dram_dly;
assign pready_efuse = (pwrite_bkd_i) ? ready_efuse_i : pready_efuse_dly;
assign pready_ksu   = (pwrite_bkd_i) ? ready_ksu_i   : pready_ksu_dly;

assign irom_cs  = IROM_ENABLE  & psel_bkd_i & penable_bkd_i && paddr_bkd_i[23:20] == 4'h0;
assign iram_cs  = IRAM_ENABLE  & psel_bkd_i & penable_bkd_i && paddr_bkd_i[23:20] == 4'h1;
assign dram_cs  = DRAM_ENABLE  & psel_bkd_i & penable_bkd_i && paddr_bkd_i[23:20] == 4'h2;
assign efuse_cs = EFUSE_ENABLE & psel_bkd_i & penable_bkd_i && paddr_bkd_i[23:16] == 8'h31;
assign ksu_cs   = KSU_ENABLE   & psel_bkd_i & penable_bkd_i && paddr_bkd_i[23:16] == 8'h32;
assign info_cs  =                psel_bkd_i & penable_bkd_i && paddr_bkd_i[23:16] == 8'h43;
assign trace_cs = TRACE_ENABLE & psel_bkd_i & penable_bkd_i && paddr_bkd_i[23:20] == 4'h5;

assign memsize0 = {iram_size, irom_size};
assign memsize1 = {fuse_size, dram_size};
assign memsize2 = {16'h0000, ksu_size};

assign irom_size = calcMemSize(IROM_AWIDTH, IROM_DWIDTH, IROM_ENABLE);
assign iram_size = calcMemSize(IRAM_AWIDTH, IRAM_DWIDTH, IRAM_ENABLE);
assign dram_size = calcMemSize(DRAM_AWIDTH, DRAM_DWIDTH, DRAM_ENABLE);
assign fuse_size = calcMemSize(EFUSE_AWIDTH, EFUSE_DWIDTH, EFUSE_ENABLE);
assign ksu_size  = calcMemSize(KSU_AWIDTH, KSU_DWIDTH, KSU_ENABLE);

assign erase_disable    = ctrl[4];
assign enable_tap_tdr_o =  ctrl[3];
assign enable_tap_o  =  ctrl[2];
assign enable_cpu_o  =  ctrl[1];
assign rstn_bkdr_o   = ~ctrl[0];
assign sss_o = sss;
assign enable = { 27'h0000_00, KSU_ENABLE, EFUSE_ENABLE, DRAM_ENABLE, IRAM_ENABLE, IROM_ENABLE};
assign core   = { 24'h0000_00, CPU_TYPE};

always @*
begin
  casez (paddr_bkd_i[7:0])
      8'h00: rdata_info = pc_i;
      8'h04: rdata_info = enable;
      8'h08: rdata_info = status;
      8'h0C: rdata_info = core;
      8'h10: rdata_info = 32'hc001c0de;
      8'h14: rdata_info = memsize0;
      8'h18: rdata_info = memsize1;
      8'h1C: rdata_info = memsize2;

      8'h40: rdata_info = ctrl;
      8'h44: rdata_info = scratch;
      8'h48: rdata_info = sss;
    default: rdata_info = 48'h0000_0000_0000;
  endcase
end

assign wr_info = info_cs & pwrite_bkd_i & penable_bkd_i & psel_bkd_i;
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    ctrl    <= 32'h0000_0000;
    scratch <= 32'h0000_0000;
    sss     <= 32'h0000_0000;
  end else if(wr_info) begin
    casez (paddr_bkd_i[7:0])
      8'h40: ctrl <= pwdata_bkd_i[31:0]; 
      8'h44: scratch <= pwdata_bkd_i[31:0];
      8'h48: sss <= pwdata_bkd_i[31:0];
    endcase
  end
end

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    pready_irom_dly  <= 1'b0;
    pready_iram_dly  <= 1'b0;
    pready_dram_dly  <= 1'b0;
    pready_efuse_dly <= 1'b0;
    pready_ksu_dly   <= 1'b0;
  end else begin
    pready_irom_dly  <= ready_irom_i  & irom_cs;
    pready_iram_dly  <= ready_iram_i  & iram_cs;
    pready_dram_dly  <= ready_dram_i  & dram_cs;
    pready_efuse_dly <= ready_efuse_i & efuse_cs;
    pready_ksu_dly   <= ready_ksu_i   & ksu_cs;
  end
end

always @*
begin
  casez(msubsel)
    7'b??????1: begin prdata_bkd_o = rdata_irom_i;  pready_bkd_o = pready_irom;    psuberr_bkd_o = 1'b0;          end 
    7'b?????10: begin prdata_bkd_o = rdata_iram_i;  pready_bkd_o = pready_iram;    psuberr_bkd_o = 1'b0;          end 
    7'b????100: begin prdata_bkd_o = rdata_dram_i;  pready_bkd_o = pready_dram;    psuberr_bkd_o = 1'b0;          end 
    7'b???1000: begin prdata_bkd_o = rdata_efuse_i; pready_bkd_o = pready_efuse;   psuberr_bkd_o = 1'b0;          end 
    7'b??10000: begin prdata_bkd_o = rdata_ksu_i;   pready_bkd_o = pready_ksu;     psuberr_bkd_o = 1'b0;          end 
    7'b?100000: begin prdata_bkd_o = rdata_info;    pready_bkd_o = 1'b1;           psuberr_bkd_o = 1'b0;          end 
    7'b1000000: begin prdata_bkd_o = prdata_trace;  pready_bkd_o = pready_trace;   psuberr_bkd_o = psuberr_trace; end
    default:    begin prdata_bkd_o = 32'h0000_0000; pready_bkd_o = 1'b1;           psuberr_bkd_o = 1'b1;          end
  endcase 

end

generate
  if (TRACE_ENABLE) begin
    msftDvDebug_cpu_trace #(
        .TRACE_WORDS(TRACE_WORDS)
      )  msftDvDebug_cpu_trace_i (
      .clk_i(clk_i),
      .rstn_i(rstn_i),
      .cpu_rst_i(cpu_rst_i),

      .psel_i(psel_bkd_i & trace_cs),
      .penable_i(penable_bkd_i),
      .paddr_i(paddr_bkd_i),
      .pwdata_i(pwdata_bkd_i),
      .pwrite_i(pwrite_bkd_i),
      
      .prdata_o(prdata_trace),
      .pready_o(pready_trace),
      .psuberr_o(psuberr_trace),

      .pc_i(pc_i),
      .inst_val_i(inst_val_i),
      .branch_i(branch_i)
    );
  end
  else begin
    assign prdata_trace = '0;
    assign pready_trace = '1;
    assign psuberr_trace = '0;
  end
endgenerate

endmodule
