
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



#ifndef __HSP_CTYPE_HEADER_INC__
#define __HSP_CTYPE_HEADER_INC__

//=============================================
// Defines
//=============================================
#define C_SP		0x001
#define C_LWR		0x002
#define C_UPR		0x004
#define C_DGT		0x008
#define C_ADGT		0x010
#define C_XDGT		0x020
#define C_ALP	 	0x040
#define C_BLNK		0x080
//#define C_CTL		0x100

//=============================================
// Prototypes
//=============================================
//#ifdef __cplusplus
//extern "C" {
//#endif

int isctype(int c, int type);


//#ifdef __cplusplus
//}
//#endif


#define isalpha(c) 		isctype(c, C_ALP)
#define isdigit(c) 		isctype(c, C_DGT)
#define isxdigit(c) 	isctype(c, C_XDGT)
#define isspace(c) 		isctype(c, C_SP)
#define isupper(c) 		isctype(c, C_UPR)
#define islower(c) 		isctype(c, C_LWR)
#define isblank(c) 		isctype(c, C_BLNK)

#endif
