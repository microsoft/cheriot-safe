
#include <stdio.h>


int fputc(int c, FILE * stream)
{
	write((int)stream, (const char*)&c, 1);
	return c;
}

