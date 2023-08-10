#include <stdlib.h>
#include <string.h>

//=====================================================
// Calloc Function
//=====================================================
void *calloc(size_t num, size_t size)
{
  int bytes = num*size;
  void *ptr = malloc(bytes);
  if(ptr != NULL) {
    memset(ptr, 0, bytes);
  }

	return ptr;

}

