
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
#include <stdlib.h>

#ifndef __MSFTDVIP_GPIO_DRIVER_INC__
#define __MSFTDVIP_GPIO_DRIVER_INC__


//=============================================================
// GPIO Class
//=============================================================
class MSFTDVIP_GPIO_DRIVER {
  public:
   
  typedef enum {
    IN_OFFSET=0,
    OUT_OFFSET=1,
    OEN_OFFSET=2,
    ALT_OFFSET=3,
    OD_OFFSET=4,
    OS_OFFSET=5,
    PU_OFFSET=6,
    RE_OFFSET=7,
    FE_OFFSET=8,
    SCK_OFFSET=9,
    ALT1_OFFSET=10,
  } GPIO_OFFSET_t;

  uint32_t *gpio_addr;

  MSFTDVIP_GPIO_DRIVER(uint32_t addr); 
	void setAddr(uint32_t val);
  void wrOut(uint32_t val);
  void wrOen(uint32_t val);
  void wrAlt(uint32_t val);
  void wrAlt1(uint32_t val);
  void wrOd(uint32_t val);
  void wrOs(uint32_t val);
  void wrPu(uint32_t val);

  uint32_t rdIn();
  uint32_t rdOut();
  uint32_t rdOen();
  uint32_t rdAlt();
  uint32_t rdAlt1();
  uint32_t rdOd();
  uint32_t rdOs();
  uint32_t rdPu();
  
};

MSFTDVIP_GPIO_DRIVER::MSFTDVIP_GPIO_DRIVER(uint32_t addr) 
{
  gpio_addr = (uint32_t*)GET_PTR_t(addr, 0x800 );
}

void MSFTDVIP_GPIO_DRIVER::wrOut(uint32_t val)
{
  *(gpio_addr+OUT_OFFSET) = val;
}
void MSFTDVIP_GPIO_DRIVER::wrOen(uint32_t val)
{
  *(gpio_addr+OEN_OFFSET) = val;
}
void MSFTDVIP_GPIO_DRIVER::wrAlt(uint32_t val)
{
  *(gpio_addr+ALT_OFFSET) = val;
}
void MSFTDVIP_GPIO_DRIVER::wrAlt1(uint32_t val)
{
  *(gpio_addr+ALT1_OFFSET) = val;
}
void MSFTDVIP_GPIO_DRIVER::wrOd(uint32_t val)
{
  *(gpio_addr+OD_OFFSET) = val;
}
void MSFTDVIP_GPIO_DRIVER::wrOs(uint32_t val)
{
  *(gpio_addr+OS_OFFSET) = val;
}
void MSFTDVIP_GPIO_DRIVER::wrPu(uint32_t val)
{
  *(gpio_addr+PU_OFFSET) = val;
}

uint32_t MSFTDVIP_GPIO_DRIVER::rdIn()
{
  return *(gpio_addr+IN_OFFSET);
}
uint32_t MSFTDVIP_GPIO_DRIVER::rdOut()
{
  return *(gpio_addr+OUT_OFFSET);
}
uint32_t MSFTDVIP_GPIO_DRIVER::rdOen()
{
  return *(gpio_addr+OEN_OFFSET);
}
uint32_t MSFTDVIP_GPIO_DRIVER::rdAlt()
{
    return *(gpio_addr+ALT_OFFSET);
}
uint32_t MSFTDVIP_GPIO_DRIVER::rdAlt1()
{
    return *(gpio_addr+ALT1_OFFSET);
}
uint32_t MSFTDVIP_GPIO_DRIVER::rdOd()
{
  return *(gpio_addr+OD_OFFSET);
}
uint32_t MSFTDVIP_GPIO_DRIVER::rdOs()
{
  return *(gpio_addr+OS_OFFSET);
}
uint32_t MSFTDVIP_GPIO_DRIVER::rdPu()
{
  return *(gpio_addr+PU_OFFSET);
}
  
#endif
