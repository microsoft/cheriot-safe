
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


#include <ctype.h>

char ctype_table[128] = {
	// 0x00
	0, 0, 0, 0, 	
	0, 0, 0, 0, 
	0,    C_SP|C_BLNK, C_SP, C_SP, 
	C_SP, C_SP, C_SP, 0,

	// 0x10
	0, 0, 0, 0, 
	0, 0, 0, 0, 
	0, 0, 0, 0, 
	0, 0, 0, 0,

	// 0x20
	C_SP|C_BLNK, 0, 0, 0, 
	0, 0, 0, 0, 
	0, 0, 0, 0, 
	0, 0, 0, 0,

	// 0x30
	C_DGT|C_ADGT|C_XDGT, C_DGT|C_ADGT|C_XDGT, C_DGT|C_ADGT|C_XDGT, C_DGT|C_ADGT|C_XDGT, 
	C_DGT|C_ADGT|C_XDGT, C_DGT|C_ADGT|C_XDGT, C_DGT|C_ADGT|C_XDGT, C_DGT|C_ADGT|C_XDGT, 
	C_DGT|C_ADGT|C_XDGT, C_DGT|C_ADGT|C_XDGT, 0, 0, 
	0, 0, 0, 0,

	// 0x40
	0, 						   C_UPR|C_ADGT|C_XDGT|C_ALP, C_UPR|C_ADGT|C_XDGT|C_ALP, C_UPR|C_ADGT|C_XDGT|C_ALP, 
	C_UPR|C_ADGT|C_XDGT|C_ALP, C_UPR|C_ADGT|C_XDGT|C_ALP, C_UPR|C_ADGT|C_XDGT|C_ALP, C_UPR|C_ADGT|C_ALP, 
	C_UPR|C_ADGT|C_ALP,        C_UPR|C_ADGT|C_ALP,        C_UPR|C_ADGT|C_ALP,        C_UPR|C_ADGT|C_ALP, 
	C_UPR|C_ADGT|C_ALP,        C_UPR|C_ADGT|C_ALP,        C_UPR|C_ADGT|C_ALP,        C_UPR|C_ADGT|C_ALP,

	// 0x50
	C_UPR|C_ADGT|C_ALP, C_UPR|C_ADGT|C_ALP, C_UPR|C_ADGT|C_ALP, C_UPR|C_ADGT|C_ALP, 
	C_UPR|C_ADGT|C_ALP, C_UPR|C_ADGT|C_ALP, C_UPR|C_ADGT|C_ALP, C_UPR|C_ADGT|C_ALP, 
	C_UPR|C_ADGT|C_ALP, C_UPR|C_ADGT|C_ALP, C_UPR|C_ADGT|C_ALP, 0, 
	0, 0, 0, 0,

	// 0x60
	0, 						   C_LWR|C_ADGT|C_XDGT|C_ALP, C_LWR|C_ADGT|C_XDGT|C_ALP, C_LWR|C_ADGT|C_XDGT|C_ALP, 
	C_LWR|C_ADGT|C_XDGT|C_ALP, C_LWR|C_ADGT|C_XDGT|C_ALP, C_LWR|C_ADGT|C_XDGT|C_ALP, C_LWR|C_ADGT|C_ALP, 
	C_LWR|C_ADGT|C_ALP,        C_LWR|C_ADGT|C_ALP,        C_LWR|C_ADGT|C_ALP,        C_LWR|C_ADGT|C_ALP, 
	C_LWR|C_ADGT|C_ALP,        C_LWR|C_ADGT|C_ALP,        C_LWR|C_ADGT|C_ALP,        C_LWR|C_ADGT|C_ALP,

	// 0x70
	C_LWR|C_ADGT|C_ALP, C_LWR|C_ADGT|C_ALP, C_LWR|C_ADGT|C_ALP, C_LWR|C_ADGT|C_ALP, 
	C_LWR|C_ADGT|C_ALP, C_LWR|C_ADGT|C_ALP, C_LWR|C_ADGT|C_ALP, C_LWR|C_ADGT|C_ALP, 
	C_LWR|C_ADGT|C_ALP, C_LWR|C_ADGT|C_ALP, C_LWR|C_ADGT|C_ALP, 0, 
	0, 0, 0, 0
};

int isctype(int c, int type)
{
	return ctype_table[c] & type;
}

