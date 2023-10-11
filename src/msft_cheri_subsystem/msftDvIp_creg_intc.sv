

module msftDvIp_creg_intc (
  input               clk_i,
  input               rstn_i,

  input               psel_i,
  input               penable_i,
  input [31:0]        paddr_i,
  input [31:0]        pwdata_i,
  input               pwrite_i,
  output reg [31:0]   prdata_o,
  output              pready_o,
  output              pslverr_o,

  input [31:0]        irqs,
  output              fiq,
  output              irq,
  output              irqx0,
  output              irqx1
);


assign pready_o = 1'b1;
assign pslverr_o = 1'b0;

assign clk = clk_i;
assign rstn = rstn_i;
assign psel = psel_i;
assign penable = penable_i;
assign pwrite = pwrite_i;

reg [31:0] int_status;
reg [31:0] fiq_enable;
reg [31:0] irq_enable;
reg [31:0] irqx0_enable;
reg [31:0] irqx1_enable;
reg [31:0] system_timer;

assign fiq = |(int_status & fiq_enable);
assign irq = |(int_status & irq_enable);

assign irqx0 = |(int_status & irqx0_enable);
assign irqx1 = |(int_status & irqx1_enable);


//=========================================
// Write Registers
//=========================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    int_status <= 32'h0000_0000;
    irq_enable <= 32'h0000_0000;
    fiq_enable <= 32'h0000_0000;
    irqx0_enable <= 32'h0000_0000;
    irqx1_enable <= 32'h0000_0000;
    system_timer <= 32'h0000_0000;
  end else begin
    system_timer <= system_timer + 1'b1;
    if(psel & penable & pwrite) begin
      casez(paddr_i[7:2])
        6'h1: irq_enable <= pwdata_i;
        6'h2: fiq_enable <= pwdata_i;
        6'h3: irqx0_enable <= pwdata_i;
        6'h4: irqx1_enable <= pwdata_i;
        6'h5: system_timer <= pwdata_i;
      endcase
    end 

    // Edge detect 
    if(psel & penable & pwrite & paddr_i[7:2] == 6'h0) begin
      int_status <= (int_status & (~pwdata_i)) | irqs;
    end else begin 
      int_status <= int_status | irqs;
    end
  end
end

//=========================================
// Read Registers
//=========================================
always @(posedge clk or negedge rstn)
begin
  if(~rstn) begin
    prdata_o <= 32'h0000_0000;
  end else begin
    prdata_o <= 32'h0000_0000;
    if(psel & ~penable & ~pwrite) begin
      casez(paddr_i[7:2])
        6'h0: prdata_o <= int_status;
        6'h1: prdata_o <= irq_enable;
        6'h2: prdata_o <= fiq_enable;
        6'h3: prdata_o <= irqx0_enable;
        6'h4: prdata_o <= irqx1_enable;
        6'h5: prdata_o <= system_timer;
      endcase
    end
  end
end


endmodule
