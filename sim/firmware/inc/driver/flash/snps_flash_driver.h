
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

#include <stdio.h>
#include <stdlib.h>

#include <flash/spi_flash_types.h>

#ifndef __SNPS_FLASH_DRIVER_INC__
#define __SNPS_FLASH_DRIVER_INC__

class SNPS_FLASH_DRIVER {

  public:

  typedef enum {
    SSEL_0=0,
    SSEL_1=1,
    SSEL_2=2,
    SSEL_3=3,
    SSEL_4=4,
    SSEL_5=5,
  } SSEL_SEL_t;

  private:

  SPI_MODE_t flash_mode = SINGLE_MODE; // Keeps track of the mode the flash is in. 
  volatile uint32_t *sptr;
	uint32_t sdiv;
  uint32_t scph, scpol;
	uint32_t smode;
	uint32_t stype;
  uint32_t trans_type;
	uint32_t dfs;
	uint32_t ssel;
	uint32_t dummy;
  uint32_t ndf = 0;
	uint32_t addr_l = 6;
  uint8_t  id[3];
  uint8_t  vendor;
  uint8_t  win_qpi_dummy = 2;          // Default dummy bits when Winbond is in QPI mode 
  bool     four_byte_mode;             // Tracks if the flash is in four byte addressing mode.
  bool     temp_four_byte = false;     // Allows four byte address commands without changing to four byte mode.
  bool     quad_enabled = false;       // Tracks if the flash has the quad enabled bit set.
  bool     fix_errors = false;

  FLASH_VENDOR_TABLE fvt;

  public:

  SNPS_FLASH_DRIVER(uint32_t addr, uint32_t div, uint32_t ssel_in=0, uint32_t mode=SINGLE_MODE, uint32_t type=TXRX_TYPE, uint32_t bits=8, uint32_t dummy=0) 
	{
  
    sptr = (uint32_t*)GET_PTR_t(addr, 0x100);
		setDiv(div);
    setPolarity(SPI_POLARITY);
    setPhase(SPI_PHASE);
		setMode(mode);
		setType(type);
		setBits(bits);
		setDummyBits(dummy);
		setSsel(ssel_in);
    setAddr_l(SPI_ADDR_LEN_24);
    four_byte_mode = false;
    vendor = -1;
	}


	void printFlashVendor()
  {
    fvt.printFlashVendor(vendor);
  }

	// Helper Functions
	void setMode(uint32_t mode_in)
	{
		smode = SET_MODE(mode_in);  // smode is the same as spi_frf
	}

  void setPolarity(uint32_t polarity)
  {
    scpol = SET_POLARITY(polarity);
  }

  void setPhase(uint32_t phase)
  {
    scph = SET_PHASE(phase);
  }

	void setType(uint32_t type)
	{
		stype = SET_TYPE(type);  // same as tmod. tx/rx
	}

	void setBits(uint32_t bits)
	{
		dfs = SET_BITS(bits);
	}

	void setDummyBits(uint32_t bits)
	{
		dummy = SET_DUMMY(bits);
	}

	void setSsel(uint32_t sel)
	{
		ssel = sel;
	}

	void setTransType(uint32_t ttype_in)
	{
		trans_type = ttype_in;
	}

  void setAddr_l(SPI_ADDR_LEN_t addr_l_in)
  {
    addr_l = addr_l_in<<2;
  }

  void setNdf(uint32_t ndf_in)
  {
    if(ndf_in == 0) ndf = 0;
    else ndf = ndf_in - 1;
  }

	// Status Functions
	void wait4Idle()
	{
		while((rdSpiStatus()&0x1) == 1) continue;
	}


  void usSleep(int us)
  {
    volatile int i, j;
    for(i=0;i<us;i++) {
      for(j=0;j<3;j++);
    }
  }

  //===================================================
  // SSIENR Access - Enable/Disable Register Writes
  //===================================================

  void enableRegWr()
  {
    *(sptr+2) = 0;
  }

  void disableRegWr()
  {
    *(sptr+2) = 1;
  }

  //===================================================
  // BAUDR Access - Enable/Disable Register Writes
  //===================================================
	void setDiv(uint32_t div_in)
	{
    enableRegWr();
    *(sptr+5) = div_in;
    disableRegWr();
	}


  //===================================================
  // CTRL0 Access
  //===================================================
	void wrCtrl0()
	{
    enableRegWr();
		*(sptr) = 0x80000000 | smode | stype | scpol | scph | dfs;
    disableRegWr();
	}

  uint32_t rdCtrl0()
  {
    return *(sptr);
  }

  //===================================================
  // SPI_CTRL0 Access
  //===================================================
	void wrSpiCtrl0()
	{
    enableRegWr();
		*(sptr+61) = dummy | INST_L | addr_l | trans_type;
    disableRegWr();
	}

  uint32_t rdSpiCtrl0()
  {
    return *(sptr+61);
  }


  //===================================================
  // CTRL1 Access - Number of data frames
  //===================================================
	void wrCtrl1()
  {
    enableRegWr();
		*(sptr+1) = ndf;
    disableRegWr();
	}

  uint32_t rdCtrl1()
  {
    return *(sptr+1);
  }

  //===================================================
  // All Ctrl Reg Write 
  //===================================================

  void wrAllCtrl()
  {
    enableRegWr();
    *(sptr)    = 0x80000000 | smode | stype | scpol | scph | dfs;
		*(sptr+1)  = ndf;
    *(sptr+61) = dummy | INST_L | addr_l | trans_type;
    disableRegWr();
	}

