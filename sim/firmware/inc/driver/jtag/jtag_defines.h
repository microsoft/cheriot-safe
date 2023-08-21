
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

// Copyright (C) Microsoft Corporation. All rights reserved.

#ifndef __JTAG_DEFINES_INCLUDE__
#define __JTAG_DEFINES_INCLUDE__

// ==================
// For SSY_* defines.
// ==================
#include <subsystem_defs.h>
#include <creg_subsystem.h> ///< For INIT_STATUS_* defines
#include <jtag_iface_base.h>

#define JTAG_MBX_WRITES_MAX   0x7777
#define JTAG_NUM_MAIL_BOXES   2
#define INIT_STAT_SP_RESET    0x10

#define SS_UNKNOWN 0x0
#define SS_BLANK   0x1
#define SS_TEST    0x2
#define SS_PROD    0x4
#define SS_SECURE  0x8
#define SS_RETEST  0x10

#define MEMORY_REG_MASK        0x7FF ///< Valid Memory register bits


#define SPROM_BIST_DONE_BIT_POS 6
#define SPROM_BIST_PASS_BIT_POS 12
#define LSM_STS_LOAD_PASS_OR_ERROR 0xc0000000 //LOAD_PASS: bit 31, LOAD_ERROR: bit i30

// ==================================
// Checking whether AEBs are enabled.
// ==================================

#ifndef JTAG_TDR_AEB_ALLOW_TDR_RST
 #define JTAG_TDR_AEB_ALLOW_TDR_RST 0
#endif

#ifndef JTAG_TDR_AEB_SP_DBGTAP_EN
 #define JTAG_TDR_AEB_SP_DBGTAP_EN  0
#endif

#ifndef JTAG_TDR_AEB_SP_EN
 #define JTAG_TDR_AEB_SP_EN         0
#endif

 #define TDR_REG_NUM             21
 #define TDR_SPROM_BIST_LENGTH   
#ifdef FORCE_SOCID_AND_SS128
 #define JTAG_TDR_SOC_ID_0 0xBBDDEEFF
 #define JTAG_TDR_SOC_ID_1 0xFFEEDDBB
 #define JTAG_TDR_SOC_ID_2 0xEE77BBDD
 #define JTAG_TDR_SOC_ID_3 0xDDBBFFEE
 #define JTAG_TDR_SS_128_0 JTAG_TDR_SOC_ID_3
 #define JTAG_TDR_SS_128_1 JTAG_TDR_SOC_ID_2
 #define JTAG_TDR_SS_128_2 JTAG_TDR_SOC_ID_1
 #define JTAG_TDR_SS_128_3 JTAG_TDR_SOC_ID_0
#else
 #define JTAG_TDR_SOC_ID_0 0
 #define JTAG_TDR_SOC_ID_1 0
 #define JTAG_TDR_SOC_ID_2 0
 #define JTAG_TDR_SOC_ID_3 0
 #define JTAG_TDR_SS_128_0 0
 #define JTAG_TDR_SS_128_1 0
 #define JTAG_TDR_SS_128_2 0
 #define JTAG_TDR_SS_128_3 0
#endif

#define DMB_PRIVILEGE_PERMISSION_REG_ADDR 0x8f0f0300

// ===========================
// Subsystem specific defines.
// ===========================

// no_sp_tap (Secure State: true) - Manticore
// tdr_tap_only -Willow Eaglecreek
// ===========================
//             DLP
// ===========================
#if defined SSY_HSP_DLP
  
  #define JTAG_TDR_MBX_SEL_PRJ  false

  #define JTAG_TDR_CTRL_LENGTH        38
  #define JTAG_TDR_CTRL_LENGTH_BYTES  5
  #define JTAG_TDR_CTRL_WSEL_OFFSET   2

  #if defined JTAG_TDR_SECURE_TEST
    #define TAPNAMES {(char *)"tdr", (char *)"riscv_dv"};
    #define IR       {5, 5};
    #define IDCODES  {0x1, 0x1};
    #define TYPES     {TAP_DV_TDR, TAP_DV_DBG}
    #define LEN      2
  #else
    #define TAPNAMES  {(char *)"TDR", (char *)"DBG", (char *)"SP"}
    #define IR        {5, 5, 5}
    #define IDCODES   {0x1, 0x1, 0x1}
    #define TYPES     {TAP_DV_TDR, TAP_DV_DBG, TAP_DV_HSP}
    #define LEN       3
  #endif

  #define JTAG_TDR_AEB_BIST0     0xB0B60DC6
  #define JTAG_TDR_AEB_BIST1     0x5969ED84
  #define JTAG_TDR_AEB_BIST2     0x18181FEA
  #define JTAG_TDR_AEB_BIST3     0x00000000
  #define JTAG_TDR_IDCODE        0x000524AB

  // From fortress/subsystem/<SS>/firmware/lib/inc/creg_subsystem.h
  #define JTAG_TDR_STS_INIT0 INIT_STATUS_0_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT1 INIT_STATUS_1_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT0_RST JTAG_TDR_STS_INIT0
  #define JTAG_TDR_STS_INIT1_RST JTAG_TDR_STS_INIT1
  #define JTAG_TDR_STS_LSM0      0x22020202
  #define JTAG_TDR_STS_LSM1      0x80000002
  #define JTAG_TDR_STS_LSM0_RST  JTAG_TDR_STS_LSM0
  #define JTAG_TDR_STS_LSM1_RST  JTAG_TDR_STS_LSM1

  #define  NUM_BITS_FATAL_ERR_STS 12
  #define NUM_BITS_STICKY_FATAL_ERR_STS 11
  #define CRYPTO_REG_MASK 0x7FFFFF ///< Possible Crypto error bits for Athena
  
  #define PKA2_EDC_ERR_BIT_MASK 0x080 ///< For DLP
  #define SHAREDRAM_EDC_ERR_BIT_MASK 0x40 ///< Shared RAM error bit mask for DLP


  #define is_athena_pioneer_or_skyline 0
  #define IS_DLP 1
  #define NUM_MEM_ERR_SOURCE 11
  #define KSU_ECC_ERR_BIT_MASK   0x200 ///< KSU memory error bit mask
  #define NUM_MEM_ERR_2_SOURCE 0
  #define SS_MISMATCH_ERR_BIT_MASK 0x40000
  #define CRYPTO_REG_MASK_SS_MISMATCH 0x40007 ///< Possible Crypto error bits
