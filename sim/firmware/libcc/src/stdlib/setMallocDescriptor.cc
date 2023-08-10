#include <stdint.h>
#include <stdlib.h>

void setMallocDescriptor(pmalloc_t ptr, uintptr_t prev, uintptr_t next, uint32_t status)
{
	ptr->prev_addr = prev;
	ptr->next_addr = next;
	ptr->status = status;
	ptr->magic_number = MALLOC_MAGIC_NUM;
	ptr->size = ((uintptr_t)next - (uintptr_t)ptr) - sizeof(struct malloc_s);
}

