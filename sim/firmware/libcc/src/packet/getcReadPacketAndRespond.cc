
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
#include <stdlib.h>


//==============================================================================
uint32_t getcReadPacketAndRespond(
				  char* buf,      //>=8 chars for rough work 
				  uint16_t len    //remaining payload length
				  ){
  uint32_t i;
  uint16_t words;
  uint32_t addr;
  uint32_t data;

/*
  for(i=0;i<8; i++){
    buf[i] = getc();
    len--;
  }
  addr = ConvertHexString2Int(buf,8)&0xfffffffc;
*/
  addr = pktGetUint32(&len);

/*
  for(i=0;i<4;i++){
    buf[i] = getc();
    len--;
  }
  words = ConvertHexString2Int(buf,4);
*/
  // Force this one to 4 nibbles. 
  // TODO: Discuss with Jeremy about whether the function should do the decrement of the len.
  words = (uint16_t)pktGetUint32(&len, 4);


  if(getc() != '-'){
    SendNAK();
  } else {
    SendACK();
  }
  //Send back the read data
  putcPktHeader(buf,words*8+1,'D');
  while(words > 0) {
    // TODO: This should be a function which transmits an integer like pktGetUint32  pktPutUint32. This would get rid of the buffer completely
    data = hw_read32((uint32_t*)addr);
    addr += 4;
    ConvertInt2HexString(data, buf, 8);
    for(i=0;i<8;i++){
      putc(buf[i]);
    }
    words--;
  }
  putc('-');
  return 0;
}
