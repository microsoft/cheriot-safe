
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

#include <inttypes.h>
// #include <spi_reg.h> 
#include <stdlib.h>
#include "spi_types.h"
#include <stdio.h>

#ifndef __SPI_INC_H__
#define __SPI_INC_H__

#ifdef __cplusplus
extern "C" {
#endif


//===========
// Prototypes
//===========
// To customize SPI_BASE_C class definition from <spi_types.h> include
class msftDvIp_spi_c {
  // volatile uint32_t * m_SPI_PTR = (uint32_t*)SPI_BASE_ADDR;
  // volatile uint32_t * ptr {nullptr};
  volatile REGS_SPI *m_SPI_PTR {nullptr};
  
  private:

  public:
    msftDvIp_spi_c ()                    {}
    msftDvIp_spi_c (const uint32_t addr) {setAddr(addr);}
    void     setAddr            (const uint32_t addr) {m_SPI_PTR = (REGS_SPI*) addr;}
    uint32_t readData           ();
    uint32_t writeData          (uint32_t wdata);
    uint32_t wait4Mst           ();
    uint32_t readStatus         ();
    uint32_t loopback           ();
    uint32_t txFifoFull         ();
    uint32_t txFifoEmpty        ();
    uint32_t txFifoCnt          ();
    uint32_t rxFifoFull         ();
    uint32_t rxFifoEmpty        ();
    void     wait4TxFifoNotFull ();
    void     wait4RxFifoNotEmpty();
    void     rxFifoCnt          ();
    uint32_t setCtrl0           (SPI_TRANS_STRUCT_t *spi_trans_s_ptr);
    uint32_t setCtrl1           (SPI_TRANS_STRUCT_t *spi_trans_s_ptr);
    void     setInterruptEnable (uint32_t wdata);
    uint32_t wait4TXDone        ();
};

// ===========
// Definitions
// ===========
//
// spiSetCtrl0
uint32_t msftDvIp_spi_c::setCtrl0(SPI_TRANS_STRUCT_t *spi_trans_s_ptr)
{
  // printf("[msftDvIp_spi_c::setCtrl0()]\n");
  uint32_t ctrl0;

  ctrl0 =
    ((spi_trans_s_ptr->enable  )                              |
    (spi_trans_s_ptr->loopback ) <<  CTRL0_LOOPBACK_OFFSET    | // 
    (spi_trans_s_ptr->spiMode  ) <<  CTRL0_MODE_OFFSET        | // 
    (spi_trans_s_ptr->txNumBits) <<  CTRL0_BITS_OFFSET        | // 
    (spi_trans_s_ptr->txType   ) <<  CTRL0_TXTYPE_OFFSET      | // 
    (spi_trans_s_ptr->sub      ) <<  CTRL0_SUB_SEL_OFFSET     | // 
    (spi_trans_s_ptr->dummy    ) <<  CTRL0_DUMMY_OFFSET       | // 
    (spi_trans_s_ptr->clkDiv   ) <<  CTRL0_CLKDIV_OFFSET);    //
  printf("CTRL0 A:0x%08x D:0x%08x\n", &m_SPI_PTR->CTRL0, ctrl0);
  hw_write32((uint32_t*)&m_SPI_PTR->CTRL0, ctrl0);

  return 0;
}

// spiSetCtrl1
uint32_t msftDvIp_spi_c::setCtrl1(SPI_TRANS_STRUCT_t *spi_trans_s_ptr)
{
    // printf("[msftDvIp_spi_c::setCtrl1()]\n");
    uint32_t ctrl1;

    ctrl1 =
        ((spi_trans_s_ptr->rdStart     )                                 |
         (spi_trans_s_ptr->wrStart     ) <<  CTRL1_WRITE_START_OFFSET    |    //
         (spi_trans_s_ptr->flashStart  ) <<  CTRL1_FLASH_START_OFFSET    |    //
         (spi_trans_s_ptr->cmd         ) <<  CTRL1_CMD_OFFSET            |    //
         (spi_trans_s_ptr->cmdType     ) <<  CTRL1_CMDTYPE_OFFSET        |    //
         (spi_trans_s_ptr->transactions) <<  CTRL1_TRANSACTIONS_OFFSET);      //
    printf("CTRL1 A:0x%08x D:0x%08x\n", &m_SPI_PTR->CTRL1, ctrl1);
    hw_write32((uint32_t*)&m_SPI_PTR->CTRL1, ctrl1);

    return 0;
}


void msftDvIp_spi_c::setInterruptEnable(uint32_t wdata)
{
   hw_write32((uint32_t *) &m_SPI_PTR->INTEN, wdata);
}


// txFifoCnt
uint32_t msftDvIp_spi_c::txFifoCnt()
{
  // printf("[TX FIFO Count]\n");
  uint32_t status;
  uint32_t count;

  status = hw_read32((uint32_t*)&(m_SPI_PTR->STATUS));
  // printf("status is: 0x%08x\n", status);
  count = status >> SPI_MST_TX_FIFO_CNT_OFFSET & 0x1f;
  // printf("count is: 0x%d\n", count);

  return count;
    // return status >> SPI_MST_TX_FIFO_FULL & 0x1;
}

// txFifoFull
uint32_t msftDvIp_spi_c::txFifoFull()
{
  // printf("[TX FIFO Full?]\n");
  uint32_t status;
  uint32_t full;

  status = hw_read32((uint32_t*)&(m_SPI_PTR->STATUS));
  // printf("txFifoFull: status is: 0x%08x\n", status);
  full = status >> SPI_MST_TX_FIFO_FULL_OFFSET & 0x1;
  // printf("txFifoFull: full is: 0x%08x\n", full);
    

  return full;
    // return status >> SPI_MST_TX_FIFO_FULL & 0x1;
}

// txFifoEmpty
uint32_t msftDvIp_spi_c::txFifoEmpty()
{
  // printf("[TX FIFO Empty?]\n");
  uint32_t status;
  uint32_t rval;

  status = hw_read32((uint32_t*)&(m_SPI_PTR->STATUS));
  // printf("status is: 0x%08x\n", status);
  rval = status >> SPI_MST_TX_FIFO_EMPTY_OFFSET & 0x1;
  // printf("rval is: 0x%08x\n", rval);
    

  return rval;
}

// rxFifoFull
uint32_t msftDvIp_spi_c::rxFifoFull()
{
  // printf("[RX FIFO Full?]\n");
  uint32_t status;
  uint32_t rval;

  status = hw_read32((uint32_t*)&(m_SPI_PTR->STATUS));
  // printf("status is: 0x%08x\n", status);
  rval = status >> SPI_MST_RX_FIFO_FULL_OFFSET & 0x1;
  // printf("rval is: 0x%08x\n", rval);
    

  return rval;
}

// rxFifoEmpty
uint32_t msftDvIp_spi_c::rxFifoEmpty()
{
  printf("[RX FIFO Empty?]\n");
  uint32_t status;
  uint32_t rval;

  status = hw_read32((uint32_t*)&(m_SPI_PTR->STATUS));
  // printf("status is: 0x%08x\n", status);
  rval = status >> SPI_MST_RX_FIFO_EMPTY_OFFSET & 0x1;
  // printf("rval is: 0x%08x\n", rval);
    

  return rval;
}

// rxFifoCnt
// uint32_t msftDvIp_spi_c::rxFifoCnt()
void msftDvIp_spi_c::rxFifoCnt()
{
  printf("[RX FIFO Count]\n");
  uint32_t status;
  uint32_t count;

  status = hw_read32((uint32_t*)&(m_SPI_PTR->STATUS));
  // printf("status is: 0x%08x\n", status);
  count = status >> SPI_MST_RX_FIFO_CNT_OFFSET & 0x1f;
  printf("rx fifo count is: 0x%d\n", count);

  // return count;
}

// spiReadData
uint32_t msftDvIp_spi_c::readData()
{
  // printf("[Read SPI master RX FIFO]\n");
  // uint32_t status;
  uint32_t rdata;

  // if (rxFifoEmpty()) {
  //   printf("RX FIFO is Empty, returning 0");
  //   rdata = 0;
  // } else {
    rdata = hw_read32((uint32_t*)&(m_SPI_PTR->FIFO));
    // printf("RX Fifo   :0x%08x\n", rdata);
  // }

  return rdata;
}

// spiLoopback
uint32_t msftDvIp_spi_c::loopback()
{
  printf("[Loopback test]\n");
  uint32_t loopback_cmd = SPI_MST_TX_ENABLE | SPI_MST_TX_LOOPBACK | SPI_MST_TX_32_BITS;

  // do { // Before writing, wait for Tx FIFO not to be full
  //     status = hw_read32((uint32_t*)&m_SPI_PTR->STATUS);
  // } while(((status >> SPI_MST_TX_FIFO_FULL_OFFSET) & 0x1) == 1); //  Master RX FIFO Not empty
  hw_write32((uint32_t*)&m_SPI_PTR->CTRL0, loopback_cmd);
  // // printf("to address :0x%08x\n", m_SPI_PTR->FIFO);
  printf("Done loopback\n");

  return 0;
}

// spiWriteData
uint32_t msftDvIp_spi_c::writeData(uint32_t wdata)
{
  // printf("[Write SPI master TX FIFO]\n");
  uint32_t status;

  do 
  { // Before writing, wait for Tx FIFO not to be full
    status = hw_read32((uint32_t*)&m_SPI_PTR->STATUS);
  } while(((status >> SPI_MST_TX_FIFO_FULL_OFFSET) & 0x1) == 1); //wait while Master TX FIFO full
  hw_write32((uint32_t*)&m_SPI_PTR->FIFO, wdata);
  // printf("TX Fifo wrote :0x%08x\n", wdata);

  return 0;
}

// wait4Mst
uint32_t msftDvIp_spi_c::wait4Mst()
{
    // printf("[msftDvIp_spi_c::wait4Mst()]\n");
    uint32_t status;

    do { // Read the status register
        status = hw_read32((uint32_t*)&m_SPI_PTR->STATUS);
    } while (!((status >> SPI_MST_STATUS_IDLE_OFFSET) & 0x1)); // 
    printf("STATUS is: 0x%08x\n", status);

    return 0;
}

// Wait until the transmit fifo is not full
void msftDvIp_spi_c::wait4TxFifoNotFull()
{
    // printf("[msftDvIp_spi_c::wait4TxFifoNotFull()]\n");
    uint32_t status;

    do { // Read the status register
        status = hw_read32((uint32_t*)&m_SPI_PTR->STATUS);
    } while ((status >> SPI_MST_TX_FIFO_FULL_OFFSET) & 0x1); // 
    // printf("STATUS is: 0x%08x\n", status);

    // return 0;
}

// wait4Mst
void msftDvIp_spi_c::wait4RxFifoNotEmpty()
{
    // printf("[msftDvIp_spi_c::wait4RxFifoNotEmpty()]\n");
    uint32_t status;

    do { // Read the status register
        status = hw_read32((uint32_t*)&m_SPI_PTR->STATUS);
    } while ((status >> SPI_MST_RX_FIFO_EMPTY_OFFSET) & 0x1); // 
    // printf("STATUS is: 0x%08x\n", status);

    // return 0;
}

// readStatus
uint32_t msftDvIp_spi_c::readStatus()
{
  // printf("[msftDvIp_spi_c::readStatus()]\n");
  uint32_t status;

  status = hw_read32((uint32_t*)&m_SPI_PTR->STATUS);
  printf("STATUS is: 0x%08x\n", status);

  return 0;
}

//
// spiWait4TXDone
uint32_t msftDvIp_spi_c::wait4TXDone()
{
    // hsp_msg_high("[msftDvIp_spi_c::wait4TXDone()]\n");
    // printf("[msftDvIp_spi_c::spiWait4TXDone()]\n");
    uint32_t sr;  // status register 

    do { // Wait for SPI to finish transmitting
        sr = hw_read32((uint32_t*)&m_SPI_PTR->STATUS);
    } while(((sr >> SPI_MST_IDLE_BIT_OFFSET) & 0x1) == 0 || ((sr >> SPI_MST_TX_FIFO_EMPTY_OFFSET) & 0x1) == 0); // Loop while SPI is 'Not' Idle or Transmit FIFO 'Not' Empty
    return 0;
}

#ifdef __cplusplus
}
#endif

#endif
