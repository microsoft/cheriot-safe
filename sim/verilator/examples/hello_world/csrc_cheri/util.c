#include <util.h>

extern volatile unsigned int* uartRegBase;
extern volatile unsigned int* mtimeRegBase;
extern volatile unsigned int* gpio0RegBase;

void uart_send_char(unsigned char dts) {
   while((uartRegBase[5] & 0x60) == 0) {;} 
   uartRegBase[0] = dts;
}

void uart_init(void) {

  uartRegBase[3] = 0x000000083;
  uartRegBase[9] = 0x00000000e;
  uartRegBase[0] = 0x00000000a;
  uartRegBase[1] = 0x000000000;
  uartRegBase[3] = 0x000000003;
  uartRegBase[2] = 0x000000001;
  uartRegBase[0] = 0x000000020;
  
}

void stop_sim(void) {
  uart_send_char (0xff);
}

void uart_prints(char *buf) {
  int i;

  i = 0;
  while ((i<32) && (buf[i]!='\0')) {
    uart_send_char(buf[i]);
    i++;
  }
}

unsigned int read_mtime (unsigned int selhi) {
  if (selhi) {
    return mtimeRegBase[1];
  } else {
    return mtimeRegBase[0];
  }
} 

void gpio_out (unsigned int val, unsigned int oe) {
  gpio0RegBase[1] = val;          // [0] is gpio_in
  gpio0RegBase[2] = oe;
}   
