
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

#ifndef __FLASH_CONFIG_H__
#define __FLASH_CONFIG_H__

#include "flash_micron_vendor.h"
#include "flash_winbond_vendor.h"
#include "flash_macronix_vendor.h"

class Flash_Config
{
  private:
  Flash_Base_Vendor *VendorObj;
  FLASH_SPI_MODE_t   m_mode;

  Flash_Micron_Vendor   Micron_V_Obj;   /**< Micron Vendor Object */
  Flash_Winbond_Vendor  Winbond_V_Obj;  /**< Winbond Vendor Object */
  Flash_Macronix_Vendor Macronix_V_Obj; /**< Macronix Vendor Object */

  public:

  void set_vendor(FLASH_VENDOR_t m_vendor, bool flash_qpi=0);
  void set_mode(FLASH_SPI_MODE_t m_flash_mode);

  void ResetEnable(CMD_STRUCT_t *m_CMD_S);  //TSS: QUESTION: Is this getting CMD_STRUCT_t from sp_master_flash_interface?
  void Reset(CMD_STRUCT_t *m_CMD_S);
  void ReadSR(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt);
  void DeviceIdentification(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt);
  void ReadID(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt);
  void WriteEnable(CMD_STRUCT_t *m_CMD_S);
  void WriteDisable(CMD_STRUCT_t *m_CMD_S);
  void WriteEnableStatusReg(CMD_STRUCT_t *m_CMD_S);
  void WriteStatusReg(CMD_STRUCT_t *m_CMD_S, uint32_t byte_cnt);
  void ReadStatusReg(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt);
  void ReadExtAddrReg(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt);
  void WriteExtAddrReg(CMD_STRUCT_t *m_CMD_S, uint32_t byte_cnt);
  void EnterQPIMode(CMD_STRUCT_t *m_CMD_S);
  void WriteVEConfigReg(CMD_STRUCT_t *m_CMD_S);
  void WriteNVConfigReg(CMD_STRUCT_t *m_CMD_S);
  void WriteVoConfigReg(CMD_STRUCT_t *m_CMD_S);
  void ReadNVConfigReg(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt);
  void ReadVEConfigReg(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt);
  void Read(CMD_STRUCT_t *m_CMD_S, uint32_t addr, uint32_t byte_cnt, uint32_t *array_ptr, bool addr4b);
  void Write(CMD_STRUCT_t *m_CMD_S, uint32_t addr, uint32_t byte_cnt, uint32_t *array_ptr, bool addr4b);
  void ReadFlagSR(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt);
  void ClearFlagSR(CMD_STRUCT_t *m_CMD_S);
  void Enable4byteAddrMode(CMD_STRUCT_t *m_CMD_S);
  void Enable3byteAddrMode(CMD_STRUCT_t *m_CMD_S);

  void WriteCmdSet(CMD_STRUCT_t *m_CMD_S, FLASH_CMDS_t cmd, uint32_t byte_cnt = 0);
  void ReadCmdSet(CMD_STRUCT_t *m_CMD_S, FLASH_CMDS_t cmd, uint32_t *array_ptr, uint32_t byte_cnt);
};

/**
 *This function builds the respective vendor type object and assigns the handle to the vendor type handle in base test.
 *In addition, sets the flash_qpi mode if the object is of winbond type
 */
void Flash_Config::set_vendor(FLASH_VENDOR_t m_vendor, bool flash_qpi) //TODO: IMPLEMENT Add print message indicating vendor
{
  if(m_vendor == MICRON) VendorObj = &Micron_V_Obj;
  else if(m_vendor == WINBOND || m_vendor == WINBOND_25Q80DL) {
    Winbond_V_Obj.is_flash_qpi = flash_qpi; /**< QPI mode is supported only by Winbond Vendor Flash */
    VendorObj = &Winbond_V_Obj;
  }
  else if (m_vendor == MACRONIX) VendorObj = &Macronix_V_Obj; 

  else printf("unknown vendor\n");
  VendorObj->m_mode = m_mode;
  VendorObj->m_vendor = m_vendor;
}

/**
 *This function sets flash mode - STD/DUAL/QUAD based on flash_mode passed from yaml parameter
 */
void Flash_Config::set_mode(FLASH_SPI_MODE_t flash_mode)
{
  m_mode = flash_mode;
}

/**
 *This function sets up register write command structure
 */
void Flash_Config::WriteCmdSet(CMD_STRUCT_t *m_CMD_S, FLASH_CMDS_t cmd, uint32_t byte_cnt)
{
  m_CMD_S->addr_bytes = 0;
  m_CMD_S->cmd        = cmd;
  m_CMD_S->rbyte_cnt  = 0;
  m_CMD_S->wbyte_cnt  = byte_cnt;
}

/**
 * This function sets up register read command structure
 */
