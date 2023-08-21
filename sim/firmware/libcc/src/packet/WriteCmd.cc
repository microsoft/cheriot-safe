
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
#include <stdlib.h>
//#include <pluton.h>  //For hw_write32
//Use macro below to keep pluton.ho out of libc

//#define _hw_write32(addr,data) (*(volatile uint32_t *)(addr))=(data)

//============================================
// WriteCmd
//============================================
int WriteCmd(char * buf, uint32_t size)
{
    uint32_t *addr, data, bytes, words;
    char * ptr;

    // Strip off command and addr
    bytes = size-9;
    
    // Need at least 17 bytes and words need to be on a word boundary
    if(size < 17 || (bytes&0x7) != 0) {
    	SendNAK();
    	return 1;
    }
    
    // Get Address and calculate words
    addr = (uint32_t*)(ConvertHexString2Int(buf+1,8)&0xfffffffc);
    words = bytes/8;
    
    ptr = buf+9;
//    g_DAbort = FALSE;
    while(words > 0) {
    
    	// Convert and WriteData
    	data = ConvertHexString2Int(ptr, 8);
    	hw_write32(addr, data);
    
    	// Update pointers
    	ptr   += 8;
    	words --;
    	addr  += 4;
    }
    
//    // ACK Command
//    if(!g_DAbort) {
    	SendACK();
//    } else {
//    	SendNAK();
//    }	
    
    return 0;

}
