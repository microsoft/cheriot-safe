
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

// Include file for string.h


#ifndef __STRING_H_INCLUDE__
#define __STRING_H_INCLUDE__

#include <stddef.h>
#include <gloss.h>

//#ifdef __cplusplus
//extern "C" {
//#endif

//=================================================
// Prototypes
//=================================================
int memcmp (const void *destaddr, const void *srcaddr, unsigned int len);
void *memcpy (void *destaddr, void const *srcaddr, unsigned int len);
void *memset (void *destaddr, int c, size_t len);
void *memset_rand (void *destaddr, size_t len);
void *memset_unique (void *destaddr, size_t len);

int strcmp (const char *s1, const char *s2);
char *strcpy(char *dest, const char *src);
size_t strlen(const char *s);
char *strncpy(char *dest, const char *src, size_t n) ;

int wordcmp (const void *destaddr, const void *srcaddr, int len);
void *wordcpy (void *destaddr, const void *srcaddr, int len);
void *wordset (void *destaddr, uint32_t c, size_t len);

//#ifdef __cplusplus
//}
//#endif

#endif