  //===================================================
  // Status Access
  //===================================================

  uint32_t rdSpiStatus()
  {
    return *(sptr+10);
  }


  //===================================================
  // SER - Subordinate enable register access
  //===================================================

  void subEnable()
  {
    *(sptr+4) = 1<<ssel;
  }

  void subDisable()
  {
    *(sptr+4) = 0;
  }


  //===================================================
  // FIFO Access
  //===================================================
  void wrSpiFifo(uint32_t data)
  {
    *(sptr+24) = data; 
  }

	uint32_t rdSpiFifo()
	{
		return *(sptr+24);
	}


  //===================================================
  // Transmit and Receive FIFO Level Register Access
  //===================================================
  uint32_t rdTxFifoLevel()
  {
    return *(sptr+8);
  }

	uint32_t rdRxFifoLevel()
	{
		return *(sptr+9);
	}

  //===================================================
  // Transmit and Receive FIFO Level Register Access
  //===================================================
  void fixErrors()
  {
    fix_errors = true;
  }

  void stopFixErrors()
  {
    fix_errors = false;
  }

  //===================================================
  // Access Quad Mode
  //===================================================
  void setQuadMode()
  {
    uint8_t reg[2];
    switch(vendor)
    {
      case FLASH_VENDOR_TABLE::WINBOND:
        rdFlashRegister(FLASH_CMD_WINB_READ_STATUS_REGISTER2, reg);
        reg[0] |= 0x2;
        wrFlashRegister(FLASH_CMD_WINB_WRITE_STATUS_REGISTER2, reg);
        flash_mode = SINGLE_MODE;
        break;
      case FLASH_VENDOR_TABLE::MACRONIX:
        reg[0] = rdFlashStatus();
        reg[0] |= 0x40; 
        wrFlashRegister(FLASH_CMD_WRITE_STATUS_REGISTER, reg);
        flash_mode = SINGLE_MODE;
        break;
      case FLASH_VENDOR_TABLE::MICRON:
        sendFlashCmd(FLASH_CMD_ENTER_QUAD_IO_MODE);
        flash_mode = QUAD_MODE;
        break;
      default:
        printf("***************************************************************\n");
        printf("***WARNING---> Vendor not supported for quad enable.\n");
        printf("***************************************************************\n");
    }
    
    quad_enabled = true;
    printf("Quad mode enabled\n");
  }

  void resetQuadMode()
  {
    uint8_t reg[2];
    setMode(flash_mode);
    switch(vendor)
    {
      case FLASH_VENDOR_TABLE::WINBOND:
        rdFlashRegister(FLASH_CMD_WINB_READ_STATUS_REGISTER2, reg);
        reg[0] &= 0xfd;
        wrFlashRegister(FLASH_CMD_WINB_WRITE_STATUS_REGISTER2, reg);
        break;
      case FLASH_VENDOR_TABLE::MACRONIX:
        reg[0] = rdFlashStatus();
        reg[0] &= 0xbf; 
        wrFlashRegister(FLASH_CMD_WRITE_STATUS_REGISTER, reg);
        break;
      case FLASH_VENDOR_TABLE::MICRON:
        sendFlashCmd(FLASH_CMD_EXIT_QUAD_IO_MODE);
        break;
    }

    printf("Quad mode disabled. Entered single mode.\n");
    flash_mode = SINGLE_MODE;
    quad_enabled = false;
  }



  void enterQpiMode()
  {
    // setMode(SINGLE_MODE);

    switch(vendor)
    {
      case FLASH_VENDOR_TABLE::WINBOND:
        if(!quad_enabled) setQuadMode();
        sendFlashCmd(FLASH_CMD_WINB_ENTER_QPI_MODE);
        flash_mode = QUAD_MODE;
        setReadParams(0x23);
        printf("****->Entered QPI mode for Winbond\n");
        break;
      case FLASH_VENDOR_TABLE::MACRONIX:
        sendFlashCmd(FLASH_CMD_ENTER_QUAD_IO_MODE);
        printf("****->Entered QPI mode for Macronix\n");
        break;
      case FLASH_VENDOR_TABLE::MICRON:
        if(flash_mode != QUAD_MODE) sendFlashCmd(FLASH_CMD_ENTER_QUAD_IO_MODE);
        printf("****->Entered QPI mode for Micron\n");
        break;
      default:
        printf("***************************************************************\n");
        printf("***WARNING---> Vendor not supported for QPI enable.\n");
        printf("***************************************************************\n");
    }

    flash_mode = QUAD_MODE;
  }

  void exitQpiMode()
  {
    uint8_t cmd = (vendor == FLASH_VENDOR_TABLE::WINBOND) ? FLASH_CMD_WINB_EXIT_QPI_MODE : FLASH_CMD_EXIT_QUAD_IO_MODE;
    sendFlashCmd(cmd);
    flash_mode = SINGLE_MODE;
    quad_enabled = false;
  }

  void setReadParams(uint8_t params)
  {
    uint8_t reg[1];
    uint8_t p54 = (params>>4) & 0x3;
    reg[0] = params;

    wrFlashRegister(FLASH_CMD_WINB_SET_READ_PARAMS, reg);

    switch(p54)
    {
      case 0x0:
        win_qpi_dummy = 2;
        break;
      case 0x1:
        win_qpi_dummy = 4;
        break;
      case 0x2:
        win_qpi_dummy = 6;
        break;
      case 0x3:
        win_qpi_dummy = 8;
        break;
      default:
        win_qpi_dummy = 2;
    }
  }


