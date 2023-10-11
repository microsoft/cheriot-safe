//import ibex_pkg::*;

module msftDvIp_cheri_core_wrapper import cheri_pkg::*; #(
    parameter DmHaltAddr      = 32'h1A11_0800,
    parameter DmExceptionAddr = 32'h1A110808,
    parameter HeapBase        = 32'h2004_0000,
    parameter TSMapBase       = 32'h200f_e000, // 4kB default
    parameter TSMapTop        = 32'h2010_0000

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
  input  logic [32:0]                  instr_rdata_i,
  input  logic [6:0]                   instr_rdata_intg_i,
  input  logic                         instr_err_i,

  // Data memory interface
  output logic                         data_req_o,
  input  logic                         data_gnt_i,
  input  logic                         data_rvalid_i,
  output logic                         data_we_o,
  output logic [3:0]                   data_be_o,
  output logic [31:0]                  data_addr_o,
  output logic [32:0]                  data_wdata_o,
  output logic [6:0]                   data_wdata_intg_o,
  input  logic [32:0]                  data_rdata_i,
  input  logic [6:0]                   data_rdata_intg_i,
  input  logic                         data_err_i,

  // TS map memory interface
  output logic                         tsmap_cs_o,
  output logic [15:0]                  tsmap_addr_o,
  input  logic [31:0]                  tsmap_rdata_i,

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
logic [15:0] tsmap_addr_ibexc;

assign tsmap_addr_o = ((TSMapBase - dRamBase) >> 2) + tsmap_addr_ibexc[13:0];

//================================================
// IBEX core instance
//================================================
ibex_top_tracing #(
    .DmHaltAddr       ( DmHaltAddr      ),
    .DmExceptionAddr  ( DmExceptionAddr ),
    .HeapBase         ( HeapBase        ),
    .TSMapBase        ( TSMapBase       ),
    .TSMapSize        (2048),
    .MMRegDinW        (128),
    .MMRegDoutW       (64)

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
  .instr_rdata_i(instr_rdata_i[31:0]),
  .instr_rdata_intg_i(instr_rdata_intg_i),
  .instr_err_i(instr_err_i),

  // Data memory interface
  .data_req_o(data_req_o),
  .data_is_cap_o(),
  .data_gnt_i(data_gnt_i),
  .data_rvalid_i(data_rvalid_i),
  .data_we_o(data_we_o),
  .data_be_o(data_be_o),
  .data_addr_o(data_addr_o),
  .data_wdata_o(data_wdata_o),
  .data_wdata_intg_o(data_wdata_intg_o),
  .data_rdata_i(data_rdata_i),
  .data_rdata_intg_i(data_rdata_intg_i),
  .data_err_i(data_err_i),

  .tsmap_cs_o(tsmap_cs_o), 
  .tsmap_addr_o(tsmap_addr_ibexc),
  .tsmap_rdata_i(tsmap_rdata_i), 
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
  .core_sleep_o(core_sleep_o)
);

//============================================
// Core stuff
//============================================
// synthesis translate_off
`define CHERI_RF_PATH   ibex_top_i.u_ibex_top.genblk1.register_file_i
`define CHERI_CORE_PATH ibex_top_i.u_ibex_top.u_ibex_core
`define CHERI_PCC_PATH  `CHERI_CORE_PATH.cs_registers_i

