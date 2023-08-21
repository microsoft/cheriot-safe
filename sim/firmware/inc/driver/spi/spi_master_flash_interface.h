
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

#ifndef __SPI_MASTER_FLASH_INTERFACE_H__
#define __SPI_MASTER_FLASH_INTERFACE_H__

#define MICRON_READ_ID 0x20bb19
#define MICRON_QUAD_CHIP_READ_ID 0x007698
#define WINBOND_READ_ID 0xef7019
#define WINBOND_25Q80DL_READ_ID 0xef13ef
#define MACRONIX_READ_ID 0xc22019

#ifndef FLASH_READ_SIZE
 #define FLASH_READ_SIZE 256 /**< To limit/control read command length */
#endif

#include "flash/flash_base_vendor.h"

/**
 * Command - Structure
 */
typedef struct CMD_STRUCT_s {
    FLASH_CMDS_t  cmd;
    uint32_t      addr;
    uint32_t      rbyte_cnt;  //TODO: UPDATE: Maybe change name to rTrans_cnt?
    uint32_t      wbyte_cnt;
    uint32_t       *array_ptr;
    uint8_t       addr_bytes;
} CMD_STRUCT_t;

#include "spi_master_interface.h"
#include "flash/flash_config.h"

class SPI_Master_Flash_Interface
{
  protected:
    SPI_Master_Interface spi_intf;
    Flash_Config         flash_cfg;

  public:
    //TSS: What does this mean? /**< Yaml Params */
    FLASH_VENDOR_t   vendor;
    SPI_MODE_t       spi_mode;    // spi_mode and flash_mode both set transmit mode to single, dual or quad. 
    FLASH_SPI_MODE_t flash_mode;  // The flash and spi have different values associated with the mode, hence two different variables.
    // SPI_FRF_t        m_spi_format;  //TSS: Declared in spi_types.h
    bool is_quad_flash_device = 0;
    bool is_flash_qpi = 0;
    bool is_addr4b = 0;  //TODO: QUESTION: make protected or private?
    // uint32_t         m_trans_addr;
    // uint8_t          m_no_of_trans;
    // int              m_slave_cnt;
    SPI_TRANS_TYPE_t m_spi_tx_mode = SPI_TX_STANDARD;  //TSS: QUESTION: How does this work? Declared in spi_types.h.