  //===================================================
  // Read ID
  //===================================================
  uint8_t* rdID()
  {
    rdFlashRegister(FLASH_CMD_READ_ID, id, 3);
    printf("Vendor ID: 0x%x%x%x\n", id[0],id[1],id[3]);

    vendor = fvt.getFlashVendor(id);
    switch(vendor)
    {
      case FLASH_VENDOR_TABLE::MICRON:
        setTransType(SPI_TX_ENHANCED_ALL);
        break;
      case FLASH_VENDOR_TABLE::WINBOND:
        setTransType(SPI_TX_STANDARD);
        break;
      case FLASH_VENDOR_TABLE::MACRONIX:
        setTransType(SPI_TX_STANDARD);
        break;
      default:
        setTransType(SPI_TX_STANDARD);
    }
    return id;
  }


  //===================================================
  // Single Commands
  //===================================================
	void resetFlash()
	{
		sendFlashCmd(FLASH_CMD_RESET_ENABLE);
		sendFlashCmd(FLASH_CMD_RESET_MEMORY);
    usSleep(40);
	}

	void setWrEnable()
	{
		sendFlashCmd(FLASH_CMD_WRITE_ENABLE);
	}

  void enter4ByteMode()
  {
    sendFlashCmd(FLASH_CMD_ENTER_4BYTE_ADDR_MODE);
    four_byte_mode = true;
  }

  void exit4ByteMode()
  {
    sendFlashCmd(FLASH_CMD_EXIT_4BYTE_ADDR_MODE);
    four_byte_mode = false;
  }

  void suspendFlashProgramErase()
  {
    sendFlashCmd(FLASH_CMD_SUSPEND_PROG_ERASE);
  }

  void resumeFlashProgramErase()
  {
    sendFlashCmd(FLASH_CMD_SUSPEND_PROG_ERASE);
  }
  
	void sendFlashCmd(uint8_t cmd)
	{
    if (flash_mode == SINGLE_MODE) setTransType(SPI_TX_STANDARD);
    else setTransType(SPI_TX_ENHANCED_ALL);
    setMode(flash_mode);
    setNdf(0);
    setBits(SPI_08_BIT_WORD);
    setType(TX_TYPE);
    setAddr_l(SPI_ADDR_LEN_0);
    setDummyBits(0);
		wrAllCtrl();
		subEnable();
    wrSpiFifo(cmd);
		wait4Idle();
    subDisable();
	}



  //===================================================
  // Flash Register READ Commands
  //===================================================
	uint32_t rdFlashRegister(uint8_t cmd, uint8_t *data, uint32_t trans=1)
	{
    if (flash_mode == SINGLE_MODE)
    {
      setType(TXRX_TYPE);
      setTransType(SPI_TX_STANDARD);
    } else
    {
      setType(RX_TYPE);
      setTransType(SPI_TX_ENHANCED_ALL);
    }
    setMode(flash_mode);
		setBits(SPI_08_BIT_WORD);
    setAddr_l(SPI_ADDR_LEN_0);
    setDummyBits(0);
    setNdf(trans);
		wrAllCtrl();
    wrSpiFifo(cmd);

    if (stype  == TXRX_TYPE)
    {
      // SPI master requires writing a byte for each byte read
      for(uint32_t i=0; i<trans; i++)
      {
        wrSpiFifo(0x1);
      }
    }

    subEnable();
		wait4Idle();
    subDisable();

    if (stype  == TXRX_TYPE)
    {
      // First byte is garbage
      rdSpiFifo();
    }

    for (uint32_t i=0; i<trans; i++)
    {
      data[i] = rdSpiFifo();
    }

    return 0;
	}

  //===================================================
  // Flash READ Commands
  //===================================================
    // Normal
  void rdFlash34Byte(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    if (flash_mode == SINGLE_MODE || !fix_errors)
    {
      uint8_t cmd;
      cmd = (four_byte) ? FLASH_CMD_4BYTE_READ : FLASH_CMD_READ;
      temp_four_byte = four_byte;
      setDummyBits(0);
      rdFlash(cmd, addr, data, trans);
    }
    else
    {
      printf("*************************************************************************************************\n");
      printf("***WARNING---> rdFlash34Byte not supported with the current mode. Directing to rdFlash34ByteFast.\n");
      printf("*************************************************************************************************\n");
      rdFlash34ByteFast(addr, data, trans, four_byte);
    }
  }

