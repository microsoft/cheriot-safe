//
//  msftDvIp_dmb_driver.h
//
//  This is a port of the DMB driver used in regressions
//  - (firmware/lib/inc/drivers/dmb/dmb_driver.h)
//
//  Make it more like the other drivers in the MsftDvIp project.
//  * Remove the #ifdef's as this supports DMB-msftDvIp only.
//  * Remove any reference to the attribute registers
//    - they are not in this version of the IP.
//  * Other subtle, some not-so subtle changes.
//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

#ifndef __DMB_DRIVER_HEADER_INC__
#define __DMB_DRIVER_HEADER_INC__

#pragma once
#include "msftDvIp_dmb_subsystem.h"


//  If for nothing else, pull in the definition of NULL
#include <stdlib.h>

//#define NULL (0)

#define COH_BIT_LSB    (13)
#define OFFSET_BIT_LSB (18)
#define SIZE_BIT_LSB   (14)
#define VMA_LSB        (27)
#define VMA_MSB        (40)
#define MAX_SEGEMNTS   (32)

#define PRIV_PERM_DATA_PTR *((volatile uint32_t*)(dmb_base + DMB_PRIV_PERM_REGISTER))
#define USER_PERM_DATA_PTR *((volatile uint32_t*)(dmb_base + DMB_USER_PERM_REGISTER))
#define CRYPTO_PERM_DATA_PTR *((volatile uint32_t*)(dmb_base + DMB_CRYPTO_PERM_REGISTER))
#define UM_SEG_ACCESS_EN_DATA_PTR *((volatile uint32_t*)(dmb_base + DMB_ACCESS_ENABLE_REGISTER))

/**
* Class that assists in driving data to Sytem via the SP.
* The DMB driver supports multiple variants of HSP subsystem.\n
* Version 0: Athena\n
* Version 1: Pioneer\n
*/
class DMB_DRIVER {
   
   /** Variable to track used DMB segments */
   static inline uint32_t dmb_table = 0;
   /** Variable to track DMB BASE Address */
   static inline uint32_t dmb_base /*= SSY_HSP_DMB_BASE_ADDR*/;
   /** Variable to track valid DMB segments of this Testbench */
   static inline uint32_t dmb_vld_seg_map = DMB_VALID_SEGMENT_MAP /*SSY_HSP_DMB_DEF_SEG_MAP*/;

   static inline uint32_t dmb_access_ena_reg;

   public:

  /**
   * An enum to Enable or Disable priviledge segment data.
   */
   enum PRIV_SEG_DATA   {
                         PRIV_DISABLE=0x0, /**< enum vaue DISABLE */
                         PRIV_ENABLE=0x1  /**< enum vaue ENABLE */
                        };
   /**
   * An enum to Enable or Disable user segment data.
   */
   enum USER_SEG_DATA   {
                         USER_DISABLE=0x0, /**< enum vaue DISABLE */
                         USER_ENABLE=0x1  /**< enum vaue ENABLE */
                        };
   /**
   * An enum to Enable or Disable crypto segment data.
   */
   enum CRYPTO_SEG_DATA {
                         CRYPTO_DISABLE=0x0, /**< enum vaue DISABLE */
                         CRYPTO_ENABLE=0x1  /**< enum vaue ENABLE */
                        };

   /**
   * An enum to Enable or Disable Secure bit
   */
   enum SECURE_BIT     {
                         SECURE_DISABLE=0x0, /**< enum value DISABLE */
                         SECURE_ENABLE=0x1 /**< enum value ENABLE */
                       };

