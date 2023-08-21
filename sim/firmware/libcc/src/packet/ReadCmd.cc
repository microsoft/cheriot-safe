
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

//#include <pluton.h>  //Needed for hw_read32()
//use macro below to keep pluton out
#define _hw_read32(addr) (*(volatile uint32_t *)(addr))

//============================================
// ReadCmd
//============================================
int ReadCmd(char * buf, uint32_t size)
{
    uint32_t *addr;
    uint32_t data, words;
    char * ptr;

    if(size < 13) {
    	SendNAK();
    	return 1;
    }
    
    // ACK Original
    SendACK();
    
    // Get Address Align to word boundary and words
    addr = (uint32_t*)(ConvertHexString2Int(buf+1,8)&0xfffffffc);
    words = ConvertHexString2Int(buf+9,4);
    
    ptr = buf;
    *ptr++ = 'D';

//    g_DAbort = FALSE;
    while(words > 0) {
    
    	// Read the data
      data = _hw_read32((uint32_t)addr);
      
//	if(g_DAbort) {
//	    break;
//	}
	ConvertInt2HexString(data, ptr, 8);
    
	addr ++;
	ptr += 8;
	words--;	
    }
    *ptr = '\0';

    // Send it back
    WritePacket(buf);

    return 0;
}
