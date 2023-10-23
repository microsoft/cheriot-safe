#include <util.h>

// Should not be inlined, because we expect arguments
// in particular registers.
//__attribute__((noinline))

//extern "C" int cheri_intr_init(int);

//extern volatile unsigned int *iromBase;
//extern volatile unsigned int *iramBase;

static volatile int int_cnt;

int mymain () {
  unsigned int tmrval;
  char *hello_msg = "Hello world!\n";

  uart_prints(hello_msg);

  while (1) {
     tmrval = read_mtime(0);
     tmrval >>= 23;                // toggle frequency == clock div by 2^24
     tmrval &= 0x3;
     tmrval <<= 14;
     gpio_out(tmrval, 0xe000);     // toggle LED (gpio0[15:14])
  }
}