void Flash_Config::ReadCmdSet(CMD_STRUCT_t *m_CMD_S, FLASH_CMDS_t cmd, uint32_t *array_ptr, uint32_t byte_cnt)
{   
    m_CMD_S->addr_bytes = 0;
    m_CMD_S->array_ptr  = array_ptr;
    m_CMD_S->cmd        = cmd;
    m_CMD_S->rbyte_cnt  = byte_cnt;
    m_CMD_S->wbyte_cnt  = 0;
}

/**
 * This function fetches Reset Enable command from the flash vendor and invokes WriteCmdSet function.
 */
void Flash_Config::ResetEnable(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_ResetEnable_cmd();  //TSS: Returns FLASH_CMD_RESET_ENABLE                     = 0x66
  WriteCmdSet(m_CMD_S, cmd);
}

/**
 * This function fetches Reset command from the flash vendor and invokes WriteCmdSet function.
 */
void Flash_Config::Reset(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_Reset_cmd(); 
  WriteCmdSet(m_CMD_S, cmd);
}

/**
 * This function fetches Read Status Register command from the flash vendor 
 * Invokes ReadCmdSet function.
 */
void Flash_Config::ReadSR(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt)
{
  FLASH_CMDS_t cmd = VendorObj->get_ReadSR_cmd(); 
  ReadCmdSet(m_CMD_S, cmd, array_ptr, byte_cnt);
}

void Flash_Config::DeviceIdentification(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt)
{
  FLASH_CMDS_t cmd = VendorObj->get_Deviceidentification_cmd();
  ReadCmdSet(m_CMD_S, cmd, array_ptr, byte_cnt);
}

/**
 * This function fetches Read ID command from the flash vendor and invokes ReadCmdSet function.
 */
void Flash_Config::ReadID(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt)
{
  FLASH_CMDS_t cmd = VendorObj->get_ReadID_cmd();
  ReadCmdSet(m_CMD_S, cmd, array_ptr, byte_cnt);
  if(VendorObj->m_vendor == WINBOND_25Q80DL) {
    m_CMD_S->addr_bytes = 3;
    m_CMD_S->addr = 0;
  }
}

/**
 *This function fetches Write Enable command from the flash vendor and passes the command to WriteCmdSet function.
 */
void Flash_Config::WriteEnable(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_WriteEnable_cmd(); 
  WriteCmdSet(m_CMD_S, cmd);
}

/**
 *This function fetches Write Disable command from the flash vendor and passes the command to WriteCmdSet function.
 */
void Flash_Config::WriteDisable(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_WriteDisable_cmd(); 
  WriteCmdSet(m_CMD_S, cmd);
}

/**
 *This function fetches Write Enable Status Register command from the flash vendor and passes the command to WriteCmdSet function.
 */
void Flash_Config::WriteEnableStatusReg(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_WriteEnableStatus_cmd(); 
  WriteCmdSet(m_CMD_S, cmd);
}

/**
 *This function fetches Write Status Register command from the Vendor object and calls WriteCmdSet function.
 */
void Flash_Config::WriteStatusReg(CMD_STRUCT_t *m_CMD_S, uint32_t byte_cnt)
{
  FLASH_CMDS_t cmd = VendorObj->get_WriteStatus_cmd(); 
  WriteCmdSet(m_CMD_S, cmd, byte_cnt);
}

/**
 *This function fetches Read Status Register command from the Vendor object and calls ReadCmdSet function.
 */
void Flash_Config::ReadStatusReg(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt)
{
  FLASH_CMDS_t cmd = VendorObj->get_ReadStatus_cmd(); 
  ReadCmdSet(m_CMD_S, cmd, array_ptr, byte_cnt);
}

/**
 *This function fetches Write Extended Address Register command from the Vendor object and calls WriteCmdSet function.
 */
void Flash_Config::WriteExtAddrReg(CMD_STRUCT_t *m_CMD_S, uint32_t byte_cnt)
{
  FLASH_CMDS_t cmd = VendorObj->get_WriteExtAddr_cmd(); 
  WriteCmdSet(m_CMD_S, cmd, byte_cnt);
}

/**
 *This function fetches Read Extended Address Register command from the Vendor object and calls ReadCmdSet function.
 */
void Flash_Config::ReadExtAddrReg(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt)
{
  FLASH_CMDS_t cmd = VendorObj->get_ReadExtAddr_cmd(); 
  ReadCmdSet(m_CMD_S, cmd, array_ptr, byte_cnt);
}

/**
 *This function fetches Write Register command for flash to enter QPI mode and invokes WriteCmdSet method.
 */
void Flash_Config::EnterQPIMode(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_EnterQPI_cmd(); 
  WriteCmdSet(m_CMD_S, cmd);
}

/**
 *This function fetches Write Volatile Enhanched Configuration Register command from the flash vendor and invokes WriteCmdSet method.
 */
void Flash_Config::WriteVEConfigReg(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_WriteVEConfig_cmd();
  WriteCmdSet(m_CMD_S, cmd, 1);
}

