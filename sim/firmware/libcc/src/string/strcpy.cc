#include <string.h>
// String copy function

char *strcpy(char *dest, const char *src)
{
	char * dst = dest;
	while((*dst++ = *src++) != '\0');
	return dest;
}

