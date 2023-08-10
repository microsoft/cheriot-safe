
#include <packet.h>
#include <stdio.h>

//==============================================================================
void putcPktHeader(
		   char * buf,             //rought work buffer with at least 4 bytes
		   const uint16_t len,     //len of payload, including packet char code
		   const char code         //the packet code
		   ){
  uint8_t i;
  ConvertInt2HexString(len, buf, 4);

  //Send the RPC call
  putc('+');
  for(i =0; i<sizeof(MAGIC_STR_ARRAY); i++){
    putc(MAGIC_STR_ARRAY[i]);
  }
  for(i=0; i<4; i++){
    putc(buf[i]);
  }
  putc(code);
}
