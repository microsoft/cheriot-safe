#pragma once

#include "jtag_iface.h"

//======================================
// RISCV_JTAG_LIB
//======================================
class RISCV_JTAG_DRIVER {

  #define JTAG_IR_DTM_CTL_STS    16 // SIFIVE
  #define JTAG_IR_DMI_IFC_ACCESS 17 // SIFIVE

  #define DMI_RD_OP 1
  #define DMI_WR_OP 2

  #define ABSTRACT_DATA0      0x04
  #define ABSTRACT_DATA11     0x0F
  #define DBG_MOD_CONTROL     0x10
  #define DBG_MOD_STATUS      0x11
  #define HART_INFO           0x12
  #define HART_SUMMARY0       0x40
  #define HART_SUMMARY1       0x13
  #define HART_SUMMARY2       0x34
  #define HART_SUMMARY3       0x35
  #define HART_ARY_WDW_SEL    0x14
  #define HART_ARY_WDW        0x15
  #define ABSTRT_CMD_STAT     0x16
  #define ABSTRT_CMD          0x17
  #define ABSTRT_CMD_AUTO     0x18
  #define CFG_STR_ADDR0       0x19
  #define CFG_STR_ADDR1       0x1A
  #define CFG_STR_ADDR2       0x1B
  #define CFG_STR_ADDR3       0x1C
  #define NEXT_DM             0x1D
  #define PROG_BUF0           0x20
  #define PROG_BUF1           0x21
  #define PROG_BUF2           0x22
  #define PROG_BUF3           0x23
  #define PROG_BUF4           0x24
  #define PROG_BUF5           0x25
  #define PROG_BUF6           0x26
  #define PROG_BUF7           0x27
  #define PROG_BUF8           0x28
  #define PROG_BUF9           0x29
  #define PROG_BUF10          0x2A
  #define PROG_BUF11          0x2B
  #define PROG_BUF12          0x2C
  #define PROG_BUF13          0x2D
  #define PROG_BUF14          0x2E
  #define PROG_BUF15          0x2F
  #define AUTH_DATA           0x30
  #define SER_CTRL_STAT       0x34
  #define SER_TX_DATA         0x35
  #define SER_RX_DATA         0x36
  #define SYS_BUS_ACC_CTL_S   0x38
  #define SYS_BUS_ADDR_31_0   0x39
  #define SYS_BUS_ADDR_63_32  0x3A
  #define SYS_BUS_ADDR_95_64  0x3B
  #define SYS_BUS_ADDR_127_96 0x37
  #define SYS_BUS_DATA_31_0   0x3C
  #define SYS_BUS_DATA_63_32  0x3D
  #define SYS_BUS_DATA_95_64  0x3E
  #define SYS_BUS_DATA_127_96 0x3F

  // CSR
  #define DBG_CTRL_STAT       0x7b0
  #define DBG_PC              0x7b1
  #define DBG_SCRATCH0        0x7b2
  #define DBG_SCRATCH1        0x7b3

  // GPR
  #define GPR_BASE            0x1000

  typedef struct __attribute__((__packed__)) IDCODE_s {
    uint8_t  _d1        : 1;
    uint16_t manufld    : 11;
    uint16_t partnumber : 16;
    uint8_t  version    : 4;
  } IDCODE_t, *pIDCODE_t;

  typedef struct __attribute__((__packed__)) DTM_STAT_s {
    uint32_t  version     : 4;
    uint32_t  abits       : 6;
    uint32_t  dmistat     : 2;
    uint32_t  idle        : 3;
    uint32_t  _d1         : 1;
    uint32_t  dmireset    : 1;
    uint32_t  dmihardreset: 1;
    uint32_t _d2         : 14;
  } DTM_STAT_t, *pDTM_STAT_t;

  typedef struct __attribute__((__packed__)) DM_STAT_s
  {
    uint8_t  version         : 4;
    uint8_t  confstrptrvalid : 1;
    uint8_t  hasresethaltreq : 1;
    uint8_t  authbusy        : 1;
    uint8_t  authenticated   : 1;
    uint8_t  anyhalted       : 1;
    uint8_t  allhalted       : 1;
    uint8_t  anyrunning      : 1;
    uint8_t  allrunning      : 1;
    uint8_t  anyunavail      : 1;
    uint8_t  allunavail      : 1;
    uint8_t  anynonexistent  : 1;
    uint8_t  allnonexistent  : 1;
    uint8_t  anyresumeack    : 1;
    uint8_t  allresumeack    : 1;
    uint8_t  anyhavereset    : 1;
    uint8_t  allhavereset    : 1;
    uint8_t  _d1             : 2;
    uint8_t  impebreak       : 1;
    uint16_t _d2             : 9;
  } DM_STAT_t, *pDM_STAT_t;

  typedef struct __attribute__((__packed__)) DM_CTRL_s
  {
    uint8_t  dmactive        : 1;
    uint8_t  ndmreset        : 1;
    uint8_t  clrresethaltreq : 1;
    uint8_t  setresethaltreq : 1;
    uint8_t  _d1             : 2;
    uint16_t hartselhi       : 10;
    uint16_t hartsello       : 10;
    uint8_t  hasel           : 1;
    uint8_t  _d2             : 1;
    uint8_t  ackhavereset    : 1;
    uint8_t  hartreset       : 1;
    uint8_t  resumereq       : 1;
    uint8_t  haltreq         : 1;
  } DM_CTRL_t, *pDM_CTRL_t;

  typedef struct __attribute__((__packed__)) DM_HARTINFO_s
  {
    uint16_t dataaddr   : 12;
    uint8_t  datasize   : 4;
    uint8_t  dataaccess : 1;
    uint8_t  _d1        : 3;
    uint8_t  nscratch   : 4;
    uint8_t  _d2        : 8;
  } DM_HARTINFO_t, *pDM_HARTINFO_t;

  typedef struct __attribute__((__packed__)) DM_ABSTRACTCS_s
  {
    uint8_t  datacount   : 4;
    uint8_t  _d1         : 4;
    uint8_t  cmderr      : 3;
    uint8_t  _d2         : 1;
    uint8_t  busy        : 1;
    uint16_t _d3         : 11;
    uint8_t  progbufsize : 5;
    uint16_t _d4         : 3;
  } DM_ABSTRACTCS_t, *pDM_ABSTRACTCS_t;

  typedef struct __attribute__((__packed__)) DM_ABSTRACTCMD_s
  {
    uint32_t control : 24;
    uint8_t  cmdtype : 8;
  } DM_ABSTRACTCMD_t, *pDM_ABSTRACTCMD_t;