   /**
   * An enum for window_n
   */
   enum WINDOW_N       {
                         WINDOW_0=0x0, /**< window_n value 0 */
                         WINDOW_1=0x1, /**< window_n value 1 */
                         WINDOW_2=0x2, /**< window_n value 2 */
                         WINDOW_3=0x3, /**< window_n value 3 */
                         WINDOW_4=0x4, /**< window_n value 4 */
                         WINDOW_5=0x5, /**< window_n value 5 */
                         WINDOW_6=0x6, /**< window_n value 6 */
                         WINDOW_7=0x7, /**< window_n value 7 */
                         WINDOW_8=0x8, /**< window_n value 8 */
                         WINDOW_9=0x9, /**< window_n value 9 */
                         WINDOW_A=0xA, /**< window_n value 10 */
                       };
   /**
   * An enum to for Coherent bit
   */
   enum COHERENT_BIT   {
                         COHERENT_0=0x0, /**< enum value Coh=0 */
                         COHERENT_1=0x1, /**< enum value Coh=1 */
                       };
   /**
   * An enum to for Segment offset
   */
   enum SEGMENT_OFFSET {
                         SEG_OFFSET_0=0x0, /**< enum value seg_offset=0x0 */
                         SEG_OFFSET_FF=0xFF, /**< enum value seg_offset=0xFF */
                         SEG_OFFSET_FFFF=0x3FF, /**< enum value seg_offset=0x3FF */
                       };
   /**
   * An enum to Axuser bits
   */
   enum AXUSER_BITS {
                         AXUSER_0=0x0, /**< enum value AXUSER=0 */
                         AXUSER_1=0x1, /**< enum value AXUSER=1 */
                         AXUSER_2=0x2, /**< enum value AXUSER=2 */
                         AXUSER_3=0x3, /**< enum value AXUSER=3 */
                   };

  /** Constructor */
   DMB_DRIVER(uint32_t addr) {
   	dmb_base = /*(uint32_t)*/ addr;
	dmb_vld_seg_map = DMB_VALID_SEGMENT_MAP;
	dmb_access_ena_reg = addr + DMB_ACCESS_ENABLE_REGISTER;
	dmb_table = 0;  //  Reset the in-use table
   }
 
