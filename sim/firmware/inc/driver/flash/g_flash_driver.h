
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

#include <flash/flash_base_vendor.h>

#ifndef __G_FLASH_DRIVER_INC__
#define __G_FLASH_DRIVER_INC__

class FLASH_VENDOR_TABLE {
  public:
  #define VENDORS   3


  typedef enum {
    VENDOR_MICRON=0x20,
    VENDOR_WINBOND=0xEF,
    VENDOR_MACRONIX=0xC2,
  } FLASH_VENDOR_t;

  typedef enum {
    MEM_3p3V=0xba,
    MEM_1p8Volt=0xbb,
  } MEM_VOLTAGE_t;

  typedef enum {
    MEM_CAP_2Gb=0x22,
    MEM_CAP_1Gb=0x21,
    MEM_CAP_512Mb=0x20,
    MEM_CAP_256Mb=0x19,
    MEM_CAP_128Mb=0x18,
    MEM_CAP_064Mb=0x17,
  } MEM_CAP_t;

  typedef struct {
    uint8_t mfg_id;
    uint8_t mem_type;
    uint8_t mem_capacity;
    uint8_t remaining;
    uint8_t ext_id;
    uint8_t dev_conf;
    uint8_t factory_data[14]; 
    const char * vendor;
  } FLASH_ID_t;

  FLASH_ID_t flash_id[VENDORS];
  FLASH_ID_t *vptr;

  FLASH_VENDOR_TABLE()
  {
    flash_id[0] = { VENDOR_MICRON,   MEM_3p3V, MEM_CAP_256Mb, 0x10, 0x40, 0x00, 0x76, 0x98, 0xba, 0xdc, 0xfe, 0x1f, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe, 0x10, "Micron FLASH 256Mb Memory"};
    flash_id[1] = { VENDOR_WINBOND,  0x70,     MEM_CAP_256Mb, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, "Winbond FLASH 256Mb Memory"};
    flash_id[2] = { VENDOR_MACRONIX, 0x20,     MEM_CAP_256Mb, 0xc2, 0x20, 0x19, 0xc2, 0x20, 0x19, 0xc2, 0x20, 0x19, 0xc2, 0x20, 0x19, 0xc2, 0x20, 0x19, 0xc2, 0x20, "Macronix FLASH 256Mb Memory"};
    vptr = NULL;
  }

  int getFlashVendor(uint8_t *varray)
  {
    int ret_vendor = -1;
    for(int i=0;i<VENDORS;i++) {
      if(varray[0] == flash_id[i].mfg_id) {
        ret_vendor = varray[0];
        vptr = flash_id+i;
        break;
      }
    }
    printFlashVendor(ret_vendor);
    return ret_vendor;
  }

  void printFlashVendor(int vendor)
  {
    if(vptr == NULL) {
      printf("FLASH VENDOR: Unknown\n");
    } else {
      printf("FLASH VENDOR: %s\n", vptr->vendor);
    }
  }
  
};

class G_FLASH_DRIVER {

	public:

	typedef enum {
		SINGLE_MODE=0,
		DUAL_MODE=1,
		QUAD_MODE=2,
	} SPI_MODE_t;

	typedef enum {
		TXRX_TYPE=0,
		RX_TYPE=1,
		TX_TYPE=2,
	} SPI_TYPE_t;

  typedef enum {
    SPI_TRANS=1,
    SPI_FLASH_CMD_ONLY=2,
    SPI_FLASH_CMD_RD=3,
    SPI_FLASH_CMD_ADDR3_RD=4,
    SPI_FLASH_CMD_ADDR4_RD=5,
    SPI_FLASH_CMD_ADDR3_DUMMY_RD=6,
    SPI_FLASH_CMD_ADDR4_DUMMY_RD=7,
    SPI_FLASH_CMD_WR=8,
    SPI_FLASH_CMD_ADDR3_WR=10,
    SPI_FLASH_CMD_ADDR4_WR=11,
  } SPI_TRANS_t;

	#define SET_MODE(mode)					(mode<<2)
	#define SET_BITS(bits)   				(((bits-1)&0x1f)<<4)
	#define SET_TYPE(type)      		((type<<9))
	#define SET_SSEL(ssel)			  	((ssel)<<11)
	#define SET_DUMMY(dum)					((dum)<<14)
	#define SET_DIV(div)						((div)<<20)

  #define SET_FCMD_MODE           (1<<4)
  #define SET_FADDR_MODE          (1<<5)
	#define SET_CNT(cnt)						(cnt<<13)

  #define FLASH_4BYTE_MODE        true

  typedef enum {
    SSEL_0=0,
    SSEL_1=1,
    SSEL_2=2,
    SSEL_3=3,
    SSEL_4=4,
    SSEL_5=5,
  } SSEL_SEL_t;

