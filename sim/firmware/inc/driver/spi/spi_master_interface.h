
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

#ifndef __SPI_MASTER_INTERFACE_H__
#define __SPI_MASTER_INTERFACE_H__

#include "msftDvIp_spi.h"

class SPI_Master_Interface {

private:
  msftDvIp_spi_c spi_c;
  uint8_t  addr_bytes = 3;
  // temp_addr_bytes is used to output 4 byte address when in 3 byte mode
  // This is necessary because 4 byte address read and write commands can 
  // use 4 byte addresses even if the flash is in 3 byte address mode.
  uint8_t  temp_addr_bytes = 3;

public:
  SPI_TRANS_STRUCT_t spi_trans_s;
  SPI_SEL_VAL_t subordinate = SPI_SEL_0;


  SPI_Master_Interface()
  {
    printf("\nSpi interface\n");
  }

  void     init();
  void     setMode(SPI_MODE_t mode);
  void     setSub(SPI_SEL_VAL_t sub);  //TODO: UPDATE: change SPI_SEL_VAL_t SUB_SEL_VAL_t
  void     setClkDiv(uint16_t clkdiv);
  void     setSpiAddr(uint32_t addr);
  void     enable_interrupts(uint32_t wdata);
  void     spiCmd(CMD_STRUCT_t CMD_S);
  void     writeCmd(FLASH_CMDS_t cmd);
  void     readFlashRegister(CMD_STRUCT_t CMD_S);
  void     writeFlashAddr(uint32_t addr);
  void     writeFlashData(FLASH_CMDS_t cmd, uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr);
  void     writeFlashData(FLASH_CMDS_t cmd, uint32_t address, uint32_t byte_cnt, uint8_t* wr_byte_ptr);
  void     readFlashData(FLASH_CMDS_t cmd, uint8_t dummyCycles, uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr);
  void     readFlashData(FLASH_CMDS_t cmd, uint8_t dummyCycles, uint32_t address, uint32_t byte_cnt, uint8_t *rd_byte_ptr);
  void     writeFlashRegister(CMD_STRUCT_t CMD_S);
  void     flashErase(FLASH_CMDS_t cmd, uint32_t addr);
  void     sendDummyCycles(uint8_t cycles);
  void     deselectSub();
  void     setAddr4Bytes();
  void     setAddr3Bytes();
  void     setTempAddr4Bytes();
  void     setTempAddr3Bytes();
};



void SPI_Master_Interface::init()
{
  spi_trans_s.spiMode=SPI_SINGLE_MODE;
  spi_trans_s.sub=subordinate;
  setClkDiv(5);
  setSpiAddr(SPI_BASE_ADDR);
}

void SPI_Master_Interface::setMode(SPI_MODE_t mode)
{
  spi_trans_s.spiMode=mode;
}

void SPI_Master_Interface::setSub(SPI_SEL_VAL_t sub)
{
  subordinate = sub;
}

void SPI_Master_Interface::setClkDiv(uint16_t clkdiv)
{
  spi_trans_s.clkDiv = clkdiv;
}

/**
 * Set spi address.
 */
void SPI_Master_Interface::setSpiAddr(uint32_t addr)
{
  // printf("Initializing SPI Block\n");
  spi_c.setAddr(addr);
}

/**
 *Clear Existing SPI IP Interrupts
 */
void SPI_Master_Interface::enable_interrupts(uint32_t wdata)
{
  printf("clear existing interrupts \n");
  spi_c.setInterruptEnable(wdata);
}


/**
 * Read data from the flash
 * 
 */
