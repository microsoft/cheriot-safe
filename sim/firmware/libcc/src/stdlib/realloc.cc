#include <stdint.h>
#include <stdlib.h>
#include <string.h>

void * realloc(void *ptr, size_t size)
{

//	pmalloc_t pm, pm_prev, pm_nxt;
	pmalloc_t pm;
	void * newptr;

	// If size = 0 then free
	if(size == 0) {
		free(ptr);
	}

	// Malloc new space
	newptr = malloc(size);

	// Check Malloc
	if(newptr == NULL) {
		return NULL;
	}

	// Check incoming pointer malloc if NULL
	if(ptr == NULL) {
		return newptr;
	}

	// Get malloc struct
	pm = (pmalloc_t) ((uintptr_t)ptr - sizeof(struct malloc_s));
//	pm_prev = (pmalloc_t)pm->prev_addr;
//	pm_nxt  = (pmalloc_t)pm->next_addr;

	// Copy old contents
	uint32_t csize;
	if(size < pm->size) {
		csize = size;
	} else {
		csize = pm->size;
	}
	memcpy(newptr, ptr, csize);

	// Free old
	free(ptr);

	// return new pointer
	return newptr;
	
}

