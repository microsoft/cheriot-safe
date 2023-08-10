// Copyright (C) Microsoft Corporation. All rights reserved.



module msftDvDebug_sync_pulse_gen #(
  parameter COUNTS=32
  ) (

  input         clk_i,
  input         rstn_i,
  input         start_i,
  output        pulse_o
);

reg                      pulse;
reg [$clog2(COUNTS)-1:0] pulse_cnt;

wire clk;
wire rstn;
wire start;

//================================
// Pulse Generator
//================================
always @(posedge clk or negedge rstn)
begin
  if (~rstn) begin
    pulse  <= 1'b0;
    pulse_cnt <= 'h00;
  end else begin
    if (start) begin
      pulse_cnt <= 5'h1f;
      pulse <= 1'b1;
    end else if (pulse_cnt != 5'h0) begin
      pulse_cnt <= pulse_cnt - 1'b1;
    end else begin
      pulse <= 1'b0;
    end
  end
end

assign clk = clk_i;
assign rstn = rstn_i;
assign start = start_i;
assign pulse_o = pulse;

endmodule

