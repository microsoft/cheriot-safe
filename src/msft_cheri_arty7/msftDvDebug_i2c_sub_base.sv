
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



module msftDvDebug_i2c_sub_base (
  input               clk,
  input               rstn,

  input [6:0]         subAddr,
  input [6:0]         subAddrMask,

  input               scl_i,
  output reg          scl_o,
  input               sda_i,
  output reg          sda_o,

  output reg [6:0]    i2cAddr,
  output              i2cWrReq,
  output [7:0]        i2cWrData,
  input               i2cWrReady,
  output              i2cRdReq,
  input  [7:0]        i2cRdData,
  input               i2cRdReady,
  output              i2cStart,
  output              i2cStop
);

//===============================
// Parameters
//===============================
parameter I2C_IDLE      = 0;
parameter I2C_ADDR      = 1;
parameter I2C_RD_WR     = 3;
parameter I2C_ACK_NAK_0 = 4;
parameter I2C_DATA      = 5;
parameter I2C_ACK_NAK_1 = 6;
parameter I2C_CLK_STRETCH_0 = 7;
parameter I2C_CLK_STRETCH_1 = 8;

reg [4:0]       i2cState;
reg [3:0]       i2cCnt;
reg [2:0]       sclkSync;
reg [2:0]       sdaSync;
reg [7:0]       shiftData;
reg [7:0]       i2cRdDataHld;
reg             i2cRd;

assign sclkRise = sclkSync[2:0] == 3'b011;
assign sclkFall = sclkSync[2:0] == 3'b100;
assign sclkHigh = sclkSync[2:0] == 3'b111;

assign sdaFall = sdaSync[2:0] == 3'b100;
assign sdaRise = sdaSync[2:0] == 3'b011;
assign i2cStart = sdaFall & sclkHigh;
assign i2cStop  = sdaRise & sclkHigh;

assign i2cWrReq = (i2cState == I2C_CLK_STRETCH_1) & ~i2cRd;
assign i2cRdReq = ((i2cState == I2C_CLK_STRETCH_0) | (i2cState == I2C_CLK_STRETCH_1)) & i2cRd;

assign i2cWrData = shiftData;

//===============================
// Edge Detects
//===============================
always @(posedge clk)
begin
  sclkSync <= {sclkSync[1:0], scl_i};
  sdaSync  <= {sdaSync[1:0],  sda_i};
end

//===============================
// Edge Detects
//===============================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    i2cCnt <= 3'h0;
    i2cState <= I2C_IDLE;
    i2cRd <= 1'b0;
    scl_o <= 1'b1;
    sda_o <= 1'b1;
    shiftData <= 8'h00;
    i2cRdDataHld <= 8'h00;
    i2cAddr <= 7'h00;
  end else if(i2cStop) begin
    i2cCnt <= 3'h0;
    i2cState <= I2C_IDLE;
    i2cRd <= 1'b0;
    scl_o <= 1'b1;
    sda_o <= 1'b1;
  end else begin
    case (i2cState)
      I2C_IDLE: begin
        if(i2cStart) begin
          i2cState <= I2C_ADDR;
          i2cCnt <= 4'h6;
        end
      end
      I2C_ADDR: begin
        if(sclkRise) begin
          shiftData[i2cCnt] <= sdaSync[1];
          i2cCnt <= i2cCnt - 1'b1;
          if(i2cCnt == 0) begin
            i2cState <= I2C_RD_WR;
          end
        end
      end
      I2C_RD_WR: begin
        i2cAddr <= shiftData[6:0];
        if((shiftData[6:0] & subAddrMask[6:0]) != (subAddr[6:0] & subAddrMask[6:0])) begin
          i2cState <= I2C_IDLE;
        end else if(sclkRise) begin
          i2cRd <= sdaSync[1];
          i2cState <= I2C_ACK_NAK_0;
        end
      end
      I2C_ACK_NAK_0: begin
        if(sclkFall) begin
          sda_o <= 1'b0;
        end
        if(sclkRise) begin
          i2cCnt <= 4'h7;
          if (~i2cRd) begin
            // Writes will check for clock stretch
            // after 8-bit of write data is received.
            i2cState <= I2C_DATA;
          end else begin
            i2cState <= I2C_CLK_STRETCH_0;
          end
        end
      end
      I2C_CLK_STRETCH_0: begin
        if(sclkFall) begin
          scl_o <= 1'b0;
          sda_o <= 1'b1;
        end
        if(i2cRdReady) begin
          scl_o <= 1'b1;
          i2cRdDataHld <= i2cRdData;
          i2cAddr <= i2cAddr + 1'b1;
          i2cState <= I2C_DATA;

          // Since we're clock stretching, 
          // we won't see a sclkFall in the
          // I2C_DATA state, but we need
          // to output the data so that it's
          // available to the master in 
          // the next posedge of SCL.
          if (i2cRd & ~sclkSync[1]) begin
            sda_o <= i2cRdData[i2cCnt];
          end
        end
      end
      I2C_DATA: begin
        if(sclkFall) begin
          if(i2cRd) begin
            sda_o <= i2cRdDataHld[i2cCnt];
          end else begin
            sda_o <= 1'b1;
          end
        end
        if(sclkRise) begin
          shiftData[i2cCnt] <= sdaSync[1];
          i2cCnt <= i2cCnt - 1'b1;
          if(i2cCnt == 4'h0) begin
            i2cState <= I2C_ACK_NAK_1;
          end
        end
      end
      I2C_ACK_NAK_1: begin
        if(sclkFall) begin
          if(i2cRd) begin
            sda_o <= 1'b1;
          end else begin
            sda_o <= 1'b0;
          end
        end
        if(sclkRise) begin
          i2cCnt <= 4'h7;
          // NAK on a read indicates that this is the
          // last byte of the transaction.
          if (i2cRd & sdaSync[1]) begin
            i2cState <= I2C_IDLE;
          end else begin
            i2cState <= I2C_CLK_STRETCH_1;
          end
        end
      end
      I2C_CLK_STRETCH_1: begin
        if(sclkFall) begin
          scl_o <= 1'b0;
          sda_o <= 1'b1;
        end
        if ( (i2cRd & i2cRdReady)
           | (~i2cRd & i2cWrReady)
           ) begin
          scl_o <= 1'b1;
          i2cRdDataHld <= i2cRdData;
          i2cState <= I2C_DATA;
          i2cAddr <= i2cAddr + 1'b1;

          // See I2C_CLK_STRETCH_0 above for
          // the reasoning behind this.
          if (i2cRd & ~sclkSync[1]) begin
            sda_o <= i2cRdData[i2cCnt];
          end
        end
      end
      default: i2cState <= I2C_IDLE;
    endcase
  end 
end


endmodule
