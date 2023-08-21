
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

#include <inttypes.h>
#include <stdlib.h>
#include <jtag/jtag_iface_base.h>

class JTAG_IFACE : virtual public JTAG_IFACE_BASE 
{
  
  private:

  

  public:

  //=============================
  // Constructor
  //=============================
  JTAG_IFACE(JTAG_HW_BASE *jbp_in) {
    jbp = jbp_in;
  }

  //==============================================
  // Auto enumerate
  //==============================================
  int auto_enumerate()
  {
   	int taps[10];
    int tapcnt;
	  tapcnt = jbp->auto_detect(taps);
	  for(int i=0;i<tapcnt;i++) {
      add_tap(taps[i], "TAP");
	  }
    read_idcodes();
    return tapcnt;
  }

  //=============================
  // Read IDCODES
  //=============================
  void read_idcodes() {
    jbp->tms_reset();
    for(uint32_t i=0;i<tap_cnt;i++) {
      set_dr_tap_data(i,32,(uint8_t*)&taps[i]->idcode);
    }
    update_dr();
  }
  
  //=============================
  // Set Tap Data
  //=============================
  void set_dr_tap_data(uint8_t tap, uint32_t bits, uint8_t *data)
  {
//    PRINT_VERBOSE(3, "TAP(%d) DR: ", tap);
    taps[tap]->data = data;
    taps[tap]->txbits = bits;
    return;
  }

  //=============================
  // Tab enabled
  //=============================
  bool tap_enabled(uint8_t tap)
  {
    return ((taps[tap]->disabled) == false);
  }

  //=============================
  // Tab disabled
  //=============================
  bool tap_disabled(uint8_t tap)
  {
    return ((taps[tap]->disabled) == true);
  }

  //=============================
  // Enable tap
  //=============================
  void enable_tap(uint8_t tap)
  {
    taps[tap]->disabled = false;
  }

  //=============================
  // Disable tap
  //=============================
  void disable_tap(uint8_t tap)
  {
    taps[tap]->disabled = true;
  }

  //=============================
  // getTapType
  //=============================
  int getTapType(uint32_t type)
  {
    for(uint32_t i=0;i<tap_cnt;i++) {
      if(type == taps[i]->type) {
        return i;
      }
    }
    return -1;
  }

  //=============================
  // getTapIdcode
  //=============================
  uint32_t getTapIdcode(uint32_t tap)
  {
    return taps[tap]->idcode;
  }

  //=============================
  // Add Taps
  //=============================
  void add_taps(uint32_t cnt, uint8_t *ir, const char * tapN[], uint32_t *idcmd, uint32_t *exp_idcode, uint32_t *disabled, uint32_t *cputype, uint32_t *type )
  {
    for(uint32_t i=0;i<cnt;i++) {
      add_tap(ir[i], tapN[i], idcmd[i], exp_idcode[i], disabled[i], cputype[i], type[i]);
    }
  }
 
  //=============================
  // Add Tap
  //=============================
  void add_tap(uint8_t ir, const char * tapN, uint32_t idcmd=JTAG_IDCODE, uint32_t exp_idcode=0, uint32_t disabled=false, uint32_t cputype=CPU_NA, uint32_t type=TAP_DV_NA )
  {
    //PRINT_VERBOSE(1,"Adding Tap %lu: %-24s IR(%u) IDCMD(0x%lx) EXPID(0x%08lx) DIS(%lu) CPUTYPE(%lu) TYPE(%lu)\n", tap_cnt, tapN, ir, idcmd, exp_idcode, disabled, cputype, type);
    printf("Adding Tap %lu: %-24s IR(%u) IDCMD(0x%lx) EXPID(0x%08lx) DIS(%lu) CPUTYPE(%lu) TYPE(%lu)\n", tap_cnt, tapN, ir, idcmd, exp_idcode, disabled, cputype, type);
    TAP_DEF_t *tap = new TAP_DEF_t;
    tap->ir_size = ir;
    tap->idcmd = idcmd;
    tap->bypass = false;
    tap->mode = 0x1;
    tap->data = NULL;
    tap->txbits = 0;
    tap->tapName = tapN;
    tap->disabled = disabled;
    tap->exp_idcode = exp_idcode;
    tap->cputype = cputype;
    tap->type = type;
    taps[tap_cnt++] = tap;
  }

  //=============================
  // send_tap_ir 
  //=============================
  void send_tap_ir(uint8_t tap, uint32_t irval)
  {
    set_all_taps_bypass();
    set_tap_ir(tap, irval);
    update_ir();
  }

  //=============================
  // set_tap_dr 
  //=============================
  void send_tap_dr(uint8_t tap, uint32_t bits, uint32_t *data)
  {
    set_dr_tap_data(tap, bits, (uint8_t*)data);
    update_dr();
  }

