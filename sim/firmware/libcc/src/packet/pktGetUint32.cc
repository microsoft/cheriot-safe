#include <packet.h>
#include <stdio.h>

const static uint8_t asci2int_vals[0x37] = {
    0,1,2,3, 4,5,6,7, 8,9,0,0, 0,0,0,0,                   // 0x30 - 0x3f   16 Bytes
    0,0xa,0xb,0xc, 0xd,0xe,0xf, 0, 0,0,0,0, 0,0,0,0,      // 0x40 - 0x4f   16 Bytes
    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,                   // 0x50 - 0x5f   16 Bytes
    0,0xa,0xb,0xc, 0xd,0xe,0xf                            // 0x60 - 0x66    6 Bytes
};

/*
uint8_t cvtASCI2uint8(uint8_t c)
{
  if (c < '0' || c > 'f') {
    //continue;      
    return 0;
  } else if(c >='a' && c <= 'f') {
    c = c - 0x20 - 0x30;
  } else {
    c -= 0x30;      
  }    
  return asci2int_vals[c];
}
*/

uint32_t pktGetUint32(uint16_t *len, int nibbles)
{
  uint32_t val = 0;
  uint8_t c;
  uint32_t tval;

  for(int i=0;i<nibbles;i++) {
    if(*len == 0) break;
    *len-=1;
    tval = 0;
    c = (uint8_t)getc();
//    tval = cvtASCI2uint8(c);
    tval = asci2int_vals[c-'0'];
#ifdef __LITTLE_ENDIAN__
    val |= tval << i;
#else
    val = (val << 4) | tval;
#endif

  }
  return val;
}