  // Single 
  void rdFlash34ByteFast(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    uint8_t cmd;
    cmd = (four_byte) ? FLASH_CMD_4BYTE_FAST_READ : FLASH_CMD_FAST_READ;
    temp_four_byte = four_byte;

    setMode(flash_mode);
    setDummyBits(8);

    if(flash_mode == SINGLE_MODE)
    {
      setTransType(SPI_TX_STANDARD);
      rdFlash(cmd, addr, data, trans);
    } else
    {
      setTransType(SPI_TX_ENHANCED_ALL);
        switch(vendor)
        {
          case FLASH_VENDOR_TABLE::MICRON:
            setDummyBits(10);
            rdFlashEnh(cmd, addr, data, trans);
            break;
          case FLASH_VENDOR_TABLE::WINBOND:
            setDummyBits(win_qpi_dummy);
            if(four_byte && !four_byte_mode)
            {
              printf("***************************************************************\n");
              printf("***WARNING---> Reading with four byte address in QPI Mode      \n");
              printf("***WARNING---> when 4 byte address mode is not enabled.        \n");
              printf("***************************************************************\n");
              if(fix_errors)
              {
                printf("**** Entering 4 byte address mode ****\n");
                enter4ByteMode();
                setDummyBits(win_qpi_dummy);
                rdFlashEnh(cmd, addr, data, trans);
                exit4ByteMode();
                printf("**** Transaction complete. Exited 4 byte address mode *****\n");
              } else rdFlashEnh(cmd, addr, data, trans);
            } else rdFlashEnh(cmd, addr, data, trans);
            break;
          case FLASH_VENDOR_TABLE::MACRONIX:
            cmd = FLASH_CMD_QUAD_IO_FAST_READ;
            setDummyBits(6);
            if(four_byte && !four_byte_mode)
            {
              printf("***************************************************************\n");
              printf("***WARNING---> Reading with four byte address in QPI Mode      \n");
              printf("***WARNING---> when four byte address mode is not enabled.     \n");
              printf("***************************************************************\n");
              if(fix_errors)
              {
                printf("**** Entering 4 byte address mode ****\n");
                enter4ByteMode();
                setDummyBits(6);
                rdFlashEnh(cmd, addr, data, trans);
                exit4ByteMode();
                printf("**** Transaction complete. Exited 4 byte address mode *****\n");
              } else rdFlashEnh(cmd, addr, data, trans);
            } else rdFlashEnh(cmd, addr, data, trans);
            break;
        }
    }
    
  }

  // Dual
  void rdFlash34ByteFastDual(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    bool set_quad = false;
    if(flash_mode==QUAD_MODE)
    {
      printf("***************************************************************\n");
      printf("***WARNING---> Attempting dual read in quad mode.\n");
      printf("***************************************************************\n");
      if(fix_errors)
      {
        printf("***Setting Flash to single mode\n");
        resetQuadMode();
        set_quad = true;
      }
    }

    uint8_t cmd;
    setDummyBits(8);
    setMode(DUAL_MODE);
    cmd = (four_byte) ? FLASH_CMD_4BYTE_DUAL_OUTPUT_FAST_READ : FLASH_CMD_DUAL_OUTPUT_FAST_READ;
    temp_four_byte = four_byte;

    if (flash_mode==DUAL_MODE)
    {
      setTransType(SPI_TX_ENHANCED_ALL);
      rdFlashEnh(cmd, addr, data, trans);
    }
    else if (flash_mode == SINGLE_MODE)
    {
      setTransType(SPI_TX_STANDARD);
      rdFlashEnh(cmd, addr, data, trans);
    }

    if(set_quad)
    {
      setQuadMode(); // Set flash back to quad mode
      printf("*** Set back to quad mode\n");
    }

  }

  // Dual INOUT
  void rdFlash34ByteFastDualInOut(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    bool set_quad = false;

    if(flash_mode==QUAD_MODE)
    {
      printf("****************************************************\n");
      printf("***WARNING---> Attempting dual IO read in quad mode.\n");
      printf("****************************************************\n");
      if(fix_errors)
      {
        printf("***Setting flash to single mode\n");
        resetQuadMode();
        set_quad = true;
      }
    }

    uint8_t cmd;
    if(vendor == FLASH_VENDOR_TABLE::MICRON) setDummyBits(8);
    else setDummyBits(4);
    setMode(DUAL_MODE);
    cmd = (four_byte) ? FLASH_CMD_4BYTE_DUAL_IO_FAST_READ : FLASH_CMD_DUAL_IO_FAST_READ;
    temp_four_byte = four_byte;

    if (flash_mode==DUAL_MODE)
    {
      setTransType(SPI_TX_ENHANCED_ALL);
      rdFlashEnh(cmd, addr, data, trans);
    }
    else if (flash_mode == SINGLE_MODE)
    {
      setTransType(SPI_TX_ENHANCED_ADDR);
      rdFlashEnh(cmd, addr, data, trans);
    }

    if(set_quad)
    {
      setQuadMode(); // Set flash back to quad mode
      printf("*** Set back to quad mode\n");
    }

  }

  // Quad
  void rdFlash34ByteFastQuad(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    bool unset_quad = false;
    uint8_t cmd;

    if(flash_mode == QUAD_MODE)
    {
      setTransType(SPI_TX_ENHANCED_ALL);
      setDummyBits(10);
    } else
    {
      if (quad_enabled != true && vendor != FLASH_VENDOR_TABLE::MICRON)
      {
        printf("******************************************************\n");
        printf("***WARNING---> Quad mode not enabled.                 \n");
        printf("******************************************************\n");

        if(fix_errors)
        {
          setQuadMode();
          printf("****Enabling quad mode.\n");
          unset_quad = true;
        }
      }

      setTransType(SPI_TX_STANDARD);
      setDummyBits(8);
    }

    setMode(QUAD_MODE);
    cmd = (four_byte) ? FLASH_CMD_4BYTE_QUAD_OUTPUT_FAST_READ : FLASH_CMD_QUAD_OUTPUT_FAST_READ;
    temp_four_byte = four_byte;
    rdFlashEnh(cmd, addr, data, trans);

    if(unset_quad)
    {
      resetQuadMode();
      printf("****Disabling quad mode\n");
    }
  }
  