   /**
   * Method to get the um_segement_access_en register contents
   * @return uint32_t : um_segement_access_en register value  
   */
   uint32_t get_user_segment_access_en()
   {
      return((uint32_t) *((uint32_t *)dmb_access_ena_reg)/*hw_read32((uint32_t *)(dmb_base + 0x30C))*/);
   }
   /**
   * Method to get the user permission register contents
   * @return uint32_t : user permission register value  
   */
   uint32_t get_user_permission()
   {
      return(*((uint32_t *)(dmb_base + 0x304)));
   }
   /**
   * Method to get the privilege permission register contents
   * @return uint32_t : privilege permission register value  
   */
   uint32_t get_privilege_permission()
   {
      return(*((uint32_t *)(dmb_base + 0x300)));
   }
   /**
   * Method to set the priviledge permission data. 
   * @param seg_ptr : to the segment that needs to be enabled/disabled
   * @param data : Bit value to be set for priviledge permission for that segment.
   */
   void set_priv_perm_data(uint32_t* seg_ptr, uint32_t data)
   {
    /** DMB MAS Section header Permission registers.
     *  In Privilege permission registers, each bit corresponds to a segment,
     *  and writing 1 to that bit ensures that access is allowed. 
     */

    /** From figure 2 of the MAS, Upper 5 bits of the HSP AXI address decided which segment should be accessed, so shifting it right to get segment register value. */   
    uint32_t seg = ((uint32_t) seg_ptr)>>VMA_LSB;
    uint32_t rdata = PRIV_PERM_DATA_PTR;
    rdata &= ~(1<<seg);
    /** shifting it left to set the bit value for the right segment value. */   
    rdata |= (data<<seg);
    PRIV_PERM_DATA_PTR = rdata;
   }
   /**
   * Method to set the user permission data. 
   * @param seg_ptr : to the segment that needs to be enabled/disabled
   * @param data : Bit value to be set for user permission for that segment.
   */
   void set_user_perm_data(uint32_t* seg_ptr, uint32_t data)
   {
    /** DMB MAS Section header - 10.7.2	User/Privilege Mode Access Check for Configuration Registers 
     *  In User permission registers, each bit corresponds to a segment,
     *  and writing 1 to that bit ensures that access is allowed. 
     */

    /** From figure 2 of the MAS, Upper 5 bits of the HSP AXI address decided which segment should be accessed, so shifting it right to get segment register value. */   
    uint32_t seg = ((uint32_t) seg_ptr)>>VMA_LSB;
    uint32_t rdata = USER_PERM_DATA_PTR;
    rdata &= ~(1<<seg);
    /** shifting it left to set the bit value for the right segment value. */   
    rdata |= (data<<seg);
    USER_PERM_DATA_PTR = rdata;
   }
   /**
   * Method to set the crypto permission data. 
   * @param seg_ptr : to the segment that needs to be enabled/disabled
   * @param data : to be set for crypto permission.
   */
   void set_crypto_perm_data(uint32_t* seg_ptr, uint32_t data)
   {
    /** DMB MAS Section header - 10.7.1	User/Privilege/Crypto Permission Access Check for Non-Configuration Registers 
     *  In Crypto permission registers, each bit corresponds to a segment,
     *  and writing 1 to that bit ensures that access is allowed. 
     */

    /** From figure 2 of the MAS, Upper 5 bits of the HSP AXI address decided which segment should be accessed, so shifting it right to get segment register value. */   
    uint32_t seg = ((uint32_t) seg_ptr)>>VMA_LSB;
    uint32_t rdata = CRYPTO_PERM_DATA_PTR;
    rdata &= ~(1<<seg);
    /** shifting it left to set the bit value for the right segment value. */   
    rdata |= (data<<seg);
    CRYPTO_PERM_DATA_PTR = rdata;
   }
   /**
   * Method to set the um_segement_access_en data. 
   * @param seg_ptr : to the segment that needs to be enabled/disabled
   * @param data : Bit value to be set for user permission for that segment.
   */
   void set_um_seg_access_en_data(uint32_t* seg_ptr, uint32_t data)
   {
    uint32_t seg = ((uint32_t) seg_ptr)>>VMA_LSB;
    uint32_t rdata = UM_SEG_ACCESS_EN_DATA_PTR;
    rdata &= ~(1<<seg);
    rdata |= (data<<seg);
    UM_SEG_ACCESS_EN_DATA_PTR = rdata;
   }
#ifdef NEVER_DEFINED
   /**
   * Method to set segment attributes
   * Defaults are high = 0xFFFFFFFF and low 0xFFFFFFFF
   * @param seg_ptr : pointer to segment to update.
   * @param high : attribute data
   * @param low : attribute data
   */
   void set_seg_attr_data(uint32_t* seg_ptr, uint32_t high, uint32_t low)
   {
    uint32_t seg = ((uint32_t) seg_ptr)>>VMA_LSB;
    //Update segment attributes
    *( (volatile uint32_t*) ((dmb_base)+(0x80)+(seg*8) )) = high;
    *( (volatile uint32_t*) ((dmb_base)+(0x84)+(seg*8) )) = low;
   }
#endif
   /**
   * Method to set Axuser data 
   * @param seg_ptr : pointer to segment to update.
   * @param axuser : axuser data
   *
   * - Does not exist in DMB version 1.00
   */
   void set_user_data(uint32_t* seg_ptr, uint8_t axuser)
   {
    uint32_t seg = ((uint32_t) seg_ptr)>>VMA_LSB;
    //Update axuser bits[31:24]
    uint32_t rdata= *( (volatile uint32_t*) ((dmb_base)+(0x180)+(seg*4)));
    rdata = (rdata & (~0xFF000000)) | ((uint32_t)axuser << 24);
    *((volatile uint32_t*) ((dmb_base)+(0x180)+(seg*4)))= rdata;
   }
   /**
   * Method to set Extended Segment Configuration Registers 
   * @param seg_ptr : pointer to segment to update.
   * @param wc_vect : wc_vect data
   * @param rc_vect : rc_vect data
   */
   void set_ext_cfg_regs(uint32_t* seg_ptr, uint8_t wc_vect, uint8_t rc_vect)
   {
     uint32_t seg = ((uint32_t) seg_ptr)>>VMA_LSB;  // extract register (18:31)
     uint32_t rdata= *( (volatile uint32_t*) ((dmb_base)+(0x200)+(seg*4)));
     rdata = (rdata & (~0x000000FF)) | ((uint32_t)wc_vect << 4) | ((uint32_t)rc_vect);
     *((volatile uint32_t*) ((dmb_base)+(0x200)+(seg*4)))= rdata;
   }
   /**
   * Method to release a pointers of the acquired handle via dmb_acquire.
   * @param hsp_axi_address : to be released from DMB table.
   * @return uint32_t : 0. 
   * Added clear_seg_reg - since after cm33 boot, segment registers should 
   * be cleared when released, but they should not be zeroeod out when we 
   * run error tests. Added this bit, so we can choose depending on the scenario, 
   * when we want to clear these registers or not. 
   */ 
   uint32_t dmb_release(uint32_t* hsp_axi_address, uint32_t clear_seg_reg=0x0) 
   {
     uint32_t dmb_acq_handle = ((uint32_t) hsp_axi_address) >> VMA_LSB;
     if (clear_seg_reg != 1){
       *( (volatile uint32_t*) ((dmb_base)+((dmb_acq_handle*8)/2) )) = 0;
     }
     //Clear segment attributes
     *( (volatile uint32_t*) ((dmb_base)+(0x80)+(dmb_acq_handle*8) )) = 0;
     *( (volatile uint32_t*) ((dmb_base)+(0x84)+(dmb_acq_handle*8) )) = 0;
     //Clear priviledge, user and crypto for the segment 
     set_priv_perm_data(hsp_axi_address,PRIV_SEG_DATA::PRIV_DISABLE);
     set_user_perm_data(hsp_axi_address,USER_SEG_DATA::USER_DISABLE);
     set_crypto_perm_data(hsp_axi_address,CRYPTO_SEG_DATA::CRYPTO_DISABLE);
     dmb_table &= ~(0x1<<dmb_acq_handle);
     return 0;
   }