#else
  #define IS_DLP 0
#endif 

// ===========================
//           ATHENA
// ===========================
#if defined SSY_HSP_ATHENA
  
  #define JTAG_TDR_MBX_SEL_PRJ  TDR_CTRL_J2P_MBX_WR_ATHENA_SEL

  #define JTAG_TDR_CTRL_LENGTH        38
  #define JTAG_TDR_CTRL_LENGTH_BYTES  5
  #define JTAG_TDR_CTRL_WSEL_OFFSET   2

  #if defined JTAG_TDR_SECURE_TEST
    #define TAPNAMES {(char *)"tdr", (char *)"riscv_dv"};
    #define IR       {5, 5};
    #define IDCODES  {0x1, 0x1};
    #define TYPES     {TAP_DV_TDR, TAP_DV_DBG}
    #define LEN      2
  #else
    #define TAPNAMES  {(char *)"TDR", (char *)"DBG", (char *)"SP"}
    #define IR        {5, 5, 5}
    #define IDCODES   {0x1, 0x1, 0x1}
    #define TYPES     {TAP_DV_TDR, TAP_DV_DBG, TAP_DV_HSP}
    #define LEN       3
  #endif

  #define JTAG_TDR_AEB_BIST0     0x0C1B55AC
  #define JTAG_TDR_AEB_BIST1     0x5A6565F3
  #define JTAG_TDR_AEB_BIST2     0x24F569B8
  #define JTAG_TDR_AEB_BIST3     0x5E49A0F1

  #define JTAG_TDR_IDCODE        0x000504AB
  //#define JTAG_TDR_STS_INIT0_RST 0xD7F7FF30
  //#define JTAG_TDR_STS_INIT1_RST 0x4B000083
  // From fortress/subsystem/<SS>/firmware/lib/inc/creg_subsystem.h
  #define JTAG_TDR_STS_INIT0 INIT_STATUS_0_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT1 INIT_STATUS_1_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT0_RST JTAG_TDR_STS_INIT0
  #define JTAG_TDR_STS_INIT1_RST JTAG_TDR_STS_INIT1
  #define JTAG_TDR_STS_LSM0      0x22020202
  #define JTAG_TDR_STS_LSM1      0x82222222
  #define JTAG_TDR_STS_LSM0_RST  JTAG_TDR_STS_LSM0
  #define JTAG_TDR_STS_LSM1_RST  JTAG_TDR_STS_LSM1

  #define AEB_BIST_DONE_BIT 14;
  #define AEB_BIST_PASS_BIT 15;

  #define NUM_BITS_FATAL_ERR_STS 12
  #define NUM_BITS_STICKY_FATAL_ERR_STS 11

  #define CRYPTO_REG_MASK 0x7FFFFF ///< Possible Crypto error bits for Athena
  #define is_athena_pioneer_or_skyline 1

  #define NUM_MEM_ERR_SOURCE 24
  #define NUM_MEM_ERR_2_SOURCE 0
  #define KSU_ECC_ERR_BIT_MASK   0x200 ///< KSU memory error bit mask


  #define PKA2_EDC_ERR_BIT_MASK 0x200 ///< PKA RAM 2 error bit mask for Athena/Pioneer/Skyline
  #define SHAREDRAM_EDC_ERR_BIT_MASK 0x80 ///< Shared RAM error bit mask for Athena/Skyline

  #define SS_MISMATCH_ERR_BIT_MASK 0x2000
  #define CRYPTO_REG_MASK_SS_MISMATCH 0x2007 ///< Possible Crypto error bits
    #define SP_TAP_OFF_STAT true
#endif

// ===========================
//           ATHENA_B0
// ===========================
#if defined SSY_HSP_ATHENA_B0
  
  #define JTAG_TDR_MBX_SEL_PRJ  TDR_CTRL_J2P_MBX_WR_ATHENA_SEL

  #define JTAG_TDR_CTRL_LENGTH        38
  #define JTAG_TDR_CTRL_LENGTH_BYTES  5
  #define JTAG_TDR_CTRL_WSEL_OFFSET   2

  #if defined JTAG_TDR_SECURE_TEST
    #define TAPNAMES {(char *)"tdr", (char *)"riscv_dv"};
    #define IR       {5, 5};
    #define IDCODES  {0x1, 0x1};
    #define TYPES     {TAP_DV_TDR, TAP_DV_DBG}
    #define LEN      2
  #else
    #define TAPNAMES  {(char *)"TDR", (char *)"DBG", (char *)"SP"}
    #define IR        {5, 5, 5}
    #define IDCODES   {0x1, 0x1, 0x1}
    #define TYPES     {TAP_DV_TDR, TAP_DV_DBG, TAP_DV_HSP}
    #define LEN       3
  #endif

  #define JTAG_TDR_AEB_BIST0     0x2D5E41DC
  #define JTAG_TDR_AEB_BIST1     0xDA6565F3 
  #define JTAG_TDR_AEB_BIST2     0x417351BB 
  #define JTAG_TDR_AEB_BIST3     0x1F4C3E88 

  #define JTAG_TDR_IDCODE        0x000504AB
  //#define JTAG_TDR_STS_INIT0_RST 0xD7F7FF30
  //#define JTAG_TDR_STS_INIT1_RST 0x4B000083
  // From fortress/subsystem/<SS>/firmware/lib/inc/creg_subsystem.h
  #define JTAG_TDR_STS_INIT0 INIT_STATUS_0_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT1 INIT_STATUS_1_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT0_RST JTAG_TDR_STS_INIT0
  #define JTAG_TDR_STS_INIT1_RST JTAG_TDR_STS_INIT1
  #define JTAG_TDR_STS_LSM0      0x22020202
  #define JTAG_TDR_STS_LSM1      0x82222222
  #define JTAG_TDR_STS_LSM0_RST  JTAG_TDR_STS_LSM0
  #define JTAG_TDR_STS_LSM1_RST  JTAG_TDR_STS_LSM1

  #define AEB_BIST_DONE_BIT 14;
  #define AEB_BIST_PASS_BIT 15;

  #define NUM_BITS_FATAL_ERR_STS 12
  #define NUM_BITS_STICKY_FATAL_ERR_STS 11

  #define CRYPTO_REG_MASK 0x7FFFFF ///< Possible Crypto error bits for Athena
  #define is_athena_pioneer_or_skyline 1

  #define NUM_MEM_ERR_SOURCE 24
  #define NUM_MEM_ERR_2_SOURCE 0
  #define KSU_ECC_ERR_BIT_MASK   0x200 ///< KSU memory error bit mask


  #define PKA2_EDC_ERR_BIT_MASK 0x200 ///< PKA RAM 2 error bit mask for Athena/Pioneer/Skyline
  #define SHAREDRAM_EDC_ERR_BIT_MASK 0x80 ///< Shared RAM error bit mask for Athena/Skyline

  #define SS_MISMATCH_ERR_BIT_MASK 0x2000
  #define CRYPTO_REG_MASK_SS_MISMATCH 0x2007 ///< Possible Crypto error bits
  #define SP_TAP_OFF_STAT true