  // Quad INOUT
  void rdFlash34ByteFastQuadInOut(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    uint8_t cmd;
    bool unset_quad = false;

    cmd = (four_byte) ? FLASH_CMD_4BYTE_QUAD_IO_FAST_READ : FLASH_CMD_QUAD_IO_FAST_READ;
    temp_four_byte = four_byte;
    
    if(flash_mode == QUAD_MODE)
    {
      setMode(QUAD_MODE);
      setTransType(SPI_TX_ENHANCED_ALL);
      switch(vendor)
      {
        case FLASH_VENDOR_TABLE::MICRON:
          setDummyBits(10);
          rdFlashEnh(cmd, addr, data, trans);
          break;
        case FLASH_VENDOR_TABLE::WINBOND:
          cmd = FLASH_CMD_QUAD_IO_FAST_READ;
          setDummyBits(win_qpi_dummy);
          if(four_byte && !four_byte_mode)
          {
            printf("*******************************************************************************************\n");
            printf("***WARNING---> Reading with four byte address in QPI Mode while in three byte address mode.\n");
            printf("*******************************************************************************************\n");
            if(fix_errors)
            {
              printf("**** Entering 4 byte address mode ****\n");
              enter4ByteMode();
              setDummyBits(win_qpi_dummy);  // Should be default 2 wait states but model uses 6
              rdFlashEnh(cmd, addr, data, trans);
              exit4ByteMode();
              printf("**** Transaction complete. Exited 4 byte address mode *****\n");
            } else rdFlashEnh(cmd, addr, data, trans);
          }
          break;
        case FLASH_VENDOR_TABLE::MACRONIX:
          setDummyBits(6);
          break;
      }
    } else
    {
      if(vendor == FLASH_VENDOR_TABLE::MICRON)
      {
        setDummyBits(10);
      } else
      {
        if (quad_enabled != true)
        {
          printf("*************************************************\n");
          printf("***WARNING---> Quad mode not enabled.            \n");
          printf("*************************************************\n");
          if(fix_errors)
            {
              printf("**** Entering quad mode ****\n");
              setQuadMode();
            }
        }
        setDummyBits(6); // Documentation shows conflicting dummy cycles of 4 and 6. 6 is the correct number.
      }
      setTransType(SPI_TX_ENHANCED_ADDR);
      setMode(QUAD_MODE);
      rdFlashEnh(cmd, addr, data, trans);
    }
    temp_four_byte = false;
    if(unset_quad)
    {
      printf("****Disabling quad mode\n");
      resetQuadMode();
    }

  }


	void rdFlash(uint8_t cmd, uint32_t addr, uint8_t *data, uint32_t trans)
	{
    uint32_t offset = (four_byte_mode || temp_four_byte) ? 5 : 4;
    if(dummy) offset++;
    uint32_t total_reads = trans + offset;
    uint32_t prefill_bytes = (trans < (SPI_TX_FIFO_SIZE - offset)) ? trans : SPI_TX_FIFO_SIZE - offset;
    uint32_t txflreg, rxflreg;  // tx and rx fifo level register values
    uint32_t rdbytes[trans + offset];
    uint32_t rdcnt = 0;
    uint32_t wrcnt = trans;  // Keeps track of how many words have been written
    uint32_t wrloops;
    uint32_t address = addr;
    uint8_t* address_ptr = (uint8_t *) &address;

    setBits(SPI_08_BIT_WORD);
    setMode(SINGLE_MODE);
    setType(TXRX_TYPE);
		wrAllCtrl();

    /** Write Cmd and Address to FIFO*/
    wrSpiFifo(cmd);
    if (four_byte_mode || temp_four_byte) wrSpiFifo(address_ptr[3]);
    wrSpiFifo(address_ptr[2]);
    wrSpiFifo(address_ptr[1]);
    wrSpiFifo(address_ptr[0]);

    if (dummy) wrSpiFifo(0x1);

    // Prefill the transmit fifo with data to ensure it doesn't run out of words during reads
    for (uint8_t ii = 0; ii < prefill_bytes; ii++)
    {
      wrSpiFifo(0x1);
      wrcnt--;
    }

    subEnable();

    if (prefill_bytes < trans)  // Need to write more bytes to keep read operation going
    {
      do
      {
        rxflreg = rdRxFifoLevel();

        for (uint32_t ii = 0; ii < rxflreg; ii++)
        {
          rdbytes[rdcnt] = rdSpiFifo();
          rdcnt++;
        }

        if (wrcnt > 0)
        {
          txflreg = rdTxFifoLevel();
          wrloops = (wrcnt < (SPI_TX_FIFO_SIZE - txflreg)) ? wrcnt : (SPI_TX_FIFO_SIZE - txflreg);
          for (uint32_t ii = 0; ii < wrloops; ii++)
          {
            wrSpiFifo(0x1);
            wrcnt--;
          }
        }
      } while((wrcnt>0 || (rdcnt<total_reads)));
    } else
    {
      // No more writes are needed. Read data from receive fifo
      do
      {
        rxflreg = rdRxFifoLevel();
        for (uint32_t ii = 0; ii < rxflreg; ii++)
        {
          rdbytes[rdcnt] = rdSpiFifo();
          rdcnt++;
        }
      } while(rdcnt<total_reads);
    }
    wait4Idle();
    subDisable();
    temp_four_byte = false;

    // The words read when transmitting cmd and address are garbage 
    for(uint32_t ii=offset; ii<(trans + offset); ii++)
    {
      data[ii-offset] = rdbytes[ii];
    }
  }

