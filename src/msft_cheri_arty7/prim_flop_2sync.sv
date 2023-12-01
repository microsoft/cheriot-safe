module prim_flop_2sync #(
  parameter int               Width      = 16,
  parameter logic [Width-1:0] ResetValue = '0
) (
  input                    clk_i,
  input                    rst_ni,
  input        [Width-1:0] d_i,
  output logic [Width-1:0] q_o
);
  logic [Width-1:0] q_1;

  always @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      q_o <= ResetValue;
      q_1 <= ResetValue;
    end else begin
      q_o <= q_1;
      q_1 <= d_i;
    end
  end
endmodule