#endif

// ===========================
//          PIONEER
// ===========================
#if defined SSY_HSP_PIONEER
  
  #define JTAG_TDR_MBX_SEL_PRJ  TDR_CTRL_J2P_MBX_WR_ATHENA_SEL

  #define JTAG_TDR_CTRL_LENGTH        38
  #define JTAG_TDR_CTRL_LENGTH_BYTES  5
  #define JTAG_TDR_CTRL_WSEL_OFFSET   2

  #if defined JTAG_TDR_SECURE_TEST
    #define TAPNAMES {(char *)"tdr", (char *)"riscv_dv"};
    #define IR       {5, 5};
    #define IDCODES  {0x1, 0x1};
    #define TYPES     {TAP_DV_TDR, TAP_DV_DBG}
    #define LEN      2
  #else
    #define TAPNAMES  {(char *)"TDR", (char *)"DBG", (char *)"SP"}
    #define IR        {5, 5, 5}
    #define IDCODES   {0x1, 0x1, 0x1}
    #define TYPES     {TAP_DV_TDR, TAP_DV_DBG, TAP_DV_HSP}
    #define LEN       3
  #endif

  #define JTAG_TDR_AEB_BIST0     0x2A7F37A0
  #define JTAG_TDR_AEB_BIST1     0xE6AB61F3
  #define JTAG_TDR_AEB_BIST2     0xEBCDDD93
  #define JTAG_TDR_AEB_BIST3     0x57EB0492
  //#define JTAG_TDR_IDCODE        0x000544AB
  //#define JTAG_TDR_STS_INIT0_RST 0xBFFFFF30
  //#define JTAG_TDR_STS_INIT1_RST 0x4B00041E
  // From fortress/subsystem/<SS>/firmware/lib/inc/creg_subsystem.h
  #define JTAG_TDR_STS_INIT0 INIT_STATUS_0_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT1 INIT_STATUS_1_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT0_RST JTAG_TDR_STS_INIT0
  #define JTAG_TDR_STS_INIT1_RST JTAG_TDR_STS_INIT1
  #define JTAG_TDR_STS_LSM0      0x002AA222
  #define JTAG_TDR_STS_LSM1      0x80000000
  #define JTAG_TDR_STS_LSM0_RST  JTAG_TDR_STS_LSM0
  #define JTAG_TDR_STS_LSM1_RST  JTAG_TDR_STS_LSM1

  #define AEB_BIST_DONE_BIT 14;
  #define AEB_BIST_PASS_BIT 15;

  #define NUM_BITS_FATAL_ERR_STS 13
  #define NUM_BITS_STICKY_FATAL_ERR_STS 12

  #define CRYPTO_REG_MASK 0x1FFFFFF ///< Possible Crypto error bits for Pioneer and Eaglecreek

  #define is_athena_pioneer_or_skyline 1

  #define NUM_MEM_ERR_SOURCE 24
  #define NUM_MEM_ERR_2_SOURCE 0
  #define KSU_ECC_ERR_BIT_MASK   0x200 ///< KSU memory error bit mask


  #define PKA2_EDC_ERR_BIT_MASK 0x400 ///< For Pioneer, others
  #define SHAREDRAM_EDC_ERR_BIT_MASK 0x100 ///< For Pioneer, others
  #define SS_MISMATCH_ERR_BIT_MASK 0x4000
  #define CRYPTO_REG_MASK_SS_MISMATCH 0x4007 ///< Possible Crypto error bits
  #define SP_TAP_OFF_STAT true
#endif

