

module msftDvPkg_dpi_apb_bus #(
  parameter APB_ADDR_WIDTH=32,
  parameter APB_DATA_WIDTH=32,
  parameter NUM_PSELECTS=16
  ) (

  input                             pclk_i,
  input                             prstn_i,

  output     [15:0]                 pselbus_o,
  output reg                        psel_o,
  output reg                        penable_o,
  output reg [APB_ADDR_WIDTH-1:0]   paddr_o,
  output reg [APB_DATA_WIDTH-1:0]   pwdata_o,
  output reg                        pwrite_o,
  input      [APB_DATA_WIDTH-1:0]   prdata_i,
  input                             pready_i,
  input                             psuberr_i,

  output                            testEnd_o,
  output                            testFail_o
);


localparam APB_IDLE      = 2'h0;
localparam APB_SEL       = 2'h1;
localparam APB_ENABLE    = 2'h2;

reg [APB_DATA_WIDTH-1:0]  rdata;
reg                       suberr;
logic                     testEnd = 1'b0;
logic                     testFail = 1'b0;
assign testEnd_o = testEnd;
assign testFail_o = testFail;

reg [1:0]                 apb_state;
reg                       apb_req = 0;

import "DPI-C" context task apb_init();
export "DPI-C" task rdApb;
export "DPI-C" task wrApb;
export "DPI-C" task clkBus;
export "DPI-C" function getTimeNs;
export "DPI-C" function setError;

//===============================
// Generate PSELECTS
//===============================
wire [19:0] saddr = paddr_o[APB_ADDR_WIDTH-1:12];
genvar i;
generate 
  for(i=0;i<NUM_PSELECTS;i+=1) begin
    assign pselbus_o[i] = psel_o && (saddr == (20'h0000_0+i));
  end
endgenerate

//===============================
// Initialize Function
//===============================
initial
begin
  repeat (10000)@(posedge pclk_i);
  $display("Starting APB_INIT");
  apb_init();
  testEnd = 1'b1;
end

//===============================
// getTimeNs
//===============================
function int getTimeNs();
   return ($time);
endfunction

//===============================
// setError
//===============================
function setError;
  testFail = 1'b1;
endfunction

//===============================
// clkBus
//===============================
task clkBus(input int cnt);
  repeat(cnt) @(posedge pclk_i);
endtask

//===============================
// Read Task
//===============================
task rdApb(input int taddr, output int tdata, output bit terror);
  @(posedge pclk_i);
  apb_req <= 1'b1;
  paddr_o <= taddr;
  pwrite_o <= 1'b0;
  repeat(2) @(posedge pclk_i);
  apb_req <= 1'b0;
  while(apb_state != APB_IDLE) @(posedge pclk_i);
  tdata = rdata;
  terror = suberr; 
endtask

//===============================
// Write Task
//===============================
task wrApb(input int taddr, input int tdata, output bit terror);
  @(posedge pclk_i);
  apb_req <= 1'b1;
  paddr_o <= taddr;
  pwdata_o <= tdata;
  pwrite_o <= 1'b1;
  repeat(2) @(posedge pclk_i);
  apb_req <= 1'b0;
  while(apb_state != APB_IDLE) @(posedge pclk_i);
  terror = suberr; 
endtask

//===============================
// APB Transactor
//===============================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    apb_state <= APB_IDLE;
    psel_o    <= 1'b0;
    penable_o <= 1'b0;
    paddr_o   <= {APB_ADDR_WIDTH{1'b0}};
    pwdata_o  <= {APB_DATA_WIDTH{1'b0}};
    pwrite_o  <= 1'b0;
    rdata     <= {APB_DATA_WIDTH{1'b0}};
    suberr     <= 1'b0;
  end else begin
    casez(apb_state)
      APB_IDLE: begin
        if(apb_req) begin
          psel_o <= 1'b1; 
          apb_state <= APB_SEL;
        end
      end
      APB_SEL: begin
        penable_o <= 1'b1;
        apb_state <= APB_ENABLE;
      end
      APB_ENABLE: begin
        if(pready_i) begin
          rdata <= prdata_i;
          suberr <= psuberr_i;
          psel_o <= 1'b0;
          penable_o <= 1'b0;
          apb_state <= APB_IDLE;
        end
      end
      default: apb_state <= APB_IDLE;
    endcase
  end
end

endmodule