  typedef struct __attribute__((__packed__)) DM_ABSTRACTAUTO_s
  {
    uint16_t autoexecdata    : 12;
    uint8_t  _d1             : 4;
    uint16_t autoexecprogbuf : 16;
  } DM_ABSTRACTAUTO_t, *pDM_ABSTRACTAUTO_t;

  typedef struct __attribute__((__packed__)) ABSTRACTCMD_AR_s
  {
    uint16_t regno            : 16;
    uint8_t  write            : 1;
    uint8_t  transfer         : 1;
    uint8_t  postexec         : 1;
    uint8_t  aarpostincrement : 1;
    uint8_t  aarsize          : 3;
    uint8_t  _d1              : 1;
  } ABSTRACTCMD_AR_t, *pABSTRACTCMD_AR_t;

  typedef struct __attribute__((__packed__)) ABSTRACTCMD_AM_s
  {
    uint16_t _d1              : 14;
    uint8_t  target_specific  : 2;
    uint8_t  write            : 1;
    uint8_t  _d2              : 2;
    uint8_t  aampostincrement : 1;
    uint8_t  aamsize          : 3;
    uint8_t  aamvirtual       : 1;
  } ABSTRACTCMD_AM_t, *pABSTRACTCMD_AM_t;

  typedef struct __attribute__((__packed__)) DM_SBCS_s
  {
    uint32_t sbaccess8       : 1;
    uint32_t sbaccess16      : 1;
    uint32_t sbaccess32      : 1;
    uint32_t sbaccess64      : 1;
    uint32_t sbaccess128     : 1;
    uint32_t sbasize         : 7;
    uint32_t sberror         : 3;
    uint32_t sbreadondata    : 1;
    uint32_t sbautoincrement : 1;
    uint32_t sbaccess        : 3;
    uint32_t sbreadonaddr    : 1;
    uint32_t sbbusy          : 1;
    uint32_t sbbusyerror     : 1;
    uint32_t _d1             : 6;
    uint32_t sbversion       : 3;
  } DM_SBCS_t, *pDM_SBCS_t;

  typedef struct __attribute__((__packed__)) CDR_DCSR_s
  {
    uint32_t  prv       : 2;
    uint32_t  step      : 1;
    uint32_t  nmip      : 1;
    uint32_t  mprven    : 1;
    uint32_t  _d1       : 1;
    uint32_t  cause     : 3;
    uint32_t  stoptime  : 1;
    uint32_t  stopcount : 1;
    uint32_t  stepie    : 1;
    uint32_t  ebreaku   : 1;
    uint32_t  ebreaks   : 1;
    uint32_t  _d2       : 1;
    uint32_t  ebreakm   : 1;
    uint32_t _d3       : 12;
    uint32_t  xdebugver : 4;
  } CDR_DCSR_t, *pCDR_DCSR_t;

  typedef struct __attribute__((__packed__)) ITYPE_INSTR_s
  {
    uint32_t  opcode : 7;
    uint32_t  rd     : 5;
    uint32_t  funct3 : 3;
    uint32_t  rs1    : 5;
    uint32_t imm    : 12;
  } ITYPE_INSTR_t, *pITYPE_INSTR_t;
  #define CSRRW(a,s,d)    ( (a<<20) | (s<<15) | (0x1<<12) | ((d&0x1f)<<7) | 0x73 )
  #define CSRRS(a,s,d)    ( (a<<20) | (s<<15) | (0x2<<12) | ((d&0x1f)<<7) | 0x73 )
  #define CSRRC(a,s,d)    ( (a<<20) | (s<<15) | (0x3<<12) | ((d&0x1f)<<7) | 0x73 )

  typedef enum {
    JTAG_RISCV_ABSCMD_ACCESSREG   = 0x0,
    JTAG_RISCV_ABSCMD_QUICKACCESS = 0x1,
    JTAG_RISCV_ABSCMD_ACCESSMEM   = 0x2,
  } JTAG_RISCV_ABSCMD_t;

  typedef enum {
    REG_ZERO = GPR_BASE,
    REG_RA,
    REG_SP,
    REG_GP,
    REG_TP,
    REG_T0,
    REG_T1,
    REG_T2,
    REG_S0,
    REG_S1,
    REG_A0,
    REG_A1,
    REG_A2,
    REG_A3,
    REG_A4,
    REG_A5,
    REG_A6,
    REG_A7,
    REG_S2,
    REG_S3,
    REG_S4,
    REG_S5,
    REG_S6,
    REG_S7,
    REG_S8,
    REG_S9,
    REG_S10,
    REG_S11,
    REG_T3,
    REG_T4,
    REG_T5,
    REG_T6
  } JTAG_RISCV_REGS_t;

  typedef enum {
    CSR_MSTATUS_ADDR=0x300,
    CSR_MIE_ADDR=0x304,
    CSR_MTVEC_ADDR=0x305,

    CSR_MSCRATCH_ADDR=0x340,
    CSR_MEPC_ADDR=0x341,
    CSR_MCAUSE_ADDR=0x342,
    CSR_MTVAL_ADDR=0x343,
    CSR_MIP_ADDR=0x344,

    CSR_DSCR_ADDR=0x7b0,
    CSR_DPC_ADDR=0x7b1,

  } CSR_ADDR_t;

  typedef struct {
    uint32_t gpr[32];
    uint32_t dscr;
    uint32_t dpc;
    uint32_t mstatus;
    uint32_t misa;
    uint32_t mie;
    uint32_t mtvec;

    uint32_t mscratch;
    uint32_t mepc;
    uint32_t mcause;
    uint32_t mtval;
    uint32_t mip;

    uint32_t mtvt;
    uint32_t mnxti;
    uint32_t mintstatus;

    uint32_t clicintip;
    uint32_t clicintie;
    uint32_t clicintcfg;
    uint32_t cliccfg;

  } RISCV_DBG_STATUS_t;


  #ifdef BIFROST_TEST
    #define PRINTFUNC hw_status
  #elif USE_PPRINTF 
    #define PRINTFUNC pprintf
  #else
    #define PRINTFUNC printf
  #endif