// ===========================
//          MANTICORE
// ===========================
#if defined SSY_HSP_MANTICORE
  
  #define JTAG_TDR_MBX_SEL_PRJ  TDR_CTRL_J2P_MBX_WR_ATHENA_SEL
  #define JTAG_TDR_TAP_FROM_YML true

  #define JTAG_TDR_CTRL_LENGTH        38
  #define JTAG_TDR_CTRL_LENGTH_BYTES  5
  #define JTAG_TDR_CTRL_WSEL_OFFSET   2

  #define JTAG_TDR_AEB_BIST0     0xE2A1FE95  // To be confirmed
  #define JTAG_TDR_AEB_BIST1     0x0CC5296B  // To be confirmed
  #define JTAG_TDR_AEB_BIST2     0xE34458CA  // To be confirmed
  #define JTAG_TDR_AEB_BIST3     0x9C7CC010  // To be confirmed
  #define JTAG_TDR_IDCODE        0x000574AB
  // From fortress/subsystem/<SS>/firmware/lib/inc/creg_subsystem.h
  #define JTAG_TDR_STS_INIT0 INIT_STATUS_0_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT1 INIT_STATUS_1_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT0_RST 0xFFFFBF23
  #define JTAG_TDR_STS_INIT1_RST 0xCC0117FF
  #define JTAG_TDR_STS_LSM0      0x002AA2AA
  #define JTAG_TDR_STS_LSM1      0x80000000
  #define JTAG_TDR_STS_LSM0_RST  0x002AA222
  #define JTAG_TDR_STS_LSM1_RST  0x80000000
  #define AEB_BIST_DONE_BIT 18
  #define AEB_BIST_PASS_BIT 19

  #define NUM_BITS_FATAL_ERR_STS 17
  #define NUM_BITS_STICKY_FATAL_ERR_STS 16


  #define CRYPTO_REG_MASK 0xFFFFFFFF ///< Possible Crypto error bits for Manticore/Willow
  #define is_athena_pioneer_or_skyline 1

  #define NUM_MEM_ERR_SOURCE 26
  #define NUM_MEM_ERR_2_SOURCE 0
  #define KSU_ECC_ERR_BIT_MASK   0x200 ///< KSU memory error bit mask


  #define PKA2_EDC_ERR_BIT_MASK 0x400 ///< For Pioneer, others
  #define SHAREDRAM_EDC_ERR_BIT_MASK 0x100 ///< For Pioneer, others
  #define SPROM_BIST_DONE_MASK 0x40 //bit 38 (upper bit 6)
  #define SPROM_BIST_PASS_MASK 0x1000 //bit 44 (upper bit 12)
  #define SS_MISMATCH_ERR_BIT_MASK 0x40000
  #define CRYPTO_REG_MASK_SS_MISMATCH 0x40007 ///< Possible Crypto error bits
  /**
   * @brief enum for AEMC register
   */
  enum {
  //emc
  STATUS_REG,
  STICKY_STATUS_REG,
  CLEAR_STATUS_REG,
  CLEAR_STICKY_STATUS_REG,
  POWER_DOWN_WLOCK_REG,
  STATUS_MASK_WLOCK_REG,
  CAL_REG_WLOCK1,
  CAL_REG_WLOCK2,
  POWER_DOWN_REG,
  STATUS_MASK_REG,
  EMC_CAL_UPDATE,
  //emc_common
  SPARE_DIGITAL_OUTPUT_REG,
  ANALOG_TEST_BUS_SEL_REG,
  SPARE_DIGITAL_INPUT_REG,
  TEMPCO_SEL_REG,
  //cmon_cplclk
  CMON_TEMPCO_SEL_REG,
  VDDREG_SEL_REG,
  CLOAD_SEL_REG,
  CTRL_SEL_REG,
  SPEED_SEL_REG,
  LOTIME_MIN_REG,
  PERIOD_MAX_REG,
  PERIOD_MIN_REG,
  HITIME_MAX_REG,
  HOLDOFF_REG,
  HITIME_MIN_REG,
  LOTIME_MAX_REG,
  //tmon
  TM_HICHK_HYST_SEL_REG,
  TM_LOCHK_HYST_SEL_REG,
  TM_HICHK_REF_SEL_REG,
  TM_HICHK_TRIP_SEL_REG,
  TM_LOCHK_REF_SEL_REG,
  TM_LOCHK_TRIP_SEL_REG,
  //vmon_hsp_core
  VHC_FILTERCAP_SEL_REG,
  VHC_HICHK_HYST_SEL_REG,
  VHC_LOCHK_HYST_SEL_REG,
  VHC_HICHK_REF_SEL_REG,
  VHC_HICHK_TRIP_SEL_REG,
  VHC_LOCHK_REF_SEL_REG,
  VHC_LOCHK_TRIP_SEL_REG,
  //vmon_aemc_core
  VAC_FILTERCAP_SEL_REG,
  VAC_HICHK_REF_SEL_REG,
  VAC_LOCHK_REF_SEL_REG,
  VAC_HICHK_TRIP_SEL_REG,
  VAC_LOCHK_TRIP_SEL_REG,

  };

  /**
   * @brief mask bit disabled for wr/rd check
   */
  //mask array has to be aligned w/  enum above
  uint32_t emc_reg_wr_mask[] = {
  //emc
  0,//STATUS_REG,
  0,//STICKY_STATUS_REG,
  0,//CLEAR_STATUS_REG, W1C
  0,//CLEAR_STICKY_STATUS_REG, W1C
  0x3f,//POWER_DOWN_WLOCK_REG,
  0x1fff,//STATUS_MASK_WLOCK_REG,
  0xfff,//CAL_REG_WLOCK1
  0x1ffff,//CAL_REG_WLOCK2,
  0x3f,//POWER_DOWN_REG,
  0x1fff,//STATUS_MASK_REG,
  0x0,//0xf,//EMC_CAL_UPDATE,
  //emc_common
  0x0,//SPARE_DIGITAL_OUTPUT_REG,R
  0xfffff,//ANALOG_TEST_BUS_SEL_REG,
  0xffff,//SPARE_DIGITAL_INPUT_REG,
  0xffff,//TEMPCO_SEL_REG,
  //cmon_cplclk
  0xffff,//TEMPCO_SEL_REG,
  0xffff,//VDDREG_SEL_REG,
  0xffff,//CLOAD_SEL_REG,
  0xffff,//CTRL_SEL_REG,
  0x7,//SPEED_SEL_REG,
  0x3f,//LOTIME_MIN_REG,
  0x1f,//PERIOD_MAX_REG,
  0x3f,//PERIOD_MIN_REG,
  0x1f,//HITIME_MAX_REG,
  0x1f,//HOLDOFF_REG,
  0x3f,//HITIME_MIN_REG,
  0x1f,//LOTIME_MAX_REG,
  //tmon
  0x1f,//HICHK_HYST_SEL_REG,
  0x1f,//LOCHK_HYST_SEL_REG,
  0x1f,//HICHK_REF_SEL_REG,
  0x1ff,//HICHK_TRIP_SEL_REG,
  0x1f,//LOCHK_REF_SEL_REG,
  0x1ff,//LOCHK_TRIP_SEL_REG,
  //vmon_hsp_core
  0xf,//FILTERCAP_SEL_REG,
  0x1f,//HICHK_HYST_SEL_REG,
  0x1f,//LOCHK_HYST_SEL_REG,
  0x1f,//HICHK_REF_SEL_REG,
  0x1ff,//HICHK_TRIP_SEL_REG,
  0x1f,//LOCHK_REF_SEL_REG,
  0x1ff,//LOCHK_TRIP_SEL_REG,
  //vmon_aemc_core
  0xf,//FILTERCAP_SEL_REG,
  0x1f,//HICHK_HYST_SEL_REG,
  0x1f,//LOCHK_HYST_SEL_REG,
  0x1f,//HICHK_REF_SEL_REG,
  0x1ff,//HICHK_TRIP_SEL_REG,
  0x1f,//LOCHK_REF_SEL_REG,
  0x1ff,//LOCHK_TRIP_SEL_REG,
  };

  /**
   * @brief aemc registers for test start/end and special purposes
   */
  uint32_t aemc_reg_start0 = POWER_DOWN_REG;
  uint32_t aemc_reg_start1 = SPARE_DIGITAL_OUTPUT_REG;
  uint32_t aemc_reg_end0 = EMC_CAL_UPDATE;
  uint32_t aemc_reg_end1 = VAC_LOCHK_TRIP_SEL_REG; 
  uint32_t aemc_reg_wlock1 = CAL_REG_WLOCK1;
  uint32_t aemc_reg_wlock2 = CAL_REG_WLOCK2;

  const uint32_t aemc_sts_mask [] = {0xffff, 0xffff, 0x1fff, 0x1f};
  #define SP_TAP_OFF_STAT true
