//import ibex_pkg::*;

module msftDvIp_cheri_core_wrapper import cheri_pkg::*; #(
    parameter int unsigned DmHaltAddr      = 32'h1A11_0800,
    parameter int unsigned DmExceptionAddr = 32'h1A110808,
    parameter int unsigned HeapBase        = 32'h2004_0000,
    parameter int unsigned TSMapBase       = 32'h200f_e000, // 4kB default
    parameter int unsigned TSMapTop        = 32'h2010_0000,
    parameter int unsigned DataWidth       = 33,
    parameter bit          UseIbex         = 1'b1
  )  (

  // Clock and Reset
  input  logic                         clk_i,
  input  logic                         rstn_i,

  input  logic                         test_en_i,     // enable all clock gates for testing
  input  logic                         cheri_pmode_i,
  input  logic                         cheri_tsafe_en_i,

  input  logic [31:0]                  hart_id_i,
  input  logic [31:0]                  boot_addr_i,

  // Instruction memory interface
  output logic                         instr_req_o,
  input  logic                         instr_gnt_i,
  input  logic                         instr_rvalid_i,
  output logic [31:0]                  instr_addr_o,
  input  logic [DataWidth-1:0]         instr_rdata_i,
  input  logic [6:0]                   instr_rdata_intg_i,
  input  logic                         instr_err_i,

  // Data memory interface
  output logic                         data_req_o,
  input  logic                         data_gnt_i,
  input  logic                         data_rvalid_i,
  output logic                         data_we_o,
  output logic                         data_is_cap_o,
  output logic [3:0]                   data_be_o,
  output logic [31:0]                  data_addr_o,
  output logic [DataWidth-1:0]         data_wdata_o,
  output logic [6:0]                   data_wdata_intg_o,
  input  logic [DataWidth-1:0]         data_rdata_i,
  input  logic [6:0]                   data_rdata_intg_i,
  input  logic                         data_err_i,

  // TS map memory interface
  output logic                         tsmap_cs_o,
  output logic [15:0]                  tsmap_addr_o,
  input  logic [DataWidth-1:0]         tsmap_rdata_i,

  input  logic [127:0]                 mmreg_corein_i,
  output logic [63:0]                  mmreg_coreout_o,

  // Interrupt inputs
  input  logic                         irq_software_i,
  input  logic                         irq_timer_i,
  input  logic                         irq_external_i,
  input  logic [14:0]                  irq_fast_i,
  input  logic                         irq_nm_i,       // non-maskeable interrupt

  // Scrambling Interface
  input  logic                         scramble_key_valid_i,
//  input  logic [SCRAMBLE_KEY_W-1:0]    scramble_key_i,
//  input  logic [SCRAMBLE_NONCE_W-1:0]  scramble_nonce_i,
  input  logic [128-1:0]    scramble_key_i,
  input  logic [64-1:0]  scramble_nonce_i,
  output logic                         scramble_req_o,

  // Debug Interface
  input  logic                         debug_req_i,
  //output crash_dump_t                  crash_dump_o,
  output logic                         double_fault_seen_o,

  // CPU Control Signals
  input  [3:0]                         fetch_enable_i,
  output logic                         alert_minor_o,
  output logic                         alert_major_internal_o,
  output logic                         alert_major_bus_o,
  output logic                         core_sleep_o,

  // DFT bypass controls
  input logic                          scan_rst_ni
);


  //prim_ram_1p_pkg::ram_1p_cfg_t ram_cfg_i,

  //assign ram_cfg_i = RAM_1P_CFG_DEFAULT;
  localparam int unsigned dRamBase = 32'h200f_0000;

  logic [15:0] tsmap_addr_cpu;
  logic       instr_addr_b2_q, data_addr_b2_q, tsmap_addr_b2_q;

  assign tsmap_addr_o = ((TSMapBase - dRamBase) >> 2) + tsmap_addr_cpu[13:0];


  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      instr_addr_b2_q <= 0;
      data_addr_b2_q  <= 0;
      tsmap_addr_b2_q <= 0;
    end else begin
       if (instr_gnt_i) instr_addr_b2_q <= instr_addr_o[2];
       if (data_gnt_i)  data_addr_b2_q  <= data_addr_o[2];
       if (tsmap_cs_o)  tsmap_addr_b2_q <= tsmap_addr_o[0];
    end
  end

