
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
