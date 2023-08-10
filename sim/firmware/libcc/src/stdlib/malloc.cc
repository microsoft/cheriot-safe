#include <cheri.h>
#include <stdint.h>
#include <stdlib.h>

extern uint32_t _heap_start;
extern uint32_t _heap_end;


void *HeapCap;
uint8_t MallocInit = 1;

//=====================================================
// Malloc init Function
//=====================================================
void malloc_init(void* heap, size_t len)
{
	pmalloc_t pm;
	pmalloc_t pm_nxt;

	if(MallocInit == 1) {

		// Init malloc
//		hsp_printf("Initializing IRAM malloc array Heap Start(0x%08x) End(0x%08x)\n", &_iram_heap_start, &_iram_heap_end);
		HeapCap = heap;
		pm = (pmalloc_t)heap;
		pm_nxt = (pmalloc_t)((uintptr_t)heap + len - sizeof(struct malloc_s));
		setMallocDescriptor(pm, 0xffffffff, (uint32_t)pm_nxt, HSP_FREE);
		setMallocDescriptor(pm_nxt, (uint32_t)pm, 0, HSP_END);
		MallocInit = 0;
	}

}

//=====================================================
// Malloc Function
//=====================================================
void *malloc(size_t size)
{
	pmalloc_t pm;
	pmalloc_t pm_nxt;
	pmalloc_t pm_new;

	// Adjust size to word boundary
	if(size == 0) {
		return (void *) NULL;
	}
	size += (((size^0x7)+1)&0x7);

	pm = (pmalloc_t)HeapCap;

	// Do Malloc Walk
	do {
		if(pm->status == HSP_FREE && size <= pm->size) {
			// Can only split if leftover is ge 0x14
			if((pm->size - size) < sizeof(struct malloc_s) + sizeof(void *)) {
				pm->status = HSP_USED;
			} else {
				pm_new = (pmalloc_t) ((uintptr_t)pm+sizeof(struct malloc_s)+size);
				pm_nxt = (pmalloc_t) malloc_fromaddr(pm->next_addr);
				setMallocDescriptor(pm, (uintptr_t)malloc_fromaddr(pm->prev_addr), (uintptr_t)pm_new, HSP_USED);
				setMallocDescriptor(pm_new, (uintptr_t)pm, (uintptr_t)pm_nxt,HSP_FREE);
				pm_nxt->prev_addr = (uintptr_t) pm_new;
			}
			return (void*)((uintptr_t)pm+sizeof(struct malloc_s));
		}	
		pm = (pmalloc_t)malloc_fromaddr(pm->next_addr);
	} while (pm->status != HSP_END);

	return (void *)NULL;

}

