#include <stdlib.h>
#include <string.h>

// Memeset function
void *wordset (void *destaddr, uint32_t c, size_t len)
{
	uint32_t *dest = (uint32_t*)destaddr;

	while (len-- > 0) {
		*dest++ = c;
	}
	return destaddr;
}