    SPI_Master_Flash_Interface()
    {
      // printf("Flash spi interface \n");
    }
    void     init();
    void     setSpiClkDiv(uint16_t clkdiv);
    void     setAddr(uint32_t addr);
    void     clear_interrupts();
    void     enable_interrupts(uint32_t wdata);
    void     set_flash_vendor_and_mode(FLASH_VENDOR_t vendor, FLASH_SPI_MODE_t mode);
    void     set_flash_mode(FLASH_SPI_MODE_t mode);
    void     set_flash_vendor(FLASH_VENDOR_t vendor);
    void     flash_ResetEnable();
    void     flash_Reset();
    void     flash_ReadID();
    int      flash_ReadID_and_set_vendor();
    void     flash_WriteStatusReg(uint32_t *array_ptr, uint32_t byte_cnt);
    uint32_t readStatusReg();
    void     pollStatusReg();
    uint32_t readFlagSR();
    void     pollFlagSR();
    void     clearFlagSR();
    void     flash_WriteEnable();
    void     flash_WriteDisable();
    void     flash_WriteVEConfigReg(FLASH_SPI_MODE_t flashMode);
    void     write_NVCR_reg(uint32_t *array_ptr);
    void     flash_WriteNVConfigReg(uint32_t *array_ptr);
    void     flash_WriteVoConfigReg(uint32_t *array_ptr);
    // void     flash_ReadConfigReg();
    uint32_t flash_ReadNVConfigReg();
    uint32_t flash_ReadVEConfigReg();
    void     flash_WriteExtAddrReg(uint32_t *wr_byte_ptr);
    uint32_t flash_ReadExtAddrReg();
    void     flash_Write(uint32_t address, uint32_t byte_cnt, uint8_t *wr_byte_ptr);
    void     flash_Write(uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr);
    void     flash_Write_4ByteAddr(uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr);
    void     flash_dual_write(uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr);
    void     flash_quad_write(uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr);
    void     flash_quad_write_4ByteAddr(uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr);
    void     Generate_Random_Data(uint32_t total_bytes, uint32_t *wr_byte_ptr);
    void     write_into_flash_memory(uint32_t address, uint32_t total_bytes, uint32_t *wr_byte_ptr);
    void     flash_read(uint32_t address, uint32_t total_words, uint32_t *rd_words);
    void     flash_read(uint32_t address, uint32_t total_bytes, uint8_t *rd_bytes);
    void     flash_read_4ByteAddr(uint32_t address, uint32_t total_words, uint32_t *rd_words);
    void     flash_fast_read(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr);
    void     flash_fast_read_4ByteAddr(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr);
    void     flash_dual_read(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr);
    void     flash_dual_read_4ByteAddr(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr);
    void     flash_quad_read(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr);
    void     flash_quad_read_4ByteAddr(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr);
    void     flash_quad_word_read(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr);
    int      flash_read_check_written(uint32_t address, uint32_t total_bytes, uint32_t *wr_byte_ptr);
    int      check_written(uint32_t total_bytes, uint32_t *wr_byte_ptr, uint32_t *rd_bytes);
    void     flash_Enter4byteAddrMode();
    void     flash_Exit4byteAddrMode();
    void     flash_EnterQuadIOMode();
    void     flash_ExitQuadIOMode();
    void     spiSetSlaveSel(SPI_SEL_VAL_t Spi);
    void     flash_erase_32kb(uint32_t addr);
    void     flash_erase_4kb(uint32_t addr);
    void     flash_erase_sector(uint32_t addr);
    void     flash_erase_chip(uint32_t addr);
    void     flash_4byte_erase_sector(uint32_t addr);
    void     flash_4byte_erase_4kb(uint32_t addr);
    void     flash_suspend_erase_prog();
    void     flash_resume_erase_prog();
 /*   void setExtaddrforspi(uint32_t *spi_addr_ptr);
    void flash_WriteEnableStatusReg();
    void flash_ReadWinbStatusReg2(uint32_t *array_ptr, uint32_t byte_cnt);
    void flash_EnterQPIMode();
    void flash_WriteConfigReg();
    int compare_read_data(uint8_t total_bytes, uint8_t *wr_byte_ptr, uint8_t *rd_bytes);
    uint8_t get_wait_clks();
    uint32_t flash_LoadImage(uint32_t flash_addr, uint32_t *dst_addr_ptr, SPI_FRF_t spi_frf = SPI_STD_FORMAT, bool test_one_page = 0);
    uint32_t flashDownload (uint32_t flash_addr, uint32_t *dst_addr_ptr, uint32_t byte_cnt);
    void flash_Write_Read_ConfigReg(SPI_SEL_VAL_t spi_ip_num = SPI_SEL_0);
    int compare_POR_value();
*/
};

/**
 *Setting Address for spi registers
 */
void SPI_Master_Flash_Interface::init()
{
  uint16_t clkdiv = 5;
  setSpiClkDiv(clkdiv);
  set_flash_mode(FLASH_ESPI_MODE);
  setAddr(SPI_BASE_ADDR);
}

/**
 *Setting Address for spi registers
 */
void SPI_Master_Flash_Interface::setSpiClkDiv(uint16_t clkdiv)
{
  spi_intf.setClkDiv(clkdiv);
}

/**
 *Setting Address for spi registers
 */
void SPI_Master_Flash_Interface::setAddr(uint32_t addr)
{
  spi_intf.setSpiAddr(addr);
}

void SPI_Master_Flash_Interface::clear_interrupts()
{
  spi_intf.enable_interrupts(0);
}

void SPI_Master_Flash_Interface::enable_interrupts(uint32_t wdata)
{
  spi_intf.enable_interrupts(wdata);
}

void SPI_Master_Flash_Interface::set_flash_vendor_and_mode(FLASH_VENDOR_t vendor, FLASH_SPI_MODE_t mode)
{
  set_flash_mode(mode);
  set_flash_vendor(vendor); /**< creates object of flash vendor type and assigns to base vendor */
}