#endif

// ===========================
//           WILLOW
// ===========================
#if defined SSY_HSP_WILLOW
  
  #define JTAG_TDR_MBX_SEL_PRJ  TDR_CTRL_J2P_MBX_WR_ATHENA_SEL
  #define JTAG_TDR_TAP_FROM_YML true

  #define JTAG_TDR_CTRL_LENGTH        38
  #define JTAG_TDR_CTRL_LENGTH_BYTES  5
  #define JTAG_TDR_CTRL_WSEL_OFFSET   2

  #define DEFAULT_IDLE_CLOCKS 10000

  #define JTAG_TDR_AEB_BIST0     0x14741FC7
  #define JTAG_TDR_AEB_BIST1     0x99DEA5A7 
  #define JTAG_TDR_AEB_BIST2     0xFEEA2368 
  #define JTAG_TDR_AEB_BIST3     0x985F2224 

  #define JTAG_TDR_IDCODE        0x000584AB
  //#define JTAG_TDR_STS_INIT0_RST 0xFC2FFF30
  //#define JTAG_TDR_STS_INIT1_RST 0x0227FFFF
  #define JTAG_TDR_STS_INIT0 INIT_STATUS_0_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT1 INIT_STATUS_1_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT0_RST JTAG_TDR_STS_INIT0
  #define JTAG_TDR_STS_INIT1_RST JTAG_TDR_STS_INIT1
  #define JTAG_TDR_STS_LSM0      0x002AA2AA
  #define JTAG_TDR_STS_LSM1      0x80000000
  #define JTAG_TDR_STS_LSM0_RST  JTAG_TDR_STS_LSM0
  #define JTAG_TDR_STS_LSM1_RST  JTAG_TDR_STS_LSM1
  //#define JTAG_TDR_STS_LSM0_RST  0x000012AA
  //#define JTAG_TDR_STS_LSM1_RST  0x00000000


  #define AEB_BIST_DONE_BIT 17
  #define AEB_BIST_PASS_BIT 18

  #define NUM_BITS_FATAL_ERR_STS 14
  #define NUM_BITS_STICKY_FATAL_ERR_STS 14


  #define CRYPTO_REG_MASK 0xFFFFFFFF ///< Possible Crypto error bits for Manticore/Willow
  #define is_athena_pioneer_or_skyline 1

  #define NUM_MEM_ERR_SOURCE 26
  #define NUM_MEM_ERR_2_SOURCE 8
  #define KSU_ECC_ERR_BIT_MASK   0x200 ///< KSU memory error bit mask


  #define PKA2_EDC_ERR_BIT_MASK 0x400 ///< For Pioneer, others
  #define SHAREDRAM_EDC_ERR_BIT_MASK 0x100 ///< For Pioneer, others
  #define SPROM_BIST_DONE_MASK 0x8000 //bit 47 (upper bit 15)
  #define SPROM_BIST_PASS_MASK 0x200000 //bit 53 (upper bit 21)
  #define SS_MISMATCH_ERR_BIT_MASK 0x8000
  #define CRYPTO_REG_MASK_SS_MISMATCH 0x8007 ///< Possible Crypto error bits
  /**
   * @brief enum of AEMC registers
   */
  enum {
    //emc
    EMC_STATUS_REG,
    EMC_STICKY_STATUS_REG,
    EMC_SPARE_DIGITAL_OUTPUT_REg,
    EMC_CLEAR_STATUS,
    EMC_CLEAR_STICKY_STATUS,
    EMC_ANALOG_TEST_BUS_SEL_REG,
    EMC_POWER_DOWN_WLOCK_REG,
    EMC_STATUS_MASK_WLOCK_REG,

    ECL_CAL_REG_WLOCK1,
    ECL_CAL_REG_WLOCK2,

    EMC_CAL_SWITCH,
    EMC_POWER_DOWN_REG,
    EMC_STATUS_MASK_REG,

    ECL_SPARE_DIGITAL_OUT_REG,
    //vmon
    VMON_VBGTC_REG,
    VMON_VDDREGSEL_REG,
    //tmon
    TMON_REFSEL_REG,
    TMON_HITRIP_REG,
    TMON_LOTRIP_REG,
    //vmon
    VMON_HSP_CORE_FILTER_REG,
    VMON_HSP_CORE_REFSEL_REG,
    VMON_HSP_CORE_HITRIP_REG,
    VMON_HSP_CORE_LOTRIP_REG,
    VMON_AEMC_CORE_FILTER_REG,
    VMON_AEMC_CORE_REFSEL_REG,
    VMON_AEMC_CORE_HITRIP_REG,
    VMON_AEMC_CORE_LOTRIP_REG,
    //cmon
    CMON_HSPCLK_VBGTC_REG,
    CMON_HSPCLK_VDDREGSEL_REG,
    CMON_HSPCLK_SPEED_REG,
    CMON_HSPCLK_CTRLPSEL_REG,
    CMON_HSPCLK_CTRLNSEL_REG,
    CMON_HSPCLK_CLOAD_REG,
    CMON_HSPCLK_CHKENBL_1_REG,
    CMON_HSPCLK_CHKENBL_2_REG,
    CMON_HSPCLK_CHKENBL_3_REG,
    CMON_HSPCLK_CHKENBL_4_REG,
    CMON_REFCLK_VBGTC_REG,
    CMON_REFCLK_VDDREGSEL_REG,
    CMON_REFCLK_SPEED_REG,
    CMON_REFCLK_CTRLPSEL_REG,
    CMON_REFCLK_CTRLNSEL_REG,
    CMON_REFCLK_CLOAD_REG,
    CMON_REFCLK_CHKENBL_1_REG,
    CMON_REFCLK_CHKENBL_2_REG,
    CMON_REFCLK_CHKENBL_3_REG,
    CMON_REFCLK_CHKENBL_4_REG,
  };

  /**
   * @brief mask bit disabled for wr/rd check
   */
  uint32_t emc_reg_wr_mask[] = {
    //emc
    0,//EMC_STATUS_REG,
    0,//EMC_STICKY_STATUS_REG,
    0xffff,//EMC_SPARE_DIGITAL_OUTPUT_REg,
    0,//0xffff_ffff, //EMC_CLEAR_STATUS,
    0,//0xffff_ffff, //EMC_CLEAR_STICKY_STATUS,
    0xfffff,//EMC_ANALOG_TEST_BUS_SEL_REG,
    0x1f,//EMC_POWER_DOWN_WLOCK_REG,
    0,//0xfffff, R/W1S, //EMC_STATUS_MASK_WLOCK_REG,

    0,//0xfffff, R/W1S, //ECL_CAL_REG_WLOCK1,
    0,//0x1fff, R/W1S, //ECL_CAL_REG_WLOCK2,

    0,//0x1,//EMC_CAL_SWITCH,
    0,//0x1f,//EMC_POWER_DOWN_REG, SKIP, also controlled by enable bit
    0xfffff,//EMC_STATUS_MASK_REG,

    0xffff,//ECL_SPARE_DIGITAL_OUT_REG,
    ////vmon
    0xffff,//VMON_VBGTC_REG,
    0xffff,//VMON_VDDREGSEL_REG,
    ////tmon
    0xffff,//TMON_REFSEL_REG,
    0xffff,//TMON_HITRIP_REG,
    0xffff,//TMON_LOTRIP_REG,
    ////vmon
    0xf,//VMON_HSP_CORE_FILTER_REG,
    0xffff,//VMON_HSP_CORE_REFSEL_REG,
    0xffffffff,//VMON_HSP_CORE_HITRIP_REG,
    0xffffffff,//VMON_HSP_CORE_LOTRIP_REG,
    0xf,//VMON_AEMC_CORE_FILTER_REG,
    0xffff,//VMON_AEMC_CORE_REFSEL_REG,
    0xffffffff,//VMON_AEMC_CORE_HITRIP_REG,
    0xffffffff,//VMON_AEMC_CORE_LOTRIP_REG,
    ////cmon
    0xffff,//CMON_HSPCLK_VBGTC_REG,
    0xffff,//CMON_HSPCLK_VDDREGSEL_REG,
    0x7,//CMON_HSPCLK_SPEED_REG,
    0xffff,//CMON_HSPCLK_CTRLPSEL_REG,
    0xffff,//CMON_HSPCLK_CTRLNSEL_REG,
    0xffff,//CMON_HSPCLK_CLOAD_REG,
    0xffff,//CMON_HSPCLK_CHKENBL_1_REG,
    0xffff,//CMON_HSPCLK_CHKENBL_2_REG,
    0xffff,//CMON_HSPCLK_CHKENBL_3_REG,
    0xffff,//CMON_HSPCLK_CHKENBL_4_REG,
    0xffff,//CMON_REFCLK_VBGTC_REG,
    0xffff,//CMON_REFCLK_VDDREGSEL_REG,
    0x3,//CMON_REFCLK_SPEED_REG,
    0xffff,//CMON_REFCLK_CTRLPSEL_REG,
    0xffff,//CMON_REFCLK_CTRLNSEL_REG,
    0xffff,//CMON_REFCLK_CLOAD_REG,
    0xffffffff,//CMON_REFCLK_CHKENBL_1_REG,
    0xffffffff,//CMON_REFCLK_CHKENBL_2_REG,
    0xffffffff,//CMON_REFCLK_CHKENBL_3_REG,
    0xffffffff,//CMON_REFCLK_CHKENBL_4_REG,
  };
  /**
   * @brief aemc registers for test start/end and special purposes
   */
  uint32_t aemc_reg_start0 = EMC_CAL_SWITCH;
  uint32_t aemc_reg_start1 = VMON_VBGTC_REG;
  uint32_t aemc_reg_end0   = ECL_SPARE_DIGITAL_OUT_REG;
  uint32_t aemc_reg_end1   = CMON_REFCLK_CHKENBL_4_REG;
  uint32_t aemc_reg_wlock1 = ECL_CAL_REG_WLOCK1;
  uint32_t aemc_reg_wlock2 = ECL_CAL_REG_WLOCK2;

  const uint32_t aemc_sts_mask [] = {0x7fffff, 0x7fffff, 0xffffffff, 0x7f};
  #define SP_TAP_OFF_STAT false

  #define IS_WILLOW 1
  #define JTAG_RESET_DELAY 10000
