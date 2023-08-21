
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
#include <string.h>

//============================================
// Binary Load
//============================================
int BinLoadCmd(char * buf, uint32_t size)
{
	uint32_t addr;
    char * ptr = buf+9;
    uint32_t bytes = size - 9;
    //    g_DAbort = FALSE;

	if(size < 9) {
		SendNAK();
		return 1;
	}

	// Get Address 
	addr = ConvertHexString2Int(buf+1,8)&0xfffffffc;

    // Convert to binary
    ConvertHexArray2Bin(ptr, bytes);

    memcpy((uint8_t*)addr, ptr, bytes/2);  //bytes/2 since binary is half the size of ASCII  

//	// ACK Original
//	if(!g_DAbort) {
		SendACK();
//	} else {
//		SendNAK();
//	}

	return 0;
}
