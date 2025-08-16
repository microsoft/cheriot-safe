#include <util.h>

// Should not be inlined, because we expect arguments
// in particular registers.
//__attribute__((noinline))

extern int cheri_intr_init(int);
extern int cheri_sw_intr_test(int);
extern int cheri_tmr_intr_test(int);
extern int cheri_tsafe_test(int);
extern int cheri_tbre_test(int);
extern int cheri_stkclr_test(int);
extern int cheri_dmb_test(int);
extern unsigned int *get_mmreg_base(void);

//extern volatile unsigned int *iromBase;
//extern volatile unsigned int *iramBase;
volatile unsigned int *mmreg_base;

static volatile int int_cnt;

int mymain () {
  volatile unsigned int *mem_ptr;
  unsigned int flag;
  int i, fail_cnt;
  unsigned int c1;

  fail_cnt = 0;
  prints("Cheri sanity test starting..\n");

  prints("Setting up ISR and PLIC\n");
  flag = cheri_intr_init(0);
  mmreg_base = get_mmreg_base();

  prints("Testing dbg fifo\n");
  for (i = 0; i < 17; i++) {
    mmreg_base[16] = i;
  }
  for (i = 0; i < 16; i++) {
    c1 = mmreg_base[16];
    if (c1 != i) {fail_cnt++;} 
  }
  c1 = mmreg_base[16];
  if ((c1 & 0x100) == 0) {fail_cnt++;}
  if (fail_cnt != 0) {
    prints("Test failed :-(\n");
    return -1;
  }

  prints("Testing sw interrupts\n"); 
  flag = cheri_sw_intr_test(0);
  if (flag != 0) {
    prints("Test failed with error code %x :-(\n");
    fail_cnt ++;
    return -1;
  }

  prints("Testing timer interrupts\n"); 
  flag = cheri_tmr_intr_test(0);
  if (flag != 0) {
    prints("Test failed with error code %x :-(\n");
    fail_cnt ++;
    return -1;
  }

  prints("calling cheriot tsafe test\n");
  flag = cheri_tsafe_test(0);

  if (flag != 0) {
    prints("Test failed with error code %x :-(\n");
    fail_cnt ++;
    return -1;
  }
 
  prints("Testing DMB\n");
  flag = cheri_dmb_test(0);

  if (flag != 0) {
    prints("Test failed with error code %x :-(\n");
    fail_cnt ++;
    return -1;
  } 

  if (fail_cnt == 0)  {
    prints("Test passed :-) \n");
    return 0;
  } else {
    return -1;
  }
  
}

