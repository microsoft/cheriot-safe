
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


class MSFTDVIP_DMA_DRIVER {

  public:

  typedef struct {
    volatile uint32_t ctrl0;
    volatile uint32_t src;
    volatile uint32_t dst;
    volatile uint32_t cnt;
    volatile uint32_t status;
  } MSFTDVIP_DMA_t;

  typedef enum {
    CTRL0_OFFSET=0,
    SRC_OFFSET=1,
    DST_OFFSET=2,
    CNT_OFFSET=3,
    STATUS_OFFSET=4,
  } MSFTDVIP_DMA_e;

  #define DMA_EN              (1<<0)

  #define DMA_SRC_INC         (1<<1)

  #define DMA_DST_INC         (1<<2)

  #define DMA_SRC_BURST_1     (0<<3)
  #define DMA_SRC_BURST_2     (1<<3)
  #define DMA_SRC_BURST_4     (2<<3)
  #define DMA_SRC_BURST_8     (3<<3)
  #define DMA_SRC_BURST_16    (4<<3)
  #define DMA_SRC_BURST_32    (5<<3)
  #define DMA_SRC_BURST_64    (6<<3)
  #define DMA_SRC_BURST_128   (7<<3)
  #define DMA_SRC_BURST_256   (8<<3)

  #define DMA_DST_BURST_1     (0<<7)
  #define DMA_DST_BURST_2     (1<<7)
  #define DMA_DST_BURST_4     (2<<7)
  #define DMA_DST_BURST_8     (3<<7)
  #define DMA_DST_BURST_16    (4<<7)
  #define DMA_DST_BURST_32    (5<<7)
  #define DMA_DST_BURST_64    (6<<7)
  #define DMA_DST_BURST_128   (7<<7)
  #define DMA_DST_BURST_256   (8<<7)

  #define DMA_SRC_SIZE_BYTE   (0<<11)
  #define DMA_SRC_SIZE_HWORD  (1<<11)
  #define DMA_SRC_SIZE_WORD   (2<<11)
  #define DMA_SRC_SIZE_WORD64 (3<<11)

  #define DMA_DST_SIZE_BYTE   (0<<14)
  #define DMA_DST_SIZE_HWORD  (1<<14)
  #define DMA_DST_SIZE_WORD   (2<<14)
  #define DMA_DST_SIZE_WORD64 (3<<14)

  volatile uint32_t *dma_addr;
 
  MSFTDVIP_DMA_DRIVER(uint32_t addr) 
  {
    dma_addr = (volatile uint32_t*)GET_PTR_t(addr, 0x20);
  }

  void wrCtrl0(uint32_t data)
  {
    *(dma_addr+CTRL0_OFFSET) = data; 
  }

  void wrSrc(uint32_t data)
  {
    *(dma_addr+SRC_OFFSET) = data; 
  }

  void wrDst(uint32_t data)
  {
    *(dma_addr+DST_OFFSET) = data; 
  }

  void wrCnt(uint32_t data)
  {
    *(dma_addr+CNT_OFFSET) = data; 
  }

  uint32_t rdStatus()
  {
    volatile uint32_t *ptr;
    ptr = dma_addr+STATUS_OFFSET;
    return *ptr;
  }

  void dmaWait4Done()
  {
    uint32_t status;
    do {
      status = rdStatus();
    } while((status&1) == 0);
  }

  void dmaTrans(uint32_t ctrl, uint32_t src, uint32_t dst, uint32_t cnt)
  {
    wrSrc(src);
    wrDst(dst);
    wrCnt(cnt);
    wrCtrl0(ctrl);
  }

  int checkTransfer(uint32_t *src, uint32_t *dst, uint32_t cnt)
  {
    int error = 0;

    printf("Checking Transfer\n");
    uint32_t rdata;
    for(uint32_t i=0;i<cnt;i++) {
      rdata = *(dst+i);
      if(rdata != src[i]) {
        printf("Error...ADDR(0x%08x)  EXP(0x%08x)  ACT(0x%08x)\n", dst+i, src[i], rdata);
        error++;
      }
    }
    if(error == 0) {
      printf("  Passed\n");
    }
    return error;
  }

};

