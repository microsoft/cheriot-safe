/*******************************************************************
 * ECC generated using hamming code.
 ****/

#include <edc.h>
#include <stdio.h>
//==================================================
// Parity defines
//==================================================
#define PARITY1		 0x0055555556aaad5bULL
#define PARITY2		 0x009999999b33366dULL
#define PARITY4		 0x00e1e1e1e3c3c78eULL
#define PARITY8		 0x00fe01fe03fc07f0ULL
#define PARITY16	 0x00fffe0003fff800ULL
#define PARITY32	 0x00fffffffc000000ULL
#define PARITY64        (uint64_t) 0x01ffffffffffffff
#define PARITYX         (uint64_t) 0x0100000000000000

//==================================================
// Compute Parity
// Compute the parity for specific bit positions based on Hamming code
//==================================================
static uint32_t ComputeParity(uint64_t Parity)
{
	Parity ^= Parity >>  32;
	Parity ^= Parity >>  16;
	Parity ^= Parity >>  8;
	Parity ^= Parity >>  4;
	Parity ^= Parity >>  2;
	Parity ^= Parity >>  1;
	return (uint32_t)(Parity&0x1);
}

//==================================================
// Generate ECC
// The hex numbers determine the bit selections for Hamming code based ECC generation
//==================================================
uint64_t GenerateECC(uint64_t data, ENCRYPTION_TYPE_t secded_mode)
{
	uint64_t p1, p2, p4, p8, p16, p32, p64;
	uint64_t addr_data;

	p1  = ComputeParity(data & (PARITY1  | secded_mode));
	p2  = ComputeParity(data & (PARITY2  | secded_mode));
	p4  = ComputeParity(data & (PARITY4  | secded_mode));
	p8  = ComputeParity(data & (PARITY8  | secded_mode));
	p16 = ComputeParity(data & (PARITY16 | secded_mode));
	p32 = ComputeParity(data & (PARITY32 | secded_mode));
  p64 = ComputeParity(data & (PARITY64 | secded_mode)) ^ p1 ^ p2 ^ p4 ^ p8 ^ p16 ^ p32;
	
	//Place the ECC and the data in the requisite bit positions
  if(secded_mode == 0) {
	  addr_data = (p32<<37) | (p16<<31) | (p8<<24) | (p4<<18) | (p2<<12) | (p1<<5) | 
				  ((data&0xF8000000)<<5) | ((data&0x7E00000)<<4)  | ((data&0x1F0000)<<3) | 
				  ((data&0xF800)<<2)     | ((data&0x7E0)<<1)      |  (data&0x1F);
  } else {
	  addr_data = (p64<<38) | (p32<<32) | (p16<<27) | (p8<<21) | (p4<<16) | (p2<<10) | (p1<<5) | 
				  ((data&0xf8000000)<<6) | ((data&0x7800000)<<5) | ((data&0x07C0000)<<4)  | ((data&0x03C000)<<3) | 
				  ((data&0x3E00)<<2)     | ((data&0x1E0)<<1)      |  (data&0x1F);
  }
	
	return addr_data;
}

//==================================================
// ConCatAddrData
// Concatenate a modified address and data in order to generate the ECC.
//==================================================
uint64_t ConCatAddrData(uint32_t Addr, uint32_t Data, uint32_t Width, ENCRYPTION_TYPE_t secded_mode)
{
	uint32_t msb = ((Addr>>(Width-1))&0x1)^0x1;
	uint32_t j;
	uint32_t k;

	k = ((1<<Width)-1);
	Addr &= k;  
	//genEccAddr(addr,width) :  {{(24-abits){~addr[abits-1]}}, addr[abits-1:2], 2'b00};
	Addr &= (secded_mode == 0) ? 0xFFFFFC : 0x1FFFFFC;

	//Extend the width sized address to 24 bits using msb
	uint32_t max_addr = (secded_mode == 0) ? 24 : 25;
	for(j=Width;j<max_addr;j++) {
	  Addr |= msb<<j;
	}
	
	uint64_t concat = (uint64_t)Addr<<32 | (uint64_t)Data;

	// Uncomment for future debug
	/* pprintf("Input Addr: 0x%08x\n", (uint32_t)(Addr)); */
	/* pprintf("Padded Data: 0x%08x%08x\n", (uint32_t)(concat>>32), (uint32_t)concat); */

	return concat;
	
}

uint64_t ConstructECC (uint32_t Addr, uint32_t Data, uint32_t Width, ENCRYPTION_TYPE_t secded_mode)
{
	uint64_t concatresult;

	concatresult = ConCatAddrData(Addr, Data, Width, secded_mode);

	return GenerateECC(concatresult, secded_mode);
}


