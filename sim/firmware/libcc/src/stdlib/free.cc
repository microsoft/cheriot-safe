#include <stdlib.h>

void free(void *ptr)
{
	pmalloc_t pm, pm_prev, pm_nxt;

	// Get malloc struct
	pm = (pmalloc_t) ((uintptr_t)ptr - sizeof(struct malloc_s));
	pm_prev	= (pmalloc_t)malloc_fromaddr(pm->prev_addr);
	pm_nxt  = (pmalloc_t)malloc_fromaddr(pm->next_addr);

	// Run some checks
	if(pm->magic_number == MALLOC_MAGIC_NUM && pm_nxt->magic_number == MALLOC_MAGIC_NUM && 
	   (pm->prev_addr == 0xffffffff || pm_prev->magic_number == MALLOC_MAGIC_NUM)) {

		// Free this area
		pm->status = HSP_FREE;
		
		// Aneal forward
		if(pm_nxt->status == HSP_FREE) {
			setMallocDescriptor(pm,pm->prev_addr, pm_nxt->next_addr, HSP_FREE);
			pm_nxt = (pmalloc_t)malloc_fromaddr(pm->next_addr);
			pm_nxt->prev_addr = (uintptr_t)pm;
		}

		// Aneal backword
		if(pm->prev_addr != 0xffffffff && pm_prev->status == HSP_FREE) {
			setMallocDescriptor(pm_prev,pm_prev->prev_addr, pm->next_addr, HSP_FREE);
			pm_nxt = (pmalloc_t)malloc_fromaddr(pm->next_addr);
			pm_nxt->prev_addr = (uintptr_t)pm_prev;
		}
	} else {
//		uint32_t * ptr = (uint32_t*)pm;
//		printf("Error: hsp_free failed (0x%08x) (0x%08x) (0x%08x) (0x%08x)\n", 
//			*(ptr+0), *(ptr+1), *(ptr+2), *(ptr+3));
	}
}


