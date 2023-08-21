
// =====================================================
// Copyright (c) Microsoft Corporation.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//    http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =====================================================

#pragma once

#include <stdlib.h>
#include <jtag/jtag_hw_base.h>

class JTAG_CTRL : virtual public JTAG_HW_BASE{

  public:
  #define EXT_CG_OKAY         (1<<16)
  #define JTAG_ACTIVE         (1<<17)
  #define TRST_ENABLE         (1<<16)

  #define TMS_ON_LAST_BIT     (1<<5)

	enum {
		JTAG_IO_CTRL_OFF=0,
		JTAG_TDO_BURST_CTRL_OFF=4,
		JTAG_TMS_BURST_CTRL_OFF=8,
		JTAG_CLK_CTRL_STATUS_OFF=12,
		JTAG_DATA_OFF=16,
		JTAG_TMS_OFF=20
	} JTAG_CTRL_OFF_t;

  typedef struct {
    volatile uint32_t JTAG_IO_CTRL;
    volatile uint32_t JTAG_TDO_BURST_CTRL;
    volatile uint32_t JTAG_TMS_BURST_CTRL;
    volatile uint32_t JTAG_CLK_CTRL_STATUS;
    volatile uint32_t JTAG_DATA;
    volatile uint32_t JTAG_TMS;
  } JTAG_CTRL_t, *ptrJTAG_CTRL_t;

  private:

	uint32_t jptr;

#ifndef __DPI_APB__
	static inline volatile uint32_t jc_read32(uint32_t addr)
	{
		return *(volatile uint32_t*)(addr);
	}

	static inline void jc_write32(uint32_t addr, uint32_t data)
	{
		*(volatile uint32_t*)(addr) = data;
	}
#endif

  public:

  //==============================================
  // Constructor
  //==============================================
  JTAG_CTRL(uint32_t jptr_in)
  {
    //jptr = (JTAG_CTRL_t*)jptr_in;
    jptr = jptr_in;
  }

  //==============================================
  // Enable Jtag Mux
  //==============================================
  int open_usb(JTAG_DEVICE_INFO_t *dev_info, bool vb=false)
  {
    return 0;
  }
  
  //==============================================
  // Auto Detect
  //==============================================
  int auto_detect(int *ir_cnt)
  {
    uint32_t words = 4;
    uint32_t bits = 32 * words;

    // Reset Chain
    tms_reset();

    // Shift IR
    uint32_t data[words];
    for(uint32_t i=0;i<words;i++) data[i] = 0xffffffff;
    shift_ir(bits, (uint8_t*)data);

    // Detect Taps
    int taps = 0;
    bool first = 0;
    bool done = false;
    int id_cnt = 0;
    for(uint32_t i=0;i<words && !done;i++) {
      for(int b=0;b<32;b++) {
        int bit = (data[i]>>b)&1;
        //printf("BIT %d: %d\n", b+(i*32), bit);
        if(bit == 1)  {
          if(first) {
            ir_cnt[taps-1] = -1;
            taps--;
            done = true;
            break;
          } else {
            if(id_cnt > 0) {
              ir_cnt[taps-1] = id_cnt;
            }
            taps++; 
            id_cnt = 1;
            first = true; 
          }
        } else {
          first = false;
          id_cnt++;
        }
      }
    }
    return taps; 
  }

  //==============================================
  // Enable Jtag Mux
  //==============================================
  void enable_jtag_mux()
  {
    jc_write32(jptr+JTAG_IO_CTRL_OFF, 1);
    while(!(jc_read32(jptr+JTAG_CLK_CTRL_STATUS_OFF)&(1<<16)));
    jc_write32(jptr+JTAG_IO_CTRL_OFF, 7);
    return;
  }
    
  //==============================================
  // Disable Jtag Mux
  //==============================================
  void disable_jtag_mux()
  {
    jc_write32(jptr+JTAG_IO_CTRL_OFF, 0);
    return;
  }

  //==============================================
  // Set Div
  //==============================================
  void set_divider(uint32_t div)
  {
    jc_write32(jptr+JTAG_CLK_CTRL_STATUS_OFF, div);
    return;
  }

  //==============================================
  // Set Frequency
  //==============================================
  uint32_t set_frequency(uint32_t xtal, uint32_t freq)
  {
    uint32_t div_freq = freq*2;
    uint32_t div = (xtal/div_freq);
    if(div_freq > xtal) {
      div = 1;
    } else if(div > 255) {
        div = 0xff;
    }
    set_divider(div);
    return xtal/(div*2);
  }