  #define PRINT_VERBOSE(veb, fmt, args...) \
    if(verbosity >= veb) PRINTFUNC(fmt, ## args)

  uint8_t verbosity;

  public:
  JTAG_IFACE *jfc;
  uint8_t riscv_tap;
  uint32_t m_dtmStat;

  RISCV_JTAG_DRIVER(JTAG_IFACE * jfc_in, uint8_t tap) {
    jfc = jfc_in;
    riscv_tap = tap;
    verbosity = 0;
    m_dtmStat = 0xffffffff;
  }

  void set_verbosity(uint8_t veb)
  {
    verbosity = veb;
  }

  void setRiscvTap(uint8_t tap)
  {
    riscv_tap = tap;
    m_dtmStat = 0xffffffff;
  }

  void setDMActive(uint8_t value)
  {
    if(m_dtmStat == 0xffffffff) {
      readDTMStatus();
    }
    DM_CTRL_t dmcontrol = {0};
    dmcontrol.dmactive  = value;
    writeDMControl((uint32_t*)&dmcontrol);
  }

  void setnDMReset(uint8_t value)
  {
    DM_CTRL_t dmcontrol = {0};
    dmcontrol.ndmreset  = value;
    writeDMControl((uint32_t*)&dmcontrol);
  }

  // Read ID Code Register
  uint32_t readIDCode()
  {
    uint32_t idcode;
    pIDCODE_t pidc;
    idcode = jfc->getTapIdcode(riscv_tap);
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - "
                  "IDCODE: 0x%x, "
                  "MANUFLD: 0x%0x, "
                  "PARTNUMBER: 0x%0x, "
                  "VERSION: 0x%0x\n",
                  riscv_tap,
                  *pidc,
                  pidc->manufld,
                  pidc->partnumber,
                  pidc->version);
    return idcode;
  }

