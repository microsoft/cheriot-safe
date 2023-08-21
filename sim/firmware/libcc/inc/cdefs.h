
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

#ifndef __CDEFS_H__
#define __CDEFS_H__

/*
 *  * Testing against Clang-specific extensions.
 *   */
#ifndef __has_attribute
#   define __has_attribute(x) 0
#endif
#ifndef __has_extension
#   define __has_extension __has_feature
#endif
#ifndef __has_feature
#   define __has_feature(x) 0
#endif
#ifndef __has_include
#   define __has_include(x) 0
#endif
#ifndef __has_builtin
#   define __has_builtin(x) 0
#endif

#if defined(__cplusplus)
#   define __BEGIN_DECLS                                                      \
            extern "C"                                                             \
                    {
#   define __END_DECLS }
#   define __DECL extern "C"
#else
#   define __BEGIN_DECLS
#   define __END_DECLS
#   define __DECL
#endif

#define __weak_symbol __attribute__((weak))
#define __dead2 __attribute__((noreturn))
#define __pure2 __attribute__((const))
#define __noinline __attribute__((noinline))
#define __unused __attribute__((unused))
#define __used __attribute__((used))
#define __packed __attribute__((packed))
#define __aligned(x) __attribute__((aligned(x)))
#define __section(x) __attribute__((section(x)))
#define __alloc_size(x) __attribute__((alloc_size(x)))
#define __alloc_align(x) __attribute__((alloc_align(x)))
#define __cheri_callback __attribute__((cheri_ccallback))
#define __cheri_compart(x) __attribute__((cheri_compartment(x)))
#define __cheri_libcall __attribute__((cheri_libcall))

#define offsetof(a, b) __builtin_offsetof(a, b)

#define __predict_true(exp) __builtin_expect((exp), 1)
#define __predict_false(exp) __builtin_expect((exp), 0)

#define __XSTRING(a) __STRING(a)
#define __STRING(a) #a

#ifndef __DECONST
#   define __DECONST(type, var)                                               \
            ((type)(__intcap_t)(const void *__capability)(var))
#endif

#ifndef __DEVOLATILE
#   define __DEVOLATILE(type, var)                                            \
            ((type)(__intcap_t)(volatile void *__capability)(var))
#endif

#ifndef __DEQUALIFY
#   define __DEQUALIFY(type, var)                                             \
            ((type)(__intcap_t)(const volatile void *__capability)(var))
#endif

#define __containerof(x, s, m)                                                 \
        __DEQUALIFY(s *, (const volatile char *)(x)-__offsetof(s, m))

#endif // _CDEFS_H_