  void rdFlashEnh(uint8_t cmd, uint32_t addr, uint8_t *data, uint32_t trans)
  {
    uint32_t transactions = trans/4;
    if(trans%4) transactions++;
    uint32_t temp[transactions];
    uint32_t rdcnt = 0;
    uint32_t rxflreg;  // rx fifo level register values


    if (four_byte_mode || temp_four_byte) setAddr_l(SPI_ADDR_LEN_32);
    else setAddr_l(SPI_ADDR_LEN_24);

    setBits(SPI_32_BIT_WORD);
    setType(RX_TYPE);
    setNdf(transactions);
		wrAllCtrl();
    wrSpiFifo(cmd);
    wrSpiFifo(addr);
    subEnable();

    do
    {
      rxflreg = rdRxFifoLevel();
      for (uint32_t ii = 0; ii < rxflreg; ii++)
      {
        temp[rdcnt] = rdSpiFifo();
        rdcnt++;
      }
    } while(rdcnt<(transactions)); // While spi master is busy

    subDisable();

    for(uint32_t i=0;i<transactions;i++)
    {
      data[(4*i)]   = temp[i]>>24;
      data[(4*i)+1] = temp[i]>>16;
      data[(4*i)+2] = temp[i]>>8;
      data[(4*i)+3] = temp[i];
    }
    temp_four_byte = false;
  }

  //===================================================
  // Write Register commands
  //===================================================
  void enableQuadMode()
  {
    setQuadMode();
  }

  void disableQuadMode()
  {
    resetQuadMode();
  }

//TODO: Dual mode is supported only by Micron. The Micron model doesn't output volatile 
//      register reads correctly and exiting the dual mode puts the flash into quad mode 
//      even though writing oxff to the volatile enhanced register should put the flash into single mode.

  // void enableDualMode()
  // {
  //   printf("@@vendor: 0x%x\n", vendor);
  //   uint8_t reg[2];
  //   switch(vendor)
  //   {
  //     case FLASH_VENDOR_TABLE::WINBOND:
  //       printf("Dual Mode doesn't exist for Winbond Flash.\n");
  //       break;
  //     case FLASH_VENDOR_TABLE::MACRONIX:
  //       printf("Dual Mode doesn't exist for Macronix Flash.\n");
  //       break;
  //     case FLASH_VENDOR_TABLE::MICRON:
  //       rdFlashRegister(FLASH_CMD_READ_ENHANCED_VOLATILE_CONF, reg);
  //       reg[0] &= 0xbf;
  //       printf("@@reg[0]: 0x%x\n", reg[0]);
  //       wrFlashRegister(FLASH_CMD_WRITE_ENHANCED_VOLATILE_CONF, reg);
  //       flash_mode = DUAL_MODE;
  //       break;
  //   }
  // }
  // void disableDualMode()
  // {
  //   uint8_t reg[2];
  //   switch(vendor)
  //   {
  //     case FLASH_VENDOR_TABLE::WINBOND:
  //       printf("Dual mode not supported by Winbind Flash. Flash is in single mode.\n");
  //       break;
  //     case FLASH_VENDOR_TABLE::MACRONIX:
  //       printf("Dual mode not supported by Macronix Flash. Flash is in single mode.\n");
  //       break;
  //     case FLASH_VENDOR_TABLE::MICRON:
  //       printf("@@flash_mode: 0x%x\n", flash_mode);
  //       rdFlashRegister(FLASH_CMD_READ_ENHANCED_VOLATILE_CONF, reg);
  //       printf("@@reg[0] before: 0x%x\n", reg[0]);
  //       reg[0] = 0xff;
  //       printf("@@reg[0] after: 0x%x\n", reg[0]);
  //       wrFlashRegister(FLASH_CMD_WRITE_ENHANCED_VOLATILE_CONF, reg);
  //       break;
  //   }
  //   flash_mode = SINGLE_MODE;
  // }

  void wrStatusRegister(uint8_t *val)
  {
    uint32_t cnt;
    cnt = (vendor == FLASH_VENDOR_TABLE::WINBOND) ? 2 : 1;
    wrFlashRegister(FLASH_CMD_WRITE_STATUS_REGISTER, val, cnt);
  }

	void wrFlashRegister(uint8_t cmd, uint8_t *data, uint32_t trans=1)
	{
    setNdf(trans);
    setMode(flash_mode);
		setWrEnable();
    setBits(SPI_08_BIT_WORD);
    setType(TX_TYPE);
    setAddr_l(SPI_ADDR_LEN_0);
    setDummyBits(0);
    if (flash_mode == SINGLE_MODE)
    {
      setTransType(SPI_TX_STANDARD);
      subEnable();
      wrSpiFifo(cmd);
      for(uint32_t ii = 0; ii < trans; ii++)
      {
        wrSpiFifo(data[ii]);
      }
      wait4Idle();
      subDisable();
    }
    else
    {
      setTransType(SPI_TX_ENHANCED_ALL);
      wrAllCtrl();
      wrSpiFifo(cmd);
      for(uint32_t ii = 0; ii < trans; ii++)
      {
        wrSpiFifo(data[ii]);
      }
      subEnable();
      wait4Idle();
      subDisable();
    }
		wait4ProgDone();
	}

  uint32_t rdFlashStatus()
  {
		uint8_t status;
    rdFlashRegister(FLASH_CMD_READ_STATUS_REGISTER, &status);
    return status;
  }

