#include <stdint.h>
#include <stdlib.h>

// lfsr inmplementation of rand()
/*
uint32_t t1 = 0, t2 = 0;

uint32_t rand(void)
{
    unsigned b;

    b = t1 ^ (t1 >> 2) ^ (t1 >> 6) ^ (t1 >> 7);
    t1 = (t1 >> 1) | (~b << 31);

    b = (t2 << 1) ^ (t2 << 2) ^ (t1 << 3) ^ (t2 << 4);
    t2 = (t2 << 1) | (~b >> 31);

    return (t1 ^ t2);
}

void srand(uint32_t seed)
{
	t1 = seed;
	t2 = seed/2;
}

*/

#define POLY_MASK_32    0xB4BCD35C
#define POLY_MASK_31    0x7A5BC2E3


// SRAND needs to be called to really randomize
uint32_t lfsr32 = 0xdeadbeef;
uint32_t lfsr31 = 0x23456789;

uint32_t shift_lfsr(uint32_t *lfsr, uint32_t polynomial_mask)
{
  uint32_t feedback;

  feedback = *lfsr&1;
  *lfsr >>=1;
  if(feedback ==1) {
    *lfsr ^= polynomial_mask;
  }
  return *lfsr;
}

uint32_t rand(void)
{
  shift_lfsr(&lfsr32, POLY_MASK_32);
  return (shift_lfsr(&lfsr32, POLY_MASK_32) ^ shift_lfsr(&lfsr31, POLY_MASK_31));
}


void srand(uint32_t seed)
{
	lfsr32 = seed;
	lfsr31 = seed/2;
}

uint32_t random_range(uint32_t min, uint32_t max)
{
    uint32_t random_val;
    random_val = (rand() % (max+1-min))+min;
    return random_val;
}

void random_fill(uint32_t * arr, uint32_t num) {
	uint32_t i;

	for(i=0;i<num;i++) 
	{
		hw_write32(arr+i,rand());
	}
}

#if 0
// BSD Implementation of rand()
static int rand_value = 1;
int rand(void)
{
	//rand_value = ((1103515245 * rand_value) + 12345) & 0x7fffffff;

	rand_value = (rand_value * 214013 + 2531011) & 0x7fffffff;

	return rand_value;
}


void srand(uint32_t seed)
{
	rand_value = seed;
}
#endif