void SPI_Master_Interface::readFlashRegister(CMD_STRUCT_t CMD_S)
{
  uint32_t counter = 1;
  uint32_t byte_cnt = CMD_S.rbyte_cnt;

  spi_trans_s.enable=ENABLE;      
  spi_trans_s.loopback=DISABLE;   
  spi_trans_s.txType=SPI_RX;
  // spi_trans_s.readStart=ENABLE;
  spi_trans_s.transactions=1;
  spi_trans_s.sub=subordinate;

  if (byte_cnt ==1 ) {
    spi_trans_s.txNumBits=SPI_08_BIT_WORD;
  } else if (byte_cnt == 2) {
      spi_trans_s.txNumBits=SPI_16_BIT_WORD;
  } else {
      spi_trans_s.txNumBits=SPI_32_BIT_WORD;
      uint32_t wordCnt = CMD_S.rbyte_cnt/4 + (CMD_S.rbyte_cnt%4 != 0);
      spi_trans_s.transactions=wordCnt;
      counter = wordCnt;
  }

  spi_c.setCtrl1(&spi_trans_s);
  spi_c.setCtrl0(&spi_trans_s);
  spi_c.wait4Mst();
  for (uint32_t i = 0; i < counter; i++) {
    CMD_S.array_ptr[i] = spi_c.readData();
  }
}

/**
 * Write address to the flash
 * 
 */
void SPI_Master_Interface::writeFlashAddr(uint32_t addr)
{

  spi_trans_s.txNumBits = (addr_bytes == 4 || temp_addr_bytes == 4) ? SPI_32_BIT_WORD : SPI_24_BIT_WORD;

  uint8_t *abyte_ptr = (uint8_t *) &addr; /**< Use pointer magic to access address bytes so they can be reversed */
  /**< Flash boots in 3-byte address mode. In SPI_08_BIT_WORD mode we want MSB Byte first, so reverse */
  uint32_t address = (addr_bytes == 4) ? (abyte_ptr[0] << 24 | abyte_ptr[1] << 16 | abyte_ptr[2] << 8 | abyte_ptr[3]) :
                                  (                     abyte_ptr[0] << 16 | abyte_ptr[1] << 8 | abyte_ptr[2]);

  spi_trans_s.enable=ENABLE;   
  spi_trans_s.loopback=DISABLE;
  spi_trans_s.txType=SPI_TX;
  // spi_trans_s.readStart=DISABLE;
  spi_trans_s.transactions=0;
  spi_trans_s.sub=subordinate;
  spi_c.writeData(address);
  spi_c.setCtrl1(&spi_trans_s);
  spi_c.setCtrl0(&spi_trans_s);
  spi_c.wait4Mst();
  spi_trans_s.enable=DISABLE;
  spi_c.setCtrl0(&spi_trans_s);
}

/**
 * Read data from the flash in 8 bit bytes
 * 
 */
void SPI_Master_Interface::readFlashData(FLASH_CMDS_t cmd, uint8_t dummyCycles, uint32_t address, uint32_t byte_cnt, uint8_t *rd_byte_ptr)
{
  writeCmd(FLASH_CMD_READ);
  writeFlashAddr(address);

  spi_trans_s.enable=ENABLE;      
  spi_trans_s.loopback=DISABLE;   
  spi_trans_s.txNumBits=SPI_08_BIT_WORD;
  spi_trans_s.txType=SPI_RX;
  // spi_trans_s.readStart=ENABLE;
  spi_trans_s.transactions=byte_cnt;
  spi_trans_s.sub=subordinate;

  spi_c.setCtrl1(&spi_trans_s);
  spi_c.setCtrl0(&spi_trans_s);

  for(uint32_t i=0; i<byte_cnt; i++) {
    spi_c.wait4RxFifoNotEmpty();
    rd_byte_ptr[i] = spi_c.readData();
  }  
  spi_c.wait4Mst();
  deselectSub();
}

void SPI_Master_Interface::sendDummyCycles(uint8_t cycles)
{
  spi_trans_s.enable=ENABLE;      
  spi_trans_s.loopback=DISABLE;   
  spi_trans_s.txType=SPI_TX;
  // spi_trans_s.readStart=DISABLE;
  spi_trans_s.transactions=0;
  spi_trans_s.sub=subordinate;

  if (cycles == DUMMY_10_CYCLES) {
    spi_c.writeData(0x0);
    spi_trans_s.txNumBits=0x13;
  } else {
    spi_trans_s.txNumBits=cycles;
  }

  spi_c.writeData(0x0);
  spi_c.setCtrl1(&spi_trans_s);
  spi_c.setCtrl0(&spi_trans_s);
}