	uint32_t wait4ProgDone()
	{
		uint8_t status;
		do {
			status = rdFlashStatus();
		} while(status&1);
		return status;
	}


  //===================================================
  // Program Commands
  //===================================================
  void wrFlash3Byte(uint32_t addr, uint8_t *data, uint32_t trans) 
  {
    setWrEnable();  // During operation sets mode to flash_mode
    if(flash_mode==SINGLE_MODE) wrFlash(FLASH_CMD_PAGE_PROGRAM, addr, data, trans);
    else wrFlashEnh(FLASH_CMD_PAGE_PROGRAM, addr, data, trans);
  }

  void wrFlash4Byte(uint32_t addr, uint8_t *data, uint32_t trans) 
  {
    setWrEnable();  // During operation sets mode to flash_mode 
    temp_four_byte = true;
    if(flash_mode==SINGLE_MODE) wrFlash(FLASH_CMD_4BYTE_PAGE_PROGRAM, addr, data, trans);
    else wrFlashEnh(FLASH_CMD_4BYTE_PAGE_PROGRAM, addr, data, trans);
    temp_four_byte =false;
  }

  void wrFlash34Byte(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false) 
  {
    uint8_t cmd;

    setWrEnable();  // During operation sets mode to flash_mode
    setMode(flash_mode);

    if(flash_mode == QUAD_MODE && vendor != FLASH_VENDOR_TABLE::MICRON && four_byte)
    {
      cmd = FLASH_CMD_PAGE_PROGRAM;

      if(four_byte_mode)
      {
        wrFlashEnh(cmd, addr, data, trans);
      } else
      {
        printf("************************************************************************************************************\n");
        printf("***WARNING---> Four byte address write not valid in QPI mode without putting flash into 4 byte address mode.\n");
        printf("************************************************************************************************************\n");
        if(fix_errors)
        {
          printf("**** Entering 4 byte address mode ****\n");
          enter4ByteMode();
          wrFlashEnh(cmd, addr, data, trans);
          exit4ByteMode();
          printf("**** Transaction complete. Exited 4 byte address mode *****\n");
        }
      }
    } else
    {
      cmd = (four_byte) ? FLASH_CMD_4BYTE_PAGE_PROGRAM : FLASH_CMD_PAGE_PROGRAM;
      temp_four_byte = four_byte;
      if(flash_mode==SINGLE_MODE) wrFlash(cmd, addr, data, trans);
      else wrFlashEnh(cmd, addr, data, trans);
      temp_four_byte =false;
    }

  }

  void wrFlashQuad(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false) 
  {
    uint8_t cmd;
    bool unset_quad = false;

    if(vendor == FLASH_VENDOR_TABLE::MACRONIX) cmd = (four_byte) ? FLASH_CMD_MAC_4BYTE_QUAD_FAST_PROGRAM : FLASH_CMD_MAC_QUAD_INPUT_FAST_PROGRAM;
    else cmd = (four_byte) ? FLASH_CMD_4BYTE_QUAD_FAST_PROGRAM : FLASH_CMD_QUAD_INPUT_FAST_PROGRAM;
    if(flash_mode == QUAD_MODE)
    {
      if(vendor == FLASH_VENDOR_TABLE::MICRON)
      {
        setWrEnable();
        temp_four_byte = four_byte;
        setTransType(SPI_TX_ENHANCED_ALL);
        setMode(QUAD_MODE);
        wrFlashEnh(cmd, addr, data, trans);
        temp_four_byte =false;
      }
      else
      {
        printf("******************************************************\n");
        printf("***WARNING---> Quad write not valid in QPI mode.      \n");
        printf("******************************************************\n");
        if(fix_errors)
        {
          printf("****Invoking wrFlash34Byte.\n");
          wrFlash34Byte(addr, data, trans, four_byte);
        }
      }
    }
    else
    {
      if (quad_enabled != true && vendor !=FLASH_VENDOR_TABLE::MICRON)
      {
        printf("***************************************************************\n");
        printf("***WARNING---> Quad mode not enabled. Enabling quad mode.\n");
        printf("***************************************************************\n");
        if(fix_errors)
        {
          printf("****Enabling quad mode.\n");
          setQuadMode();
        }
      }
      setWrEnable();

      if(vendor == FLASH_VENDOR_TABLE::MACRONIX) setTransType(SPI_TX_ENHANCED_ADDR);
      else setTransType(SPI_TX_STANDARD);
      temp_four_byte = four_byte;
      setMode(QUAD_MODE);
      wrFlashEnh(cmd, addr, data, trans);
      temp_four_byte =false;
      if(unset_quad)
      {
        printf("****Disabling quad mode\n");
        resetQuadMode();
      }
    }
  }