	typedef enum {
		CMD_ONLY=0,
		CMD_ADDR3=2,
		CMD_ADDR4=3,
	} CMD_TYPE_t;

	private:
	volatile uint32_t *sptr;
	uint32_t sdiv;
	uint32_t smode;
  uint32_t smode_save;
	uint32_t stype;
	uint32_t sbits;
	uint32_t ssel;
	uint32_t dummy;
  uint32_t fcmd_mode;
  uint32_t faddr_mode;
  uint8_t  id[20];
  uint8_t  vendor;
  uint32_t fmode;
  bool     quad_mode;
  bool     four_byte_mode;

  FLASH_VENDOR_TABLE fvt;

	public:
	G_FLASH_DRIVER(uint32_t addr, uint32_t div, uint32_t ssel_in=0, uint32_t mode=SINGLE_MODE, uint32_t type=TXRX_TYPE, uint32_t bits=32, uint32_t dummy=8) 
	{
  
    sptr = (uint32_t*)GET_PTR_t(addr, 0x100);
		setDiv(div);
		setMode(mode);
		setType(type);
		setBits(bits);
		setDummyBits(dummy);
		setSsel(ssel_in);
    quad_mode = false;
    fmode = 0;
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
		smode = SET_MODE(mode_in);
	}

	void setDiv(uint32_t div_in)
	{
		sdiv = SET_DIV(div_in);
	}

	void setType(uint32_t type)
	{
		stype = SET_TYPE(type);
	}

	void setBits(uint32_t bits)
	{
		sbits = SET_BITS(bits);
	}

	void setDummyBits(uint32_t bits)
	{
		dummy = SET_DUMMY(bits-1);
	}

	void setSsel(uint32_t sel)
	{
		ssel = SET_SSEL(sel);
	}

	// Status Functions
	void wait4Idle()
	{
		while((rdSpiStatus()&0x8000) == 0) continue;
	}

  void usSleep(int us)
  {
    volatile int i, j;
    for(i=0;i<us;i++) {
      for(j=0;j<3;j++);
    }
  }

  //===================================================
  // CTRL0 Access
  //===================================================
	void wrCtrl0()
	{
		*(sptr+0) = sdiv | dummy | ssel | stype | sbits | smode | 1;
	}

  uint32_t rdCtrl0()
  {
    return *(sptr+1);
  }

  void clrCtrl0()
  {
    *(sptr+0) = 0;
  }

  //===================================================
  // CTRL1 Access
  //===================================================
	void wrCtrl1(uint8_t op, uint32_t cnt=0) {
		*(sptr+1) = SET_CNT(cnt) | fmode | op;
    fmode = 0;
	}
 
  uint32_t rdCtrl1()
  {
    return *(sptr+1);
  }

  //===================================================
  // Status Access
  //===================================================
  void wrSpiStatus(uint32_t data)
  {
    *(sptr+3) = data; 
  }

  uint32_t rdSpiStatus()
  {
    return *(sptr+3);
  }

  //===================================================
  // FIFO Access
  //===================================================
  void wrSpiFifo(uint32_t data)
  {
    *(sptr+4) = data; 
  }

	uint32_t rdSpiFifo()
	{
		return *(sptr+4);
	}

  //===================================================
  // Access Quad Mode
  //===================================================
  void setQuadMode()
  {
    setMode(SINGLE_MODE);
    uint8_t cmd = (vendor == FLASH_VENDOR_TABLE::VENDOR_WINBOND) ? FLASH_CMD_WINB_ENTER_QPI_MODE : FLASH_CMD_ENTER_QUAD_IO_MODE;
    sendFlashCmd(cmd);
    //if(vendor != FLASH_VENDOR_TABLE::VENDOR_WINBOND) quad_mode = true;
    quad_mode = true;
  }

  void resetQuadMode()
  {
    setMode(QUAD_MODE);
    uint8_t cmd = (vendor == FLASH_VENDOR_TABLE::VENDOR_WINBOND) ? FLASH_CMD_WINB_EXIT_QPI_MODE : FLASH_CMD_EXIT_QUAD_IO_MODE;
    sendFlashCmd(cmd);
    quad_mode = false;
  }

  //===================================================
  // Read ID
  //===================================================
  uint8_t * rdID()
  {
    setMode(SINGLE_MODE);
	  rdFlashRegister(FLASH_CMD_READ_ID, id, 20);

    vendor = fvt.getFlashVendor(id);
    return id;
  }

  void setCurrentMode()
  {
    uint32_t mode;
    if(quad_mode) mode = QUAD_MODE; else mode = SINGLE_MODE;
    setMode(mode);
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
    setCurrentMode();
		sendFlashCmd(FLASH_CMD_WRITE_ENABLE);
	}

  void enter4ByteMode()
  {
    setCurrentMode();
    sendFlashCmd(FLASH_CMD_ENTER_4BYTE_ADDR_MODE);
    four_byte_mode = true;
  }

