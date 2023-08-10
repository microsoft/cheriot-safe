
#include <stdio.h>
#include <string.h>

int fputs(const char *s, FILE *stream)
{
	return write((int)stream, (char *)s, strlen(s));
}
