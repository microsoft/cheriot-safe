

#include <packet.h>
#include <stdio.h>
#include <stdlib.h>

enum {
	WAIT_4_PLUS=0,
	MAGIC_NUMBER,
	BYTE_COUNT,
	RECEIVE_PACKET,
	RECEIVE_MINUS,
};


//============================================
// ReadPacket
//============================================
char extbuffer[100];
int ccnt;
uint32_t ReadPacket( char * buffer )
{
	char c;
	uint32_t state, cnt=0, bytes=0;
	uint32_t plus_cnt;
	uint8_t mg_num[3] = MAGIC_STRING;

	state = WAIT_4_PLUS;
	plus_cnt = 0;
	ccnt = 0;

	while(1) {
		c=getc();
        //putc(c);
		if(ccnt < 100) extbuffer[ccnt++] = c;

		// Check for plus count
		if(c == '+') {
			plus_cnt++;
		} else {
			plus_cnt = 0;
		}

		// If we get 100 then reset state
		if(plus_cnt == 50) {
		  //ResetHandler();  //Doesn't exist in test template anymore
		} else
		// Else tarry on
		switch(state) {
			case WAIT_4_PLUS: 
				if(c == '+') {
					state = MAGIC_NUMBER; 
					cnt = 0;
				}
				break;
			case MAGIC_NUMBER:
				if(c == mg_num[cnt]) {
					if(++cnt == sizeof(mg_num)) {
						state = BYTE_COUNT;
						cnt = 0;
						bytes = 0;
					}
				} else {
					if(c == '+') {
						cnt = 0;
						state = MAGIC_NUMBER;
					} else {
						state = WAIT_4_PLUS;
					}
				}
				break;
			case BYTE_COUNT:
				buffer[cnt] = c;
				if(++cnt == 4) {
					buffer[cnt] = '\0';
					bytes = strtoul((const char*)buffer, (char**)NULL, 16);
					cnt = 0;
					if(bytes == 0) {
						state = RECEIVE_MINUS;
					} else {
						state = RECEIVE_PACKET;
					}
				}
				break;
			case RECEIVE_PACKET:	
				if(bytes <= RECEIVE_BUFFER_SIZE) {
					buffer[cnt] = c;
				}
				if(++cnt == bytes) {
					state = RECEIVE_MINUS;
				}
				break;
			case RECEIVE_MINUS:
				if(c != '-' || bytes > RECEIVE_BUFFER_SIZE) {
					SendNAK();
				} else {
                    buffer[cnt] = '\0';
					return bytes;
					
				}
				state = WAIT_4_PLUS;
				break;
			default:
				state = WAIT_4_PLUS;
				break;
		}
	}

	return 0;
}

