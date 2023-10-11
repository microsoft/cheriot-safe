module msftDvIp_periph_axi2apb_decode_decoder #(
  parameter APB_ADDR_WIDTH=32,
  parameter APB_DATA_WIDTH=32
  )  (
  input                             psel_mgr_i,
  input                             penable_mgr_i,
  input  [APB_ADDR_WIDTH-1:0]       paddr_mgr_i,
  input  [APB_DATA_WIDTH-1:0]       pwdata_mgr_i,
  input                             pwrite_mgr_i,
  input  [(APB_DATA_WIDTH/8)-1:0]   pstrb_mgr_i,
  output [APB_DATA_WIDTH-1:0]       prdata_mgr_o,
  output                            pready_mgr_o,
  output                            psuberr_mgr_o,

  output                            penable_sub_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_sub_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_sub_o,
  output                            pwrite_sub_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_sub_o,


  output                            psel_intc_o,
  output                            penable_intc_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_intc_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_intc_o,
  output                            pwrite_intc_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_intc_o,
  input [APB_DATA_WIDTH-1:0]        prdata_intc_i,
  input                             pready_intc_i,
  input                             psuberr_intc_i,

  output                            psel_tmr0_o,
  output                            penable_tmr0_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_tmr0_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_tmr0_o,
  output                            pwrite_tmr0_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_tmr0_o,
  input [APB_DATA_WIDTH-1:0]        prdata_tmr0_i,
  input                             pready_tmr0_i,
  input                             psuberr_tmr0_i,

  output                            psel_tmr1_o,
  output                            penable_tmr1_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_tmr1_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_tmr1_o,
  output                            pwrite_tmr1_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_tmr1_o,
  input [APB_DATA_WIDTH-1:0]        prdata_tmr1_i,
  input                             pready_tmr1_i,
  input                             psuberr_tmr1_i,

  output                            psel_dma0_o,
  output                            penable_dma0_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_dma0_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_dma0_o,
  output                            pwrite_dma0_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_dma0_o,
  input [APB_DATA_WIDTH-1:0]        prdata_dma0_i,
  input                             pready_dma0_i,
  input                             psuberr_dma0_i,

  output                            psel_jtag_o,
  output                            penable_jtag_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_jtag_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_jtag_o,
  output                            pwrite_jtag_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_jtag_o,
  input [APB_DATA_WIDTH-1:0]        prdata_jtag_i,
  input                             pready_jtag_i,
  input                             psuberr_jtag_i,

  output                            psel_uart0_o,
  output                            penable_uart0_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_uart0_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_uart0_o,
  output                            pwrite_uart0_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_uart0_o,
  input [APB_DATA_WIDTH-1:0]        prdata_uart0_i,
  input                             pready_uart0_i,
  input                             psuberr_uart0_i,

  output                            psel_spi0_o,
  output                            penable_spi0_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_spi0_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_spi0_o,
  output                            pwrite_spi0_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_spi0_o,
  input [APB_DATA_WIDTH-1:0]        prdata_spi0_i,
  input                             pready_spi0_i,
  input                             psuberr_spi0_i,

  output                            psel_i2c0_o,
  output                            penable_i2c0_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_i2c0_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_i2c0_o,
  output                            pwrite_i2c0_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_i2c0_o,
  input [APB_DATA_WIDTH-1:0]        prdata_i2c0_i,
  input                             pready_i2c0_i,
  input                             psuberr_i2c0_i,

  output                            psel_gpio0_o,
  output                            penable_gpio0_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_gpio0_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_gpio0_o,
  output                            pwrite_gpio0_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_gpio0_o,
  input [APB_DATA_WIDTH-1:0]        prdata_gpio0_i,
  input                             pready_gpio0_i,
  input                             psuberr_gpio0_i,

  output                            psel_gpio1_o,
  output                            penable_gpio1_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_gpio1_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_gpio1_o,
  output                            pwrite_gpio1_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_gpio1_o,
  input [APB_DATA_WIDTH-1:0]        prdata_gpio1_i,
  input                             pready_gpio1_i,
  input                             psuberr_gpio1_i
);


  wire [APB_DATA_WIDTH-1:0]         prdata_intc_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_tmr0_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_tmr1_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_dma0_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_jtag_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_uart0_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_spi0_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_i2c0_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_gpio0_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_gpio1_mux;


  assign penable_sub_o = penable_mgr_i;
  assign paddr_sub_o   = paddr_mgr_i;
  assign pwdata_sub_o  = pwdata_mgr_i;
  assign pwrite_sub_o  = pwrite_mgr_i;
  assign pstrb_sub_o   = pstrb_mgr_i;

  assign penable_intc_o = penable_mgr_i;
  assign paddr_intc_o   = paddr_mgr_i;
  assign pwdata_intc_o  = pwdata_mgr_i;
  assign pwrite_intc_o  = pwrite_mgr_i;
  assign pstrb_intc_o   = pstrb_mgr_i;

  assign penable_tmr0_o = penable_mgr_i;
  assign paddr_tmr0_o   = paddr_mgr_i;
  assign pwdata_tmr0_o  = pwdata_mgr_i;
  assign pwrite_tmr0_o  = pwrite_mgr_i;
  assign pstrb_tmr0_o   = pstrb_mgr_i;

  assign penable_tmr1_o = penable_mgr_i;
  assign paddr_tmr1_o   = paddr_mgr_i;
  assign pwdata_tmr1_o  = pwdata_mgr_i;
  assign pwrite_tmr1_o  = pwrite_mgr_i;
  assign pstrb_tmr1_o   = pstrb_mgr_i;

  assign penable_dma0_o = penable_mgr_i;
  assign paddr_dma0_o   = paddr_mgr_i;
  assign pwdata_dma0_o  = pwdata_mgr_i;
  assign pwrite_dma0_o  = pwrite_mgr_i;
  assign pstrb_dma0_o   = pstrb_mgr_i;

  assign penable_jtag_o = penable_mgr_i;
  assign paddr_jtag_o   = paddr_mgr_i;
  assign pwdata_jtag_o  = pwdata_mgr_i;
  assign pwrite_jtag_o  = pwrite_mgr_i;
  assign pstrb_jtag_o   = pstrb_mgr_i;

  assign penable_uart0_o = penable_mgr_i;
  assign paddr_uart0_o   = paddr_mgr_i;
  assign pwdata_uart0_o  = pwdata_mgr_i;
  assign pwrite_uart0_o  = pwrite_mgr_i;
  assign pstrb_uart0_o   = pstrb_mgr_i;

  assign penable_spi0_o = penable_mgr_i;
  assign paddr_spi0_o   = paddr_mgr_i;
  assign pwdata_spi0_o  = pwdata_mgr_i;
  assign pwrite_spi0_o  = pwrite_mgr_i;
  assign pstrb_spi0_o   = pstrb_mgr_i;

  assign penable_i2c0_o = penable_mgr_i;
  assign paddr_i2c0_o   = paddr_mgr_i;
  assign pwdata_i2c0_o  = pwdata_mgr_i;
  assign pwrite_i2c0_o  = pwrite_mgr_i;
  assign pstrb_i2c0_o   = pstrb_mgr_i;

  assign penable_gpio0_o = penable_mgr_i;
  assign paddr_gpio0_o   = paddr_mgr_i;
  assign pwdata_gpio0_o  = pwdata_mgr_i;
  assign pwrite_gpio0_o  = pwrite_mgr_i;
  assign pstrb_gpio0_o   = pstrb_mgr_i;

  assign penable_gpio1_o = penable_mgr_i;
  assign paddr_gpio1_o   = paddr_mgr_i;
  assign pwdata_gpio1_o  = pwdata_mgr_i;
  assign pwrite_gpio1_o  = pwrite_mgr_i;
  assign pstrb_gpio1_o   = pstrb_mgr_i;

  assign psel_intc_o = psel_mgr_i &   (paddr_mgr_i >= 32'h8f00_0600 && paddr_mgr_i < 32'h8f00_0640);
  assign psel_tmr0_o = psel_mgr_i &   (paddr_mgr_i >= 32'h8f00_0800 && paddr_mgr_i < 32'h8f00_0840);
  assign psel_tmr1_o = psel_mgr_i &   (paddr_mgr_i >= 32'h8f00_0840 && paddr_mgr_i < 32'h8f00_0880);
  assign psel_dma0_o = psel_mgr_i &   (paddr_mgr_i >= 32'h8f00_9000 && paddr_mgr_i < 32'h8f00_a000);
  assign psel_jtag_o = psel_mgr_i &   (paddr_mgr_i >= 32'h8f00_a000 && paddr_mgr_i < 32'h8f00_b000);
  assign psel_uart0_o = psel_mgr_i &   (paddr_mgr_i >= 32'h8f00_b000 && paddr_mgr_i < 32'h8f00_c000);
  assign psel_spi0_o = psel_mgr_i &   (paddr_mgr_i >= 32'h8f00_c000 && paddr_mgr_i < 32'h8f00_d000);
  assign psel_i2c0_o = psel_mgr_i &   (paddr_mgr_i >= 32'h8f00_d000 && paddr_mgr_i < 32'h8f00_e000);
  assign psel_gpio0_o = psel_mgr_i &   (paddr_mgr_i >= 32'h8f00_f000 && paddr_mgr_i < 32'h8f00_f800);
  assign psel_gpio1_o = psel_mgr_i &   (paddr_mgr_i >= 32'h8f00_f800 && paddr_mgr_i < 32'h8f01_0000);
  assign psel_def_o = psel_mgr_i & ~(psel_intc_o | psel_tmr0_o | psel_tmr1_o | psel_dma0_o | psel_jtag_o | psel_uart0_o | psel_spi0_o | psel_i2c0_o | psel_gpio0_o | psel_gpio1_o);

  assign prdata_intc_mux =  {APB_DATA_WIDTH{psel_intc_o}} & prdata_intc_i;
  assign prdata_tmr0_mux =  {APB_DATA_WIDTH{psel_tmr0_o}} & prdata_tmr0_i;
  assign prdata_tmr1_mux =  {APB_DATA_WIDTH{psel_tmr1_o}} & prdata_tmr1_i;
  assign prdata_dma0_mux =  {APB_DATA_WIDTH{psel_dma0_o}} & prdata_dma0_i;
  assign prdata_jtag_mux =  {APB_DATA_WIDTH{psel_jtag_o}} & prdata_jtag_i;
  assign prdata_uart0_mux =  {APB_DATA_WIDTH{psel_uart0_o}} & prdata_uart0_i;
  assign prdata_spi0_mux =  {APB_DATA_WIDTH{psel_spi0_o}} & prdata_spi0_i;
  assign prdata_i2c0_mux =  {APB_DATA_WIDTH{psel_i2c0_o}} & prdata_i2c0_i;
  assign prdata_gpio0_mux =  {APB_DATA_WIDTH{psel_gpio0_o}} & prdata_gpio0_i;
  assign prdata_gpio1_mux =  {APB_DATA_WIDTH{psel_gpio1_o}} & prdata_gpio1_i;

  assign prdata_mgr_o = prdata_intc_mux | prdata_tmr0_mux | prdata_tmr1_mux | prdata_dma0_mux | prdata_jtag_mux | prdata_uart0_mux | prdata_spi0_mux | prdata_i2c0_mux | prdata_gpio0_mux | prdata_gpio1_mux;

  assign pready_intc_mux =  psel_intc_o & pready_intc_i;
  assign pready_tmr0_mux =  psel_tmr0_o & pready_tmr0_i;
  assign pready_tmr1_mux =  psel_tmr1_o & pready_tmr1_i;
  assign pready_dma0_mux =  psel_dma0_o & pready_dma0_i;
  assign pready_jtag_mux =  psel_jtag_o & pready_jtag_i;
  assign pready_uart0_mux =  psel_uart0_o & pready_uart0_i;
  assign pready_spi0_mux =  psel_spi0_o & pready_spi0_i;
  assign pready_i2c0_mux =  psel_i2c0_o & pready_i2c0_i;
  assign pready_gpio0_mux =  psel_gpio0_o & pready_gpio0_i;
  assign pready_gpio1_mux =  psel_gpio1_o & pready_gpio1_i;

  assign pready_mgr_o = pready_intc_mux | pready_tmr0_mux | pready_tmr1_mux | pready_dma0_mux | pready_jtag_mux | pready_uart0_mux | pready_spi0_mux | pready_i2c0_mux | pready_gpio0_mux | pready_gpio1_mux | psel_def_o;

  assign psuberr_intc_mux =  psel_intc_o & psuberr_intc_i;
  assign psuberr_tmr0_mux =  psel_tmr0_o & psuberr_tmr0_i;
  assign psuberr_tmr1_mux =  psel_tmr1_o & psuberr_tmr1_i;
  assign psuberr_dma0_mux =  psel_dma0_o & psuberr_dma0_i;
  assign psuberr_jtag_mux =  psel_jtag_o & psuberr_jtag_i;
  assign psuberr_uart0_mux =  psel_uart0_o & psuberr_uart0_i;
  assign psuberr_spi0_mux =  psel_spi0_o & psuberr_spi0_i;
  assign psuberr_i2c0_mux =  psel_i2c0_o & psuberr_i2c0_i;
  assign psuberr_gpio0_mux =  psel_gpio0_o & psuberr_gpio0_i;
  assign psuberr_gpio1_mux =  psel_gpio1_o & psuberr_gpio1_i;

  assign psuberr_mgr_o = psuberr_intc_mux | psuberr_tmr0_mux | psuberr_tmr1_mux | psuberr_dma0_mux | psuberr_jtag_mux | psuberr_uart0_mux | psuberr_spi0_mux | psuberr_i2c0_mux | psuberr_gpio0_mux | psuberr_gpio1_mux | psel_def_o;


endmodule
