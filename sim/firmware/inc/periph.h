
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




#ifndef  __MSFTDVIP_PERIPH_INC__
#define __MSFTDVIP_PERIPH_INC__


typedef enum {
  MSFTDVIP_INTC_ADDR=0x8f000600,
  MSFTDVIP_DW_SPI_ADDR=0x8f007000,
  MSFTDVIP_TMR0_ADDR=0x8f008000,
  MSFTDVIP_TMR1_ADDR=0x8f008080,
  MSFTDVIP_DMA_ADDR=0x8f009000,
  MSFTDVIP_JTAG_ADDR=0x8f00a000,
  MSFTDVIP_UART0_ADDR=0x8f00b000,
  MSFTDVIP_SPI0_MGR_ADDR=0x8f00c000,
  MSFTDVIP_SPI0_SUB_ADDR=0x8f00c020,
  MSFTDVIP_I2C0_MGR_ADDR=0x8f00d000,
  MSFTDVIP_I2C0_SUB_ADDR=0x8f00d020,
  MSFTDVIP_GPIO0_ADDR=0x8f00f000,
  MSFTDVIP_GPIO1_ADDR=0x8f00f800,
  MSFTDVIP_SHARED_RAM_ADDR=0x8f020000,
  MSFTDVIP_DMB_ADDR=0x8f0f0000,
  MSFTDVIP_DMB_MEM_ADDR=0x90000000,
} MSFTDVIP_PERIPH_t;


#endif
