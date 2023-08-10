// Include file for edc.h


#ifndef __EDC_H_INCLUDE__
#define __EDC_H_INCLUDE__

#include <inttypes.h>

typedef enum ENCRYPTION_TYPE_E {
  ENCRYPTION_TYPE_EDC  = (uint64_t) 0x0,  
  ENCRYPTION_TYPE_ECC  = (uint64_t) 0x0100000000000000
} ENCRYPTION_TYPE_t;

//#ifdef __cplusplus
//extern "C" {
//#endif

//=================================================
// Prototypes
//=================================================
uint64_t GenerateECC(uint64_t data, ENCRYPTION_TYPE_t secded_mode=ENCRYPTION_TYPE_EDC);
  uint64_t ConCatAddrData(uint32_t Addr, uint32_t Data, uint32_t Width, ENCRYPTION_TYPE_t secded_mode=ENCRYPTION_TYPE_EDC);
uint64_t ConstructECC (uint32_t Addr, uint32_t Data, uint32_t Width, ENCRYPTION_TYPE_t secded_mode=ENCRYPTION_TYPE_EDC);

//#ifdef __cplusplus
//}
//#endif

#endif
