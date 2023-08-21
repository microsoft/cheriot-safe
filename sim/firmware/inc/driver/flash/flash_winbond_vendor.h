
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

#ifndef __FLASH_WINBOND_VENDOR_H__
#define __FLASH_WINBOND_VENDOR_H__

class Flash_Winbond_Vendor : public Flash_Base_Vendor
{
  public:

   Flash_Winbond_Vendor() : Flash_Base_Vendor()
   {
     // printf("\nWinbond Vendor\n");
   }
   
   bool is_flash_qpi;

   FLASH_CMDS_t get_Read_cmd();
   FLASH_CMDS_t get_Write_cmd();
   FLASH_CMDS_t get_ReadFlagSR_cmd();
   FLASH_CMDS_t get_ReadID_cmd();

};
/**
 * Set the Flash STD/Dual/Quad/QPI read command depending on device, mode, etc.
 */
FLASH_CMDS_t Flash_Winbond_Vendor::get_Read_cmd()
{
  FLASH_CMDS_t cmd = FLASH_CMD_QUAD_OUTPUT_FAST_READ; /**< Default is Quad */

  if(m_mode == FLASH_QUAD_MODE) { 
    if(is_flash_qpi) 
      cmd = FLASH_CMD_WINB_QUAD_IO_FAST_READ;

  } else if (m_mode == FLASH_DUAL_MODE) { 
    cmd = FLASH_CMD_DUAL_OUTPUT_FAST_READ;

  } else {
    /**< Fast Read for XIP Confirmation Bit insertion in dummy/wait clocks */
    cmd   = FLASH_CMD_READ;
  }

  return cmd;
}

/**< Set the Flash STD/Dual/Quad/QPI write command depending on device, mode, etc. */
FLASH_CMDS_t Flash_Winbond_Vendor::get_Write_cmd()
{
  FLASH_CMDS_t cmd = FLASH_CMD_QUAD_INPUT_FAST_PROGRAM; /**< Default is Quad */

  if(m_mode == FLASH_QUAD_MODE) {
    if(is_flash_qpi)
      cmd = FLASH_CMD_PAGE_PROGRAM;
  } else {
    cmd = FLASH_CMD_PAGE_PROGRAM;
  }

  return cmd;
}

FLASH_CMDS_t Flash_Winbond_Vendor::get_ReadFlagSR_cmd()
{
  return FLASH_CMD_READ_STATUS_REGISTER;
}

FLASH_CMDS_t Flash_Winbond_Vendor::get_ReadID_cmd()
{
  FLASH_CMDS_t cmd = FLASH_CMD_READ_ID; /** when vendor is winbond (W25Q256JVxIM) it returns 0x9F as readid cmd */

  if(m_vendor == WINBOND_25Q80DL) { /** when vendor is winbond (W25Q80DL) it returns readid cmd based on mode*/
    if(m_mode == FLASH_QUAD_MODE) cmd = FLASH_CMD_READ_ID_WB_QUAD;
    else if(m_mode == FLASH_DUAL_MODE) cmd = FLASH_CMD_READ_ID_WB_DUAL;
    else cmd = FLASH_CMD_READ_ID_WB_STD;
  }
  return cmd;
}

#endif
