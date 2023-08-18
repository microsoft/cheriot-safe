
#ifndef  __MSFTDVPKG_APB_INIT_H__
#define 	__MSFTDVPKG_APB_INIT_H__

#include <inttypes.h>

#ifdef __cplusplus
extern "C" {
#endif

extern int apb_init();
extern void rdApb(uint32_t addr, uint32_t *data, uint32_t* error);
extern void wrApb(uint32_t addr, uint32_t  data, uint32_t* error);
extern void clkBus(uint32_t cnt);
extern void setError();

#ifdef __cplusplus
}
#endif

#define __DPI_APB__

static inline uint32_t jc_read32(uint32_t addr)
{
	uint32_t data;
	uint32_t error;

	rdApb(addr, &data, &error);
	return data;
}

static inline void jc_write32(uint32_t addr, uint32_t data)
{
	uint32_t error;
	wrApb(addr, data, &error);
}


#endif
