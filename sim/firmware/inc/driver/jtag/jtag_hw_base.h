#pragma once

#include "inttypes.h"
//#include "jtag_utils.h"

typedef struct JTAG_DEVICE_INFO_s {
  uint16_t vid;
  uint16_t pid;
  const char * vendor_str;
  uint32_t serial;
} JTAG_DEVICE_INFO_t, *ptrJTAG_DEVICE_INFO_t;

class JTAG_HW_BASE {

  public: 

  JTAG_HW_BASE() 
  {
  }

  virtual int auto_detect(int *)=0;
  virtual int open_usb(JTAG_DEVICE_INFO_t *dev_info, bool vb=false) = 0;
  virtual void shift_ir(uint32_t bits, uint8_t* data) = 0;
  virtual void shift_dr(uint32_t bits, uint8_t *data) = 0;
  virtual void idle_clocks(uint32_t clocks) = 0;
  virtual uint32_t set_frequency(uint32_t xtal, uint32_t freq) = 0;
  virtual void trst_reset() = 0;
  virtual void tms_reset() = 0;
  virtual void set_trst(bool trst) = 0;
  virtual void async_reset() = 0;

  // Wait Clock Cycles, Perform Async Reset Loop
  void wait_and_async_reset_loops(int waits, int resets)
  {
    for(int rr=0; rr<resets; rr++) {
        idle_clocks(waits);
        async_reset();
    }
  }

  // Wait Clock Cycles, Perform TMS Reset Loop
  void wait_and_tms_reset_loops(int waits, int resets)
  {
    for(int rr=0; rr<resets; rr++) {
        idle_clocks(waits);
        tms_reset();
    }
  }

}; // End Class
