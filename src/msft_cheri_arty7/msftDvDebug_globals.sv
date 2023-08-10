

module msftDvDebug_globals #(
  parameter PART_NUM=16'h0000,
  parameter CHANGE_LIST=32'h0000_0000,
  parameter CAPABILITY_0=32'h0000_0000,
  parameter CAPABILITY_1=32'h0000_0000
  ) (
  input               clk_i,
  input               rstn_i,

  input               psel_com_i,
  input               penable_com_i,
  input [31:0]        paddr_com_i,
  input [47:0]        pwdata_com_i,
  input               pwrite_com_i,

  output [47:0]       prdata_com_o,
  output              pready_com_o,
  output              pslverr_com_o,

  output              rstn_dbg_o,
  output              pwrn_dbg_o,

  output [31:0]       gpio_out_o,
  input  [31:0]       gpio_in_i
);


//====================================================
// Reg/Wire
//====================================================
reg                   rst;
reg                   pwron;

reg  [31:0]           gpio_out;
reg  [31:0]           gpio_in;

reg  [31:0]           prdata;
wire                  rst_dbg;
wire                  pwr_dbg;

//====================================================
// Assignments
//====================================================
assign clk = clk_i;
assign rstn = rstn_i;

assign prdata_com_o = prdata;
assign pready_com_o = 1'b1;
assign pslverr_com_o = 1'b0;

assign rstn_dbg_o = ~rst_dbg & ~rst;
assign pwrn_dbg_o = ~pwr_dbg & ~pwron;

assign gpio_out_o = gpio_out;

assign pwr = psel_com_i & penable_com_i &  pwrite_com_i;
assign prd = psel_com_i & ~pwrite_com_i;

assign genRst = pwr && paddr_com_i[7:2] == 6'h4 && pwdata_com_i[0];
assign genPwr = pwr && paddr_com_i[7:2] == 6'h5 && pwdata_com_i[0];

// ================================
// Read Registers
// ================================
always @(posedge clk or negedge rstn)
begin
  if (~rstn) begin
    prdata <= 32'h0000_0000;
    gpio_in <= 32'h0000_0000;
  end else begin
    gpio_in <= gpio_in_i;
    prdata <= 32'h0000_0000;
    if (prd) begin
      case (paddr_com_i[7:2])
        6'h0: prdata <= {16'h0, PART_NUM};
        6'h1: prdata <= CHANGE_LIST;
        6'h2: prdata <= CAPABILITY_0;
        6'h3: prdata <= CAPABILITY_1;
        6'h4: prdata <= {30'h0000_0000, rst, rstn_dbg_o};
        6'h5: prdata <= {30'h0000_0000, pwron, pwrn_dbg_o};
        6'h6: prdata <= gpio_out;
        6'h7: prdata <= gpio_in;
      endcase
    end
  end
end

// ================================
// Write Registers
// ================================
always @(posedge clk or negedge rstn)
begin
  if (~rstn) begin
    rst <= 1'b0;
    pwron <= 1'b0;
    gpio_out <= 32'h0000_0000;
  end else begin
    if (pwr) begin
      case (paddr_com_i[7:2])
        6'h4: rst   <= pwdata_com_i[1];
        6'h5: pwron <= pwdata_com_i[1];
        6'h6: gpio_out <= pwdata_com_i;
      endcase
    end
  end
end

//================================
// Reset Generator
//================================
msftDvDebug_sync_pulse_gen rstn_gen_i (.clk_i(clk), .rstn_i(rstn), .start_i(genRst), .pulse_o(rst_dbg));
msftDvDebug_sync_pulse_gen pwrn_gen_i (.clk_i(clk), .rstn_i(rstn), .start_i(genPwr), .pulse_o(pwr_dbg));

endmodule
