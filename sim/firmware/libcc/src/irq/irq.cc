

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