  //==============================================
  // trstn Reset
  //==============================================
  void trst_reset()
  {
    set_trst(true);
    set_trst(false);
  }

  //==============================================
  // Set TRST
  //==============================================
  void set_trst(bool trst)
  {
    uint32_t rval = jc_read32(jptr+JTAG_IO_CTRL_OFF);

    if(!trst) {
        jc_write32(jptr+JTAG_IO_CTRL_OFF, rval | TRST_ENABLE);
    } else {
        jc_write32(jptr+JTAG_IO_CTRL_OFF, rval&(~TRST_ENABLE));
    }
    return;
  }

  //==============================================
  // wait_while_active()
  //==============================================
  void wait_while_active()
  {
    while(jc_read32(jptr+JTAG_CLK_CTRL_STATUS_OFF) & JTAG_ACTIVE);
    return;
  }
  
  //==============================================
  // tms_reset
  //==============================================
  void tms_reset()
  {
    jc_write32(jptr+JTAG_TMS_BURST_CTRL_OFF, 7);
    jc_write32(jptr+JTAG_TMS_OFF, 0xffffffff);
    wait_while_active();
    idle_clocks(1);
    return;
  }

  //==============================================
  // data_shift
  //==============================================
  void data_shift(uint32_t *data, uint32_t bits)
  {
    uint32_t idx = 0;
    uint32_t cburst;
    uint32_t shift;

    // SHIFT data
    wait_while_active();
    while(bits != 0) {
      if(bits > 32) {
        cburst = 32;
        shift = 0;
        jc_write32(jptr+JTAG_TDO_BURST_CTRL_OFF, 31);
      } else {
        shift = 32-bits;
        cburst = bits;
        jc_write32(jptr+JTAG_TDO_BURST_CTRL_OFF, TMS_ON_LAST_BIT | (bits-1));
      }
      jc_write32(jptr+JTAG_DATA_OFF, data[idx]);
      wait_while_active();
      data[idx++] = jc_read32(jptr+JTAG_DATA_OFF)>>shift;
      bits -= cburst;
    }
    return;
  }
   

  //==============================================
  // shift_tms
  //==============================================
  void shift_tms(uint32_t *data, uint32_t bits)
  {
    uint32_t idx = 0;

    while(bits != 0) {
      if(bits > 32) {
        jc_write32(jptr+JTAG_TMS_BURST_CTRL_OFF, 31);
        jc_write32(jptr+JTAG_TMS_OFF, data[idx]);
        wait_while_active();
        bits -= 32;
      } else {
        jc_write32(jptr+JTAG_TMS_BURST_CTRL_OFF, bits-1);
        jc_write32(jptr+JTAG_TMS_OFF, data[idx]);
        wait_while_active();
        bits = 0;
      }
    }
    return;
  }

  //==============================================
  // clkBurst
  //==============================================
  void idle_clocks(uint32_t clocks)
  {
    uint32_t tmsData = 0;
    jc_write32(jptr+JTAG_TMS_BURST_CTRL_OFF,0);
    while(clocks != 0) {
      jc_write32(jptr+JTAG_TMS_OFF, 0);
      if(clocks > 32) {
        shift_tms(&tmsData, 32);
        wait_while_active();
        clocks -= 32;
      } else {
        shift_tms(&tmsData, clocks);
        wait_while_active();
        clocks = 0;
      }
    }
    return;
  }

  //==============================================
  // shift_ir
  //==============================================
  void shift_ir(uint32_t bits, uint8_t *data)
  {
    uint32_t tmsData;

    // SHIFT to IR state
    tmsData = 0x3;
    shift_tms(&tmsData, 4);

    // Shift Data
    data_shift((uint32_t*)data, bits);

    // Shift TEST/RUN state
    tmsData = 0x1;
    shift_tms(&tmsData, 2);
    return;
  }

  //==============================================
  // shift_dr
  //==============================================
  void shift_dr(uint32_t bits, uint8_t *data)
  {
    uint32_t tmsData[1];

    // SHIFT to DR state
    tmsData[0] = 0x1;
    shift_tms(tmsData, 3);

    // Shift Data
    data_shift((uint32_t*)data, bits);

    // Shift TEST/RUN state
    tmsData[0] = 0x1;
    shift_tms(tmsData, 2);
    return;
  }

  //==============================================
  // async_reset
  //==============================================
  void async_reset()
  {
    return;
  }

};
