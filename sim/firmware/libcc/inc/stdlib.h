
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


#ifndef __STDLIB_HEADER_INC__
#define __STDLIB_HEADER_INC__

#include <cheri.h>
#include <inttypes.h>
#include <stddef.h>
#include <stdio.h>

//#ifdef __cplusplus
//extern "C" {
//#endif
//======================================================
// Defines
//======================================================
#define PRINT_BYTES 1
#define PRINT_HALF_WORD 2
#define PRINT_WORD 4

#define EXIT_SUCCESS 		0
#define EXIT_FAILURE 		1
//#define NULL 				((void *)0)
#ifndef NULL
  #define NULL 				__null
#endif
#ifdef __DEBUG_RTC__
#define WR_RTC_RAM(o,d)         *((uint32_t*)0x07803000+o) = ((uint32_t)d)
#else
#define WR_RTC_RAM(o,d)  
#endif

#define exit(a)             _exit(a)

//======================================================
// typedefs
//======================================================
//typedef uint32_t size_t;

//======================================================
// assert macro
//======================================================
#define assert(cond) \
    if(!(cond)) { \
        printf("Error in Function: %s File:%s:%d Assertion (" #cond ") Failed\n",   \
            __func__, __FILE__, __LINE__);											\
        _exit(EXIT_FAILURE);																		\
    }   

#define hsp_assert(cond) \
    if(!(cond)) { \
        pprintf("Error in Function: %s File:%s:%d Assertion (" #cond ") Failed\n",   \
            __func__, __FILE__, __LINE__);											\
        _exit(EXIT_FAILURE);																		\
    }  

#define u1assert(cond) \
    if(!(cond)) { \
        u1printf("Error in Function: %s File:%s:%d Assertion (" #cond ") Failed\n",   \
            __func__, __FILE__, __LINE__);											\
        _exit(EXIT_FAILURE);																		\
    }   

#define pfassert(cond) \
    if(!(cond)) { \
        pfprintf((FILE*)0, "Error in Function: %s File:%s:%d Assertion (" #cond ") Failed\n",   \
            __func__, __FILE__, __LINE__);											\
        errors++;																		\
    } 

void _exit(int);

//======================================================
// Malloc
//======================================================
#define HSP_FREE    0
#define HSP_USED    1
#define HSP_END     2
#define MALLOC_MAGIC_NUM 0xa53c

typedef struct malloc_s {
    uint32_t prev_addr;
    uint32_t next_addr;
    uint16_t status;
    uint16_t magic_number;
    uint32_t size;
} malloc_t, *pmalloc_t;

extern void *HeapCap;
static inline void *malloc_fromaddr(uint32_t addr)
{
	return cheri_address_set(HeapCap, addr);
}

void *malloc(size_t size);
void * realloc(void *ptr, size_t size);
void free(void *ptr);
void setMallocDescriptor(pmalloc_t ptr, uintptr_t prev, uintptr_t next, uint32_t status);

#define MALLOC_SR_SIZE            0x2000
#define MALLOC_SR_DEF_VALUE       0xFF
#define MALLOC_SR_BLOCK_SIZE      256
#define MALLOC_SR_ARRAY_SIZE      (MALLOC_SR_SIZE/MALLOC_SR_BLOCK_SIZE)

void free_SR(void * ptr);
void *malloc_SR(size_t size);
void malloc_SR_init(uint32_t sr_addr);
void malloc_SR_table_print();

//======================================================
// Random Functions
//======================================================
uint32_t 	rand(void);
void 		srand(uint32_t seed);

void        random_fill(uint32_t * arr, uint32_t num);
uint32_t 	random_range(uint32_t min, uint32_t max);

extern const unsigned int RAND_SEED;

//======================================================
// Register read/write proto-types
//======================================================

inline uint8_t hw_read8(volatile uint8_t* addr) { return *addr; }
inline uint16_t hw_read16(volatile uint16_t* addr) { return *addr; }
inline uint32_t hw_read32(volatile uint32_t* addr) { return *addr; }
inline uint64_t hw_read64(volatile uint64_t* addr) { return *addr; }

inline void hw_write32(volatile uint32_t* addr, uint32_t data) { *addr = data; }
inline void hw_write8(volatile uint8_t* addr, uint8_t data) { *addr = data; }
inline void hw_write16(volatile uint16_t* addr, uint16_t data) { *addr = data; }
inline void hw_write64(volatile uint64_t * addr, uint64_t data) { *addr = data; }


//__attribute__((target("thumb"))) void hw_read256(uint32_t * src, uint32_t * dst);
void hw_read256(uint32_t * src, uint32_t * dst);

#ifdef DSB
inline uint8_t hw_read8_abt(volatile uint8_t* addr) { uint8_t rdata = *addr; DSB;DSB; return rdata; }
inline uint16_t hw_read16_abt(volatile uint16_t* addr) { uint16_t rdata = *addr; DSB;DSB; return rdata; }
inline uint32_t hw_read32_abt(volatile uint32_t* addr) { 
  uint32_t rdata = *addr; 
  return rdata; 
}
inline uint64_t hw_read64_abt(volatile uint64_t* addr) { uint64_t rdata = *addr; DSB;DSB; return rdata; }

inline void hw_write32_abt(volatile uint32_t* addr, uint32_t data) { *addr = data; DSB;DSB; }
inline void hw_write8_abt(volatile uint8_t* addr, uint8_t data) { *addr = data; DSB;DSB; }
inline void hw_write16_abt(volatile uint16_t* addr, uint16_t data) { *addr = data;  DSB;DSB;}
inline void hw_write64_abt(volatile uint64_t * addr, uint64_t data) { *addr = data; DSB;DSB;}
#endif

//======================================================
// Specialized functions
//======================================================
#define PRINT_BYTES 1
#define PRINT_HALF_WORD 2
#define PRINT_WORD 4
void hsp_print_c_array(uint32_t bytes, char * array, uint32_t size);

// Given argc, argv, and the argv array index expected to contain an 0xABC type 
// string, this function will return a uint32_t of what's encoded in the string, 
// given it's within the min and max. If anything doesn't look correct or the 
// uint32_t is out of the min,max range, then 0xFFFFFFFF is returned.
uint32_t parse_hexul_from_argv(int argc, const char* argv[],int index,uint32_t min,uint32_t max);

long strtol(const char *nptr, char **endptr, int base);
uint32_t strtoul( const char *nptr, char **endptr, int base);

//======================================================
// Cheri Obfuscation of how to create a pointer
//======================================================
#define GET_PTR_t(addr,len)   get_ptr(addr,len)
void * get_ptr(unsigned long start, size_t len);

//#ifdef __cplusplus
//}
//#endif

#endif
