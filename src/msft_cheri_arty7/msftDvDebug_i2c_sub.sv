// Copyright (C) Microsoft Corporation. All rights reserved.



/*
I2C address Space
ADDR    REG
0x70    ADDR[31:24]
0x71    ADDR[23:16]
0x72    ADDR[15:8]
0x73    ADDR[7:0]

0x78    DATA[47:40]
0x79    DATA[39:32]
0x76    DATA[31:24]
0x77    DATA[23:16]
0x78    DATA[15:8]
0x79    DATA[7:0]

*/


module msftDvDebug_i2c_sub (
  input             clk_i,
  input             rstn_i,

  input             scl_i,
  output reg        scl_oen_o,
  input             sda_i,
  output reg        sda_oen_o,
 
  output            psel32_i2c_o,
  output            penable32_i2c_o,
  output     [31:0] paddr32_i2c_o,
  output     [47:0] pwdata32_i2c_o,
  output            pwrite32_i2c_o,
  input      [47:0] prdata32_i2c_i,
  input             pready32_i2c_i,
  input             psuberr32_i2c_i,

  output            psel16_i2c_o,
  output            penable16_i2c_o,
  output     [14:0] paddr16_i2c_o,
  output     [15:0] pwdata16_i2c_o,
  output            pwrite16_i2c_o,
  input      [15:0] prdata16_i2c_i,
  input             pready16_i2c_i,
  input             psuberr16_i2c_i,

  output            sel_i2c_o

);

parameter APB_IDLE  = 0;
parameter APB_ENABLE  = 1;
parameter APB_WAIT  = 2;

reg           psel;
reg           penable;
reg  [31:0]   paddr;
wire [47:0]   prdata;
reg  [47:0]   pwdata;
reg           pwrite;
wire          pready;
wire          psuberr;

wire [1:0] txSize;

assign sel_i2c_o = psel;

assign psel32_i2c_o = psel & txSize[1];
assign penable32_i2c_o = penable;
assign paddr32_i2c_o = paddr;
assign pwdata32_i2c_o = pwdata;
assign pwrite32_i2c_o = pwrite;

assign psel16_i2c_o = psel && txSize == 2'h1;
assign penable16_i2c_o = penable;
assign paddr16_i2c_o = paddr[14:0];
assign pwdata16_i2c_o = pwdata[15:0];
assign pwrite16_i2c_o = pwrite;

assign prdata  = (psel32_i2c_o) ? prdata32_i2c_i   : prdata16_i2c_i;
assign pready  = (psel32_i2c_o) ? pready32_i2c_i   : pready16_i2c_i;
assign psuberr = (psel32_i2c_o) ? psuberr32_i2c_i  : psuberr16_i2c_i;

//================================
// I2C SUB output signals
//================================
wire [6:0]    i2cAddr;
wire          i2cWrReq;
wire [7:0]    i2cWrData;
wire          i2cRdReq;
reg  [7:0]    i2cRdData;
wire          i2cStop;
wire          i2cStart;

reg  [7:0]    errReg;

reg [1:0]     apbState;
reg [47:0]    apbRdData;
reg  [15:0]   apbCtrl;
reg           disIncr;

wire [6:0]    subAddr = 7'h70;  // TODO: Fix this
wire [6:0]    subAddrMask = 7'h70;