//================================================
// IBEX core instance
//================================================
if (UseIbex) begin : gen_cheriot_ibex
  logic [31:0]          instr_rdata_ibex;
  logic [DataWidth-1:0] data_rdata_ibex;
  logic [31:0]          tsmap_rdata_ibex;

  ibex_top_tracing #(
      .DmHaltAddr       ( DmHaltAddr      ),
      .DmExceptionAddr  ( DmExceptionAddr ),
      .RV32B            ( ibex_pkg::RV32BFull),
      .HeapBase         ( HeapBase        ),
      .TSMapBase        ( TSMapBase       ),
      .TSMapSize        (2048),
      .MMRegDinW        (128),
      .MMRegDoutW       (64),
      .DataWidth        (DataWidth)

  ) ibex_top_i (

    // Clock and Reset
    .clk_i(clk_i),
    .rst_ni(rstn_i),

    .test_en_i(test_en_i),     // enable all clock gates for testing
    .scan_rst_ni(1'b1),
    .ram_cfg_i(10'h000),

    .cheri_pmode_i(cheri_pmode_i),
    .cheri_tsafe_en_i(cheri_tsafe_en_i),

    .hart_id_i(hart_id_i),
    .boot_addr_i(boot_addr_i),

    // Instruction memory interface
    .instr_req_o(instr_req_o),
    .instr_gnt_i(instr_gnt_i),
    .instr_rvalid_i(instr_rvalid_i),
    .instr_addr_o(instr_addr_o),
    .instr_rdata_i(instr_rdata_ibex),
    .instr_rdata_intg_i(instr_rdata_intg_i),
    .instr_err_i(instr_err_i),

    // Data memory interface
    .data_req_o(data_req_o),
    .data_is_cap_o(data_is_cap_o),
    .data_gnt_i(data_gnt_i),
    .data_rvalid_i(data_rvalid_i),
    .data_we_o(data_we_o),
    .data_be_o(data_be_o),
    .data_addr_o(data_addr_o),
    .data_wdata_o(data_wdata_o),
    .data_wdata_intg_o(data_wdata_intg_o),
    .data_rdata_i(data_rdata_ibex),
    .data_rdata_intg_i(data_rdata_intg_i),
    .data_err_i(data_err_i),

    .tsmap_cs_o(tsmap_cs_o), 
    .tsmap_addr_o(tsmap_addr_cpu),
    .tsmap_rdata_i(tsmap_rdata_ibex), 
    .tsmap_rdata_intg_i(7'h0), 

    .mmreg_corein_i  (mmreg_corein_i),
    .mmreg_coreout_o (mmreg_coreout_o),

    // Interrupt inputs
    .irq_software_i(irq_software_i),
    .irq_timer_i(irq_timer_i),
    .irq_external_i(irq_external_i),
    .irq_fast_i(irq_fast_i),
    .irq_nm_i(irq_nm_i),       // non-maskeable interrupt

    // Scrambling Interface
    .scramble_key_valid_i(scramble_key_valid_i),
    .scramble_key_i(scramble_key_i),
    .scramble_nonce_i(scramble_nonce_i),
    .scramble_req_o(scramble_req_o),

    // Debug Interface
    .debug_req_i(debug_req_i),
    .crash_dump_o(),
    .double_fault_seen_o(double_fault_seen_o),

    // CPU Control Signals
    .fetch_enable_i(fetch_enable_i),
  /*
    .alert_minor_o(alert_minor_o),
    .alert_major_internal_o(alert_major_internal_o),
    .alert_major_bus_o(alert_major_bus_o),
  */
    .core_sleep_o(core_sleep_o),
    .cheri_fatal_err_o ()
  );

  if (DataWidth == 65) begin
    assign instr_rdata_ibex = instr_addr_b2_q ? instr_rdata_i[63:32] : instr_rdata_i[31:0];
    assign data_rdata_ibex  = data_addr_b2_q ? {33'h0, data_rdata_i[63:32]} : data_rdata_i;
    assign tsmap_rdata_ibex = tsmap_addr_b2_q ? tsmap_rdata_i[63:32] : tsmap_rdata_i[31:0];
  end else begin
    assign instr_rdata_ibex = instr_rdata_i[31:0];
    assign data_rdata_ibex  = data_rdata_i;
    assign tsmap_rdata_ibex = tsmap_rdata_i[31:0];
  end
  
end else begin : gen_kudu
  logic [63:0] instr_rdata_kudu;
  logic [64:0] data_rdata_kudu;
  logic [31:0] tsmap_rdata_kudu;

  kudu_top #(
    .CHERIoTEn      (1'b1),
    .PipeCfg        (1),
    .HeapBase       (HeapBase),
    .TSMapSize      (2048)
  ) kudu_top_i (
    .clk_i                (clk_i       ),
    .rst_ni               (rstn_i      ),
    .hart_id_i            (hart_id_i   ),
    .cheri_pmode_i        (cheri_pmode_i ),
    .boot_addr_i          (boot_addr_i  ), // align with spike boot address
    .instr_req_o          (instr_req_o   ),
    .instr_gnt_i          (instr_gnt_i ),
    .instr_rvalid_i       (instr_rvalid_i),
    .instr_addr_o         (instr_addr_o  ),
    .instr_rdata_i        (instr_rdata_kudu),
    .instr_err_i          (instr_err_i   ),
    .data_req_o           (data_req_o    ),
    .data_gnt_i           (data_gnt_i    ),
    .data_rvalid_i        (data_rvalid_i ),
    .data_we_o            (data_we_o     ),
    .data_be_o            (data_be_o     ),
    .data_is_cap_o        (data_is_cap_o ),
    .data_addr_o          (data_addr_o   ),
    .data_wdata_o         (data_wdata_o  ),
    .data_rdata_i         (data_rdata_kudu),
    .data_err_i           (data_err_i    ),
    .tsmap_cs_o           (tsmap_cs_o    ),
    .tsmap_addr_o         (tsmap_addr_cpu),
    .tsmap_rdata_i        (tsmap_rdata_kudu),
    .cheri_fatal_err_o    (),
    .irq_software_i       (irq_software_i),
    .irq_timer_i          (irq_timer_i   ),
    .irq_external_i       (irq_external_i),
    .irq_fast_i           (irq_fast_i    ),
    .debug_req_i          (debug_req_i   )
  );

  assign instr_rdata_kudu = instr_rdata_i[63:0];
  assign data_rdata_kudu  = data_addr_b2_q ? {33'h0, data_rdata_i[63:32]} : data_rdata_i;
  assign tsmap_rdata_kudu = tsmap_addr_b2_q ? tsmap_rdata_i[63:32] : tsmap_rdata_i[31:0];

  assign mmreg_coreout_o         = 64'h0;
  assign alert_minor_o           = 1'b0;
  assign alert_major_internal_o  = 1'b0;
  assign alert_major_bus_o       = 1'b0;
  assign core_sleep_o            = 1'b0;
  assign double_fault_seen_o     = 1'b0;
end

endmodule
