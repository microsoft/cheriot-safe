#include <util.h>

// Should not be inlined, because we expect arguments
// in particular registers.
//__attribute__((noinline))

extern int rv32_atest(int);

int mymain () {
  int fail_flag, result;

  char *hello_msg = "Hello World!\n";
  char *pass_msg = "\nRV32 test passed :-)\n";
  char *fail_msg = "\nRV32 test failed :-(((((\n";

  prints(hello_msg);

  fail_flag = rv32_atest(0);

  if (fail_flag == 0) {
    prints(pass_msg);
  }

  return 0;
   
}

