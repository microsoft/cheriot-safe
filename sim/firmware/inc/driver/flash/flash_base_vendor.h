#ifndef __FLASH_BASE_VENDOR_H__
#define __FLASH_BASE_VENDOR_H__

#define FLASH_PAGE_SIZE   256 /**< Can only program one page at a time. It wraps around if not starting at a boundary! */


/**
 * Micron(MT25QU256)        - Datasheet : 128Mb, 3V, Multiple I/O Serial Flash Memory (sharepoint.com)
 * Winbond(W25Q256JVxIM)    - Datasheet : W25Q512JV Datasheet (winbond.com)
 * Macronix(MX25U3272FWAJ42)- Datasheet : Manticore - MX25U3232F J-grade, 1.8V, 32Mb, v0.00.pdf - All Documents (sharepoint.com)
*/

//This file defines flash commands for various vendors and returns the appropriate command based on the defined vendor.
/**<Command naming came from Micron Flash, added Microchip specific commands */
typedef enum FLASH_CMDS_e {

  // Reset Memory
  FLASH_CMD_RESET_ENABLE                     = 0x66,
  FLASH_CMD_RESET_MEMORY                     = 0x99,

  // Read ID
  FLASH_CMD_READ_ID                          = 0x9F, /**< STD */
  FLASH_CMD_READ_ID_MULTI_IO                 = 0xAF, /**< Dual/Quad */
  FLASH_CMD_READ_ID_WB_STD                   = 0x90, /**< STD */
  FLASH_CMD_READ_ID_WB_DUAL                  = 0x92, /**< Dual */
  FLASH_CMD_READ_ID_WB_QUAD                  = 0x94, /**< Quad */

  // Enter/Exit QUAD Mode
  FLASH_CMD_ENTER_QUAD_IO_MODE               = 0x35,
  FLASH_CMD_EXIT_QUAD_IO_MODE                = 0xF5,
  FLASH_CMD_WINB_ENTER_QUAD_IO_MODE          = 0x38,
  FLASH_CMD_WINB_EXIT_QUAD_IO_MODE           = 0xFF,

  // Enter 4 Byte Mode
  FLASH_CMD_ENTER_4BYTE_ADDR_MODE            = 0xB7,
  FLASH_CMD_EXIT_4BYTE_ADDR_MODE             = 0xE9,

  // STATUS Register
  FLASH_CMD_READ_STATUS_REGISTER             = 0x05,
  FLASH_CMD_WRITE_STATUS_REGISTER            = 0x01,

  // Write Enable
  FLASH_CMD_WRITE_DISABLE                    = 0x04,
  FLASH_CMD_WRITE_ENABLE                     = 0x06,

  // SUSPEND/RESUME Program Erase
  FLASH_CMD_SUSPEND_PROG_ERASE               = 0x75,
  FLASH_CMD_RESUME_PROG_ERASE                = 0x7A,
  FLASH_CMD_MACR_SUSPEND_PROG_ERASE          = 0xB0,  // Macronix Only
  FLASH_CMD_MACR_RESUME_PROG_ERASE           = 0x30,  // Macronix Only

  // READ
  FLASH_CMD_READ                             = 0x03,
  FLASH_CMD_FAST_READ                        = 0x0B,
  FLASH_CMD_DUAL_OUTPUT_FAST_READ            = 0x3B,
  FLASH_CMD_QUAD_OUTPUT_FAST_READ            = 0x6B,
  FLASH_CMD_DUAL_IO_FAST_READ                = 0xBB,
  FLASH_CMD_QUAD_IO_FAST_READ                = 0xEB,
  FLASH_CMD_QUAD_IO_FAST_WORD_READ           = 0xE7,

  // READ 4Byte
  FLASH_CMD_4BYTE_READ                       = 0x13,
  FLASH_CMD_4BYTE_FAST_READ                  = 0x0C,
  FLASH_CMD_4BYTE_DUAL_OUTPUT_FAST_READ      = 0x3C,
  FLASH_CMD_4BYTE_QUAD_OUTPUT_FAST_READ      = 0x6C,
  FLASH_CMD_4BYTE_DUAL_IO_FAST_READ          = 0xBC,
  FLASH_CMD_4BYTE_QUAD_IO_FAST_READ          = 0xEC,

  // ERASE Commands
  FLASH_CMD_ERASE_4KB_SUBSECTOR              = 0x20, /**< Microchip Sector Erase */
  FLASH_CMD_ERASE_32KB_SUBSECTOR             = 0x52,
  FLASH_CMD_4BYTE_ERASE_4KB_SUBSECTOR        = 0x21,
  FLASH_CMD_ERASE_SECTOR                     = 0xD8, /**< Microchip Block  Erase */
  FLASH_CMD_4BYTE_ERASE_SECTOR               = 0xDC,
  FLASH_CMD_BULK_ERASE                       = 0xC7,

  FLASH_CMD_ERASE_CHIP                       = 0xC4,  /**< Not Micron */

  FLASH_CMD_MCHP_ERASE_BLOCK                 = 0xD8, /**< Microchip Specific */
  FLASH_CMD_MCHP_ERASE_CHIP                  = 0xC7,
  FLASH_CMD_MCHP_ERASE_SECTOR                = 0x20,
  FLASH_CMD_MCHP_GLOBAL_BLOCK_PROT_UNLOCK    = 0x98,
  FLASH_CMD_MCHP_PAGE_PROGRAM                = 0x02,
  FLASH_CMD_MCHP_PAGE_PROGRAM_QUAD           = 0x32,
  FLASH_CMD_MCHP_READ_BLOCK_PROT_REGISTER    = 0x72,
  FLASH_CMD_MCHP_WRITE_BLOCK_PROT_REGISTER   = 0x42,

  // PROGRAM
  FLASH_CMD_PAGE_PROGRAM                     = 0x02, /**< Micron can also use 0x02 */
  FLASH_CMD_DUAL_INPUT_FAST_PROGRAM          = 0xA2,
  FLASH_CMD_QUAD_INPUT_FAST_PROGRAM          = 0x32,
  FLASH_CMD_4BYTE_FAST_PROGRAM               = 0x12,
  FLASH_CMD_4BYTE_QUAD_FAST_PROGRAM          = 0x34,


  // EXT Address
  FLASH_CMD_READ_EXT_ADDR                    = 0xC8,
  FLASH_CMD_WRITE_EXT_ADDR                   = 0xC5,

  // READ/CLEAR Flag Status
  FLASH_CMD_READ_FLAG_STATUS_REGISTER        = 0x70,
  FLASH_CMD_CLEAR_FLAG_STATUS_REGISTER       = 0x50,  // micron

  // Enhanced Volatile Config (Micron)
  FLASH_CMD_READ_ENHANCED_VOLATILE_CONF      = 0x65,
  FLASH_CMD_WRITE_ENHANCED_VOLATILE_CONF     = 0x61,

  // Lock Register
  FLASH_CMD_READ_LOCK_REGISTER               = 0xE8, 
  FLASH_CMD_WRITE_LOCK_REGISTER              = 0xE5,

  // NON Volatile Config (Micron)
  FLASH_CMD_READ_NON_VOLATILE_CONF           = 0xB5,
  FLASH_CMD_WRITE_NON_VOLATILE_CONF          = 0xB1,

  // VOLATILE Config (Micron)
  FLASH_CMD_READ_VOLATILE_CONF               = 0x85,
  FLASH_CMD_WRITE_VOLATILE_CONF              = 0x81,

  FLASH_CMD_SFDP                             = 0x5A,

  

  // Windbond Commands
  FLASH_CMD_WINB_ENTER_QPI_MODE              = 0x38, /**< WinBond Specific */
  FLASH_CMD_WINB_EXIT_QPI_MODE               = 0xFF, /**< WinBond Specific */

  FLASH_CMD_WINB_QUAD_IO_FAST_READ           = 0xEB,

  FLASH_CMD_WINB_READ_STATUS_REGISTER1       = 0x05,  // Common Status Register
  FLASH_CMD_WINB_WRITE_STATUS_REGISTER1      = 0x01,

  FLASH_CMD_WINB_READ_STATUS_REGISTER2       = 0x35,
  FLASH_CMD_WINB_WRITE_STATUS_REGISTER2      = 0x31,

  FLASH_CMD_WINB_READ_STATUS_REGISTER3       = 0x15,
  FLASH_CMD_WINB_WRITE_STATUS_REGISTER3      = 0x11,

  FLASH_CMD_WINB_VOLATILE_SR_WRITE_ENABLE    = 0x50,

} FLASH_CMDS_t;

