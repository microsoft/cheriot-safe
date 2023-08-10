#include <packet.h>
#include <stdio.h>


const static uint8_t short_asci2int[0x17] = {
    0,1,2,3, 4,5,6,7, 8,9,0,0, 0,0,0,0,                    // 0x30 - 0x3f
    0,0xa,0xb,0xc, 0xd,0xe,0xf, /*0, 0,0,0,0, 0,0,0,0,*/   // 0x40 - 0x4f
};

//Cases
//0x00-0x30 - continue
//0x30-0x39 - c' = 0x00 - 0x09 , lookup[c'] = 0x00-0x9
//0x3a-0x40 - c' = 0x0a - 0x10 , lookup[c'] = 0x00
//0x41-0x46 - c' = 0x11 - 0x16 , lookup[c'] = 0xa-0xf
//0x47-0x60 - c' = 0x17 - 0x30 , continue
//0x61-0x66 - c' = 0x11 - 0x16 , lookup[c'] = 0xa-0xf
//0x66-0xFF - continue
uint32_t ConvertHexString2Int(const char *str, const int width){
  char c;
  uint32_t val = 0;
  for (int i=0; i<width; i++){
    c = str[i];
    if (c < '0' || c > 'f') {
      //continue;      
      return 0;
    } else if(c >='a' && c <= 'f') {
      c = c - 0x20 /*to upper*/ - 0x30;
    } else {
      c -= 0x30;      
    }    
    if (c > 0x16){
      //continue;
      return 0;
    }
    val = (val<<4)+short_asci2int[(int)c];
  }
    return val;
}

//============================================
// ConvertArray2Bin
//============================================
int ConvertHexArray2Bin(char * array, int bytes)
{
    int i;
    char * ptr = array;
    uint8_t * uptr = (uint8_t *)array;
    for(i=0;i<bytes;i+=2,ptr+=2) {
      *uptr++ = (uint8_t)(ConvertHexString2Int(ptr,1) << 4 | ConvertHexString2Int(ptr+1,1));
    } 
    return 0;
}





#if(USE_OLD_CHS2I_VERSION)

uint8_t asci2int[128] = {
    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,                 // 0x00 - 0x0f
    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,                 // 0x10 - 0x1f
    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,                 // 0x20 - 0x2f
    0,1,2,3, 4,5,6,7, 8,9,0,0, 0,0,0,0,                 // 0x30 - 0x3f
    0,0xa,0xb,0xc, 0xd,0xe,0xf,0, 0,0,0,0, 0,0,0,0,     // 0x40 - 0x4f
    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,                 // 0x50 - 0x5f
    0,0xa,0xb,0xc, 0xd,0xe,0xf,0, 0,0,0,0, 0,0,0,0,     // 0x60 - 0x6f
    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0                  // 0x70 - 0x7f
};

//============================================
// ConvertArray2Bin
//============================================
int ConvertHexArray2Bin(char * array, int bytes)
{
    int i;
    char * ptr = array;
    uint8_t * uptr = (uint8_t *)array;
    for(i=0;i<bytes;i+=2,ptr+=2) {
        *uptr++ = (asci2int[(int)*ptr]<<4) | asci2int[(int)*(ptr+1)];
    } 
    return 0;
}


//============================================
// Convert Integer 2 Hex String
//============================================
uint32_t ConvertHexString2Int(char * str, int width)
{
	int i;
	uint32_t val = 0;
	for(i=0;i<width;i++) {
        val = (val<<4)+(uint32_t)asci2int[(int)*(str+i)];
	}
	return val;
}
#endif
