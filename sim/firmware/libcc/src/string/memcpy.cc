// Simple memcpy routine

#include <string.h>

void *memcpy (void *destaddr, const void *srcaddr, unsigned int  len)
{
  char *dest = (char *)destaddr;
  const char *src = (const char *)srcaddr;

  while (len-- > 0)
    *dest++ = *src++;
  return destaddr;
}