// //TSS: copied here from flash_driver.h, maybe move to flash_config
// typedef enum FLASH_SPI_MODE_e { // For Micron, only 2 MSBs are used. 6 LSBs enable other features
//     FLASH_DUAL_MODE = 0xBF,
//     FLASH_ESPI_MODE = 0xFF,
//     FLASH_QUAD_MODE = 0x7F,
// } FLASH_SPI_MODE_t;

// //TSS: copied here from flash_driver.h
// typedef enum FLASH_VENDOR_e {
//     MICROCHIP  = 0,
//     MICRON     = 1,
//     WINBOND    = 2,
//     MACRONIX   = 3,
//     WINBOND_25Q80DL = 4
// } FLASH_VENDOR_t;
 
// class Flash_Base_Vendor
// {
//   public:

//     FLASH_VENDOR_t    m_vendor;
//     FLASH_SPI_MODE_t  m_mode;

//     FLASH_CMDS_t get_ResetEnable_cmd();
//     FLASH_CMDS_t get_Reset_cmd();
//     FLASH_CMDS_t get_ReadSR_cmd();
//     virtual FLASH_CMDS_t get_ReadID_cmd();
//     FLASH_CMDS_t get_Deviceidentification_cmd();
//     FLASH_CMDS_t get_WriteEnable_cmd();
//     FLASH_CMDS_t get_WriteDisable_cmd();
//     FLASH_CMDS_t get_WriteEnableStatus_cmd();
//     FLASH_CMDS_t get_WriteStatus_cmd();
//     FLASH_CMDS_t get_ReadStatus_cmd();
//     FLASH_CMDS_t get_ClearFlagStatus_cmd();
//     FLASH_CMDS_t get_EnterQPI_cmd();
//     FLASH_CMDS_t get_WriteVEConfig_cmd();
//     FLASH_CMDS_t get_WriteNVConfig_cmd();
//     FLASH_CMDS_t get_WriteVoConfig_cmd();
//     FLASH_CMDS_t get_WriteExtAddr_cmd();
//     FLASH_CMDS_t get_ReadExtAddr_cmd();
//     FLASH_CMDS_t get_ReadVEConfig_cmd();
//     FLASH_CMDS_t get_ReadNVConfig_cmd();
//     virtual FLASH_CMDS_t get_Read_cmd();
//     virtual FLASH_CMDS_t get_Write_cmd();
//     virtual FLASH_CMDS_t get_ReadFlagSR_cmd();
//     FLASH_CMDS_t get_4byteAddrmode_cmd();
//     FLASH_CMDS_t get_3byteAddrmode_cmd();
// };

