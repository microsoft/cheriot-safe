#pragma once

#include <inttypes.h>
#include <jtag/jtag_hw_base.h>

enum CPU_TYPES {
  CPU_NA,
  CPU_SIFIVE,
  CPU_RISCV,
  CPU_M7,
};

enum {
  TAP_DV_NA,
  TAP_DV_DBG,
  TAP_DV_FMC,
  TAP_DV_TDR,
  TAP_DV_HSP,
  TAP_DV_CPU1,
  TAP_DV_CPU2,
};

//#include "jtag_defines.h"

class JTAG_IFACE_BASE {

  #define MAX_TAP_COUNT 50

  public:

  JTAG_HW_BASE *jbp;

  enum {
    JTAG_IDCODE=1,
  };

  typedef struct TAP_DEF_s {
    uint8_t ir_size;
    bool bypass;
    bool disabled;
    uint8_t mode;
    uint32_t idcode;
    uint32_t idcmd;
    const char * tapName;
    uint8_t *data;
    uint32_t txbits;
    uint32_t exp_idcode;
    uint32_t type;
    uint32_t cputype;
  } TAP_DEF_t, *ptrTAP_DEF_t;

  TAP_DEF_t *taps[MAX_TAP_COUNT];
  uint32_t   tap_cnt;

  JTAG_IFACE_BASE()
  {
    tap_cnt = 0;
  }

  virtual int auto_enumerate()=0;
  virtual void set_dr_tap_data(uint8_t tap, uint32_t bits, uint8_t *data) = 0;
  virtual void enable_tap(uint8_t tap) = 0;
  virtual void disable_tap(uint8_t tap) = 0;
  //virtual void add_tap(uint8_t ir, const char * tapN, uint32_t idcmd=JTAG_IDCODE) = 0;
  virtual void add_tap(uint8_t ir, const char * tapN, uint32_t idcmd=JTAG_IDCODE, uint32_t exp_idcode=0, uint32_t disabled=false, uint32_t cputype=CPU_NA, uint32_t type=TAP_DV_NA ) = 0;
  virtual void send_tap_ir(uint8_t tap, uint32_t irval) = 0;
  virtual void send_tap_dr(uint8_t tap, uint32_t bits, uint32_t *data) = 0;
  virtual void set_all_taps_bypass() = 0;
  virtual void set_tap_bypass(uint32_t tap) = 0;
  virtual void set_tap_ir(uint32_t tap, uint32_t inst) = 0;
  virtual uint32_t get_dr_chain_length() = 0;
  virtual void update_dr() = 0;
  virtual void get_dr_data(uint8_t tap_sel, uint32_t *bits, uint8_t *out) = 0;
  virtual uint32_t get_ir_chain_length() = 0;
  virtual void update_ir() = 0;
//  virtual void shift_ir(uint32_t bits, uint8_t* data)=0;
//  virtual void shift_dr(uint32_t bits, uint8_t *data)=0; 

  ///////////////////////////////////
  // Helper Functions 
  ///////////////////////////////////
  const char * get_tap_name(uint8_t tap_num)
  {
    if (tap_num >= tap_cnt)
    {
      printf("Failed to retrieve tap name because tap number %0d does not exist",tap_num);
      return NULL;
    }
    else
    {
      return taps[tap_num]->tapName;
    }
  }
  
  //=============================
  // print_array_bits 
  //=============================
  void print_array_bits(uint8_t veb, uint32_t bits, const uint8_t *data)
  {
    print_array(veb, get_bytes_from_bits(bits), data);
  }

  //=============================
  // print_array 
  //=============================
  void print_array(uint8_t veb, uint32_t bytes, const uint8_t *data)
  {
    printf("PRINT_ARRAY(%d): ", (int)bytes);
    for(uint32_t i=0;i<bytes;i++) {
      printf("%02x ", data[i]);
    }
    printf("\n");
    return;
  }

  //=============================
  // get bytes from bits
  //=============================
  uint32_t get_bytes_from_bits(uint32_t bits)
  {
    uint32_t bytes;
    uint32_t rbits;
    bytes = bits/8;
    rbits = bits % 8;
    if(rbits != 0) {
      bytes++;
    }
    return bytes;
  }

  //=============================
  // get bit in array
  //=============================
  uint8_t get_bit_in_array(uint32_t bit_num, const uint8_t *array)
  {
    uint32_t byte = bit_num/8;
    uint32_t shiftr = bit_num % 8;
    uint8_t ret_val;
    ret_val = (array[byte]>>shiftr)&0x1;
    return ret_val;
  }

  //=============================
  // set bit in array
  //=============================
  void set_bit_in_array(uint32_t bit_num, uint8_t val, uint8_t *array)
  {
    uint32_t byte = bit_num/8;
    uint32_t shiftl = bit_num % 8;
    uint8_t shft_val = val<<shiftl;
    array[byte] &= ~(1<<shiftl);
    array[byte] |= shft_val;
    return;
  }

  ///////////////////////////////////
  // HW Layer pass through functions 
  ///////////////////////////////////
  void set_trst(bool trst) 
  {
    jbp->set_trst(trst);
  }

  void trst_reset()
  {
    jbp->trst_reset();
  }

  void async_reset()
  {
    jbp->trst_reset();
  }

  void tms_reset() 
  {
    jbp->tms_reset();
  }

  void shift_ir(uint32_t bits, uint8_t* data) 
  {
    jbp->shift_ir(bits,data);
  }

  void shift_dr(uint32_t bits, uint8_t *data) 
  {
    jbp->shift_dr(bits,data);
  }

  void idle_clocks(uint32_t clocks) 
  {
    jbp->idle_clocks(clocks);
  }

  uint32_t set_frequency(uint32_t xtal, uint32_t freq) 
  {
    return jbp->set_frequency(xtal,freq);
  }

//  int open_usb(JTAG_DEVICE_INFO_t *dev_info, bool vb=false) 
//  {
//    return driver.open_usb(dev_info,vb);
//  }

/*
  void tb_handshake(uint32_t clocks) 
  {
    driver.tb_handshake(clocks);
  }

  void wait_and_async_reset_loops(int waits, int resets)
  {
    driver.wait_and_async_reset_loops(waits,resets);
  }

  void wait_and_tms_reset_loops(int waits, int resets)
  {
    driver.wait_and_tms_reset_loops(waits,resets);
  }
*/

};
