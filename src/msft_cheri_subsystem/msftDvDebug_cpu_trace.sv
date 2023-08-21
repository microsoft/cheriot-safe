
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




module msftDvDebug_cpu_trace #(
    parameter TRACE_WORDS=1024
  )  (
  input             clk_i,
  input             rstn_i,
  input             cpu_rst_i,

  input             psel_i,
  input             penable_i,
  input [31:0]      paddr_i,
  input [47:0]      pwdata_i,
  input             pwrite_i,
  
  output reg [47:0] prdata_o,
  output            pready_o,
  output reg        psuberr_o,

  input [31:0]      pc_i,
  input             inst_val_i,
  input             branch_i
);

localparam TRACE_WIDTH  = $clog2(TRACE_WORDS);

localparam TRACE_IDLE = 3'h0;
localparam TRACE_WAIT_4_START = 3'h1;
localparam TRACE_RUN  = 3'h2;
localparam TRACE_DONE = 3'h3;
localparam TRACE_HIT_EOB =3'h4;


reg [31:0]  ctrl;
reg [31:0]  addr_start;
reg [31:0]  addr_end;
reg         trace_wrapped;

wire [31:0] status;

reg [63:0]                trace_ram  [TRACE_WORDS:0];
reg [15:0]                trace_cnt  [TRACE_WORDS:0];
reg [31:0]                last_pc, last_pre_pc;
reg [31:0]                repeat_cnt;
reg [TRACE_WIDTH-1:0]     trace_addr;

wire [TRACE_WIDTH-1:0]    trace_raddr;
wire [63:0]                trace_rdata;
wire [15:0]                trace_rcnt;

reg  [2:0]                trace_state;
reg [1:0]                 pready_cnt;

assign pready_o = pready_cnt[1];

// Enumberate Mode bits
wire [2:0]    trace_mode    = ctrl[2:0];
wire          trace_wrap_en = ctrl[16];
wire          trace_enabled = ctrl[31];