#else
  #define  IS_WILLOW 0
  #define JTAG_RESET_DELAY 5000
#endif

// ===========================
//          EAGLECREEK
// ===========================
#if defined SSY_HSP_EAGLECREEK
  
  #define JTAG_TDR_MBX_SEL_PRJ  TDR_CTRL_J2P_MBX_WR_ATHENA_SEL
  #define JTAG_TDR_TAP_FROM_YML true

  #define JTAG_TDR_CTRL_LENGTH        45
  #define JTAG_TDR_CTRL_LENGTH_BYTES  6
  #define JTAG_TDR_CTRL_WSEL_OFFSET   1


  #define JTAG_TDR_AEB_BIST0     0x2A7F37A0 
  #define JTAG_TDR_AEB_BIST1     0x238360B3 
  #define JTAG_TDR_AEB_BIST2     0xF602E557 
  #define JTAG_TDR_AEB_BIST3     0x57EB04B5 
  #define JTAG_TDR_IDCODE        0x0005A4AB
  //#define JTAG_TDR_STS_INIT0_RST 0x7FFFFF30
  //#define JTAG_TDR_STS_INIT1_RST 0x4C0008BF
  #define JTAG_TDR_STS_INIT0 INIT_STATUS_0_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT1 INIT_STATUS_1_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT0_RST JTAG_TDR_STS_INIT0
  #define JTAG_TDR_STS_INIT1_RST JTAG_TDR_STS_INIT1
  #define JTAG_TDR_STS_LSM0      0x0002A222
  #define JTAG_TDR_STS_LSM1      0x80000000
  #define JTAG_TDR_STS_LSM0_RST  JTAG_TDR_STS_LSM0
  #define JTAG_TDR_STS_LSM1_RST  JTAG_TDR_STS_LSM1
  //#define JTAG_TDR_STS_LSM0_RST  0x0002A222
  //#define JTAG_TDR_STS_LSM1_RST  0x80000000


  #define AEB_BIST_DONE_BIT 14
  #define AEB_BIST_PASS_BIT 15
  #define NUM_BITS_FATAL_ERR_STS 13
  #define NUM_BITS_STICKY_FATAL_ERR_STS 12

  #define CRYPTO_REG_MASK 0x1FFFFFF ///< Possible Crypto error bits for Pioneer and Eaglecreek

  #define is_athena_pioneer_or_skyline 1
  #define NUM_MEM_ERR_SOURCE 24
  #define NUM_MEM_ERR_2_SOURCE 0
  #define KSU_ECC_ERR_BIT_MASK   0x200 ///< KSU memory error bit mask

  #define PKA2_EDC_ERR_BIT_MASK 0x400 ///< For Pioneer, others
  #define SHAREDRAM_EDC_ERR_BIT_MASK 0x100 ///< For Pioneer, others

  #define SPROM_BIST_DONE_MASK 0x2 //bit 33 (upper bit 1)
  #define SPROM_BIST_PASS_MASK 0x80 //bit 39 (upper bit 8)
  #define SS_MISMATCH_ERR_BIT_MASK 0x4000
  #define CRYPTO_REG_MASK_SS_MISMATCH 0x4007 ///< Possible Crypto error bits
  #define SP_TAP_OFF_STAT false
