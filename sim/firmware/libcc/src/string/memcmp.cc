// Simple memcpy routine

#include <string.h>

int memcmp (const void *destaddr, const void *srcaddr, unsigned int len)
{
  int retval=0;
  const char * dest, * src;
  dest = (char*) destaddr;
  src  = (char*) srcaddr;

  while (len-- > 0 && (retval=*dest++-*src++) == 0);
  return retval;
}

