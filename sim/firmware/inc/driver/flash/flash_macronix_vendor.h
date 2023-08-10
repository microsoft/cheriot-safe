#ifndef __FLASH_MACRONIX_VENDOR_H__
#define __FLASH_MACRONIX_VENDOR_H__

class Flash_Macronix_Vendor : public Flash_Base_Vendor
{
  public:

   Flash_Macronix_Vendor() : Flash_Base_Vendor()
   {
     // printf("\nMicron Vendor\n");
   }

   FLASH_CMDS_t get_Read_cmd();
   FLASH_CMDS_t get_Write_cmd();
   FLASH_CMDS_t get_ReadFlagSR_cmd();
   FLASH_CMDS_t get_ReadID_cmd();

};
/**
 *Set the Flash STD/Dual/Quad/QPI read command depending on device, mode, etc.
 */
FLASH_CMDS_t Flash_Macronix_Vendor::get_Read_cmd()
{
  FLASH_CMDS_t cmd = FLASH_CMD_QUAD_OUTPUT_FAST_READ; // Default is Quad
  
  if (m_mode == FLASH_DUAL_MODE) cmd = FLASH_CMD_DUAL_OUTPUT_FAST_READ;

  else if (m_mode != FLASH_DUAL_MODE && m_mode != FLASH_QUAD_MODE) cmd = FLASH_CMD_READ; 
 
  return cmd;
}

/**
 * Set the Flash STD/Dual/Quad/QPI write command depending on device, mode, etc.
 */
FLASH_CMDS_t Flash_Macronix_Vendor::get_Write_cmd()
{
  FLASH_CMDS_t cmd = FLASH_CMD_QUAD_INPUT_FAST_PROGRAM; // Default is Quad

  if(m_mode != FLASH_QUAD_MODE) cmd = FLASH_CMD_PAGE_PROGRAM;
  
  return cmd;
}

FLASH_CMDS_t Flash_Macronix_Vendor::get_ReadFlagSR_cmd()
{
  return FLASH_CMD_READ_STATUS_REGISTER;
}

FLASH_CMDS_t Flash_Macronix_Vendor::get_ReadID_cmd()
{
  return FLASH_CMD_READ_ID;
}

#endif

