
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



#include <stdio.h>
//#include <packet.h>
#include <stdlib.h>
#include <irq.h>


//===============================================
// IRQ handler Array
//===============================================

//Hard coding NUM_IRQ to 48 for now for git libc repo
//since NUM_IRQ is not bound until subsystem is selected...

//ISR_t irq_array[NUM_IRQ];
//char irq_vector_exists[NUM_IRQ] = {0};
const static uint32_t _NUM_IRQ = 48;
ISR_t irq_array[_NUM_IRQ];
char irq_vector_exists[_NUM_IRQ] = {0};

//===============================================
// Register IRQ handler
//===============================================
ISR_t register_handler(uint32_t irq_bit_number, ISR_t handler) 
{
    ISR_t old;
    old = irq_array[irq_bit_number];
    irq_array[irq_bit_number] = handler;
    irq_vector_exists[irq_bit_number] = 1;
    return old;
}

//===============================================
// Unregister IRQ handler
//===============================================
ISR_t unregister_handler(uint32_t irq_bit_number) 
{
    ISR_t old;
    old = irq_array[irq_bit_number];
    irq_array[irq_bit_number] = NULL;
    irq_vector_exists[irq_bit_number] = 0;
    return old;
}

//===============================================
// Dispatch IRQ's
//===============================================
int dispatch_irqs(uint32_t irq_bit_number)
{
    
    // Call the function
    if(irq_vector_exists[irq_bit_number] && irq_bit_number < _NUM_IRQ ) {
            irq_array[irq_bit_number]();
            return IRQ_TRUE;
    } else {
            pprintf("Error...Unhandled Exception(%d). Exiting test\n", irq_bit_number);
            exit(1);
            return IRQ_FALSE;
    }
}


