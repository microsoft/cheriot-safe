// Simple memcpy routine

#include <string.h>

int wordcmp (const void *destaddr, const void *srcaddr, int len)
{
  int retval=0;
  const uint32_t * dest, * src;
  dest = (uint32_t*) destaddr;
  src  = (uint32_t*) srcaddr;

  while (len-- > 0 && (retval=*dest++-*src++) == 0);
  return retval;
}

