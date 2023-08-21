
// =====================================================
// Copyright (c) Microsoft Corporation.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//    http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =====================================================

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
