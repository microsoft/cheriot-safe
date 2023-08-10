#include <packet.h>
#include <stdlib.h>

static uint8_t hex_str_array[16] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

//============================================
// Convert Integer 2 Hex String
//============================================
void ConvertInt2HexString( uint32_t value, char * str, int width)
{
	int i;
	for(i=0;i<width;i++) {
		str[width-1-i] = hex_str_array[value&0xf];
        WR_RTC_RAM(8+i, str[width-1-i]);
		value >>=4;
	}

	return;
}