  void exit4ByteMode()
  {
    setCurrentMode();
    sendFlashCmd(FLASH_CMD_EXIT_4BYTE_ADDR_MODE);
    four_byte_mode = false;
  }

  void suspendFlashProgramErase()
  {
    setCurrentMode();
    sendFlashCmd(FLASH_CMD_SUSPEND_PROG_ERASE);
  }

  void resumeFlashProgramErase()
  {
    setCurrentMode();
    sendFlashCmd(FLASH_CMD_SUSPEND_PROG_ERASE);
  }

	void sendFlashCmd(uint8_t cmd)
	{
		// Single Command doesn't care about normal ctrl0 changes
		wrCtrl0();
    wrSpiFifo(cmd);
		wrCtrl1(SPI_FLASH_CMD_ONLY);
		wait4Idle();
	}

  //===================================================
  // Flash Register READ Commands
  //===================================================
	uint32_t rdFlashRegister(uint8_t cmd, uint8_t *data, uint32_t trans=1)
	{
		setBits(8);
		wrCtrl0();
    wrSpiFifo(cmd);
		wrCtrl1(SPI_FLASH_CMD_RD, trans);
		uint32_t cnt = 0;
		do {
			if((rdSpiStatus()&0x10000) == 0) {
				data[cnt++] = rdSpiFifo();
			}
		} while(cnt < trans);
		wait4Idle();
		return 0;
	}

  //===================================================
  // Flash READ Commands
  //===================================================
  // Normal
  void rdFlash34Byte(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    uint32_t op;
    uint32_t cmd;
    setMode(SINGLE_MODE);
    op = (four_byte_mode || four_byte) ? SPI_FLASH_CMD_ADDR4_RD : SPI_FLASH_CMD_ADDR3_RD;
    cmd = (four_byte) ? FLASH_CMD_4BYTE_READ : FLASH_CMD_READ;
    rdFlash(op, cmd, addr, data, trans);
  }

  // Single 
  void rdFlash34ByteFast(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    uint32_t op;
    uint32_t cmd;
    if(quad_mode) setMode(QUAD_MODE); else setMode(SINGLE_MODE); 
    if(quad_mode) setDummyBits(10); else setDummyBits(8); 
    op = (four_byte_mode || four_byte) ? SPI_FLASH_CMD_ADDR4_DUMMY_RD : SPI_FLASH_CMD_ADDR3_DUMMY_RD;
    cmd = (four_byte) ? FLASH_CMD_4BYTE_FAST_READ : FLASH_CMD_FAST_READ;
    rdFlash(op, cmd, addr, data, trans);
  }

  // Dual
  void rdFlash34ByteFastDual(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    uint32_t op;
    uint32_t cmd;
    setDummyBits(8);
    setMode(DUAL_MODE);
    op = (four_byte_mode || four_byte) ? SPI_FLASH_CMD_ADDR4_DUMMY_RD : SPI_FLASH_CMD_ADDR3_DUMMY_RD;
    cmd = (four_byte) ? FLASH_CMD_4BYTE_DUAL_OUTPUT_FAST_READ : FLASH_CMD_DUAL_OUTPUT_FAST_READ;
    fmode = SET_FCMD_MODE | SET_FADDR_MODE;
    rdFlash(op, cmd, addr, data, trans);
  }

  // Dual INOUT
  void rdFlash34ByteFastDualInOut(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    uint32_t op;
    uint32_t cmd;
    setDummyBits(8);
    setMode(DUAL_MODE);
    op = (four_byte_mode || four_byte) ? SPI_FLASH_CMD_ADDR4_DUMMY_RD : SPI_FLASH_CMD_ADDR3_DUMMY_RD;
    //TODO: change command below to FLASH_CMD_DUAL_IO_FAST_READ
    cmd = (four_byte) ? FLASH_CMD_4BYTE_DUAL_IO_FAST_READ : FLASH_CMD_DUAL_OUTPUT_FAST_READ;
    fmode = SET_FCMD_MODE;
    rdFlash(op, cmd, addr, data, trans);
  }

  // Quad
  void rdFlash34ByteFastQuad(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    uint32_t op;
    uint32_t cmd;
    if(quad_mode) setDummyBits(10); else setDummyBits(8);
    setMode(QUAD_MODE);
    op = (four_byte_mode | four_byte) ? SPI_FLASH_CMD_ADDR4_DUMMY_RD : SPI_FLASH_CMD_ADDR3_DUMMY_RD;
    cmd = (four_byte) ? FLASH_CMD_4BYTE_QUAD_OUTPUT_FAST_READ : FLASH_CMD_QUAD_OUTPUT_FAST_READ;
    if(!quad_mode) fmode = SET_FCMD_MODE | SET_FADDR_MODE;
    rdFlash(op, cmd, addr, data, trans);
  }
  