/**
 * Read data from the flash in 32 bit words
 * 
 */
void SPI_Master_Interface::readFlashData(FLASH_CMDS_t cmd, uint8_t dummyCycles, uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr)
{
  // writeCmd(cmd);
  // writeFlashAddr(address);
  spi_c.writeData(address);
  // For ctrl0
  spi_trans_s.enable       = ENABLE;
  spi_trans_s.loopback     = DISABLE;
  spi_trans_s.txNumBits    = SPI_32_BIT_WORD;
  spi_trans_s.txType       = SPI_RX;
  // For ctrl1
  // spi_trans_s.readStart    = ENABLE;
  spi_trans_s.sub          = subordinate;  // Default is SPI_SEL_0
  spi_trans_s.transactions = 0;
  // For flashCtrl0
  // flash_trans_s.cmd        = cmd;
  // flash_trans_s.dummy      = dummyCycles;
  // flash_trans_s.rdop       = 1;
  // flash_trans_s.cmdType    = CMD_ADDR3_DUMMY;
  // flash_trans_s.cmdStart   = 1;

  spi_c.setCtrl1(&spi_trans_s);
  spi_c.setCtrl0(&spi_trans_s);
  // spi_c.setFlashCtrl0(&flash_trans_s);

  for(uint32_t i=0; i<word_cnt; i++) {
    spi_c.wait4RxFifoNotEmpty();
    rd_word_ptr[i] = spi_c.readData();
    printf("rd word ptr: 0x%x\n", rd_word_ptr[i]);
    printf("cnt: %d\n", i);
  }
  printf("waiting for mst\n");
  spi_c.wait4Mst();
  printf("ready to deselect sub\n");
  deselectSub();
  printf("done\n");
}
// /**
//  * Read data from the flash in 32 bit words
//  * 
//  */
// void SPI_Master_Interface::readFlashData(FLASH_CMDS_t cmd, uint8_t dummyCycles, uint32_t address, uint32_t word_cnt, uint32_t *rd_word_ptr)
// {
//   printf("read flash data cmd: 0x%x\n", cmd);
//   // writeCmd(cmd);
//   // writeFlashAddr(address);

//   if (dummyCycles != 0) {
//     sendDummyCycles(dummyCycles);
//   }

//   spi_trans_s.enable=ENABLE;      
//   spi_trans_s.loopback=DISABLE;   
//   spi_trans_s.txNumBits=SPI_32_BIT_WORD;
//   spi_trans_s.txType=SPI_RX;
  // spi_trans_s.readStart=ENABLE;
//   spi_trans_s.transactions=word_cnt;
//   spi_trans_s.sub=subordinate;

//   spi_c.setCtrl1(&spi_trans_s);
//   spi_c.setCtrl0(&spi_trans_s);

//   for(uint32_t i=0; i<word_cnt; i++) {
//     spi_c.wait4RxFifoNotEmpty();
//     rd_word_ptr[i] = spi_c.readData();
//   }  
//   spi_c.wait4Mst();
//   deselectSub();
// }

/**
 * Write data to the flash in 32 bit words
 * 
 */