  // Read DTM Status Register
  uint32_t readDTMStatus(uint32_t check=0)
  {
    jfc->send_tap_ir(riscv_tap, JTAG_IR_DTM_CTL_STS);

    m_dtmStat = 0xA0000000;
    jfc->send_tap_dr(riscv_tap, 32, &m_dtmStat);
    pDTM_STAT_t pdtm = (pDTM_STAT_t)&m_dtmStat;

    printDTMStatus(pdtm);

    if(check != 0 && m_dtmStat != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) -  Error...DTM_STAT Exp:0x%0x Obs:0x%0x\n",
                    riscv_tap,check,m_dtmStat);
      //setError();
    }
    return m_dtmStat;
  }

  // Print the Decoded DTM Status Register
  void printDTMStatus(pDTM_STAT_t pdtm)
  {
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - DTM STAT 0x%x: "
                  "VERSION:%x ABITS:%d DMISTAT:%d IDLE:%d\n",
                  riscv_tap, *pdtm, pdtm->version, pdtm->abits, pdtm->dmistat, pdtm->idle);
  }

  // Read DMI Register
  uint32_t readDMIReg(uint32_t addr)
  {
    PRINT_VERBOSE(2,"RISCV_TAP(%0d) - Reading DMI register 0x%0x\n", riscv_tap, addr);
    uint64_t data;
    jfc->send_tap_ir(riscv_tap, JTAG_IR_DMI_IFC_ACCESS);

    data = ((uint64_t)addr << 34) | DMI_RD_OP;
    PRINT_VERBOSE(2,"RISCV_TAP(%0d) - set DMI = 0x%llx\n", riscv_tap, data);

    pDTM_STAT_t pdtm = (pDTM_STAT_t)&m_dtmStat;
    jfc->send_tap_dr(riscv_tap, pdtm->abits+34, (uint32_t*)&data);
    jfc->idle_clocks(5);
    jfc->send_tap_dr(riscv_tap, pdtm->abits+34, (uint32_t*)&data);
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - READ DMI DATA: 0x%llx\n",riscv_tap, data);
    if(data & 0x3) {
      PRINT_VERBOSE(1,"RISCV_TAP(%0d) - READ DMI ERROR 0x%llx\n",riscv_tap,data&0x3);
    }
    data = (data >> 2) & 0xffffffff;
    return (uint32_t)data;
  }

  uint32_t readDMStatus(uint32_t check=0)
  {
    uint32_t status = readDMIReg(DBG_MOD_STATUS);
    pDM_STAT_t pdm = (pDM_STAT_t)&status;
    PRINT_VERBOSE(1,
                 "RISCV_TAP(%0d) - "
                 "READ DMSTATUS: 0x%x, "
                 "VERSION:0x%x, "
                 "CONFSTRPTRVALID:0x%x, "
                 "HASRESETHALTREQ:0x%x, "
                 "AUTHBUSY:0x%x, "
                 "AUTHENTICATED:0x%x, "
                 "ANYHALTED:0x%x, "
                 "ALLHALTED:0x%x, "
                 "ANYRUNNING:0x%x, "
                 "ALLRUNNING:0x%x, "
                 "ANYUNAVAIL:0x%x, "
                 "ALLUNAVAIL:0x%x, "
                 "ANYNONEXISTENT:0x%x, "
                 "ALLNONEXISTENT:0x%x, "
                 "ANYRESUMEACK:0x%x, "
                 "ALLRESUMEACK:0x%x, "
                 "ANYHAVERESET:0x%x, "
                 "ALLHAVERESET:0x%x, "
                 "IMPEBREAK:0x%x\n",
                 riscv_tap,
                 *pdm,
                 pdm->version,
                 pdm->confstrptrvalid,
                 pdm->hasresethaltreq,
                 pdm->authbusy,
                 pdm->authenticated,
                 pdm->anyhalted,
                 pdm->allhalted,
                 pdm->anyrunning,
                 pdm->allrunning,
                 pdm->anyunavail,
                 pdm->allunavail,
                 pdm->anynonexistent,
                 pdm->allnonexistent,
                 pdm->anyresumeack,
                 pdm->allresumeack,
                 pdm->anyhavereset,
                 pdm->allhavereset,
                 pdm->impebreak);
    if(check && status != check)
    {
      PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Error...DMSTATUS Exp:0x%0x  Obs:0x%0x\n", riscv_tap, check, status);
      //setError();
    }
    return status;
  }

  uint32_t readDMControl(uint32_t check=0)
  {
    uint32_t dmcontrol = readDMIReg(DBG_MOD_CONTROL);
    printDMControl(dmcontrol);
    if(check && dmcontrol != check)
    {
      PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Error...DMCONTROL Exp:0x%0x  Obs:0x%0x\n", check, dmcontrol);
      //setError();
    }
    return dmcontrol;
  }

  uint32_t readHartInfo(uint32_t check=0)
  {
    uint32_t hartinfo = readDMIReg(HART_INFO);
    pDM_HARTINFO_t pdm = (pDM_HARTINFO_t)&hartinfo;
    PRINT_VERBOSE(1,
                 "RISCV_TAP(%0d) - "
                 "READ HARTINFO: 0x%0x, "
                 "DATAADDR: 0x%0x, "
                 "DATASIZE: 0x%0x, "
                 "DATAACCESS: 0x%0x, "
                 "NSCRATCH: 0x%0x\n",
                 riscv_tap,
                 *pdm,
                 pdm->dataaddr,
                 pdm->datasize,
                 pdm->dataaccess,
                 pdm->nscratch);
    if(check && hartinfo != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...HARTINFO Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, check, hartinfo);
      //setError();
    }
    return hartinfo;
  }

  uint32_t readHartWindowSel(uint32_t check=0)
  {
    uint32_t hawindowsel = readDMIReg(HART_ARY_WDW_SEL);
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - READ HAWINDOWSEL: 0x%0x\n",riscv_tap,hawindowsel);
    if (check && hawindowsel != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...HAWINDOWSEL Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, check, hawindowsel);
      //setError();
    }
    return hawindowsel;
  }

  uint32_t readHartWindow(uint32_t check=0)
  {
    uint32_t hawindow = readDMIReg(HART_ARY_WDW);
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - READ HAWINDOW: 0x%0x\n",riscv_tap,hawindow);
    if (check && hawindow != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...HAWINDOW Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, check, hawindow);
      //setError();
    }
    return hawindow;
  }

  uint32_t readAbstractStatus(uint32_t check=0) {
    uint32_t abstractcs = readDMIReg(ABSTRT_CMD_STAT);
    printAbstractCS(abstractcs);
    if (check && abstractcs != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...ABSTRACTCS Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, check, abstractcs);
      //setError();
    }
    return abstractcs;
  }

  uint32_t readAbstractAuto(uint32_t check=0) {
    uint32_t abstractauto = readDMIReg(ABSTRT_CMD_AUTO);
    printAbstractAuto(abstractauto);
    if (check && abstractauto != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...ABSTRACTAUTO Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, check, abstractauto);
      //setError();
    }
    return abstractauto;
  }

  uint32_t readConfigurationPtr(uint32_t ptrnumber, uint32_t check=0)
  {
    uint32_t confstrptr;
    if (ptrnumber < 0 || ptrnumber > 3)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...ConfigurationPointer number%0d is invalid",
                    riscv_tap, ptrnumber);
      //setError();
    }
    confstrptr = readDMIReg(CFG_STR_ADDR0+ptrnumber);
    PRINT_VERBOSE(1,"READ CONFSTRPTR%0d: 0x%x",ptrnumber,confstrptr);
    if (check && confstrptr != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...CONFSTRPTR%0d Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, ptrnumber, check, confstrptr);
      //setError();
    }
    return confstrptr;
  }

  uint32_t readNextDM(uint32_t check=0)
  {
    uint32_t nextdm = readDMIReg(NEXT_DM);
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - READ NEXTDM: 0x%x",riscv_tap,nextdm);
    if (check && nextdm != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...NEXTDM Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, check, nextdm);
      //setError();
    }
    return nextdm;
  }

  uint32_t readAbstractData(uint32_t regnum, uint32_t check=0)
  {
    uint32_t abstractdata;
    if (regnum < 0 || regnum > 11)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...Read AbstractData number%0d is invalid\n",
                    riscv_tap, regnum);
      //setError();
    }
    abstractdata = readDMIReg(ABSTRACT_DATA0+regnum);
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - READ ABSTRACTDATA%0d: 0x%x\n",
                  riscv_tap, regnum, abstractdata);
    if (check && abstractdata != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...ABSTRACTDATA%0d Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, regnum, check, abstractdata);
      //setError();
    }
    return abstractdata;
  }

  uint32_t readProgBuf(uint32_t regnum, uint32_t check=0)
  {
    uint32_t programbuf;
    if (regnum < 0 || regnum > 15)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...Read ProgramBuf number%0d is invalid\n",
                    riscv_tap, regnum);
      //setError();
    }
    programbuf = readDMIReg(PROG_BUF0+regnum);
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - READ PROGRAMBUF%0d: 0x%x\n",
                  riscv_tap, regnum, programbuf);
    if (check && programbuf != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...PROGRAMBUF%0d Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, regnum, check, programbuf);
      //setError();
    }
    return programbuf;
  }

  uint32_t readSBCS(uint32_t check=0)
  {
    uint32_t sbcs = readDMIReg(SYS_BUS_ACC_CTL_S);
    printSBCS(sbcs);
    if (check && sbcs != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...SBCS Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, check, sbcs);
      //setError();
    }
    return sbcs;
  }

  uint32_t readAuthData(uint32_t check=0)
  {
    uint32_t authdata = readDMIReg(AUTH_DATA);
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - READ AUTHDATA: 0x%x\n",riscv_tap,authdata);
    if (check && authdata != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...AUTHDATA Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, check, authdata);
      //setError();
    }
    return authdata;
  }

  uint32_t readHaltSummary(uint32_t regnum, uint32_t check=0)
  {
    uint32_t haltsummary;
    if (regnum < 0 || regnum > 3)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...Read HaltSummary number%0d is invalid\n",
                    riscv_tap, regnum);
      //setError();
    }
    switch (regnum)
    {
      case 0:
      {
        haltsummary = readDMIReg(HART_SUMMARY0);
        break;
      }
      case 1:
      {
        haltsummary = readDMIReg(HART_SUMMARY1);
        break;
      }
      case 2:
      {
        haltsummary = readDMIReg(HART_SUMMARY2);
        break;
      }
      case 3:
      {
        haltsummary = readDMIReg(HART_SUMMARY3);
        break;
      }
    }
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - READ HALTSUMMARY%0d: 0x%x\n",
                  riscv_tap, regnum, haltsummary);
    if (check && haltsummary != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...HALTSUMMARY%0d Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, regnum, check, haltsummary);
      //setError();
    }
    return haltsummary;
  }

  uint32_t readSBAddr(uint32_t regnum, uint32_t check=0)
  {
    uint32_t sbaddr;
    if (regnum < 0 || regnum > 3)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...Read HaltSummary number%0d is invalid\n",
                    riscv_tap, regnum);
      //setError();
    }
    switch (regnum)
    {
      case 0:
      {
        sbaddr = readDMIReg(SYS_BUS_ADDR_31_0);
        break;
      }
      case 1:
      {
        sbaddr = readDMIReg(SYS_BUS_ADDR_63_32);
        break;
      }
      case 2:
      {
        sbaddr = readDMIReg(SYS_BUS_ADDR_95_64);
        break;
      }
      case 3:
      {
        sbaddr = readDMIReg(SYS_BUS_ADDR_127_96);
        break;
      }
    }
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - READ SBADDR%0d: 0x%x\n",riscv_tap,regnum,sbaddr);
    if (check && sbaddr != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...SBADDR%0d Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, regnum, check, sbaddr);
      //setError();
    }
    return sbaddr;
  }

  uint32_t readSBData(uint32_t regnum, uint32_t check=0)
  {
    uint32_t sbdata;
    if (regnum < 0 || regnum > 3)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...Read SBData number%0d is invalid\n",
                    riscv_tap, regnum);
      //setError();
    }
    sbdata = readDMIReg(SYS_BUS_DATA_31_0+regnum);
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - READ SBDATA_%0d_%0d: 0x%x\n",
                  riscv_tap, regnum*32+31, regnum*32, sbdata);
    if (check && sbdata != check)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...SBDATA%0d Exp:0x%0x  Obs:0x%0x\n",
                    riscv_tap, regnum, check, sbdata);
      //setError();
    }
    return sbdata;
  }

  // Write DMI Register
  void writeDMIReg(uint32_t addr, uint32_t wdata)
  {
    PRINT_VERBOSE(2,
                  "RISCV_TAP(%0d) - Writing DMI register ADDR:0x%08x DATA:0x%08x\n",
                  riscv_tap, addr, wdata);
    uint32_t data[2];
    jfc->send_tap_ir(riscv_tap, JTAG_IR_DMI_IFC_ACCESS);

    data[0] = (wdata << 2) | DMI_WR_OP;
    data[1] = (addr  << 2) | ((wdata >> 30) & 0x3);
    PRINT_VERBOSE(2,
                  "RISCV_TAP(%0d) - WRITE DMI DATA 1:0x%08x 0:0x%08x\n",
                  riscv_tap, data[1], data[0]);

    pDTM_STAT_t pdtm = (pDTM_STAT_t)&m_dtmStat;
    jfc->send_tap_dr(riscv_tap, (uint32_t)pdtm->abits+34, (uint32_t*)&data);
  }

  void writeDMControl(uint32_t *wdata)
  {
    printDMControl(*wdata, 1);
    writeDMIReg(DBG_MOD_CONTROL, *wdata);
  }

  void writeDTMControl(uint32_t *wdata)
  {
    jfc->send_tap_ir(riscv_tap, JTAG_IR_DTM_CTL_STS);
    jfc->send_tap_dr(riscv_tap, 32, wdata);
  }

  void dmiReset()
  {
    pDTM_STAT_t pdtm = (pDTM_STAT_t)&m_dtmStat;
    pdtm->dmireset = 1;
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Setting DMIRESET\n",riscv_tap);
    writeDTMControl((uint32_t*)pdtm);
    pdtm->dmireset = 0;
  }

  void dmiHardReset()
  {
    pDTM_STAT_t pdtm = (pDTM_STAT_t)&m_dtmStat;
    pdtm->dmihardreset = 1;
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Setting DMIHARDRESET\n",riscv_tap);
    writeDTMControl((uint32_t*)pdtm);
    pdtm->dmihardreset = 0;
  }

  void writeHartWindowSel(uint32_t *wdata) {
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - WRITE HAWINDOWSEL: 0x%0x\n",riscv_tap,*wdata);
    writeDMIReg(HART_ARY_WDW_SEL, *wdata);
  }

  void writeHartWindow(uint32_t *wdata) {
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - WRITE HAWINDOW: 0x%0x\n",riscv_tap,*wdata);
    writeDMIReg(HART_ARY_WDW, *wdata);
  }

  void writeAbstractCtrl(uint32_t *wdata) {
    printAbstractCS(*wdata,1);
    writeDMIReg(ABSTRT_CMD_STAT, *wdata);
  }

  void writeAbstractCmd(uint32_t *wdata) {
    pDM_ABSTRACTCMD_t pdm = (pDM_ABSTRACTCMD_t)wdata;
    PRINT_VERBOSE(2,
                  "RISCV_TAP(%0d) - WRITE ABSTRACTCMD: 0x%x, CONTROL: 0x%0x, CMDTYPE: 0x%0x\n",
                  riscv_tap, *pdm, pdm->control, pdm->cmdtype);
    switch (pdm->cmdtype)
    {
      case JTAG_RISCV_ABSCMD_ACCESSREG:
      {
        printAbstractAccessReg(pdm->control);
        break;
      }
      case JTAG_RISCV_ABSCMD_ACCESSMEM:
      {
        printAbstractAccessMem(pdm->control);
        break;
      }
    }
    writeDMIReg(ABSTRT_CMD, *wdata);
  }

  void writeAbstractAuto(uint32_t *wdata) {
    printAbstractAuto(*wdata,1);
    writeDMIReg(ABSTRT_CMD_AUTO, *wdata);
  }

  void writeAbstractData(uint32_t regnum, uint32_t *wdata)
  {
    if (regnum < 0 || regnum > 11)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...Write AbstractData number%0d is invalid\n",
                    riscv_tap, regnum);
      //setError();
    }
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - WRITE ABSTRACTDATA%0d: 0x%x\n",
                  riscv_tap, regnum, *wdata);
    writeDMIReg(ABSTRACT_DATA0+regnum,*wdata);
  }

  void writeProgBuf(uint32_t regnum, uint32_t *wdata)
  {
    if (regnum < 0 || regnum > 15)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...Write ProgramBuf number%0d is invalid\n",
                    riscv_tap, regnum);
      //setError();
    }
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - WRITE PROGRAMBUF%0d: 0x%x\n",
                  riscv_tap, regnum, *wdata);
    writeDMIReg(PROG_BUF0+regnum,*wdata);
  }

  void writeAuthData(uint32_t *wdata) {
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - WRITE AUTHDATA: 0x%0x\n",riscv_tap,*wdata);
    writeDMIReg(AUTH_DATA, *wdata);
  }

  void writeSBCS(uint32_t *wdata)
  {
    printSBCS(*wdata,1);
    writeDMIReg(SYS_BUS_ACC_CTL_S, *wdata);
  }

  void writeSBAddr(uint32_t regnum, uint32_t *wdata)
  {
    if (regnum < 0 || regnum > 3)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...Write SBAddr number%0d is invalid\n",
                    riscv_tap, regnum);
      //setError();
    }
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - WRITE SBADDR%0d: 0x%x\n",riscv_tap,regnum,*wdata);
    switch (regnum)
    {
      case 0:
      {
        writeDMIReg(SYS_BUS_ADDR_31_0,*wdata);
        break;
      }
      case 1:
      {
        writeDMIReg(SYS_BUS_ADDR_63_32,*wdata);
        break;
      }
      case 2:
      {
        writeDMIReg(SYS_BUS_ADDR_95_64,*wdata);
        break;
      }
      case 3:
      {
        writeDMIReg(SYS_BUS_ADDR_127_96,*wdata);
        break;
      }
    }
  }

  void writeSBData(uint32_t regnum, uint32_t *wdata)
  {
    if (regnum < 0 || regnum > 3)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Error...Write SBData number%0d is invalid\n",
                    riscv_tap, regnum);
      //setError();
    }
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - WRITE SBDATA_%0d_%0d: 0x%x\n",
                  riscv_tap, regnum*32+31, regnum*32, *wdata);
    writeDMIReg(SYS_BUS_DATA_31_0+regnum,*wdata);
  }

  void printAbstractCS(uint32_t cs, uint8_t wr=0)
  {
    pDM_ABSTRACTCS_t pdm = (pDM_ABSTRACTCS_t)&cs;
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - "
                  "%s ABSTRACTCS: 0x%x, "
                  "DATACOUNT: 0x%0x, "
                  "CMDERR: 0x%0x, "
                  "BUSY: 0x%0x, "
                  "PROGBUFSIZE: 0x%0x\n",
                  riscv_tap,
                  wr ? "WRITE" : "READ",
                  *pdm,
                  pdm->datacount,
                  pdm->cmderr,
                  pdm->busy,
                  pdm->progbufsize);
  }

  void printAbstractAuto(uint32_t abstractauto, uint8_t wr=0)
  {
    pDM_ABSTRACTAUTO_t pdm = (pDM_ABSTRACTAUTO_t)&abstractauto;
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - "
                  "%s ABSTRACTAUTO: 0x%x, "
                  "AUTOEXECDATA: 0x%x, "
                  "AUTOEXECPROGBUF: 0x%x\n",
                  riscv_tap,
                  wr ? "WRITE" : "READ",
                  *pdm,
                  pdm->autoexecdata,
                  pdm->autoexecprogbuf);
  }

  void printSBCS(uint32_t sbcs, uint8_t wr=0)
  {
    pDM_SBCS_t pdm = (pDM_SBCS_t)&sbcs;
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - "
                  "%s SBCS: 0x%x, "
                  "SBACCESS8: 0x%0x, "
                  "SBACCESS16: 0x%0x, "
                  "SBACCESS32: 0x%0x, "
                  "SBACCESS64: 0x%0x, "
                  "SBACCESS128: 0x%0x, "
                  "SBASIZE: 0x%0x, "
                  "SBERR: 0x%0x, "
                  "SBREADONDATA: 0x%0x, "
                  "SBAUTOINCREMENT: 0x%0x, "
                  "SBACCESS: 0x%0x, "
                  "SBREADONADDR: 0x%0x, "
                  "SBBUSY: 0x%0x, "
                  "SBBUSYERR: 0x%0x, "
                  "SBVERSION: 0x%0x\n",
                  riscv_tap,
                  wr ? "WRITE" : "READ",
                  *pdm,
                  pdm->sbaccess8,
                  pdm->sbaccess16,
                  pdm->sbaccess32,
                  pdm->sbaccess64,
                  pdm->sbaccess128,
                  pdm->sbasize,
                  pdm->sberror,
                  pdm->sbreadondata,
                  pdm->sbautoincrement,
                  pdm->sbaccess,
                  pdm->sbreadonaddr,
                  pdm->sbbusy,
                  pdm->sbbusyerror,
                  pdm->sbversion);
  }

  void printDMControl(uint32_t dmcontrol, uint8_t wr=0)
  {
    pDM_CTRL_t pdm = (pDM_CTRL_t)&dmcontrol;
    PRINT_VERBOSE(1,
                 "RISCV_TAP(%0d) - "
                 "%s DMCONTROL:0x%08x, "
                 "DMACTIVE:0x%0x, "
                 "NDMRESET:0x%0x, "
                 "CLRRESETHALTREQ:0x%0x, "
                 "SETRESETHALTREQ:0x%0x, "
                 "HARTSELHI:0x%0x, "
                 "HARTSELLO:0x%0x, "
                 "HASEL:0x%0x, "
                 "ACKHAVERESET:0x%0x, "
                 "HARTRESET:0x%0x, "
                 "RESUMEREQ:0x%0x, "
                 "HALTREQ:0x%0x\n",
                  riscv_tap,
                  wr ? "WRITE" : "READ",
                  *pdm,
                  pdm->dmactive,
                  pdm->ndmreset,
                  pdm->clrresethaltreq,
                  pdm->setresethaltreq,
                  pdm->hartselhi,
                  pdm->hartsello,
                  pdm->hasel,
                  pdm->ackhavereset,
                  pdm->hartreset,
                  pdm->resumereq,
                  pdm->haltreq);
  }

  void printAbstractAccessReg(uint32_t regaccess)
  {
    pABSTRACTCMD_AR_t par = (pABSTRACTCMD_AR_t)&regaccess;
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - "
                  "REGACCESS: 0x%x, "
                  "REGNO: 0x%0x, "
                  "WRITE: 0x%0x, "
                  "TRANSFER: 0x%0x, "
                  "POSTEXEC: 0x%0x, "
                  "AARPOSTINCREMENT: 0x%0x, "
                  "AARSIZE: 0x%0x\n",
                  riscv_tap,
                  *par,
                  par->regno,
                  par->write,
                  par->transfer,
                  par->postexec,
                  par->aarpostincrement,
                  par->aarsize);
  }

  void printAbstractAccessMem(uint32_t memaccess)
  {
    pABSTRACTCMD_AM_t pam = (pABSTRACTCMD_AM_t)&memaccess;
    PRINT_VERBOSE(1,
                  "RISCV_TAP(%0d) - "
                  "MEMACCESS: 0x%x, "
                  "_D1:0x%0x, "
                  "TARGET_SPECIFIC:0x%0x, "
                  "WRITE:0x%0x, "
                  "_D2:0x%0x, "
                  "AAMPOSTINCREMENT:0x%0x, "
                  "AAMSIZE:0x%0x, "
                  "AAMVIRTUAL:0x%0x\n",
                  riscv_tap,
                  *pam,
                  pam->_d1,
                  pam->target_specific,
                  pam->write,
                  pam->_d2,
                  pam->aampostincrement,
                  pam->aamsize,
                  pam->aamvirtual);
  }

  // RISC-V Halt
  void riscvHalt()
  {
    pDM_STAT_t dmstatus;
    DM_CTRL_t dmcontrol = {0};
    uint32_t status;
    dmcontrol.dmactive = 1;
    writeDMControl((uint32_t*)&dmcontrol);
    dmcontrol.haltreq = 1;
    writeDMControl((uint32_t*)&dmcontrol);
    status = readDMStatus();
    dmstatus = (pDM_STAT_t)&status;
    if (!dmstatus->anyhalted || !dmstatus->allhalted) {
      PRINT_VERBOSE(1,"RISCV_TAP(%0d) - ERROR...Halt Unsuccessful\n",riscv_tap);
      //setError();
    }
    else {
      PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Halt successful\n",riscv_tap);
    }
  }

  // RISC-V Release
  void riscvRelease()
  {
    pDM_STAT_t dmstatus;
    DM_CTRL_t dmcontrol = {0};
    uint32_t status;
    dmcontrol.dmactive = 1;
    dmcontrol.resumereq = 1;
    writeDMControl((uint32_t*)&dmcontrol);
    status = readDMStatus();
    dmstatus = (pDM_STAT_t)&status;
    if (dmstatus->anyhalted || dmstatus->allhalted || !dmstatus->anyrunning || !dmstatus->allrunning) {
      PRINT_VERBOSE(1,"RISCV_TAP(%0d) - ERROR...Resume Unsuccessful\n",riscv_tap);
      //setError();
    }
    else {
      PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Resume successful\n",riscv_tap);
    }
  }

  // RISC-V Test
  void riscvTest(uint32_t tdmi_stat=0)
  {
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Running riscvTest\n",riscv_tap);
    //wait(100);
    readIDCode();
    readDTMStatus(tdmi_stat);
    readDMStatus();
    readSBCS();
    readHartInfo();
    riscvHalt();
    //wait(20);
    riscvAbstractAccessRegTest();
    riscvRelease();
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Finished riscvTest\n",riscv_tap);
  }

  void riscvAbstractAccessDownloadTest()
  {
    uint32_t r0data,r1data;
    uint32_t opcode0 = 0x00942023;
    uint32_t opcode1 = 0x00440413;
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Running riscvAbstractAccessDownloadTest\n",riscv_tap);

    r0data = abstractAccessRegRead(REG_S0);
    r1data = abstractAccessRegRead(REG_S1);
    abstractAccessRegWrite(REG_S0, 0x20040000);
    abstractAccessRegWrite(REG_S1, 0xc001c0de);
    writeProgBuf(0,&opcode0);
    writeProgBuf(1,&opcode1);
    uint32_t cmd = (1<<18);
    writeAbstractCmd(&cmd);
    abstractAccessRegWrite(REG_S1, 0xdeadbeef);
    writeAbstractCmd(&cmd);
    abstractAccessRegWrite(REG_S1, 0xc001ca11);
    writeAbstractCmd(&cmd);
    abstractAccessRegWrite(REG_S0, r0data);
    abstractAccessRegWrite(REG_S1, r1data);
    
  }

  void riscvAbstractAccessRegTest()
  {
    uint32_t r0data,r1data;
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Running riscvAbstractAccessRegTest\n",riscv_tap);

    r0data = abstractAccessRegRead(REG_S0);
    r1data = abstractAccessRegRead(REG_S1);
    abstractAccessRegWrite(REG_S0, 0xabcd1234);
    readAbstractData(0);
    abstractAccessRegRead(REG_S0);
    readAbstractStatus();
    abstractAccessRegWrite(REG_S1, 0xabababab);
    abstractAccessRegRead(REG_S1);
    readAbstractStatus();
    if (abstractAccessRegRead(REG_S0) != 0xabcd1234)
    {
      PRINT_VERBOSE(1,"RISCV_TAP(%0d) - ERROR...Access Reg S0 mismatch\n",riscv_tap);
      //setError();
    }
    abstractAccessRegWrite(REG_S0, r0data);
    abstractAccessRegWrite(REG_S1, r1data);
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Finished riscvAbstractAccessRegTest\n",riscv_tap);
  }

  void riscvAbstractAccessMemTest(uint32_t testreg1, uint32_t testreg2)
  {
    uint32_t status;
    pDM_ABSTRACTCS_t abcs;

    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Running riscvAbstractAccessMemTest\n",riscv_tap);
    readAbstractData(0);
    readAbstractStatus();
    abstractAccessMemWrite(testreg1,0x12121212);
    status = readAbstractStatus();
    abcs = (pDM_ABSTRACTCS_t)&status;
    if (abcs->cmderr == 0x2)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - Access Memory abstract command is not supported\n",
                    riscv_tap);
      abcs->cmderr=0x7;
      writeAbstractCtrl((uint32_t*)abcs);
      status = readAbstractStatus();
      abcs = (pDM_ABSTRACTCS_t)&status;
      if (abcs->cmderr)
      {
        PRINT_VERBOSE(1,"RISCV_TAP(%0d) - ERROR...Failed to clear cmderr\n",riscv_tap);
        //setError();
      }
      return;
    }
    abstractAccessMemWrite(testreg2,0x10101010);
    if (abstractAccessMemRead(testreg1 != 0x12121212))
    {
      PRINT_VERBOSE(1,"ERROR...Acess Memory data mismatch\n");
    }
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Finished riscvAbstractAccessMemTest\n",riscv_tap);
  }

  void riscvSystemBusTest(uint32_t testreg)
  {
    DM_CTRL_t dmcontrol = {0};
    pDM_SBCS_t sbstatus;
    uint32_t status;

    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Running riscvSystemBusTest\n",riscv_tap);
    readSBCS();
    dmcontrol.dmactive = 1;
    writeDMControl((uint32_t*)&dmcontrol);
    systemBusWrite(testreg,0x1a2b3c4d); // HSP_SCRATCH0
    if (systemBusRead(testreg) != 0x1a2b3c4d)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - ERROR... riscvSystemBusTest data mismatch\n",
                    riscv_tap);
      //setError();
    }
    status = readSBCS();
    sbstatus = (pDM_SBCS_t)&status;
    if (sbstatus->sberror || sbstatus->sbbusyerror)
    {
      PRINT_VERBOSE(1,
                    "RISCV_TAP(%0d) - ERROR... riscvSystemBusTest encountered a System Bus error\n",
                    riscv_tap);
      //setError();
    }
    PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Finished riscvSystemBusTest\n",riscv_tap);
  }

  void readAllRiscvRegs (uint32_t data[])
  {
    for (uint32_t i=REG_ZERO; i<=REG_T6; i++)
    {
      data[i-REG_ZERO] = abstractAccessRegRead(i,0); 
    }
  }

  // Gyle