void SPI_Master_Flash_Interface::set_flash_mode(FLASH_SPI_MODE_t mode)
{
  
  switch(mode) {
    case FLASH_ESPI_MODE : spi_mode = SPI_SINGLE_MODE; break;
    case FLASH_DUAL_MODE : spi_mode = SPI_DUAL_MODE; break;
    case FLASH_QUAD_MODE : spi_mode = SPI_QUAD_MODE; break;
  }
  flash_mode = mode;
  flash_cfg.set_mode(mode);
  spi_intf.setMode(spi_mode);
}

void SPI_Master_Flash_Interface::set_flash_vendor(FLASH_VENDOR_t vendor)
{
  if(vendor == WINBOND && flash_mode == FLASH_QUAD_MODE) {
    if(m_spi_tx_mode != SPI_TX_STANDARD) is_flash_qpi = 1;
    else is_flash_qpi = 0;
  }

  flash_cfg.set_vendor(vendor, is_flash_qpi);
}

// /**
//  * ResetEnable cmd
//  * 
//  */
void SPI_Master_Flash_Interface::flash_ResetEnable()
{
  CMD_STRUCT_t m_CMD_S;
  flash_cfg.ResetEnable(&m_CMD_S);
  spi_intf.spiCmd(m_CMD_S);  
}

void SPI_Master_Flash_Interface::flash_Reset()
{
  CMD_STRUCT_t m_CMD_S;
  flash_cfg.Reset(&m_CMD_S);
  spi_intf.spiCmd(m_CMD_S);
}


void SPI_Master_Flash_Interface::flash_ReadID()
{
  const uint32_t wordCnt = 5;
  const uint32_t byteCnt = 20;
  uint32_t       reg_words[wordCnt];
  uint32_t       exp_read_id, act_read_id = 0;
  // int            num = 2;
  CMD_STRUCT_t m_CMD_S;

  flash_cfg.ReadID(&m_CMD_S, reg_words, byteCnt);
  spi_intf.spiCmd(m_CMD_S);

  // printf("ID word: %d value: 0x%x\n", i, reg_words[i]);
  act_read_id = reg_words[0] >> 8;

  if(vendor == MICRON && is_quad_flash_device) exp_read_id = MICRON_QUAD_CHIP_READ_ID;
  else if(vendor == MACRONIX) exp_read_id = MACRONIX_READ_ID;
  else if(vendor == WINBOND) exp_read_id = WINBOND_READ_ID;
  else if(vendor == WINBOND_25Q80DL) exp_read_id = WINBOND_25Q80DL_READ_ID;
  else exp_read_id = MICRON_READ_ID;

  if(act_read_id == exp_read_id){
    // hw_status("Read ID Matched \n");
    printf("Read ID Matched \n");
  }
  else{
  //  hw_errmsg("Read ID Not Matched act = 0x%0x exp = 0x%0x \n",act_read_id,exp_read_id);
  printf("Read ID Not Matched act = 0x%0x exp = 0x%0x \n",act_read_id,exp_read_id);
  }
}


int SPI_Master_Flash_Interface::flash_ReadID_and_set_vendor()
{
  FLASH_VENDOR_t m_vendor;
  int errors = 0;
  uint32_t       reg_bytes[1];
  uint32_t      read_id = 0;
  CMD_STRUCT_t m_CMD_S;

  flash_cfg.DeviceIdentification(&m_CMD_S, reg_bytes, 3);
  spi_intf.spiCmd(m_CMD_S);

    read_id = reg_bytes[0] >> 8;
    printf("ID: 0x%x\n", reg_bytes[0]);

  switch(read_id) {
    case MICRON_READ_ID : m_vendor = MICRON; break;
    case MACRONIX_READ_ID : m_vendor = MACRONIX; break;
    case WINBOND_READ_ID : m_vendor = WINBOND; break;
    case WINBOND_25Q80DL_READ_ID : m_vendor = WINBOND_25Q80DL; break;
    default: 
      printf("READ ID is Not Matched : Unknown Vendor\n");
      errors++;
  }

  if(errors == 0) set_flash_vendor(m_vendor);
  return errors;
}