assign trace_wrap = trace_addr == {TRACE_WIDTH{1'b1}};
assign status = {28'h000_0000, trace_wrapped, trace_state};

assign psel_reg = psel_i &  paddr_i[16]; 
assign psel_ram = psel_i & ~paddr_i[16];

assign pread_reg =  psel_reg & penable_i & ~pwrite_i;
assign pwrite_reg = psel_reg & penable_i &  pwrite_i; 

assign pread_ram = psel_ram & penable_i & ~pwrite_i & ~pready_o;

assign trace_raddr = paddr_i[TRACE_WIDTH+2:3];

//============================================
// Write Logic
//============================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    ctrl <= 32'h8000_0000;
    addr_start <= 32'h0000_0000;
    addr_end <= 32'h0000_0000;
  end else begin
    if(pwrite_reg & pready_o) begin
      case(paddr_i[7:2])
      6'h00: ctrl <= pwdata_i;
      6'h01: addr_start <= pwdata_i;
      6'h02: addr_end <= pwdata_i;
      endcase
    end
  end 
end

//============================================
// Read Logic
//============================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    prdata_o <= 32'h0000_0000;
  end else begin
    if(pread_reg & ~pready_o) begin
      casez(paddr_i[7:2])
        6'h00: prdata_o <= {16'h0000, ctrl};
        6'h01: prdata_o <= {16'h0000, addr_start};
        6'h02: prdata_o <= {16'h0000, addr_end};
        6'h03: prdata_o <= {16'h0000, status};
        6'h04: prdata_o <= trace_addr;
      default: prdata_o <= 48'hdeaddeadbeef;
      endcase
    end else if(pread_ram) begin
      prdata_o <= (paddr_i[2]) ? {16'h0000, trace_rdata[63:32]} : {trace_rcnt, trace_rdata[31:0]};
    end
  end
end

//============================================
// pready always delay 2 clock cycle
//============================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    pready_cnt <= 2'h0;
    psuberr_o <= 1'b0;
  end else begin
    if(psel_i & penable_i & ~pready_o) begin
      pready_cnt <= pready_cnt + 1;
    end else begin
      pready_cnt <= 2'h0;
    end
  end
end

//============================================
// Trace Enable
// Modes
//   000: Trace Always on  
//   001: Trace from Start Address to Stop Address
//   002: Trace to Stop Address
//
// If trace wrap is enable then the buffer and overflow
//============================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    trace_state <= TRACE_IDLE;
    trace_wrapped <= 1'b0;
  end else begin
    if(trace_enabled) begin
      casez(trace_state[2:0])
        TRACE_IDLE: begin
          casez(trace_mode)
            3'h0: trace_state <= TRACE_RUN;
            3'h1: trace_state <= TRACE_WAIT_4_START;
            3'h2: trace_state <= TRACE_RUN;
          endcase
        end 
        TRACE_WAIT_4_START: begin
          if(pc_i == addr_start) begin
            trace_state <= TRACE_RUN;
          end
        end
        TRACE_RUN: begin
          casez(trace_mode)
            3'h1, 3'h2: begin
              if(pc_i == addr_end) begin
                trace_state <= TRACE_DONE;
              end
            end
            default: begin
              if(trace_wrap) begin
                if(trace_wrap_en) begin
                  trace_wrapped <= 1'b1;
                end else begin
                  trace_state <= TRACE_HIT_EOB;
                end
              end
            end
          endcase
        end
        TRACE_DONE: begin
        end
        TRACE_HIT_EOB: begin
        end
      endcase
    end else begin
      trace_state <= TRACE_IDLE;
      trace_wrapped <= 1'b0;
    end
  end
end

//============================================
// Branch Delay
//============================================
localparam BRANCH_WAIT = 1'b0;
localparam BRANCH_TAKEN = 1'b1;

reg branch_state;
reg [31:0] pre_pc;
assign branch = branch_state == BRANCH_TAKEN;

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    branch_state <= BRANCH_WAIT;
  end else begin
    casez(branch_state)
      BRANCH_WAIT: begin
        if(branch_i & ~cpu_rst_i) begin
          branch_state <= BRANCH_TAKEN;
          pre_pc <= pc_i;
        end
      end
      BRANCH_TAKEN: begin
        branch_state <= BRANCH_WAIT;
      end
    endcase
  end
end

//============================================
// Trace RAM
//============================================
logic new_sample;
assign new_sample = (pc_i != last_pc) || (pre_pc != last_pre_pc);

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    last_pc <= 32'h0000_0000;
    repeat_cnt <= 16'h0000;
    trace_addr <= 32'h0000_0000;
    last_pre_pc <= 32'h0000_0000;
  end else begin
    if(trace_enabled & branch && trace_state == TRACE_RUN) begin
      if(new_sample) begin
        repeat_cnt <= 16'h0000;
        last_pc <= pc_i;
        last_pre_pc <= pre_pc;
        trace_addr <= trace_addr + 1'b1;
      end else begin
        if(repeat_cnt != 16'hffff) begin
          repeat_cnt <= repeat_cnt + 1'b1;
        end
      end
    end else begin
      if(~trace_enabled) begin
        last_pc <= 32'h0000_0000;
        last_pre_pc <= 32'h0000_0000;
        trace_addr <= 32'h0000_0000;
        repeat_cnt <= 16'h0000;
      end
    end
  end

end

assign trace_rdata = trace_ram[trace_raddr];
assign trace_rcnt  = trace_cnt[trace_raddr];

//============================================
// Trace RAM
//============================================
always @(posedge clk_i)
begin
  if(trace_enabled & branch && trace_state == TRACE_RUN) begin
    //if(pc_i != last_pc) begin
    if (new_sample) begin
      // $display("--- cpu_trace: %t: trace[%d] = %x --> %x", $time, trace_addr, pre_pc, pc_i);
      trace_ram[trace_addr] <= {pc_i, pre_pc};
      trace_cnt[trace_addr] <= 16'h0000;
    end else begin
      if(repeat_cnt != 16'hffff) begin
        trace_cnt[trace_addr-1'b1] <= repeat_cnt +1'b1;
      end
    end
  end
end


endmodule
