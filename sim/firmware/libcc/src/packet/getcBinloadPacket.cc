
#include <packet.h>
#include <stdio.h>

//==============================================================================
uint32_t getcBinloadPacket(
			   char* buf,      //>=8 chars for rought work 
			   uint16_t len    //remaining payload length 
			   ){
  if( (len <8) || (len%2 != 0)) {
    SendNAK();
    return 1;
  }
  uint32_t *addr = (uint32_t*)pktGetUint32(&len);
  //pprintf("Binload a=%08x l=%04x\n",addr,len);
  while(len>0) {
    *addr++ = pktGetUint32(&len);
  }
  if(getc() != '-'){
    SendNAK();
  } else {
    SendACK();
  }
  return 0;
}
