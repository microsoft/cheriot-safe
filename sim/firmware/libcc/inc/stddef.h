
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

#ifndef __STDDEF_H__
#define __STDDEF_H__

#ifndef NULL
#	ifdef __cplusplus
#		define NULL nullptr
#	else
#		define NULL ((void *)0)
#	endif
#endif

typedef __SIZE_TYPE__    size_t;
typedef signed int       ssize_t;
typedef __PTRDIFF_TYPE__ ptrdiff_t;
typedef __UINTPTR_TYPE__ maxalign_t;

/// CHERI C definition for an address-sized integer
typedef __PTRADDR_TYPE__ ptraddr_t;

/// Compatibility definition
typedef ptraddr_t vaddr_t;

#endif // __STDDEF_H__