// FLASH_CMDS_t Flash_Base_Vendor::get_ResetEnable_cmd()
// {
//   return FLASH_CMD_RESET_ENABLE;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_Reset_cmd()
// {
//   return FLASH_CMD_RESET_MEMORY;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_ReadSR_cmd()
// {
//   return FLASH_CMD_READ_STATUS_REGISTER;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_WriteEnable_cmd()
// {
//   return FLASH_CMD_WRITE_ENABLE;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_WriteDisable_cmd()
// {
//   return FLASH_CMD_WRITE_DISABLE;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_WriteEnableStatus_cmd()
// {
//   return FLASH_CMD_WINB_VOLATILE_SR_WRITE_ENABLE;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_WriteStatus_cmd()
// {
//   // Only worked for winbond. No command was available for micron
//   // if(m_vendor == WINBOND_25Q80DL) return FLASH_CMD_WRITE_STATUS_REGISTER;  // doesn't account for other vendors
//   // else return FLASH_CMD_WINB_WRITE_STATUS_REGISTER2;
//   return FLASH_CMD_WRITE_STATUS_REGISTER;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_ReadStatus_cmd()
// {
//   return FLASH_CMD_WINB_READ_STATUS_REGISTER2;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_ClearFlagStatus_cmd()
// {
//   return FLASH_CMD_CLEAR_FLAG_STATUS_REGISTER;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_EnterQPI_cmd()
// {
//   return FLASH_CMD_WINB_ENTER_QPI_MODE;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_WriteVEConfig_cmd()
// {
//   return FLASH_CMD_WRITE_ENHANCED_VOLATILE_CONF;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_WriteNVConfig_cmd()
// {
//   return FLASH_CMD_WRITE_NON_VOLATILE_CONF;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_WriteVoConfig_cmd()
// {
//   return FLASH_CMD_WRITE_VOLATILE_CONF;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_WriteExtAddr_cmd()
// {
//   return FLASH_CMD_WRITE_EXT_ADDR;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_ReadExtAddr_cmd()
// {
//   return FLASH_CMD_READ_EXT_ADDR;
// }


// FLASH_CMDS_t Flash_Base_Vendor::get_ReadVEConfig_cmd()
// {
//   return FLASH_CMD_READ_ENHANCED_VOLATILE_CONF;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_ReadNVConfig_cmd()
// {
//   return FLASH_CMD_READ_NON_VOLATILE_CONF;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_4byteAddrmode_cmd()
// {
//   return FLASH_CMD_ENTER_4BYTE_ADDR_MODE;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_3byteAddrmode_cmd()
// {
//   return FLASH_CMD_EXIT_4BYTE_ADDR_MODE;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_Read_cmd()
// {
//   return FLASH_CMD_READ;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_Write_cmd()
// {
//   return FLASH_CMD_PAGE_PROGRAM;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_ReadFlagSR_cmd()
// {
//   return FLASH_CMD_READ_STATUS_REGISTER;
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_Deviceidentification_cmd()
// {
//   return FLASH_CMD_READ_ID; /** when test is flash agnostic then it returns 0x9F as readid cmd */
// }

// FLASH_CMDS_t Flash_Base_Vendor::get_ReadID_cmd()
// {
//   return FLASH_CMD_READ_ID;
// }

#endif