#endif

// ===========================
//          BLUERIDGE
// ===========================
#if defined SSY_HSP_BLUERIDGE
  
  #define JTAG_TDR_MBX_SEL_PRJ  TDR_CTRL_J2P_MBX_WR_ATHENA_SEL
  #define JTAG_TDR_TAP_FROM_YML true

  #define JTAG_TDR_CTRL_LENGTH        38
  #define JTAG_TDR_CTRL_LENGTH_BYTES  5
  #define JTAG_TDR_CTRL_WSEL_OFFSET   2

  #define JTAG_TDR_AEB_BIST0     0x88F137A0
  #define JTAG_TDR_AEB_BIST1     0x4355e6e3
  #define JTAG_TDR_AEB_BIST2     0x00667770 
  #define JTAG_TDR_AEB_BIST3     0x57EB04AA
  #define JTAG_TDR_IDCODE        0x0005C4AB
  //#define JTAG_TDR_STS_INIT0_RST 0xFFFFFF23
  //#define JTAG_TDR_STS_INIT1_RST 0x4C00008B
  #define JTAG_TDR_STS_INIT0 INIT_STATUS_0_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT1 INIT_STATUS_1_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT0_RST JTAG_TDR_STS_INIT0
  #define JTAG_TDR_STS_INIT1_RST JTAG_TDR_STS_INIT1
  #define JTAG_TDR_STS_LSM0      0x002AA222
  #define JTAG_TDR_STS_LSM1      0x80000000
  #define JTAG_TDR_STS_LSM0_RST  JTAG_TDR_STS_LSM0
  #define JTAG_TDR_STS_LSM1_RST  JTAG_TDR_STS_LSM1
  //#define JTAG_TDR_STS_LSM0_RST  0x0002A222
  //#define JTAG_TDR_STS_LSM1_RST  0x80000000


  #define AEB_BIST_DONE_BIT 14
  #define AEB_BIST_PASS_BIT 15
  #define NUM_BITS_FATAL_ERR_STS 13
  #define NUM_BITS_STICKY_FATAL_ERR_STS 14

  #define CRYPTO_REG_MASK 0x7FFFFFF ///< Possible Crypto error bits for Pioneer and Eaglecreek

  #define is_athena_pioneer_or_skyline 1
  #define NUM_MEM_ERR_SOURCE 18
  #define NUM_MEM_ERR_2_SOURCE 0
  #define KSU_ECC_ERR_BIT_MASK   0x80 ///< KSU memory error bit mask


  #define PKA2_EDC_ERR_BIT_MASK 0x400 ///< For Pioneer, others
  #define SHAREDRAM_EDC_ERR_BIT_MASK 0x40 ///< Shared RAM error bit mask for DLP

  #define SPROM_BIST_DONE_MASK 0x2 //bit 33 (upper bit 1)
  #define SPROM_BIST_PASS_MASK 0x80 //bit 39 (upper bit 7)
  #define SS_MISMATCH_ERR_BIT_MASK 0x4000
  #define CRYPTO_REG_MASK_SS_MISMATCH 0x4007 ///< Possible Crypto error bits
  #define SP_TAP_OFF_STAT false
