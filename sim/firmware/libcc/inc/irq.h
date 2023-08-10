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
