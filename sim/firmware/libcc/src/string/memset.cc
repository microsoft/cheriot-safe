#include <stdlib.h>
#include <string.h>

// Memeset function
void *memset (void *destaddr, int c, size_t len)
{
	char *dest = (char*)destaddr;

	while (len-- > 0) {
		*dest++ = c;
	}
	return destaddr;
}

