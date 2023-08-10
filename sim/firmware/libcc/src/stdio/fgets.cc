
#include <stdio.h>

char * fgets(char *s, int size, FILE *stream)
{
	char *ptr;
	ptr = s;
	int  cnt;
	char c;
	cnt = 0;
	do {
		read((int)stream, &c, 1);
		*ptr++ = c;
	} while(cnt++ < size && c != '\n');

	*ptr = '\0';

	return s;
}