  // Quad INOUT
  void rdFlash34ByteFastQuadInOut(uint32_t addr, uint8_t *data, uint32_t trans, bool four_byte=false)
  {
    uint32_t op;
    uint32_t cmd;
    uint32_t dummys;
    dummys = (vendor == FLASH_VENDOR_TABLE::VENDOR_WINBOND || vendor == FLASH_VENDOR_TABLE::VENDOR_MACRONIX) ? 6 : 10; 
    setDummyBits(dummys);
    setMode(QUAD_MODE);
    op = (four_byte_mode | four_byte) ? SPI_FLASH_CMD_ADDR4_DUMMY_RD : SPI_FLASH_CMD_ADDR3_DUMMY_RD;
    cmd = (four_byte) ? FLASH_CMD_4BYTE_QUAD_IO_FAST_READ : FLASH_CMD_QUAD_IO_FAST_READ;
    if(!quad_mode) fmode = SET_FCMD_MODE; 
    rdFlash(op, cmd, addr, data, trans);
  }

	void rdFlash(uint8_t op, uint8_t cmd, uint32_t addr, uint8_t *data, uint32_t trans)
	{
		uint32_t cnt;

		setBits(8);
    wrSpiFifo(cmd);
    wrSpiFifo(addr);
		wrCtrl0();
		wrCtrl1(op, trans);

		cnt = 0;
		do {
			if((rdSpiStatus()&0x10000) == 0) {
				data[cnt++] = rdSpiFifo();
			}
		} while(cnt < trans);
	}

  //===================================================
  // Write Register commands
  //===================================================
  void enableQuadMode()
  {
    uint8_t reg[2];
    switch(vendor) {
      case FLASH_VENDOR_TABLE::VENDOR_WINBOND:
	      rdFlashRegister(FLASH_CMD_WINB_READ_STATUS_REGISTER2, reg);
        reg[0] |= 0x2;
        wrFlashRegister(FLASH_CMD_WINB_WRITE_STATUS_REGISTER2, reg);
        break;
      case FLASH_VENDOR_TABLE::VENDOR_MACRONIX:
        reg[0] = rdFlashStatus();
        reg[0] |= 0x40; 
        wrFlashRegister(FLASH_CMD_WRITE_STATUS_REGISTER, reg);
        break;
    }
  }

  void wrStatusRegister(uint8_t *val)
  {
    uint32_t cnt;
    cnt = (vendor == FLASH_VENDOR_TABLE::VENDOR_WINBOND) ? 2 : 1;
    wrFlashRegister(FLASH_CMD_WRITE_STATUS_REGISTER, val, cnt);

  }

	void wrFlashRegister(uint8_t cmd, uint8_t *data, uint32_t trans=1)
	{
		setWrEnable();
		setBits(8);
		wrCtrl0();
    wrSpiFifo(cmd);
		wrCtrl1(SPI_FLASH_CMD_WR, trans);

		for(uint32_t cnt=0;cnt<trans;cnt++) {	
			while((rdSpiStatus()&0x2) == 2) continue;
      wrSpiFifo(data[cnt]);
		}
		wait4Idle();
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
    wrFlash(SPI_FLASH_CMD_ADDR3_WR, FLASH_CMD_PAGE_PROGRAM, addr, data, trans);
  }

  void wrFlash4Byte(uint32_t addr, uint8_t *data, uint32_t trans) 
  {
    //TODO: UPDATE: change FLASH_CMD_4BYTE_FAST_PROGRAM to FLASH_CMD_4BYTE_FAST_PROGRAM 
    wrFlash(SPI_FLASH_CMD_ADDR4_WR, FLASH_CMD_4BYTE_FAST_PROGRAM, addr, data, trans);
  }

	void wrFlash(uint8_t op, uint8_t cmd, uint32_t addr, uint8_t *data, uint32_t trans)
	{
		setWrEnable();
		setBits(8);
		wrCtrl0();
		wrCtrl1(op, trans);
    wrSpiFifo(cmd);
    wrSpiFifo(addr);

		for(uint32_t cnt=0;cnt<trans;cnt++) {	
			while((rdSpiStatus()&0x2) == 2) continue;
      wrSpiFifo(data[cnt]);
		}
		wait4Idle();
		wait4ProgDone();
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
    uint8_t op;

    op = (four_byte) ? SPI_FLASH_CMD_ADDR4_WR : SPI_FLASH_CMD_ADDR3_WR;
    setCurrentMode();
		setWrEnable();
		wrCtrl0();
    wrSpiFifo(cmd);
    wrSpiFifo(addr);
		wrCtrl1(op, 0);
		wait4Idle();
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
        printf("Error...%d: EXP(0xff) ACT(0x%02x)\n", act[i]);
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