wire [31:0] AR_ZERO  = 32'h0000_0000;
wire [31:0] AR_RA  = `CHERI_RF_PATH.rf_reg_q[1];
wire [31:0] AR_SP  = `CHERI_RF_PATH.rf_reg_q[2];
wire [31:0] AR_GP  = `CHERI_RF_PATH.rf_reg_q[3];
wire [31:0] AR_TP  = `CHERI_RF_PATH.rf_reg_q[4];
wire [31:0] AR_T0  = `CHERI_RF_PATH.rf_reg_q[5];
wire [31:0] AR_T1  = `CHERI_RF_PATH.rf_reg_q[6];
wire [31:0] AR_T2  = `CHERI_RF_PATH.rf_reg_q[7];
wire [31:0] AR_S0  = `CHERI_RF_PATH.rf_reg_q[8];
wire [31:0] AR_S1  = `CHERI_RF_PATH.rf_reg_q[9];
wire [31:0] AR_A0  = `CHERI_RF_PATH.rf_reg_q[10];
wire [31:0] AR_A1  = `CHERI_RF_PATH.rf_reg_q[11];
wire [31:0] AR_A2  = `CHERI_RF_PATH.rf_reg_q[12];
wire [31:0] AR_A3  = `CHERI_RF_PATH.rf_reg_q[13];
wire [31:0] AR_A4  = `CHERI_RF_PATH.rf_reg_q[14];
wire [31:0] AR_A5  = `CHERI_RF_PATH.rf_reg_q[15];
wire [31:0] AR_A6  = `CHERI_RF_PATH.rf_reg_q[16];
wire [31:0] AR_A7  = `CHERI_RF_PATH.rf_reg_q[17];
wire [31:0] AR_S2  = `CHERI_RF_PATH.rf_reg_q[18];
wire [31:0] AR_S3  = `CHERI_RF_PATH.rf_reg_q[19];
wire [31:0] AR_S4  = `CHERI_RF_PATH.rf_reg_q[20];
wire [31:0] AR_S5  = `CHERI_RF_PATH.rf_reg_q[21];
wire [31:0] AR_S6  = `CHERI_RF_PATH.rf_reg_q[22];
wire [31:0] AR_S7  = `CHERI_RF_PATH.rf_reg_q[23];
wire [31:0] AR_S8  = `CHERI_RF_PATH.rf_reg_q[24];
wire [31:0] AR_S9  = `CHERI_RF_PATH.rf_reg_q[25];
wire [31:0] AR_S10 = `CHERI_RF_PATH.rf_reg_q[26];
wire [31:0] AR_S11 = `CHERI_RF_PATH.rf_reg_q[27];
wire [31:0] AR_T3  = `CHERI_RF_PATH.rf_reg_q[28];
wire [31:0] AR_T4  = `CHERI_RF_PATH.rf_reg_q[29];
wire [31:0] AR_T5  = `CHERI_RF_PATH.rf_reg_q[30];
wire [31:0] AR_T6  = `CHERI_RF_PATH.rf_reg_q[31];
wire [31:0] PCC    = `CHERI_PCC_PATH.pc_id_i;

wire [31:0] PC_IF  = `CHERI_CORE_PATH.pc_if[31:0];
wire [31:0] PC_ID  = `CHERI_CORE_PATH.pc_id[31:0];

wire [31:0] CSR_DEPC = `CHERI_CORE_PATH.csr_depc[31:0];
wire [31:0] CSR_MEPC = `CHERI_CORE_PATH.csr_mepc[31:0]; 
wire [31:0] CSR_MTVAL = `CHERI_CORE_PATH.csr_mtval[31:0];
wire [31:0] CSR_MTVEC = `CHERI_CORE_PATH.csr_mtvec[31:0];

