module msftDvIp_axi_fifo #(
  parameter FIFO_SIZE=4,
  parameter FIFO_DATA_WIDTH=32
  )  (
  input                       clk_i,
  input                       rstn_i,

  input                        wrReq,
  output                       wrAck,
  input [FIFO_DATA_WIDTH-1:0]  wdata,

  input                        rdReq,
  output                       rdAck,
  output [FIFO_DATA_WIDTH-1:0] rdata
);

localparam FIFO_PTR_BITS = $clog2(FIFO_SIZE);

reg [FIFO_DATA_WIDTH-1:0]           fifo    [FIFO_SIZE-1:0];
reg [FIFO_PTR_BITS-1:0]             fifo_hptr;
reg [FIFO_PTR_BITS-1:0]             fifo_tptr;
reg [FIFO_PTR_BITS:0]               fifo_cnt;


assign fifo_inc = wrReq & wrAck & ~(rdReq & rdAck); 
assign fifo_dec = rdReq & rdAck & ~(wrReq & wrAck);
assign fifo_full  = fifo_cnt[FIFO_PTR_BITS];
assign fifo_empty = ~(|fifo_cnt);

assign wrAck = ~fifo_full;
assign rdAck = ~fifo_empty;

assign rdata = fifo[fifo_tptr];

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    for(int i=0;i<FIFO_SIZE;i=i+1) begin
      fifo[i] <= {FIFO_DATA_WIDTH{1'b0}};
    end
    fifo_hptr <= {FIFO_PTR_BITS+1{1'b0}};
    fifo_tptr <= {FIFO_PTR_BITS+1{1'b0}};
    fifo_cnt <=  {FIFO_PTR_BITS+1{1'b0}};
  end else begin
    if(wrReq & wrAck) begin
      fifo[fifo_hptr] <= wdata;
      fifo_hptr  <= fifo_hptr + 1'b1;
    end
    if(rdReq & rdAck) begin
      fifo_tptr  <= fifo_tptr + 1'b1;
    end

    if(fifo_inc) begin
      fifo_cnt <= fifo_cnt + 1'b1;
    end else if(fifo_dec) begin
      fifo_cnt <= fifo_cnt - 1'b1;
    end
  end
end
endmodule