   /**
   * Method to acquire a pointer to be able to Write or Read via DMB.
   * @param address : one wants to access.
   * @param coh : Value of coherent bit. Default 0.
   * @param window_n : Number of windows for segment. Default 10.
   * @param segment_offset : Default 0.
   * @param sec: Default 1. Secure bit in segment register.
   * @param user: Default 0. User bits in Upper segment register.
   * @return uint32_t* : pointer to access the input address 
   */ 
   uint32_t* dmb_acquire(uint64_t address, uint32_t coh=0x0, uint32_t window_n=0xA, uint32_t segment_offset=0x0,uint32_t non_sec=0x0,uint32_t user=0x0)
   {
    //Segment data
    uint32_t dmb_seg_reg_data;
    uint32_t addr_data = address>>VMA_LSB;
    //if the window_n not equal to 10, then configure the segment_offset
    //to bits [26:17] of the address
    if (window_n != 0xA) {
      segment_offset = ((address>>17) & 0x3ff);
    }
    uint32_t upper_reg_addr = address>>VMA_MSB;
    uint32_t upper_addr_data = (((user &=0xFF)<<24) | (upper_reg_addr &= 0xFFFFFF));
    dmb_seg_reg_data = (((non_sec &= 0x1)<<28) | ((segment_offset &= 0x3ff)<<18) | ((window_n&= 0xf)<<14) | ((coh&= 0x1)<<13) | (addr_data &= 0x1FFF));

    //Segment selection
    uint32_t free_dmb_entry;
    uint32_t free_dmb_entry_map = dmb_vld_seg_map & ~dmb_table;
    // If all entries used up then report Error
    if (free_dmb_entry_map == (uint32_t) 0) 
    {
      printf(" ERROR : No dmb entry available.");
      //write(1, " ERROR : No dmb entry available.\n", 33);
      //exit(1);
      return NULL;
    }
    //  Allocate available DMB segment 
    for (uint32_t i=0; i<DMB_MAX_SEGMENTS; i++) {
      if ((free_dmb_entry_map & (0x1<<i)) ) {
        free_dmb_entry = i;
        dmb_table |= (0x1<<i);
        break;
      }
      free_dmb_entry = i;
    }

    //Calculate the pointer to access the incoming address
    uint32_t seg_ba = (0x1 << VMA_LSB) * free_dmb_entry;
    uint32_t* mapAddr = (uint32_t*) ((seg_ba) | ((uint32_t)(address & ~(~0 << VMA_LSB))));

    //Write to segment and its attributes
    *(((uint32_t*)dmb_base)+free_dmb_entry) = dmb_seg_reg_data;
#ifdef NEVER_DEFINED
    *( (volatile uint32_t*) ((dmb_base)+(0x80)+(free_dmb_entry*8))) = seg_attr_high_data;
    *( (volatile uint32_t*) ((dmb_base)+(0x84)+(free_dmb_entry*8))) = seg_attr_low_data;
#endif
    //Write to Upper Address bits for segment
    *( (volatile uint32_t*) ((dmb_base)+(0x180)+(free_dmb_entry*4))) = upper_addr_data;
    //Write to priviledge, user and crypto permission data 
    set_priv_perm_data(mapAddr,PRIV_SEG_DATA::PRIV_ENABLE);
    set_user_perm_data(mapAddr,USER_SEG_DATA::USER_ENABLE);
    set_crypto_perm_data(mapAddr,CRYPTO_SEG_DATA::CRYPTO_ENABLE);
    return (mapAddr);
   }
};

#endif //__DMB_DRIVER_HEADER_INC__