void SPI_Master_Flash_Interface::flash_WriteStatusReg(uint32_t *array_ptr, uint32_t byte_cnt)
{
  flash_WriteEnable();

  CMD_STRUCT_t m_CMD_S;
  m_CMD_S.array_ptr = array_ptr;

  flash_cfg.WriteStatusReg(&m_CMD_S,byte_cnt);
  spi_intf.spiCmd(m_CMD_S);

  // hsp_msg_high("Wr Addr:0x%02x %0d Byte(s):\n", m_CMD_S.cmd, byte_cnt);
  // for(int ii=0; ii<byte_cnt; ii++) {
      // hsp_msg_high("%0d:0x%02x\n", ii, array_ptr[ii]);
  // }

  readStatusReg();
  pollStatusReg();
  flash_WriteDisable();
}

uint32_t SPI_Master_Flash_Interface::readStatusReg()
{
  // printf("In SPI_Master_Flash_Interface::readStatusReg.\n");
  uint32_t byte_array[1];
  CMD_STRUCT_t m_CMD_S;

  flash_cfg.ReadSR(&m_CMD_S, byte_array, 1);
  spi_intf.spiCmd(m_CMD_S);
  // printf("Status Register: 0x%x\n", byte_array[0]);

  return byte_array[0];
}

void SPI_Master_Flash_Interface::pollStatusReg()
{
  uint32_t status;

  do { /** Poll Status register until bit 0 is zero */
    status = readStatusReg();
    // hsp_msg_high("Stat:0x%x\n", byte_array[0], 1);
    // printf("Stat:0x%x\n", status);
  } while(status & 0x1);
}


uint32_t SPI_Master_Flash_Interface::readFlagSR()
{
  CMD_STRUCT_t m_CMD_S;
  uint32_t byte_array[1];

        flash_cfg.ReadFlagSR(&m_CMD_S, byte_array, 1);
        spi_intf.spiCmd(m_CMD_S);
        printf("Flag Status Register:0x%x\n", byte_array[0]);

  return byte_array[0];
}

void SPI_Master_Flash_Interface::pollFlagSR()
{
  uint32_t status;

      do { /**< Poll Flag Status register until bit-7 (Program or Erase Done) is one */
        status = readFlagSR();
        // hsp_msg_high("Flag Stat:0x%x\n", byte_array[0]);
        // printf("Flag Stat:0x%x\n", status);
      } while((status >> 7) ^ 0x1);
}

void SPI_Master_Flash_Interface::clearFlagSR()
{
  CMD_STRUCT_t m_CMD_S;
  flash_cfg.ClearFlagSR(&m_CMD_S);
  spi_intf.spiCmd(m_CMD_S);
}


void SPI_Master_Flash_Interface::flash_WriteEnable()
{
  CMD_STRUCT_t m_CMD_S;
  flash_cfg.WriteEnable(&m_CMD_S);
  spi_intf.spiCmd(m_CMD_S);
}

void SPI_Master_Flash_Interface::flash_WriteDisable()
{
  CMD_STRUCT_t m_CMD_S;
  flash_cfg.WriteDisable(&m_CMD_S);
  spi_intf.spiCmd(m_CMD_S);
}

//TODO: IMPLEMENT Fix this method to work with micron. Will need flash config modification.
// void SPI_Master_Flash_Interface::flash_WriteStatusReg(uint32_t *array_ptr, uint32_t byte_cnt)
// {
//   flash_WriteEnable();

//   CMD_STRUCT_t m_CMD_S;
//   m_CMD_S.array_ptr = array_ptr;

//   flash_cfg.WriteStatusReg(&m_CMD_S,byte_cnt);
//   spi_intf.SpiCmd(m_CMD_S);

//   hsp_msg_high("Wr Addr:0x%02x %0d Byte(s):\n", m_CMD_S.cmd, byte_cnt);
//   for(int ii=0; ii<byte_cnt; ii++) {
//       hsp_msg_high("%0d:0x%02x\n", ii, array_ptr[ii]);
//   }

//   flash_ReadSR();
//   flash_WriteDisable();
// }



/**
 * Write to the Volatile Enhanced configuration register
 * Sets the mode for the flash.
 */
