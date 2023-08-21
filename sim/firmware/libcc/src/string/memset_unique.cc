
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

#include <string.h>  //has prototypes for functions defined here.  w/o this C++ name mangled
#include <stdlib.h>

// Memeset function
void *memset_unique (void *destaddr, size_t len)
{
	char *dest = (char*)destaddr;
	int i = 0;

	while (len-- > 0) {
		*dest++ = i++;
	}
	return destaddr;
}

