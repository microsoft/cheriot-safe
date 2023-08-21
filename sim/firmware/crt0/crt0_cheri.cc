
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

// FIXME: What is the mangled name in C++?
//#include <cdefs.h>
#include <cheri.h>
#include <inttypes.h>
//#include <hsp_core.h>
#include <riscvregs.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define BASE_ADDR    0x80000000
#define UART_OFFSET  0x0f00b000
#define UART_ADDR  BASE_ADDR+UART_OFFSET
#define XTAL_FREQ  20000000
#define BAUDRATE   115200

#define UART_WLS_8                  (3 << 0)
#define UART_NONE_PARITY            (0 << 3)
#define UART_1_STOP                 (0 << 2)

#define UART_DEFAULT_BAUD_RATE 		(115200)
#define UART_DEFAULT_DATA_BIT		(UART_WLS_8)
#define UART_DEFAULT_PARITY			(UART_NONE_PARITY)
#define UART_DEFAULT_STOP_BIT		(UART_1_STOP)


extern void malloc_init(void* heap, size_t len);
extern int main(void);
void uart_init( void* uartCap, unsigned long xtal_freq, unsigned long baudrate=UART_DEFAULT_BAUD_RATE, unsigned long word_size=UART_DEFAULT_DATA_BIT, unsigned long parity=UART_DEFAULT_PARITY, unsigned long stop=UART_DEFAULT_STOP_BIT);

volatile unsigned char* uartReg;
volatile unsigned int*  tmrReg;
volatile unsigned int*  simReg;
volatile unsigned int*  rngReg;
volatile unsigned int*  cfgReg;
volatile unsigned int*  memRands;

void* globalRoot;
void* pccRoot;

uint32_t mtvecArr [32] __attribute__ ((aligned(64))) __attribute__((section(".boot.init0"))) {
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000,
  0x00000000
};

void _exit(int val)
{
  int retval = (val != 0) ? 0xfe : 0xff;
  putc(retval);
  while(1);
}

// Ideally we also set the bounds and permissions when deriving from root, but I don't have enough
// information now.
void* from_root(unsigned int addr) {
  return __builtin_cheri_address_set(globalRoot, addr);
}

//static void* cap_build(void* root, ptraddr_t start, size_t len, size_t perms)
void* cap_build(void* root, ptraddr_t start, size_t len, size_t perms)
{
	void* ret = root;

	ret = cheri_perms_and(ret, perms);
	ret = cheri_address_set(ret, start);
	ret = cheri_bounds_set(ret, len);

	return ret;
}

typedef struct {
  unsigned int addr;
  unsigned int base;
  unsigned int offset;
  unsigned int len;
  unsigned int flags;
} CapReloc;

void populate_caprelocs(CapReloc* caprelocs, unsigned int n)
{
  for (unsigned int i = 0; i < n; ++i) {
    void** capaddr = (void**)from_root(caprelocs[i].addr);
    void* cap;
    if (caprelocs[i].flags & 0x80000000U) { // This is a function pointer.
      cap = pccRoot;
    } else {
      cap = from_root(0);
    }

    cap = __builtin_cheri_address_set(cap, caprelocs[i].base);
    cap = __builtin_cheri_bounds_set(cap, caprelocs[i].len);
    cap = __builtin_cheri_offset_increment(cap, caprelocs[i].offset);
    *capaddr = cap;
  }
}

// the only reason we need this is to pass argument to main if needed
extern "C" void cstart(void *pccRootArg, void* memRootArg, void* heapCap, unsigned int heapSize, CapReloc* caprelocs, unsigned int nCaprelocs) {
	ptraddr_t dataROMStart = la_abs(_pcc_end);
	ptraddr_t dataRAMStart = la_abs(_data_start);
	ptraddr_t bssRAMStart = la_abs(_bss_start);
	constexpr size_t memoryPerms = CHERI_PERM_LOAD | CHERI_PERM_STORE | CHERI_PERM_LOAD_STORE_CAP;
	size_t sz = la_abs(_data_end) - dataRAMStart;
	size_t bssSz = la_abs(_bss_end) - la_abs(_bss_start);

	void* dataROM = cap_build(memRootArg, dataROMStart, sz, memoryPerms);
	void* dataRAM = cap_build(memRootArg, dataRAMStart, sz, memoryPerms);
	void* bssRAM = cap_build(memRootArg, bssRAMStart, bssSz, memoryPerms);

	// Copy data section from ROM to RAM.
	memcpy(dataRAM, dataROM, sz);

	// Zero .bss.
	memset(bssRAM, 0, bssSz);

  pccRoot = pccRootArg;
  globalRoot = memRootArg;
  populate_caprelocs(caprelocs, nCaprelocs);

  simReg  = (volatile unsigned int*)from_root(0x21000000U);
  tmrReg  = (volatile unsigned int*)from_root(0x21000100U);
  uartReg = (volatile unsigned char*)from_root(0x21000200U);
  rngReg  = (volatile unsigned int*)from_root(0x21000300U);
  cfgReg  = (volatile unsigned int*)from_root(0x21000400U);

  memRands = (volatile unsigned int*)from_root(0x20011000U);

  malloc_init(heapCap, heapSize);

	uart_init(cap_build(memRootArg, UART_ADDR, 0x1000, memoryPerms), XTAL_FREQ, BAUDRATE);

	int retval = main();

	_exit(retval);

	while(1);
}

//void cheri_fault_handler(void) {
//}