void SPI_Master_Flash_Interface::flash_WriteVEConfigReg(FLASH_SPI_MODE_t flashMode)
{
  uint32_t array[1];
  uint32_t val = flashMode;
  CMD_STRUCT_t m_CMD_S;

  array[0] = val & 0xFF;
  m_CMD_S.array_ptr = array;

  flash_WriteEnable();      // Bit is reset after operation.
  flash_cfg.WriteVEConfigReg(&m_CMD_S);
  spi_intf.spiCmd(m_CMD_S);
}

void SPI_Master_Flash_Interface::write_NVCR_reg(uint32_t *array_ptr)
{
  // spi_intf.SpiInit(spi_ip_num, SPI_PHASE, SPI_POLARITY, SPI_STD_FORMAT, SPI_TX_STANDARD);
  flash_WriteNVConfigReg(array_ptr);
  flash_ResetEnable();
  flash_Reset();
}

void SPI_Master_Flash_Interface::flash_WriteNVConfigReg(uint32_t *array_ptr)
{
  CMD_STRUCT_t m_CMD_S;

  flash_WriteEnable();
  m_CMD_S.array_ptr  = array_ptr;
  flash_cfg.WriteNVConfigReg(&m_CMD_S);
  spi_intf.spiCmd(m_CMD_S);
}

void SPI_Master_Flash_Interface::flash_WriteVoConfigReg(uint32_t *array_ptr)
{
  flash_WriteEnable();

  CMD_STRUCT_t m_CMD_S;
  m_CMD_S.array_ptr = array_ptr;

  flash_cfg.WriteVoConfigReg(&m_CMD_S);
  spi_intf.spiCmd(m_CMD_S);

  // hsp_msg_high("Wr Addr:0x%02x %0d Byte(s):\n", m_CMD_S.cmd, byte_cnt);
  // for(int ii=0; ii<byte_cnt; ii++) {
  //     hsp_msg_high("%0d:0x%02x\n", ii, array_ptr[ii]);
  // }

  readStatusReg();
  flash_WriteDisable();
}

// void SPI_Master_Flash_Interface::flash_ReadConfigReg()
// {
//   flash_ReadNVConfigReg();
//   flash_ReadVEConfigReg();
// }

uint32_t SPI_Master_Flash_Interface::flash_ReadNVConfigReg()
{
  uint32_t reg_bytes[1];
  CMD_STRUCT_t m_CMD_S;
  flash_cfg.ReadNVConfigReg(&m_CMD_S, reg_bytes, 2);
  spi_intf.spiCmd(m_CMD_S);
  // hw_status("Read NONVOL Dword:0x%02x%02x\n", reg_bytes[0], reg_bytes[1]);
  // printf("Read NONVOL Dword:0x%02x%02x\n", reg_bytes[0], reg_bytes[1]);
  return reg_bytes[0];
}

uint32_t SPI_Master_Flash_Interface::flash_ReadVEConfigReg()
{
  uint32_t reg_bytes[1];
  CMD_STRUCT_t m_CMD_S;

  flash_cfg.ReadVEConfigReg(&m_CMD_S, reg_bytes, 1);
  spi_intf.spiCmd(m_CMD_S);
  // hw_status("Read EnVol = 0x%x\n", reg_bytes[0]);
  printf("Read EnVol = 0x%x\n", reg_bytes[0]);
  return reg_bytes[0];
}

//TODO:: UPDATE: Test when winbond flash is available
// void SPI_Master_Flash_Interface::flash_ReadWinbStatusReg2(uint32_t *array_ptr, uint32_t byte_cnt)
// {
//   CMD_STRUCT_t m_CMD_S;
//   flash_cfg.ReadStatusReg(&m_CMD_S, array_ptr, byte_cnt);
//   spi_intf.spiCmd(m_CMD_S);
// }


void SPI_Master_Flash_Interface::flash_WriteExtAddrReg(uint32_t *wr_byte_ptr)
{
  CMD_STRUCT_t m_CMD_S;
  m_CMD_S.array_ptr = wr_byte_ptr;
  flash_cfg.WriteExtAddrReg(&m_CMD_S, 1);
  flash_WriteEnable();
  spi_intf.spiCmd(m_CMD_S);
}

