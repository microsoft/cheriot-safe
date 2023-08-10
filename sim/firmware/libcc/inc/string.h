// Include file for string.h


#ifndef __STRING_H_INCLUDE__
#define __STRING_H_INCLUDE__

#include <stddef.h>
#include <gloss.h>

//#ifdef __cplusplus
//extern "C" {
//#endif

//=================================================
// Prototypes
//=================================================
int memcmp (const void *destaddr, const void *srcaddr, unsigned int len);
void *memcpy (void *destaddr, void const *srcaddr, unsigned int len);
void *memset (void *destaddr, int c, size_t len);
void *memset_rand (void *destaddr, size_t len);
void *memset_unique (void *destaddr, size_t len);

int strcmp (const char *s1, const char *s2);
char *strcpy(char *dest, const char *src);
size_t strlen(const char *s);
char *strncpy(char *dest, const char *src, size_t n) ;

int wordcmp (const void *destaddr, const void *srcaddr, int len);
void *wordcpy (void *destaddr, const void *srcaddr, int len);
void *wordset (void *destaddr, uint32_t c, size_t len);

//#ifdef __cplusplus
//}
//#endif

#endif