  //=============================
  // set_all_taps_bypass
  //=============================
  void set_all_taps_bypass()
  {
    for(uint8_t i=0;i<tap_cnt;i++) {
      set_tap_bypass(i);
    }
  }

  //=============================
  // set_tap_state
  //=============================
  void set_tap_bypass(uint32_t tap)
  {
    uint32_t tap_byp = ((1<<taps[tap]->ir_size)-1);
    taps[tap]->mode = tap_byp;
    taps[tap]->bypass = true;
    //PRINT_VERBOSE(2, "Setting Tap IR: %-20s BYPASS(0x%02x)\n", taps[tap]->tapName, (unsigned int)tap_byp);
    //printf("Setting Tap IR: %-20s BYPASS(0x%02x)\n", taps[tap]->tapName, (unsigned int)tap_byp);
  }

  //=============================
  // set_tap_state
  // FIXME: Need to check if the value here is bypass
  //=============================
  void set_tap_ir(uint32_t tap, uint32_t inst)
  {
    taps[tap]->mode = inst;
    //PRINT_VERBOSE(2, "TAP(%d) IR: %-20s Mode(0x%x)\n", (int)tap, taps[tap]->tapName, (unsigned int)inst);
    //printf("TAP(%d) IR: %-20s Mode(0x%x)\n", (int)tap, taps[tap]->tapName, (unsigned int)inst);
    taps[tap]->bypass = false;  
    return;
  }

  
  //=============================
  // get_dr_chain_length in bits
  //=============================
  uint32_t get_dr_chain_length()
  {
    // Get the DR tap chain length
    uint32_t tap_chain_length=0;
    for(uint8_t i=0;i<tap_cnt;i++) {
      if(taps[i]->disabled) {
        continue; 
      } else if(taps[i]->bypass) {
        tap_chain_length++;
      } else { 
        tap_chain_length += taps[i]->txbits;
      }
      //PRINT_VERBOSE(2, "GET_DR_CHAIN_LENGTH: taps[%u] %0s dr_size=%0lu disabled=%d bypass=%0d tap_chain_length=%0lu\n", 
		  //     i, taps[i]->tapName,taps[i]->txbits, taps[i]->disabled, taps[i]->bypass, tap_chain_length);
      //printf("GET_DR_CHAIN_LENGTH: taps[%u] %0s dr_size=%0lu disabled=%d bypass=%0d tap_chain_length=%0lu\n", 
		  //     i, taps[i]->tapName,taps[i]->txbits, taps[i]->disabled, taps[i]->bypass, tap_chain_length);
    }
    return tap_chain_length;

  }

  //=============================
  // update_dr
  //=============================
  void update_dr()
  {
    //const uint8_t * ret_val;

    // Get the DR tap chain length
    uint32_t tap_chain_length= get_dr_chain_length();

    // Calculate bytes needed
    uint32_t tap_chain_bytes = get_bytes_from_bits(tap_chain_length);

    // Allocate buffer
    //PRINT_VERBOSE(2, "UPDATE_DR: TAP CHAIN LENGTH BITS(%d) BYTES(%d)\n", (int)tap_chain_length, (int)tap_chain_bytes);
    uint8_t *dr_tap_data = (uint8_t*)calloc(tap_chain_bytes, 1);
    
    // Generate shift data
    uint32_t obit_num = 0;
    for(uint8_t i=0;i<tap_cnt;i++) {
      TAP_DEF_t *tap = taps[i]; 
      uint32_t tap_bits;
      if(tap->disabled) {
        //PRINT_VERBOSE(2, "TAP(%d): Disabled\n", i);
        tap_bits = 0;
      } else if(tap->bypass) {
        //PRINT_VERBOSE(2, "TAP(%d): Bypass\n", i);
        tap_bits = 1;
      } else {
        //PRINT_VERBOSE(2, "TAP(%d): ", i);
        //print_array_bits(2, tap->txbits, tap->data);
        tap_bits = tap->txbits;
      }

      // Update Array
      for(uint8_t j=0;j<tap_bits;j++) {
        uint8_t bit;
        bit = (tap->bypass) ? 0 : get_bit_in_array(j, taps[i]->data);
        set_bit_in_array(obit_num, bit, dr_tap_data);
        obit_num++; 
      } 
    }

    //PRINT_VERBOSE(2,"TX TAP CHAIN: ");
    //print_array(2, tap_chain_bytes, dr_tap_data);

    // Shift data
    jbp->shift_dr(tap_chain_length, dr_tap_data);

    //PRINT_VERBOSE(2,"RX TAP CHAIN: ");
    //print_array(2, tap_chain_bytes, dr_tap_data);

    // Update taps with shifted data
    uint32_t dr_bit = 0;
    for(uint8_t i=0; i<tap_cnt; i++)
    {
      if (taps[i]->disabled)
      {
        //PRINT_VERBOSE(2, "TAP(%d): Disabled\n", i);
        continue;
      }
      else if (taps[i]->bypass)
      {
        //PRINT_VERBOSE(2, "TAP(%d): Bypass\n", i);
        dr_bit += 1;
        continue;
      }
      else
      {
        for(uint32_t j=0; j<taps[i]->txbits; j++)
        {
          uint8_t bit = get_bit_in_array(j+dr_bit,dr_tap_data);
          set_bit_in_array(j,bit,taps[i]->data);
        }
        dr_bit += taps[i]->txbits;
        //PRINT_VERBOSE(2, "TAP(%d): ", i);
        //print_array_bits(2, taps[i]->txbits, taps[i]->data);
      }
    }

    // Clean up
    free(dr_tap_data);

  }

