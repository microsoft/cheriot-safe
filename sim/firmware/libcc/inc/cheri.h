
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


//#include <stddef.h>

#ifndef __CHERI_H__
#define __CHERI_H__


#define CHERI_PERM_GLOBAL (1U << 0)
#define CHERI_PERM_LOAD_GLOBAL (1U << 1)
#define CHERI_PERM_STORE (1U << 2)
#define CHERI_PERM_LOAD_MUTABLE (1U << 3)
#define CHERI_PERM_STORE_LOCAL (1U << 4)
#define CHERI_PERM_LOAD (1U << 5)
#define CHERI_PERM_LOAD_STORE_CAP (1U << 6)
#define CHERI_PERM_ACCESS_SYS (1U << 7)
#define CHERI_PERM_EXECUTE (1U << 8)
#define CHERI_PERM_UNSEAL (1U << 9)
#define CHERI_PERM_SEAL (1U << 10)
#define CHERI_PERM_USER0 (1U << 11)
#define CHERI_PERM_USER1 (1U << 12)

#ifndef __ASSEMBLER__

#define cheri_address_get(x) __builtin_cheri_address_get(x)
#define cheri_address_set(x, y) __builtin_cheri_address_set((x), (y))
#define cheri_base_get(x) __builtin_cheri_base_get(x)
#define cheri_length_get(x) __builtin_cheri_length_get(x)
#define cheri_offset_get(x) __builtin_cheri_offset_get(x)
#define cheri_offset_set(x, y) __builtin_cheri_offset_set((x), (y))
#define cheri_tag_clear(x) __builtin_cheri_tag_clear(x)
#define cheri_tag_get(x) __builtin_cheri_tag_get(x)
#define cheri_is_valid(x) __builtin_cheri_tag_get(x)
#define cheri_is_invalid(x) (!__builtin_cheri_tag_get(x))
#define cheri_is_equal_exact(x, y) __builtin_cheri_equal_exact((x), (y))
#define cheri_is_subset(x, y) __builtin_cheri_subset_test((x), (y))
#define cheri_bounds_set(x, y) __builtin_cheri_bounds_set((x), (y))
#define cheri_bounds_set_exact(x, y) __builtin_cheri_bounds_set_exact((x), (y))
#define cheri_perms_get(x) ((cheri_perms_t)(__builtin_cheri_perms_get(x)))
#define cheri_perms_and(x, y) __builtin_cheri_perms_and((x), (__SIZE_TYPE__)(y))
#define cheri_perms_clear(x, y)                                                \
	__builtin_cheri_perms_and((x), ~(__SIZE_TYPE__)(y))

#define  CHERI_PERMS 	 (CHERI_PERM_LOAD | CHERI_PERM_STORE | CHERI_PERM_LOAD_STORE_CAP)
//static void* cap_build(void* root, ptraddr_t start, size_t len, size_t perms);

#endif // __ASSEMBLER__

#endif // __CHERI_H__