wire [31:0] CSR_MCAUSE = {26'h0, `CHERI_CORE_PATH.cs_registers_i.csr_mcause_i[5:0]};

wire CC_lsu_req        = `CHERI_CORE_PATH.load_store_unit_i.lsu_req_i;
wire CC_lsu_cheri_error = `CHERI_CORE_PATH.load_store_unit_i.lsu_cheri_err_i;
wire CC_perm_vio       = `CHERI_CORE_PATH.g_cheri_ex.u_cheri_ex.perm_vio;

wire CC_addr_bound_vio    = `CHERI_CORE_PATH.g_cheri_ex.u_cheri_ex.addr_bound_vio;
wire [32:0] CC_top_bound  = `CHERI_CORE_PATH.g_cheri_ex.u_cheri_ex.check_cheri.top_bound;
wire [31:0] CC_base_bound = `CHERI_CORE_PATH.g_cheri_ex.u_cheri_ex.check_cheri.base_bound;
wire [32:0] CC_check_addr = `CHERI_CORE_PATH.g_cheri_ex.u_cheri_ex.check_cheri.base_chkaddr;

wire CC_vio = CC_lsu_req & CC_lsu_cheri_error;

wire CM_pmode = `CHERI_CORE_PATH.cheri_pmode_i;


reg_cap_t AR_CRA, AR_CSP, AR_CGP, AR_CTP; 
reg_cap_t AR_CT0, AR_CT1, AR_CT2, AR_CT3, AR_CT4, AR_CT5, AR_CT6; 
reg_cap_t AR_CA0, AR_CA1, AR_CA2, AR_CA3, AR_CA4, AR_CA5, AR_CA6, AR_CA7; 
reg_cap_t AR_CS0, AR_CS1, AR_CS2, AR_CS3, AR_CS4, AR_CS5, AR_CS6, AR_CS7, AR_CS8, AR_CS9, AR_CS10, AR_CS11;
pcc_cap_t CPCC;

assign AR_CRA  = `CHERI_RF_PATH.rf_cap_q[1];
assign AR_CSP  = `CHERI_RF_PATH.rf_cap_q[2];
assign AR_CGP  = `CHERI_RF_PATH.rf_cap_q[3];
assign AR_CTP  = `CHERI_RF_PATH.rf_cap_q[4];
assign AR_CT0  = `CHERI_RF_PATH.rf_cap_q[5];
assign AR_CT1  = `CHERI_RF_PATH.rf_cap_q[6];
assign AR_CT2  = `CHERI_RF_PATH.rf_cap_q[7];
assign AR_CS0  = `CHERI_RF_PATH.rf_cap_q[8];
assign AR_CS1  = `CHERI_RF_PATH.rf_cap_q[9];
assign AR_CA0  = `CHERI_RF_PATH.rf_cap_q[10];
assign AR_CA1  = `CHERI_RF_PATH.rf_cap_q[11];
assign AR_CA2  = `CHERI_RF_PATH.rf_cap_q[12];
assign AR_CA3  = `CHERI_RF_PATH.rf_cap_q[13];
assign AR_CA4  = `CHERI_RF_PATH.rf_cap_q[14];
assign AR_CA5  = `CHERI_RF_PATH.rf_cap_q[15];
assign AR_CA6  = `CHERI_RF_PATH.rf_cap_q[16];
assign AR_CA7  = `CHERI_RF_PATH.rf_cap_q[17];
assign AR_CS2  = `CHERI_RF_PATH.rf_cap_q[18];
assign AR_CS3  = `CHERI_RF_PATH.rf_cap_q[19];
assign AR_CS4  = `CHERI_RF_PATH.rf_cap_q[20];
assign AR_CS5  = `CHERI_RF_PATH.rf_cap_q[21];
assign AR_CS6  = `CHERI_RF_PATH.rf_cap_q[22];
assign AR_CS7  = `CHERI_RF_PATH.rf_cap_q[23];
assign AR_CS8  = `CHERI_RF_PATH.rf_cap_q[24];
assign AR_CS9  = `CHERI_RF_PATH.rf_cap_q[25];
assign AR_CS10 = `CHERI_RF_PATH.rf_cap_q[26];
assign AR_CS11 = `CHERI_RF_PATH.rf_cap_q[27];
assign AR_CT3  = `CHERI_RF_PATH.rf_cap_q[28];
assign AR_CT4  = `CHERI_RF_PATH.rf_cap_q[29];
assign AR_CT5  = `CHERI_RF_PATH.rf_cap_q[30];
assign AR_CT6  = `CHERI_RF_PATH.rf_cap_q[31];
assign CPCC = `CHERI_PCC_PATH.pcc_cap_q;

typedef struct packed {
  logic VALID;
  logic ERROR;
  logic U1;
  logic U0;
  logic SE;
  logic US;
  logic EX;
  logic SR;
  logic MC;
  logic LD;
  logic SL;
  logic LM;
  logic SD;
  logic LG;
  logic GL;
  logic bound_err;
  logic [32:0] TOP;
  logic [31:0] ADDR;
  logic [31:0] BASE;
} cap_bits_t;

function cap_bits_t getFullCap(pcc_cap_t pcc_cap, input [31:0] addr);
  getFullCap.VALID = pcc_cap.valid;
  getFullCap.ERROR = CC_vio;
  getFullCap.U1    = pcc_cap.perms[12];
  getFullCap.U0    = pcc_cap.perms[11];
  getFullCap.SE    = pcc_cap.perms[10];
  getFullCap.US    = pcc_cap.perms[9];
  getFullCap.EX    = pcc_cap.perms[8];
  getFullCap.SR    = pcc_cap.perms[7];
  getFullCap.MC    = pcc_cap.perms[6];
  getFullCap.LD    = pcc_cap.perms[5];
  getFullCap.SL    = pcc_cap.perms[4];
  getFullCap.LM    = pcc_cap.perms[3];
  getFullCap.SD    = pcc_cap.perms[2];
  getFullCap.LG    = pcc_cap.perms[1];
  getFullCap.GL    = pcc_cap.perms[0];
  getFullCap.TOP  = pcc_cap.top33;
  getFullCap.ADDR = addr;
  getFullCap.BASE = pcc_cap.base32;
  getFullCap.bound_err = (getFullCap.ADDR < getFullCap.BASE) | (getFullCap.ADDR > getFullCap.TOP);

endfunction

function cap_bits_t getCap(reg_cap_t cap, input [31:0] addr);
  getCap.VALID = cap.valid;
  getCap.ERROR = CC_vio;
  getCap.GL=cap.cperms[5]; 
  getCap.U1=1'b0;
  getCap.U0=1'b0;
  getCap.U1=1'b0; 
  getCap.EX=1'b0; 
  getCap.SR=1'b0; 
  getCap.SE=1'b0; 
  getCap.US=1'b0; 
  getCap.SL=1'b0; 
  getCap.LM=1'b0; 
  getCap.LG=1'b0; 
  getCap.MC=1'b0; 
  getCap.SD=1'b0; 
  getCap.LD=1'b0;
  getCap.TOP  = get_bound33(cap.top,  cap.top_cor,  cap.exp, addr);
  getCap.ADDR = addr;
  getCap.BASE = get_bound33(cap.base, cap.base_cor, cap.exp, addr);
  getCap.bound_err = (getCap.ADDR < getCap.BASE) | (getCap.ADDR > getCap.TOP);
  casez(cap.cperms[4:2])
    3'b11?: begin
      getCap.LD = 1'b1;
      getCap.MC = 1'b1;
      getCap.SD = 1'b1;
      getCap.SL = cap.cperms[2];
      getCap.LM = cap.cperms[1];
      getCap.LG = cap.cperms[0];
    end
    3'b101: begin
      getCap.LD = 1'b1;
      getCap.MC = 1'b1;
      getCap.SD = cap.cperms[1];
      getCap.LG = cap.cperms[0];
    end
    5'b100: begin
      if(|cap.cperms[1:0]) begin
        getCap.LD = cap.cperms[1];
        getCap.SD = cap.cperms[0];
      end else begin
        getCap.SD = 1'b1;
        getCap.MC = 1'b1;
      end
    end
    3'b01?: begin
      getCap.EX = 1'b1;
      getCap.LD = 1'b1;
      getCap.MC = 1'b1;
      getCap.SR = cap.cperms[2];
      getCap.LM = cap.cperms[1];
      getCap.LG = cap.cperms[0];
    end
    3'b00?: begin
      getCap.U0 = cap.cperms[2];
      getCap.SE = cap.cperms[1];
      getCap.US = cap.cperms[0];
    end
  endcase
endfunction

cap_bits_t CAP_RA, CAP_SP, CAP_GP, CAP_TP; 
cap_bits_t CAP_T0, CAP_T1, CAP_T2, CAP_T3, CAP_T4, CAP_T5, CAP_T6; 
cap_bits_t CAP_A0, CAP_A1, CAP_A2, CAP_A3, CAP_A4, CAP_A5, CAP_A6, CAP_A7; 
cap_bits_t CAP_S0, CAP_S1, CAP_S2, CAP_S3, CAP_S4, CAP_S5, CAP_S6, CAP_S7, CAP_S8, CAP_S9, CAP_S10, CAP_S11;
cap_bits_t CAP_PCC;

assign CAP_RA  = getCap(AR_CRA,  AR_RA);
assign CAP_SP  = getCap(AR_CSP,  AR_SP);
assign CAP_GP  = getCap(AR_CGP,  AR_GP);
assign CAP_TP  = getCap(AR_CTP,  AR_TP);

assign CAP_T0  = getCap(AR_CT0,  AR_T0);
assign CAP_T1  = getCap(AR_CT1,  AR_T1);
assign CAP_T2  = getCap(AR_CT2,  AR_T2);
assign CAP_T3  = getCap(AR_CT3,  AR_T3);
assign CAP_T4  = getCap(AR_CT4,  AR_T4);
assign CAP_T5  = getCap(AR_CT5,  AR_T5);
assign CAP_T6  = getCap(AR_CT6,  AR_T6);

assign CAP_A0  = getCap(AR_CA0,  AR_A0);
assign CAP_A1  = getCap(AR_CA1,  AR_A1);
assign CAP_A2  = getCap(AR_CA2,  AR_A2);
assign CAP_A3  = getCap(AR_CA3,  AR_A3);
assign CAP_A4  = getCap(AR_CA4,  AR_A4);
assign CAP_A5  = getCap(AR_CA5,  AR_A5);
assign CAP_A6  = getCap(AR_CA6,  AR_A6);
assign CAP_A7  = getCap(AR_CA7,  AR_A7);

assign CAP_S0  = getCap(AR_CS0,  AR_S0);
assign CAP_S1  = getCap(AR_CS1,  AR_S1);
assign CAP_S2  = getCap(AR_CS2,  AR_S2);
assign CAP_S3  = getCap(AR_CS3,  AR_S3);
assign CAP_S4  = getCap(AR_CS4,  AR_S4);
assign CAP_S5  = getCap(AR_CS5,  AR_S5);
assign CAP_S6  = getCap(AR_CS6,  AR_S6);
assign CAP_S7  = getCap(AR_CS7,  AR_S7);
assign CAP_S8  = getCap(AR_CS8,  AR_S8);
assign CAP_S9  = getCap(AR_CS9,  AR_S9);
assign CAP_S10 = getCap(AR_CS10, AR_S10);
assign CAP_S11 = getCap(AR_CS11, AR_S11);

assign CAP_PCC  = getFullCap(CPCC, PCC);

// synthesis translate_on

endmodule
