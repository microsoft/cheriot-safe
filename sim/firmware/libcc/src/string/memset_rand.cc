#include <string.h>  //has prototypes for functions defined here.  w/o this C++ name mangled
#include <stdlib.h>

// Memeset function
void *memset_rand (void *destaddr, size_t len)
{
	char *dest = (char*)destaddr;

	while (len-- > 0) {
		*dest++ = rand();
	}
	return destaddr;
}

