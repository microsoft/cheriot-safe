

#ifndef __JTAG_APB_DRIVER_INC__
#define __JTAG_APB_DRIVER_INC__

#include "stdio.h"
#include <jtag/jtag_iface.h>

//==========================================
// Class JTAGDriver 
//==========================================
class JTAG_APB_DRIVER {

  #define JTAG_CMD_APB_DEBUG_ACCESS   0xa
  #define JTAG_CMD_APB_READ_WRITE     0xb
  #define JTAG_CMD_AXI_DEBUG_ACCESS   0xc
  #define JTAG_CMD_AXI_READ_WRITE     0xd

  #define APB_16BIT                   (0x0)
  #define APB_32BIT                   (0x1)
  #define APB_WRITE                   (0x2)
  #define APB_READ                    (0x4)
  #define APB_AUTO_INC                (0x8)

  #define APB_RD_WR_SCAN_BITS         88
  #define APB_ACCESS_SCAN_BITS        49

  #define AXI_RD_WR_SCAN_BITS         192
  #define AXI_ACCESS_SCAN_BITS        73

  #define RD16_CMD                    (APB_16BIT|APB_READ)
  #define WR16_CMD                    (APB_16BIT|APB_WRITE)
  #define RD32_CMD                    (APB_32BIT|APB_READ)
  #define WR32_CMD                    (APB_32BIT|APB_WRITE)

  #define GENERIC_BKDR_BASE_ADDR      (0x20000000)
  #define CPU_BKDR_OFFSET             (0x01000000)
  #define CPU_BASE_ADDR(cpu)          (GENERIC_BKDR_BASE_ADDR + ((uint32_t)cpu*CPU_BKDR_OFFSET))
  #define PC_OFFSET                   (0x00430000)
  #define ENABLE_OFFSET               (0x00430004)
  #define STATUS_OFFSET               (0x00430008)
  #define CORE_OFFSET                 (0x0043000C)
  #define CTRL_OFFSET                 (0x00430040)
  #define RESET_BIT                   (1<<0)
  #define ADDROF(offset)              (addrBase+offset)

  typedef struct __attribute__((__packed__)) AXI_ACCESS_CMD_s {
    uint64_t data    : 64;
    uint8_t  strobe  : 8;
    uint8_t  last    : 1;
    uint8_t  size    : 3;
    uint8_t  id      : 4;
    uint8_t  length  : 8;
    uint8_t  burst   : 2;
    uint8_t  lock    : 2;
    uint8_t  cache   : 4;
    uint64_t addr    : 64;
    uint8_t  qos     : 4;
    uint8_t  prot    : 3;
    uint8_t  read    : 1;
    uint8_t  write   : 1;
    uint8_t  auto_inc: 1;
    uint32_t rsvd    : 22;
  } AXI_ACCESS_CMD_t;

  typedef struct __attribute__((__packed__)) APB_ACCESS_CMD_s {
    uint64_t data   : 48;
    uint8_t  read   : 1;
    uint8_t  write  : 1;
    uint8_t  d32bit : 1;
    uint8_t  rsvd   : 5;
    uint32_t addr   : 32;
  } APB_ACCESS_CMD_t;

  public:

  JTAG_IFACE *jfc;
  uint8_t tap;

  // Constructor
  JTAG_APB_DRIVER(JTAG_IFACE *jfc_in, uint32_t tap_in) {
    jfc = jfc_in;
    tap = tap_in;
  }

  void dbgWr32(int addr, int wdata)
  {
    APB_ACCESS_CMD_t cdata;

    jfc->send_tap_ir(tap, JTAG_CMD_APB_READ_WRITE);
   
    cdata.addr = addr;
    cdata.data = (uint64_t)wdata;
    cdata.read = 0;
    cdata.write = 1;
    cdata.d32bit = 1;

    jfc->send_tap_dr(tap, APB_RD_WR_SCAN_BITS, (uint32_t*)&cdata);

  }

  int dbgRd32(int addr)
  {
    APB_ACCESS_CMD_t cdata;

    jfc->send_tap_ir(tap, JTAG_CMD_APB_READ_WRITE);
   
    cdata.addr = addr;
    cdata.data = (uint64_t)0;
    cdata.read = 1;
    cdata.write = 0;
    cdata.d32bit = 1;

    jfc->send_tap_dr(tap, APB_RD_WR_SCAN_BITS, (uint32_t*)&cdata);

    cdata.addr = addr;
    cdata.data = (uint64_t)0;
    cdata.read = 0;
    cdata.write = 0;
    cdata.d32bit = 1;

    jfc->send_tap_dr(tap, APB_RD_WR_SCAN_BITS, (uint32_t*)&cdata);

    return (int)cdata.data;
  }

};

#endif