#define ZERO_REG    0
#define S0_REG      8
#define S1_REG      9
  void writeAllRiscvRegs (uint32_t data[])
  {
    uint32_t cnt = 0;
    for (uint32_t i=REG_ZERO; i<=REG_T6; i++)
    {
      abstractAccessRegWrite(i, data[cnt++]);
    }
  }

  uint32_t writeCSRReg(uint32_t csrreg, uint32_t data)
  {
    abstractAccessRegWrite(REG_S1, data);
    riscvExecOpcode(CSRRW(csrreg,S0_REG, S1_REG));
    return abstractAccessRegRead(REG_S0,0);
  }

  uint32_t readCSRReg(uint32_t csrreg)
  {
    riscvExecOpcode(CSRRS(csrreg,ZERO_REG, S0_REG));
    return abstractAccessRegRead(REG_S0,0);
  }

  uint32_t readBreakStatus(RISCV_DBG_STATUS_t * status)
  {
    readAllRiscvRegs(status->gpr);
    status->mstatus = readCSRReg(CSR_MSTATUS_ADDR);
    status->mie = readCSRReg(CSR_MIE_ADDR);
    status->mtvec = readCSRReg(CSR_MTVEC_ADDR);
    status->mscratch = readCSRReg(CSR_MSCRATCH_ADDR);
    status->mepc = readCSRReg(CSR_MEPC_ADDR);
    status->mcause = readCSRReg(CSR_MCAUSE_ADDR);
    status->mtval = readCSRReg(CSR_MTVAL_ADDR);
    status->mip = readCSRReg(CSR_MIP_ADDR);
    status->dscr = readCSRReg(CSR_DSCR_ADDR);
    status->dpc = readCSRReg(CSR_DPC_ADDR);
    return 0; 
  }

  void restoreBreakStatus(RISCV_DBG_STATUS_t * status)
  {
    writeAllRiscvRegs(status->gpr);
    return;
  }
  
  uint32_t abstractAccessRegRead(uint32_t regno, uint8_t execProgBuf=0)
  {
    DM_ABSTRACTCMD_t abscmd = {0};
    ABSTRACTCMD_AR_t regaccess = {0};
    regaccess.regno = regno;
    regaccess.transfer = 0x1;
    regaccess.postexec = execProgBuf;
    regaccess.aarsize = 0x2;
    abscmd.cmdtype = JTAG_RISCV_ABSCMD_ACCESSREG;
    abscmd.control = *((uint32_t*)&regaccess);
    writeAbstractCmd((uint32_t*)&abscmd);
    return readAbstractData(0);
  }

  uint32_t abstractAccessMemRead(uint32_t addr)
  {
    DM_ABSTRACTCMD_t abscmd = {0};
    ABSTRACTCMD_AM_t memaccess = {0};
    memaccess.aamsize = 0x2;
    abscmd.cmdtype = JTAG_RISCV_ABSCMD_ACCESSMEM;
    abscmd.control = *((uint32_t*)&memaccess);
    writeAbstractData(1,&addr);
    writeAbstractCmd((uint32_t*)&abscmd);
    return readAbstractData(0);
  }

  uint32_t systemBusRead(uint32_t addr)
  {
    DM_SBCS_t sbcs = {0};
    sbcs.sbaccess = 0x2;
    sbcs.sbreadonaddr = 0x1;
    writeSBCS((uint32_t *)&sbcs);
    writeSBAddr(0,&addr);
    return readSBData(0);
  }

  void abstractAccessRegWrite(uint32_t regno, uint32_t wdata, uint8_t execProgBuf=0)
  {
    DM_ABSTRACTCMD_t abscmd = {0};
    ABSTRACTCMD_AR_t regaccess = {0};
    regaccess.regno = regno;
    regaccess.write = 0x1;
    regaccess.transfer = 0x1;
    regaccess.postexec = execProgBuf;
    regaccess.aarsize = 0x2;
    abscmd.cmdtype = JTAG_RISCV_ABSCMD_ACCESSREG;
    abscmd.control = *((uint32_t*)&regaccess);
    writeAbstractData(0,&wdata);
    writeAbstractCmd((uint32_t*)&abscmd);
  }

  void abstractAccessMemWrite(uint32_t addr, uint32_t wdata)
  {
    DM_ABSTRACTCMD_t abscmd = {0};
    ABSTRACTCMD_AM_t memaccess = {0};
    memaccess.write = 0x1;
    memaccess.aamsize = 0x2;
    abscmd.cmdtype = JTAG_RISCV_ABSCMD_ACCESSMEM;
    abscmd.control = *((uint32_t*)&memaccess);
    writeAbstractData(1,&addr);
    writeAbstractData(0,&wdata);
    writeAbstractCmd((uint32_t*)&abscmd);
  }

  void systemBusWrite(uint32_t addr, uint32_t wdata)
  {
    DM_SBCS_t sbcs = {0};
    sbcs.sbaccess = 0x2;
    writeSBCS((uint32_t*)&sbcs);
    writeSBAddr(0,&addr);
    writeSBData(0,&wdata);
  }

  void riscvExecOpcode(uint32_t opcode)
  {
    uint32_t ebreak = 0x00100073;
    writeProgBuf(0,&opcode);
    writeProgBuf(1,&ebreak);
    uint32_t cmd = (1<<18);
    writeAbstractCmd(&cmd);
  }

  void riscvProgramBufTest(uint32_t testreg1, uint32_t testreg2)
  {
      ITYPE_INSTR_t instr = {0};
      PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Running riscvProgramBufTest\n",riscv_tap);
      abstractAccessRegWrite(REG_S0, 0x12345678);
      systemBusWrite(testreg2,0xab12cd34);

      // lw s0, s1
      instr.opcode = 0x3;
      instr.rd = 0x8;
      instr.funct3 = 0x2;
      instr.rs1 = 0x9;
      instr.imm = 0x0;
      writeProgBuf(0,(uint32_t*)&instr);
      readProgBuf(0);

      // ebreak
      instr.opcode = 0x73;
      instr.rd = 0x0;
      instr.funct3 = 0x0;
      instr.rs1 = 0x0;
      instr.imm = 0x1;
      writeProgBuf(1,(uint32_t*)&instr);
      readProgBuf(0);

      abstractAccessRegWrite(REG_S1, testreg2, 1);
      readAbstractStatus();
      if (abstractAccessRegRead(REG_S0) != 0xab12cd34)
      {
        PRINT_VERBOSE(1,
                      "RISCV_TAP(%0d) - ERROR...riscvProgramBufTest data mismatch\n",
                      riscv_tap);
        //setError();
      }
      PRINT_VERBOSE(1,"RISCV_TAP(%0d) - Finished riscvProgramBufTest\n",riscv_tap);
  }

};