// Read and Write Requests
assign apbWrReq = i2cWrReq & i2cAddr[3:0] == 4'hf;
assign apbRdReq0 = (i2cWrReq && i2cAddr[3:0] == 4'h3);
assign apbRdReq1 = (i2cRdReq && i2cAddr[3:0] == 4'hf);

assign i2cApbReady = (apbWrReq | apbRdReq0 | apbRdReq1) ? penable & pready : 1'b1;

// Control signals
assign autoIncr = apbCtrl[0] && apbState == APB_WAIT && pready & ~disIncr;
assign txSize   = apbCtrl[3:2];

//================================
// I2C SUB Base
//================================
msftDvDebug_i2c_sub_base msftDvDebug_i2c_sub_base_i (
  .clk(clk_i),
  .rstn(rstn_i),
  .scl_i(scl_i),
  .scl_o(scl_oen_o),
  .sda_i(sda_i),
  .sda_o(sda_oen_o),

  .subAddr(subAddr),
  .subAddrMask(subAddrMask),

  .i2cAddr(i2cAddr),
  .i2cWrReq(i2cWrReq),
  .i2cWrData(i2cWrData),
  .i2cWrReady(i2cApbReady),
  .i2cRdReq(i2cRdReq),
  .i2cRdData(i2cRdData),
  .i2cRdReady(i2cApbReady),
  .i2cStart(i2cStart),
  .i2cStop(i2cStop)
);

//================================
// Register Reads
//================================
always @*
begin
  i2cRdData = 48'h0000_0000_0000;
  if(i2cRdReq) begin
    case (i2cAddr[3:0])
      4'h0: i2cRdData = paddr[31:24];
      4'h1: i2cRdData = paddr[23:16];
      4'h2: i2cRdData = paddr[15: 8];
      4'h3: i2cRdData = paddr[ 7: 0];
      4'h4: i2cRdData = apbCtrl[15:8];
      4'h5: i2cRdData = apbCtrl[7:0];
      4'h6: i2cRdData = 8'hc0;
      4'h7: i2cRdData = 8'hde;
      4'h8: i2cRdData = errReg;

      4'ha: i2cRdData = apbRdData[47:40];
      4'hb: i2cRdData = apbRdData[39:32];
      4'hc: i2cRdData = apbRdData[31:24];
      4'hd: i2cRdData = apbRdData[23:16];
      4'he: i2cRdData = apbRdData[15: 8];
      4'hf: i2cRdData = apbRdData[ 7: 0];

    endcase
  end
end

//================================
// Register Writes
//================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    paddr <= 32'h0000_0000;
    pwdata <= 48'h0000_0000_0000;
    apbCtrl <= 16'h09;
  end else begin
    if(autoIncr) begin
        paddr <= paddr + ((txSize == 2) ? 4 : (txSize == 1) ? 2 : (txSize == 0) ? 1 : 6);
    end
    if(i2cWrReq) begin
      case(i2cAddr[3:0]) 
        4'h0: paddr[31:24]   <= i2cWrData;
        4'h1: paddr[23:16]   <= i2cWrData;
        4'h2: paddr[15: 8]   <= i2cWrData;
        4'h3: paddr[ 7: 0]   <= i2cWrData;
        4'h4: apbCtrl[15:8]  <= {1'b0,i2cWrData[6:0]};
        4'h5: apbCtrl[ 7:0]  <= i2cWrData;

        4'ha: pwdata[47:40]   <= i2cWrData;
        4'hb: pwdata[39:32]   <= i2cWrData;
        4'hc: pwdata[31:24]   <= i2cWrData;
        4'hd: pwdata[23:16]   <= i2cWrData;
        4'he: pwdata[15: 8]   <= i2cWrData;
        4'hf: pwdata[ 7: 0]   <= i2cWrData;
      endcase
    end
  end
end

//================================
// APB state machine
//================================
always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    apbState <= APB_IDLE;
    psel <= 1'b0;
    penable <= 1'b0;
    pwrite <= 1'b0;
    errReg <= 8'h0;
    disIncr <= 1'b0;
  end else begin
    case (apbState)
      APB_IDLE: begin
        if(apbWrReq) begin
          pwrite <= 1'b1;
          psel <= 1'b1;
          apbState <= APB_ENABLE;
        end else if(apbRdReq0) begin
          psel <= 1'b1;
          disIncr <= 1'b1;
          apbState <= APB_ENABLE;
        end else if(apbRdReq1) begin
          psel <= 1'b1;
          apbState <= APB_ENABLE;
        end
      end
      APB_ENABLE: begin
        penable <= 1'b1;
        apbState <= APB_WAIT;
      end
      APB_WAIT: begin
        if(pready) begin
          psel <= 1'b0;
          penable <= 1'b0;
          pwrite <= 1'b0;
          errReg[0] <= psuberr;
          apbRdData <= prdata;
          disIncr <= 1'b0;
          apbState <= APB_IDLE;
        end
      end
    endcase
  end
end


endmodule