void SPI_Master_Interface::writeFlashData(FLASH_CMDS_t cmd, uint32_t address, uint32_t word_cnt, uint32_t* wr_word_ptr)
{
  printf("In 32 bit write data\n");
  spi_c.writeData(address);
  // writeCmd(cmd);
  // writeFlashAddr(address);
  // For ctrl0
  spi_trans_s.enable       = ENABLE;
  spi_trans_s.loopback     = DISABLE;
  spi_trans_s.txNumBits    = SPI_32_BIT_WORD;
  spi_trans_s.txType       = SPI_TX;
  // For ctrl1
  // spi_trans_s.readStart    = DISABLE;
  spi_trans_s.sub          = subordinate;  // Default is SPI_SEL_0
  spi_trans_s.transactions = 0;
  // For flashCtrl0
  // flash_trans_s.cmd        = cmd;
  // flash_trans_s.dummy      = 0;
  // flash_trans_s.rdop       = 0;
  // flash_trans_s.cmdType    = CMD_ADDR3_DUMMY;
  // flash_trans_s.cmdStart   = 1;

  // spi_c.setCtrl1(&spi_trans_s);
  // spi_c.setCtrl0(&spi_trans_s);
  // spi_c.setFlashCtrl0(&flash_trans_s);
  // spi_trans_s.enable=DISABLE;
  // spi_c.wait4Mst();
  // spi_c.setCtrl0(&spi_trans_s);


  // spi_trans_s.enable=ENABLE;      
  // spi_trans_s.loopback=DISABLE;   
  // spi_trans_s.txNumBits=SPI_32_BIT_WORD;
  // spi_trans_s.txType=SPI_TX;
  // spi_trans_s.readStart=DISABLE;
  // spi_trans_s.transactions=0;
  // spi_trans_s.sub=subordinate;

  spi_c.setCtrl1(&spi_trans_s);
  spi_c.setCtrl0(&spi_trans_s);
  // spi_c.setFlashCtrl0(&flash_trans_s);


  for(uint32_t i=0; i<word_cnt; i++) {
    spi_c.wait4TxFifoNotFull();
    spi_c.writeData(wr_word_ptr[i]);
  }  
  spi_c.wait4Mst();
  deselectSub();
}

/**
 * Write data to the flash in bytes
 * 
 */
void SPI_Master_Interface::writeFlashData(FLASH_CMDS_t cmd, uint32_t address, uint32_t byte_cnt, uint8_t* wr_byte_ptr)
{
  printf("In 8 bit write flash data\n");
  writeCmd(cmd);
  writeFlashAddr(address);

  // uint32_t byte_cnt = CMD_S.wbyte_cnt;
  spi_trans_s.enable=ENABLE;      
  spi_trans_s.loopback=DISABLE;   
  spi_trans_s.txNumBits=SPI_08_BIT_WORD;
  spi_trans_s.txType=SPI_TX;
  // spi_trans_s.readStart=DISABLE;
  spi_trans_s.transactions=0;
  spi_trans_s.sub=subordinate;

  spi_c.setCtrl1(&spi_trans_s);
  spi_c.setCtrl0(&spi_trans_s);

  for(uint32_t i=0; i<byte_cnt; i++) {
    spi_c.wait4TxFifoNotFull();
    spi_c.writeData(wr_byte_ptr[i]);
  }  
  spi_c.wait4Mst();
  deselectSub();
}

/**
 * Write data to the flash register
 * 
 */
void SPI_Master_Interface::writeFlashRegister(CMD_STRUCT_t CMD_S)
{
  if (CMD_S.wbyte_cnt == 1) {
    spi_trans_s.txNumBits=SPI_08_BIT_WORD;
  } else {
    spi_trans_s.txNumBits=SPI_16_BIT_WORD;
  }

  // printf("Writing data to flash register\n");
  // For ctrl0
  spi_trans_s.enable=ENABLE;
  spi_trans_s.loopback=DISABLE;
  spi_trans_s.txType=SPI_TX;
  // For ctrl1
  // spi_trans_s.readStart=DISABLE;
  spi_trans_s.sub=subordinate;  // Default is SPI_SEL_0
  spi_trans_s.transactions=0;

  spi_c.writeData(CMD_S.array_ptr[0]); // Write data to TX FIFO
  spi_c.setCtrl1(&spi_trans_s);
  spi_c.setCtrl0(&spi_trans_s);
  // spi_trans_s.enable=DISABLE;
  spi_c.wait4Mst();
  // spi_c.setCtrl0(&spi_trans_s);
}

