
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

// Header file for IRQ's

#include <inttypes.h>
//#include <irq_subsystem.h>

#ifndef __IRQ_HEADER_H__
#define __IRQ_HEADER_H__

//#ifdef __cplusplus
//extern "C" {
//#endif

#define IRQ_TRUE            ((bool)1)
#define IRQ_FALSE           ((bool)0)

// uint32_t hsp_atomic_bset(uint32_t *, uint32_t);
// uint32_t hsp_atomic_bclr(uint32_t *, uint32_t);

//===================================
// Typedefs
//===================================
typedef void (*ISR_t)();
typedef int (*IRQ_DISPATCH_t)(uint32_t irq);

//typedef enum IRQ_SEL_e defined in irq_subsystem.h and is subsystem specific


//===================================
// Prototypes
//===================================
ISR_t register_handler(uint32_t irq_bit_index, ISR_t handler); 
ISR_t unregister_handler(uint32_t irq_bit_index);

int dispatch_irqs(uint32_t irq_bit_index);

//#ifdef __cplusplus
//}
//#endif

#endif
