

#include <stdlib.h>
#include <cheri.h>

extern void *globalRoot;


void * get_ptr(unsigned long start, size_t len)
{
	void* ret = globalRoot;

	ret = cheri_perms_and(ret, CHERI_PERMS);
	ret = cheri_address_set(ret, start);
	ret = cheri_bounds_set(ret, len);

	return ret;
}