uint32_t SPI_Master_Flash_Interface::flash_ReadExtAddrReg()
{
  uint32_t array[1];
  CMD_STRUCT_t m_CMD_S;
  flash_cfg.ReadExtAddrReg(&m_CMD_S, array, 1);
  spi_intf.spiCmd(m_CMD_S);
  return array[0];
}


void SPI_Master_Flash_Interface::flash_Write(uint32_t address, uint32_t byte_cnt, uint8_t *wr_byte_ptr) {
  flash_WriteEnable();
  spi_intf.writeFlashData(FLASH_CMD_PAGE_PROGRAM, address, byte_cnt, wr_byte_ptr);
  pollStatusReg();
}


void SPI_Master_Flash_Interface::flash_Write(uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr)
{
  flash_WriteEnable();
  spi_intf.writeFlashData(FLASH_CMD_PAGE_PROGRAM, address, word_cnt, wr_word_ptr);
  pollStatusReg();
  }

void SPI_Master_Flash_Interface::flash_Write_4ByteAddr(uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr)
{
  flash_WriteEnable();
  spi_intf.setTempAddr4Bytes();
  spi_intf.writeFlashData(FLASH_CMD_4BYTE_FAST_PROGRAM, address, word_cnt, wr_word_ptr);
  spi_intf.setTempAddr3Bytes();
  pollStatusReg();
  }

void SPI_Master_Flash_Interface::flash_dual_write(uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr)
{
  flash_WriteEnable();
  spi_intf.writeFlashData(FLASH_CMD_DUAL_INPUT_FAST_PROGRAM, address, word_cnt, wr_word_ptr);
  pollStatusReg();
  }

void SPI_Master_Flash_Interface::flash_quad_write(uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr)
{
  flash_WriteEnable();
  spi_intf.writeFlashData(FLASH_CMD_QUAD_INPUT_FAST_PROGRAM, address, word_cnt, wr_word_ptr);
  pollStatusReg();
  }

void SPI_Master_Flash_Interface::flash_quad_write_4ByteAddr(uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr)
{
  flash_WriteEnable();
  spi_intf.setTempAddr4Bytes();
  spi_intf.writeFlashData(FLASH_CMD_4BYTE_QUAD_FAST_PROGRAM, address, word_cnt, wr_word_ptr);
  spi_intf.setTempAddr3Bytes();
  pollStatusReg();
  }

/**
* Generates random data for flash writes
*/
void SPI_Master_Flash_Interface::Generate_Random_Data(uint32_t total_words, uint32_t *wr_word_ptr)
{
  for(uint32_t ii=0; ii<total_words; ii++) {
    wr_word_ptr[ii] = rand();
    printf("%d:0x%x\n", ii, wr_word_ptr[ii]);
  }
}

/**
 *Write Flash Memory Contents
 */
void SPI_Master_Flash_Interface::write_into_flash_memory(uint32_t address, uint32_t total_words, uint32_t *wr_word_ptr)
{
  Generate_Random_Data(total_words, wr_word_ptr);

  flash_Write_4ByteAddr(address, total_words, wr_word_ptr);

  // Poll_FlagSR();
  // flash_WriteDisable();
}

// **************************** Flash Read Section ***************************************************

void SPI_Master_Flash_Interface::flash_read(uint32_t address, uint32_t total_words, uint32_t *rd_words)
{
  uint8_t dummy_cycles = 0;
  spi_intf.readFlashData(FLASH_CMD_READ, dummy_cycles, address, total_words, rd_words);
}


void SPI_Master_Flash_Interface::flash_read(uint32_t address, uint32_t total_bytes, uint8_t *rd_bytes)
{
  uint8_t dummy_cycles = 0;
  spi_intf.readFlashData(FLASH_CMD_READ, dummy_cycles, address, total_bytes, rd_bytes);
}

void SPI_Master_Flash_Interface::flash_read_4ByteAddr(uint32_t address, uint32_t total_bytes, uint32_t *rd_bytes)
{
  uint8_t dummy_cycles = 0;
  spi_intf.setTempAddr4Bytes();
  spi_intf.readFlashData(FLASH_CMD_4BYTE_READ, dummy_cycles, address, total_bytes, rd_bytes);
  spi_intf.setTempAddr3Bytes();
}