void Flash_Config::WriteNVConfigReg(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_WriteNVConfig_cmd();
  WriteCmdSet(m_CMD_S, cmd, 2);
}
/**
 *This function fetches Write Volatile Configuration Register command from the flash vendor and invokes WriteCmdSet function.
 */
void Flash_Config::WriteVoConfigReg(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_WriteVoConfig_cmd();
  WriteCmdSet(m_CMD_S, cmd, 1);
}

/**
 *This function fetches Read Non-Volatile Configuration Register flash command and passes it to function ReadCmdSet.
 */
void Flash_Config::ReadNVConfigReg(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt)
{
  FLASH_CMDS_t cmd = VendorObj->get_ReadNVConfig_cmd(); 
  ReadCmdSet(m_CMD_S, cmd, array_ptr, byte_cnt);
}

/**
 *This function fetches Read Volatile Enhanced Configuration Register flash command and passes it to function ReadCmdSet.
 */
void Flash_Config::ReadVEConfigReg(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt)
{
  FLASH_CMDS_t cmd = VendorObj->get_ReadVEConfig_cmd(); 
  ReadCmdSet(m_CMD_S, cmd, array_ptr, byte_cnt);
}

/**
 * This function fetches the Read command from vendor object 
 * Invokes ReadCmdSet method to populate command structure
 * Calculates address & address bytes based on address mode - 3byte or 4byte
 */
void Flash_Config::Read(CMD_STRUCT_t *m_CMD_S, uint32_t addr, uint32_t byte_cnt, uint32_t *array_ptr, bool addr4b)
{
  FLASH_CMDS_t cmd = VendorObj->get_Read_cmd(); 
  ReadCmdSet(m_CMD_S, cmd, array_ptr, byte_cnt);

  uint8_t *abyte_ptr = (uint8_t *) &addr; /**< Use pointer magic to access address bytes so they can be reversed */
  /**< Flash boots in 3-byte address mode, SPI Transmits Addr LSB byte first:[B0 B1 B2 B3] */
  m_CMD_S->addr        = (addr4b) ? (abyte_ptr[0] << 24 | abyte_ptr[1] << 16 | abyte_ptr[2] << 8 | abyte_ptr[3]) :
                                    (                     abyte_ptr[0] << 16 | abyte_ptr[1] << 8 | abyte_ptr[2]);
  m_CMD_S->addr_bytes  = (addr4b) ? 4 : 3;

}

/**
 * This function fetches the Write command from vendor object 
 * Invokes WriteCmdSet method to populate command structure
 * Calculates address & address bytes based on address mode - 3byte or 4byte
 */
void Flash_Config::Write(CMD_STRUCT_t *m_CMD_S, uint32_t addr, uint32_t byte_cnt, uint32_t *array_ptr, bool addr4b)
{
  FLASH_CMDS_t cmd = VendorObj->get_Write_cmd(); 
  WriteCmdSet(m_CMD_S, cmd, byte_cnt);

  uint8_t *abyte_ptr = (uint8_t *) &addr; /**< Use pointer magic to access address bytes so they can be reversed */
  /**< Flash boots in 3-byte address mode. In SPI_08_BIT_WORD mode we want MSB Byte first, so reverse */
  m_CMD_S->addr       = (addr4b) ? (abyte_ptr[0] << 24 | abyte_ptr[1] << 16 | abyte_ptr[2] << 8 | abyte_ptr[3]) :
                                  (                     abyte_ptr[0] << 16 | abyte_ptr[1] << 8 | abyte_ptr[2]);
  m_CMD_S->addr_bytes = (addr4b) ? 4 : 3; /**< Overwrite default:0 set in WriteCmdSet() */
  m_CMD_S->array_ptr  = array_ptr;

}

/**
 *This function fetches Read FlagSR flash command and passes it to method ReadCmdSet 
 */
void Flash_Config::ReadFlagSR(CMD_STRUCT_t *m_CMD_S, uint32_t *array_ptr, uint32_t byte_cnt)
{
  FLASH_CMDS_t cmd = VendorObj->get_ReadFlagSR_cmd();
  ReadCmdSet(m_CMD_S, cmd, array_ptr, byte_cnt);
}

/**
 *This function fetches Clear FlagSR flash command and passes it to method ReadCmdSet 
 */
void Flash_Config::ClearFlagSR(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_ClearFlagStatus_cmd();
  WriteCmdSet(m_CMD_S, cmd);
}

/**
 *Function enables 4 byte Address Mode in Flash
 */
void Flash_Config::Enable4byteAddrMode(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_4byteAddrmode_cmd(); 
  WriteCmdSet(m_CMD_S, cmd);
}

/**
 *Function enables 3 byte Address Mode in Flash
 */
void Flash_Config::Enable3byteAddrMode(CMD_STRUCT_t *m_CMD_S)
{
  FLASH_CMDS_t cmd = VendorObj->get_3byteAddrmode_cmd(); 
  WriteCmdSet(m_CMD_S, cmd);
}

#endif