#endif


/**
 * SKYLINE
 */
#if defined SSY_HSP_SKYLINE
  #define JTAG_TDR_AEB_BIST0     0x0C1B55AC
  #define JTAG_TDR_AEB_BIST1     0x5A6565F3
  #define JTAG_TDR_AEB_BIST2     0x24F569B8
  #define JTAG_TDR_AEB_BIST3     0x5E49A0F1
  #define JTAG_TDR_IDCODE        0x000504AB
  //#define JTAG_TDR_STS_INIT0_RST 0xD7F7FF30
  //#define JTAG_TDR_STS_INIT1_RST 0x4B000083
  #define JTAG_TDR_STS_INIT0 INIT_STATUS_0_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT1 INIT_STATUS_1_2_AFTER_INIT_VALUE
  #define JTAG_TDR_STS_INIT0_RST JTAG_TDR_STS_INIT0
  #define JTAG_TDR_STS_INIT1_RST JTAG_TDR_STS_INIT1
  #define JTAG_TDR_STS_LSM0      0x22020202
  #define JTAG_TDR_STS_LSM1      0x82222222
  #define JTAG_TDR_STS_LSM0_RST  JTAG_TDR_STS_LSM0
  #define JTAG_TDR_STS_LSM1_RST  JTAG_TDR_STS_LSM1


  #define PKA2_EDC_ERR_BIT_MASK 0x400 ///< For Pioneer, others
#endif

// ===========================
// 
// ===========================
#ifndef JTAG_TDR_MBX_SEL_PRJ
  #define JTAG_TDR_MBX_SEL_PRJ  TDR_CTRL_J2P_MBX_WR_ATHENA_SEL
#endif

// ================================================
// Tap chain information present in subsystem yaml.
// ================================================
#ifdef JTAG_TDR_TAP_FROM_YML

  #include <jtag_tap_data.h>

  #define TAPNAMES  {0}
  #define IR        {0}
  #define IDCODES   {0}
  #define TYPES     {0}
  #define LEN       {0}

#else

  #define JTAG_TDR_TAP_FROM_YML false
  
  #define SSY_JTAG_TAP0_TAPS      0
  #define SSY_JTAG_TAP0_IR_SIZE   0
  #define SSY_JTAG_TAP0_TAP_NAMES 0
  #define SSY_JTAG_TAP0_IDCMD     0
  #define SSY_JTAG_TAP0_IDCODE    0
  #define SSY_JTAG_TAP0_DISABLED  0
  #define SSY_JTAG_TAP0_CPUTYPE   0
  #define SSY_JTAG_TAP0_TYPE      0

#endif

// =======================================
// Default wait for idle clocks funcition.
// =======================================
#ifndef DEFAULT_IDLE_CLOCKS
  #define DEFAULT_IDLE_CLOCKS   1000
#endif

// TODO: Remove if not used
#ifndef JTAG_TDR_SECURE_TEST_PROD
  #define JTAG_TDR_SECURE_TEST_PROD 0
#endif

 // Note |SP| = Register value found in the <SS>_TDR_MAS_1.0 spec: SEL: |SP|
 const uint32_t jt_exp_data[TDR_REG_NUM] =
   { JTAG_TDR_SOC_ID_0 , // JTAG_TDR_STS_SOCID_DATA0                0   [ok]
     JTAG_TDR_SOC_ID_1 , // JTAG_TDR_STS_SOCID_DATA1                1   [ok]
     JTAG_TDR_SOC_ID_2 , // JTAG_TDR_STS_SOCID_DATA2                2   [ok]
     JTAG_TDR_SOC_ID_3 , // JTAG_TDR_STS_SOCID_DATA3                3   [ok]
     2                 , // JTAG_TDR_STS_SS                         4   [ok]
     JTAG_TDR_STS_INIT0, // JTAG_TDR_STS_INIT0                      5   [ok]
     JTAG_TDR_STS_INIT1, // JTAG_TDR_STS_INIT1                      6   [ok]
     0x000004AA        , // JTAG_TDR_STS_SP                         7   [?]
     0x00000000        , // JTAG_TDR_STS_JP_MBX0                    8   [ok]
     0x00000000        , // JTAG_TDR_STS_JP_MBX1                    9   [ok]
     0x00000000        , // JTAG_TDR_STS_MEMORY                    10   [ok]
     0x00000000        , // JTAG_TDR_STS_WDT_ERR                   11   [ok]
     0x00000000        , // JTAG_TDR_STS_CRYPTO_ERR                12   [ok]
     JTAG_TDR_SS_128_0 , // JTAG_TDR_STS_SS128_DATA0               13   [?]
     JTAG_TDR_SS_128_1 , // JTAG_TDR_STS_SS128_DATA1               14   [?]
     JTAG_TDR_SS_128_2 , // JTAG_TDR_STS_SS128_DATA2               15   [?]
     JTAG_TDR_SS_128_3 , // JTAG_TDR_STS_SS128_DATA3               16   [?]
     JTAG_TDR_STS_LSM0 , // JTAG_TDR_STS_LSM0                      17   [ok]
     JTAG_TDR_STS_LSM1 , // JTAG_TDR_STS_LSM1                      18   [ok]
     0x00000001        , // JTAG_TDR_STS_TDR_HSP_RSTN              19   [ok]
     0x87654321       }; // JTAG_TDR_STS_DBG                       20   [ok]



#endif // __JTAG_DEFINES_INCLUDE__