void SPI_Master_Flash_Interface::flash_fast_read(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr)
{
  // uint8_t dummyCycles = (flash_mode == FLASH_QUAD_MODE) ? QUAD_10_DUMMY_CYCLES : SINGLE_8_DUMMY_CYCLES;
  uint8_t dummyCycles = (flash_mode == FLASH_QUAD_MODE) ? DUMMY_10_CYCLES : DUMMY_8_CYCLES;
  spi_intf.readFlashData(FLASH_CMD_FAST_READ, dummyCycles, address, word_cnt, rd_word_ptr);
}

void SPI_Master_Flash_Interface::flash_fast_read_4ByteAddr(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr)
{
  uint8_t dummyCycles = (flash_mode == FLASH_QUAD_MODE) ? DUMMY_10_CYCLES : DUMMY_8_CYCLES;
  spi_intf.setTempAddr4Bytes();
  spi_intf.readFlashData(FLASH_CMD_4BYTE_FAST_READ, dummyCycles, address, word_cnt, rd_word_ptr);
  spi_intf.setTempAddr3Bytes();

}

void SPI_Master_Flash_Interface::flash_dual_read(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr)
{
  // uint8_t dummy_cycles = DUAL_8_DUMMY_CYCLES;
  uint8_t dummy_cycles = DUMMY_8_CYCLES;
  spi_intf.readFlashData(FLASH_CMD_DUAL_OUTPUT_FAST_READ, dummy_cycles, address, word_cnt, rd_word_ptr);
}

void SPI_Master_Flash_Interface::flash_dual_read_4ByteAddr(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr)
{
  // uint8_t dummy_cycles = DUAL_8_DUMMY_CYCLES;
  uint8_t dummy_cycles = DUMMY_8_CYCLES;
  spi_intf.setTempAddr4Bytes();
  spi_intf.readFlashData(FLASH_CMD_4BYTE_DUAL_OUTPUT_FAST_READ, dummy_cycles, address, word_cnt, rd_word_ptr);
  spi_intf.setTempAddr3Bytes();
}

void SPI_Master_Flash_Interface::flash_quad_read(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr)
{
  // uint8_t dummy_cycles = QUAD_10_DUMMY_CYCLES;
  uint8_t dummy_cycles = DUMMY_10_CYCLES;
  spi_intf.readFlashData(FLASH_CMD_QUAD_OUTPUT_FAST_READ, dummy_cycles, address, word_cnt, rd_word_ptr);
}

void SPI_Master_Flash_Interface::flash_quad_read_4ByteAddr(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr)
{
  // uint8_t dummy_cycles = QUAD_10_DUMMY_CYCLES;
  uint8_t dummy_cycles = DUMMY_10_CYCLES;
  spi_intf.setTempAddr4Bytes();
  spi_intf.readFlashData(FLASH_CMD_4BYTE_QUAD_OUTPUT_FAST_READ, dummy_cycles, address, word_cnt, rd_word_ptr);
  spi_intf.setTempAddr3Bytes();
}

void SPI_Master_Flash_Interface::flash_quad_word_read(uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr)
{
  // uint8_t dummy_cycles = QUAD_4_DUMMY_CYCLES;
  uint8_t dummy_cycles = DUMMY_4_CYCLES;
  spi_intf.readFlashData(FLASH_CMD_QUAD_IO_FAST_WORD_READ, dummy_cycles, address, word_cnt, rd_word_ptr);
}

/**
 *Read Flash Memory Check vs Written
 */
int SPI_Master_Flash_Interface::flash_read_check_written(uint32_t address, uint32_t total_bytes, uint32_t *wr_byte_ptr)
{
  uint32_t      rd_bytes[total_bytes];
  // uint32_t      rd_bytes[FLASH_PAGE_SIZE];

  printf("\nReading %d Bytes From Flash Address:0x%08x\n", total_bytes, address);

  flash_read(address, total_bytes, rd_bytes);
  return check_written(total_bytes, wr_byte_ptr, rd_bytes);
}

/**
 * Compare read data to written data
 */
