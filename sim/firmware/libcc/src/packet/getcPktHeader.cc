
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
#include <stddef.h>
#include <stdlib.h>

//==============================================================================
uint32_t getcPktHeader(
		       char *buf,          //rought buf space of at least 5 chars
		       char *charCode,     //packet char code
		       uint16_t* len       //length of payload excluding pkt code
		       ){
  uint32_t i = 0;
  while(getc() != '+');  //Blocks until packet start

  //Magic string
  for(i=0;i<sizeof(MAGIC_STR_ARRAY); i++){
    if (getc() != MAGIC_STR_ARRAY[i]) return 1;
  }
  
  //Char length
  *len = 4;
  *len = (uint16_t)pktGetUint32(len);
/*
  for(i=0; i<4; i++){
    buf[i] = getc();
  }
  buf[4] = '\0';
  // len = strtoul((const char*)buf, (char**)NULL, 16);
  *len = (uint16_t) ConvertHexString2Int((const char*)buf,4);
*/
  *charCode = getc();
  *len = *len -1;
  return 0;
}
