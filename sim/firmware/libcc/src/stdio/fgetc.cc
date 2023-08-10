
#include <stdio.h>

int fgetc(FILE *stream)
{
	char buf;
	read((int)stream, &buf, 1);

	return (int) buf;

}
