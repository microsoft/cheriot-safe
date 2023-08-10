// Simple memcpy routine

#include <string.h>

void *wordcpy (void *destaddr, const void *srcaddr, int len)
{
  uint32_t *dest = (uint32_t *)destaddr;
  const uint32_t *src = (const uint32_t *)srcaddr;

  while (len-- > 0)
    *dest++ = *src++;
  return destaddr;
}

