

module msftDvIp_mmreg (
  input  logic         pclk_i,
  input  logic         prstn_i,
                       
  input  logic         psel_i,
  input  logic         penable_i,
  input  logic  [7:0]  paddr_i,
  input  logic [31:0]  pwdata_i,
  input  logic         pwrite_i,
                       
  output logic [31:0]  prdata_o,
  output logic         pready_o,
  output logic         pslverr_o,

  input  logic [63:0]  mmreg_coreout_i,
  output logic [127:0] mmreg_corein_o
);


//=================================================
// Registers/Wires
//=================================================
logic [31:0]      tbre_start_addr;
logic [31:0]      tbre_end_addr;
logic             tbre_go;
logic [30:0]      tbre_epoch;
logic             tbre_done, tbre_stat_q;

logic [31:0]      prdata;


//=================================================
// Assignements
//=================================================
assign mmreg_corein_o = {63'h0, tbre_go, tbre_end_addr, tbre_start_addr};
assign tbre_stat      = mmreg_coreout_i[0];
assign tbre_done      = tbre_stat_q & ~tbre_stat;

assign prdata_o = prdata;
assign pready_o = 1'b1;
assign pslverr_o = 1'b0;

assign wr_op = psel_i & penable_i &  pwrite_i & pready_o;
assign rd_op = psel_i & ~penable_i & ~pwrite_i;

//=================================================
// Write registers
//=================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    tbre_start_addr <= 32'h0;
    tbre_end_addr   <= 32'h0;
    tbre_go         <= 1'b0;
    tbre_epoch      <= 8'h0;
    tbre_stat_q     <= 1'b0;
  end else begin
    if(wr_op) begin
      casez(paddr_i[7:2]) 
        6'h0: tbre_start_addr <= pwdata_i;
        6'h1: tbre_end_addr   <= pwdata_i;
      endcase
    end

    if (wr_op && (paddr_i[7:2] == 6'h2))
      tbre_go <= 1'b1;
    else
      tbre_go <= 1'b0;

    tbre_stat_q <= tbre_stat;
    
    if (tbre_done)
      tbre_epoch <= tbre_epoch + 1;
  end
end

//=================================================
// Read registers
//=================================================
always @(posedge pclk_i or negedge prstn_i)
begin
  if(~prstn_i) begin
    prdata <= 32'h0000_0000;
  end else begin
    casez(paddr_i[7:2]) 
      6'h0: prdata <= tbre_start_addr;
      6'h1: prdata <= tbre_end_addr;
      6'h2: prdata <= {16'h5500, 15'h0, tbre_go};
      6'h3: prdata <= {tbre_epoch, tbre_stat};
      default: prdata <= 32'h0000_0000;
    endcase
  end
end

endmodule
