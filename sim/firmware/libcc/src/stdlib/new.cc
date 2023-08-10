#include <stdlib.h>

void * operator new(size_t size) {
  void * ptr;

  ptr = (void*) malloc(size);

  return ptr;
}