	void wrFlash(uint8_t cmd, uint32_t addr, uint8_t *data, uint32_t trans)
	{
    uint32_t offset = (four_byte_mode || temp_four_byte) ? 5 : 4;
    uint32_t prefill_bytes = (trans < (SPI_TX_FIFO_SIZE - offset)) ? trans : SPI_TX_FIFO_SIZE - offset;
    uint32_t txflreg;  // tx fifo level register values
    uint32_t address = addr;
    uint8_t* address_ptr = (uint8_t *) &address;

    setBits(SPI_08_BIT_WORD);
    setMode(SINGLE_MODE); //TODO: REMOVE: remove and test
    setType(TX_TYPE);
		wrAllCtrl();
    /** Write Cmd and Address to FIFO*/
    wrSpiFifo(cmd);
    if (four_byte_mode || temp_four_byte) wrSpiFifo(address_ptr[3]);
    wrSpiFifo(address_ptr[2]);
    wrSpiFifo(address_ptr[1]);
    wrSpiFifo(address_ptr[0]);

    // Prefill the transmit fifo with data to ensure it doesn't run out of data during writes
    for (uint8_t ii = 0; ii < prefill_bytes; ii++)
    {
      wrSpiFifo(data[ii]);
    }

    subEnable();
    if (prefill_bytes < trans)
    {
      uint32_t wrloops;
      uint32_t wrcnt = prefill_bytes;
      uint32_t bytes_left = trans - prefill_bytes;
      do
      {
        txflreg = rdTxFifoLevel();
        wrloops = (bytes_left < (SPI_TX_FIFO_SIZE - txflreg)) ? bytes_left : (SPI_TX_FIFO_SIZE - txflreg);
        for (uint32_t ii = 0; ii < wrloops; ii++)
          {
            wrSpiFifo(data[wrcnt]);
            wrcnt++;
          }
        bytes_left = trans - wrcnt;
      } while(wrcnt < trans);
    }

    wait4Idle();
    subDisable();
	}


	void wrFlashEnh(uint8_t cmd, uint32_t addr, uint8_t *data, uint32_t trans)
	{
    uint32_t prefill_bytes = (trans < (SPI_TX_FIFO_SIZE - 2)) ? trans : SPI_TX_FIFO_SIZE - 2;
    uint32_t txflreg;  // tx fifo level register values

    if (four_byte_mode || temp_four_byte) setAddr_l(SPI_ADDR_LEN_32);
    else setAddr_l(SPI_ADDR_LEN_24);
    setBits(SPI_08_BIT_WORD);
    setType(TX_TYPE);
		wrAllCtrl();
    wrSpiFifo(cmd);
    wrSpiFifo(addr);

    // Prefill the transmit fifo with data to ensure it doesn't run out of bytes during writes
    for (uint8_t ii = 0; ii < prefill_bytes; ii++)
    {
      wrSpiFifo(data[ii]);
    }

    subEnable();

    if (prefill_bytes < trans)
    {
      uint32_t wrloops;
      uint32_t wrcnt = prefill_bytes;
      uint32_t bytes_left = trans - prefill_bytes;
      do
      {
        txflreg = rdTxFifoLevel();
        wrloops = (bytes_left < (SPI_TX_FIFO_SIZE - txflreg)) ? bytes_left : (SPI_TX_FIFO_SIZE - txflreg);
        for (uint32_t ii = 0; ii < wrloops; ii++)
          {
            wrSpiFifo(data[wrcnt]);
            wrcnt++;
          }
        bytes_left = trans - wrcnt;
      } while(wrcnt < trans);
    }

    wait4Idle();
    subDisable();
	}


  //===================================================
  // Flash Erase
  //===================================================
	void flash4KSubSectorErase(uint32_t addr)
	{
		flashErase(addr, FLASH_CMD_ERASE_4KB_SUBSECTOR);
	}

	void flash4Byte4KSubSectorErase(uint32_t addr)
	{
		flashErase(addr, FLASH_CMD_4BYTE_ERASE_4KB_SUBSECTOR, true);
	}

	void flash32KSubSectorErase(uint32_t addr)
	{
		flashErase(addr, FLASH_CMD_ERASE_32KB_SUBSECTOR);
	}

	void flashSectorErase(uint32_t addr)
	{
		flashErase(addr, FLASH_CMD_ERASE_SECTOR);
	}

	void flash4ByteSectorErase(uint32_t addr)
	{
		flashErase(addr, FLASH_CMD_4BYTE_ERASE_SECTOR, true);
	}

	void flashSectorChip(uint32_t addr)
	{
		flashErase(addr, FLASH_CMD_BULK_ERASE);
	}


	void flashErase(uint32_t addr, uint32_t cmd, bool four_byte=false)
	{

    setWrEnable();
    uint32_t address = addr;
    uint8_t* address_ptr = (uint8_t *) &address;

    setBits(SPI_08_BIT_WORD);
    setMode(flash_mode);
    setType(TX_TYPE);

    if (four_byte) setNdf(4);
    else setNdf(3);
		wrAllCtrl();

    if (flash_mode == SINGLE_MODE)
    {
      subEnable();
      wrSpiFifo(cmd);
      if (four_byte) wrSpiFifo(address_ptr[3]);
      wrSpiFifo(address_ptr[2]);
      wrSpiFifo(address_ptr[1]);
      wrSpiFifo(address_ptr[0]);
    } else
    {
      wrSpiFifo(cmd);
      if (four_byte) wrSpiFifo(address_ptr[3]);
      wrSpiFifo(address_ptr[2]);
      wrSpiFifo(address_ptr[1]);
      wrSpiFifo(address_ptr[0]);
      subEnable();
    }
		wait4Idle();
    subDisable();
		wait4ProgDone();
	}


  //===================================================
  // Utilities
  //===================================================
  int eraseCheck(int cnt, uint8_t *act)
  {
    int error = 0;

    printf("Checking Erased Array\n");
    for(int i=0;i<cnt;i++) {
      if(act[i] != 0xff) {
        printf("Error...%d: EXP(0xff) ACT(0x%02x)\n", i, act[i]);
        error++;
      }
    }
    if(error == 0) {
      printf("    Erase Check Passed\n");
    }
    return error;
  }

};

#endif