  //=============================
  // Get DR data for a TAP
  //=============================
  //void get_dr_data(uint8_t tap_sel, const uint8_t *in, uint8_t *out)
  //{
  //  uint32_t bit=0;
  //  uint32_t obit=0;
  //  for(uint8_t i=0;i<tap_cnt;i++) {
  //    TAP_DEF_t *tap = taps[i]; 
  //    uint32_t obits = (tap->bypass) ? 1 : taps[i]->txbits;
  //    for(uint32_t j=0;j<obits;j++) {
  //      if(tap_sel == i) {
  //        if(tap->bypass || tap->disabled) {
  //          printf("ERROR...Trying to read data from a bypassed/disabled TAP(%d)\n", i);
  //          exit(1);
  //        }
  //        set_bit_in_array(obit++, get_bit_in_array(bit++, in), out);
  //      } else {
  //        bit++;
  //      }
  //    }
  //  } 
  //  return;
  //}
  void get_dr_data(uint8_t tap_sel, uint32_t *bits, uint8_t *out)
  {
    if (taps[tap_sel]->bypass || taps[tap_sel]->disabled)
    {
      printf("ERROR...Trying to read data from a bypassed/disabled TAP(%d)\n", tap_sel);
      return;
    }
    else
    {
      *bits = taps[tap_sel]->txbits;
      out = taps[tap_sel]->data;
    }
  }

  //=============================
  // get_ir_chain_length in bits
  //=============================
  uint32_t get_ir_chain_length()
  {
    // Get the tap chain length
    uint32_t tap_chain_length=0;
    for(uint8_t i=0;i<tap_cnt;i++) {
      if(!taps[i]->disabled) {
        tap_chain_length += taps[i]->ir_size;
      }
      //PRINT_VERBOSE(2, "GET_IR_CHAIN_LENGTH: taps[%d] ir_size=%0d disabled=%d tap_chain_length=%d\n", 
			//i, taps[i]->ir_size, taps[i]->disabled, tap_chain_length);
    }
    return tap_chain_length;
  }

  //=============================
  // update_ir
  //=============================
  void update_ir()
  {
    // Get the tap chain length
    uint32_t tap_chain_length = get_ir_chain_length();

    // Calculate bytes needed
    uint8_t tap_chain_bytes = get_bytes_from_bits(tap_chain_length);

    //PRINT_VERBOSE(2, "UPDATE_IR: TAP CHAIN LENGTH BITS(%d) BYTES(%d)\n", (int)tap_chain_length, (int)tap_chain_bytes);
    // Allocate buffer
    uint8_t *ir_tap_data = (uint8_t*)calloc(tap_chain_bytes, 1);

    // Generate shift data
    uint32_t bit = 0;
    for(uint8_t i=0;i<tap_cnt;i++) {
     uint32_t rshift = 0;
    //PRINT_VERBOSE(2, "[update_ir] TAP[%d] Mode/Inst: %08x\n",i,taps[i]->mode);
     for(uint32_t j=0;j<taps[i]->ir_size;j++) {
        if(!taps[i]->disabled) {
          uint8_t byte = bit/8;
          uint8_t lshift  = bit % 8;
          uint8_t mask = (taps[i]->mode>>rshift)<<lshift;
          ir_tap_data[byte] |= mask; 
          lshift++;
          rshift++;
          bit++;
        }
      } 
    }

    // Debug Print
    //PRINT_VERBOSE(2, "IR TAP Chain Length: %d\n", (int)tap_chain_length);
    //print_array(2, tap_chain_bytes, ir_tap_data);

    // Shift the data
    jbp->shift_ir(tap_chain_length, ir_tap_data);

    // Cleanup
    free(ir_tap_data);
  }

};