int SPI_Master_Flash_Interface::check_written(uint32_t total_bytes, uint32_t *wr_byte_ptr, uint32_t *rd_bytes)
{
  int     errors      = EXIT_SUCCESS;
  for(uint32_t ii=0; ii<total_bytes; ii++) { // Verify write vs read data
    if(wr_byte_ptr[ii] != rd_bytes[ii]) {
      errors++;
      printf("\n=== Error: Data Exp:0x%02x Obs:0x%02x\n", wr_byte_ptr[ii], rd_bytes[ii]);
    }
    // printf("write word: 0x%x, read word: 0x%x\n", wr_byte_ptr[ii], rd_bytes[ii]);
  }
  printf("There are %d errors\n", errors);
  return errors;
}


void SPI_Master_Flash_Interface::flash_Enter4byteAddrMode()
{
  flash_WriteEnable();

  CMD_STRUCT_t m_CMD_S;
  flash_cfg.Enable4byteAddrMode(&m_CMD_S);
  spi_intf.setAddr4Bytes();
  spi_intf.spiCmd(m_CMD_S);
  is_addr4b=1;
}


void SPI_Master_Flash_Interface::flash_Exit4byteAddrMode()
{
  flash_WriteEnable();

  CMD_STRUCT_t m_CMD_S;
  flash_cfg.Enable3byteAddrMode(&m_CMD_S);
  spi_intf.setAddr3Bytes();
  spi_intf.spiCmd(m_CMD_S);
  is_addr4b=1;
}


void SPI_Master_Flash_Interface::flash_EnterQuadIOMode()
{
  spi_intf.writeCmd(FLASH_CMD_ENTER_QUAD_IO_MODE);
  spi_intf.deselectSub();
  set_flash_mode(FLASH_QUAD_MODE);
}

void SPI_Master_Flash_Interface::flash_ExitQuadIOMode()
{
  spi_intf.writeCmd(FLASH_CMD_EXIT_QUAD_IO_MODE);
  spi_intf.deselectSub();
  set_flash_mode(FLASH_ESPI_MODE);
}

void SPI_Master_Flash_Interface::spiSetSlaveSel(SPI_SEL_VAL_t Spi)
{
  spi_intf.setSub(Spi);
}


void SPI_Master_Flash_Interface::flash_erase_32kb(uint32_t addr)
{
  flash_WriteEnable();
  spi_intf.flashErase(FLASH_CMD_ERASE_32KB_SUBSECTOR, addr);
}
void SPI_Master_Flash_Interface::flash_erase_4kb(uint32_t addr)
{
  flash_WriteEnable();
  spi_intf.flashErase(FLASH_CMD_ERASE_4KB_SUBSECTOR, addr);
}
void SPI_Master_Flash_Interface::flash_erase_sector(uint32_t addr)
{
  flash_WriteEnable();
  spi_intf.flashErase(FLASH_CMD_ERASE_SECTOR, addr);
}
void SPI_Master_Flash_Interface::flash_erase_chip(uint32_t addr)
{
  flash_WriteEnable();
  spi_intf.flashErase(FLASH_CMD_BULK_ERASE, addr);
}
void SPI_Master_Flash_Interface::flash_4byte_erase_sector(uint32_t addr)
{
  flash_WriteEnable();
  spi_intf.setTempAddr4Bytes();
  spi_intf.flashErase(FLASH_CMD_4BYTE_ERASE_SECTOR, addr);
  spi_intf.setTempAddr3Bytes();
}
void SPI_Master_Flash_Interface::flash_4byte_erase_4kb(uint32_t addr)
{
  flash_WriteEnable();
  spi_intf.setTempAddr4Bytes();
  spi_intf.flashErase(FLASH_CMD_4BYTE_ERASE_4KB_SUBSECTOR, addr);
  spi_intf.setTempAddr3Bytes();
}

void SPI_Master_Flash_Interface::flash_suspend_erase_prog()
{
  spi_intf.writeCmd(FLASH_CMD_SUSPEND_PROG_ERASE);
  spi_intf.deselectSub();
}
void SPI_Master_Flash_Interface::flash_resume_erase_prog()
{
  spi_intf.writeCmd(FLASH_CMD_RESUME_PROG_ERASE);
  spi_intf.deselectSub();
}

#endif
