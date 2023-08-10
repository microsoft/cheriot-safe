#include <string.h>  //has prototypes for functions defined here.  w/o this C++ name mangled
#include <stdlib.h>

// Memeset function
void *memset_unique (void *destaddr, size_t len)
{
	char *dest = (char*)destaddr;
	int i = 0;

	while (len-- > 0) {
		*dest++ = i++;
	}
	return destaddr;
}

