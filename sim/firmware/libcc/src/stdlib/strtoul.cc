
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

#include <stdlib.h>  //has prototypes for functions defined here.  w/o this C++ name mangle
#include <ctype.h>
#include <inttypes.h>

/* STRTOUL.C */
/*
 * Convert a string to an unsigned long integer.
 *
 * Ignores `locale' stuff.  Assumes that the upper and lower case
 * alphabets and digits are each contiguous.
 */

#define ULONG_MIN 		(-4294967295UL -1)
#define ULONG_MAX		( 4294967295UL )

uint32_t strtoul(
        const char *nptr,
        char **endptr,
        int base)
{
        const char *s = nptr;
        uint32_t acc;
        int c;
        uint32_t cutoff;
        int neg = 0, any, cutlim;

        /*
         * See strtol for comments as to the logic used.
         */
        do {
                c = *s++;
        } while (isspace(c));
        if (c == '-') {
                neg = 1;
                c = *s++;
        } else if (c == '+')
                c = *s++;
        if ((base == 0 || base == 16) &&
            (c == '0') && (*s == 'x' || *s == 'X')) {
                c = s[1];
                s += 2;
                base = 16;
        }
        if (base == 0)
                base = c == '0' ? 8 : 10;
        cutoff = (uint32_t)ULONG_MAX / base;
        cutlim = (uint32_t)ULONG_MAX % base;
        for (acc = 0, any = 0;; c = *s++) {
                if (isdigit(c))
                        c -= '0';
                else if (isalpha(c))
                        c -= isupper(c) ? 'A' - 10 : 'a' - 10;
                else
                        break;
                if (c >= base)
                        break;
                if (any < 0 || acc > cutoff || (acc == cutoff && c > cutlim))
                        any = -1;
                else {
                        any = 1;
                        acc = acc * base;
                        acc += c;
                }
        }
        if (any < 0) {
                acc = (uint32_t) ULONG_MAX;
/*              errno = ERANGE; */
        } else if (neg)
                acc = (uint32_t)-(uint32_t)acc;
        if (endptr != 0)
                *endptr = (char *)(any ? s - 1 : nptr);
        return (acc);
}

