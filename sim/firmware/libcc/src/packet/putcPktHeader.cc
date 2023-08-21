
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
