#include <util.h>

extern int mymain(int, int);

volatile unsigned int* uartRegBase;
volatile unsigned int* mtimeRegBase;
volatile unsigned int* gpio0RegBase;
volatile unsigned int* iromBase;
volatile unsigned int* iramBase;
volatile unsigned int* dramBase;

void* globalRoot;

// Ideally we also set the bounds and permissions when deriving from root, but I don't have enough
// information now.
void* from_root(unsigned int addr) {
  return __builtin_cheri_address_set(globalRoot, addr);
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
    void** capaddr = from_root(caprelocs[i].addr);
    void* cap;
    if (caprelocs[i].flags & 0x80000000U) { // This is a function pointer.
      __asm volatile("auipcc %0, 0": "=C"(cap));
    }
    else
      cap = from_root(0);
    cap = __builtin_cheri_address_set(cap, caprelocs[i].base);
    cap = __builtin_cheri_bounds_set(cap, caprelocs[i].len);
    cap = __builtin_cheri_offset_increment(cap, caprelocs[i].offset);
    *capaddr = cap;
  }
}

// the only reason we need this is to pass argument to main if needed
void cstart(void* gRoot, CapReloc* caprelocs, unsigned int nCaprelocs) {
  globalRoot = gRoot;
  populate_caprelocs(caprelocs, nCaprelocs);

  iromBase = from_root(0x20000000U);
  iramBase = from_root(0x20040000U);
  dramBase = from_root(0x200f0000U);
  uartRegBase = from_root(0x8f00b000U);
  mtimeRegBase = from_root(0x14001010U);
  gpio0RegBase = from_root(0x8f00f000U);

  uart_init();

  mymain(0, 0);

  stop_sim();

  while (1) {;}
}

//void cheri_fault_handler(void) {
//}