void SPI_Master_Interface::flashErase(FLASH_CMDS_t cmd, uint32_t addr)
{
  writeCmd(cmd);
  writeFlashAddr(addr);
  deselectSub();
}

/**
 * Write a command to flash. 
 * 
 */
void SPI_Master_Interface::spiCmd(CMD_STRUCT_t CMD_S)
{
  printf("entered spicmd\n");
  writeCmd(CMD_S.cmd);         // Write the flash command
  if (CMD_S.rbyte_cnt > 0) {   // Is data expected back from flash?
    readFlashRegister(CMD_S);          // Then read the flash
  } else if (CMD_S.wbyte_cnt > 0) {
    writeFlashRegister(CMD_S);
  }
  printf("finished spicmd\n");
  // deselectSub();          // deassert the flash chip select
}

/**
 * Write a single command to flash. 
 * Does not deselect the flash
 */
void SPI_Master_Interface::writeCmd(FLASH_CMDS_t cmd)
{
  printf("Writing command to flash\n");
  // For ctrl0
  spi_trans_s.enable       = ENABLE;
  spi_trans_s.loopback     = DISABLE;
  spi_trans_s.txNumBits    = SPI_08_BIT_WORD;
  spi_trans_s.txType       = SPI_TX;
  spi_trans_s.sub          = subordinate;  // Default is SPI_SEL_0
  spi_trans_s.dummy        = 0;
  // For ctrl1
  spi_trans_s.rdStart      = DISABLE;
  spi_trans_s.wrStart      = DISABLE;
  spi_trans_s.flashStart   = ENABLE;
  spi_trans_s.cmd          = cmd;
  spi_trans_s.cmdType      = CMD;
  spi_trans_s.transactions = 1;
  printf("writing to the control\n");
  spi_c.setCtrl0(&spi_trans_s);
  spi_c.setCtrl1(&spi_trans_s);
  spi_trans_s.enable=DISABLE;
  spi_c.wait4Mst();
  spi_c.setCtrl0(&spi_trans_s);
}
// void SPI_Master_Interface::writeCmd(FLASH_CMDS_t cmd)
// {
//   // printf("Writing command to flash\n");
//   // For ctrl0
//   spi_trans_s.enable=ENABLE;
//   spi_trans_s.loopback=DISABLE;
//   spi_trans_s.txNumBits=SPI_08_BIT_WORD;
//   spi_trans_s.txType=SPI_TX;
//   // For ctrl1
  // spi_trans_s.readStart=DISABLE;
//   spi_trans_s.sub=subordinate;  // Default is SPI_SEL_0
//   spi_trans_s.transactions=0;

//   spi_c.writeData(cmd); // Write command to TX FIFO
//   spi_c.setCtrl1(&spi_trans_s);
//   spi_c.setCtrl0(&spi_trans_s);
//   spi_trans_s.enable=DISABLE;
//   spi_c.wait4Mst();
//   spi_c.setCtrl0(&spi_trans_s);
// }

/**
 * Deselect sub. 
 * 
 */
void SPI_Master_Interface::deselectSub()
{
  // printf("Writing command to flash\n");
  spi_trans_s.enable=DISABLE; // Disable SPI 
  spi_trans_s.loopback=DISABLE;
  // For ctrl1
  // spi_trans_s.readStart=DISABLE;
  // spi_trans_s.sub=SPI_SEL_NONE;  // Set slave select to unselect all lines
  spi_trans_s.transactions=0;

  spi_c.setCtrl0(&spi_trans_s);
  spi_c.setCtrl1(&spi_trans_s);

  // return 0;
}

  void SPI_Master_Interface::setAddr4Bytes()
  {
    addr_bytes = 4;
  }
  void SPI_Master_Interface::setAddr3Bytes()
  {
    addr_bytes = 3;
  }

  void SPI_Master_Interface::setTempAddr4Bytes()
  {
    temp_addr_bytes = 4;
  }
  void SPI_Master_Interface::setTempAddr3Bytes()
  {
    temp_addr_bytes = 3;
  }

#endif