#include <stdlib.h>

void operator delete (void* ptr) {
  free(ptr);
  return;
}

void operator delete (void* ptr, size_t size) {
  free(ptr);
  return;
}


