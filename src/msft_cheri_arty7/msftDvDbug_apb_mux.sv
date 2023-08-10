module msftDvDbug_apb_mux #(
  parameter APB_ADDR_WIDTH=32,
  parameter APB_DATA_WIDTH=32
  )  (
  input                             psel_dbg_i,
  input                             penable_dbg_i,
  input  [APB_ADDR_WIDTH-1:0]       paddr_dbg_i,
  input  [APB_DATA_WIDTH-1:0]       pwdata_dbg_i,
  input                             pwrite_dbg_i,
  input  [(APB_DATA_WIDTH/8)-1:0]   pstrb_dbg_i,
  output [APB_DATA_WIDTH-1:0]       prdata_dbg_o,
  output                            pready_dbg_o,
  output                            psuberr_dbg_o,

  output                            penable_bkd_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_bkd_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_bkd_o,
  output                            pwrite_bkd_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_bkd_o,


  output                            psel_com_o,
  output                            penable_com_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_com_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_com_o,
  output                            pwrite_com_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_com_o,
  input [APB_DATA_WIDTH-1:0]        prdata_com_i,
  input                             pready_com_i,
  input                             psuberr_com_i,

  output                            psel_sysdbg_o,
  output                            penable_sysdbg_o,
  output [APB_ADDR_WIDTH-1:0]       paddr_sysdbg_o,
  output [APB_DATA_WIDTH-1:0]       pwdata_sysdbg_o,
  output                            pwrite_sysdbg_o,
  output [(APB_DATA_WIDTH/8)-1:0]   pstrb_sysdbg_o,
  input [APB_DATA_WIDTH-1:0]        prdata_sysdbg_i,
  input                             pready_sysdbg_i,
  input                             psuberr_sysdbg_i
);


  wire [APB_DATA_WIDTH-1:0]         prdata_com_mux;
  wire [APB_DATA_WIDTH-1:0]         prdata_sysdbg_mux;


  assign penable_bkd_o = penable_dbg_i;
  assign paddr_bkd_o   = paddr_dbg_i;
  assign pwdata_bkd_o  = pwdata_dbg_i;
  assign pwrite_bkd_o  = pwrite_dbg_i;
  assign pstrb_bkd_o   = pstrb_dbg_i;

  assign penable_com_o = penable_dbg_i;
  assign paddr_com_o   = paddr_dbg_i;
  assign pwdata_com_o  = pwdata_dbg_i;
  assign pwrite_com_o  = pwrite_dbg_i;
  assign pstrb_com_o   = pstrb_dbg_i;

  assign penable_sysdbg_o = penable_dbg_i;
  assign paddr_sysdbg_o   = paddr_dbg_i;
  assign pwdata_sysdbg_o  = pwdata_dbg_i;
  assign pwrite_sysdbg_o  = pwrite_dbg_i;
  assign pstrb_sysdbg_o   = pstrb_dbg_i;

  assign psel_com_o = psel_dbg_i &   (paddr_dbg_i >= 32'h1000_0000 && paddr_dbg_i < 32'h1000_0100);
  assign psel_sysdbg_o = psel_dbg_i &   (paddr_dbg_i >= 32'h2000_0000 && paddr_dbg_i < 32'h2100_0000);
  assign psel_def_o = psel_dbg_i & ~(psel_com_o | psel_sysdbg_o);

  assign prdata_com_mux =  {APB_DATA_WIDTH{psel_com_o}} & prdata_com_i;
  assign prdata_sysdbg_mux =  {APB_DATA_WIDTH{psel_sysdbg_o}} & prdata_sysdbg_i;

  assign prdata_dbg_o = prdata_com_mux | prdata_sysdbg_mux;

  assign pready_com_mux =  psel_com_o & pready_com_i;
  assign pready_sysdbg_mux =  psel_sysdbg_o & pready_sysdbg_i;

  assign pready_dbg_o = pready_com_mux | pready_sysdbg_mux | psel_def_o;

  assign psuberr_com_mux =  psel_com_o & psuberr_com_i;
  assign psuberr_sysdbg_mux =  psel_sysdbg_o & psuberr_sysdbg_i;

  assign psuberr_dbg_o = psuberr_com_mux | psuberr_sysdbg_mux | psel_def_o;


endmodule
