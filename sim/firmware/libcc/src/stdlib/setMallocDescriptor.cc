
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

#include <stdint.h>
#include <stdlib.h>

void setMallocDescriptor(pmalloc_t ptr, uintptr_t prev, uintptr_t next, uint32_t status)
{
	ptr->prev_addr = prev;
	ptr->next_addr = next;
	ptr->status = status;
	ptr->magic_number = MALLOC_MAGIC_NUM;
	ptr->size = ((uintptr_t)next - (uintptr_t)ptr) - sizeof(struct malloc_s);
}

