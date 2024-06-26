

module msftDvIp_led_alive (
  input   clk_i,
  input   rstn_i,
  input   locked,

  output alive_o

);



reg [31:0] led_cnt;

assign alive_o = led_cnt[27];

always @(posedge clk_i or negedge rstn_i)
begin
  if(~rstn_i) begin
    led_cnt <= 32'h0000_0000;
  end else if (locked) begin
    led_cnt <= led_cnt - 1'b1;
  end
end



endmodule

