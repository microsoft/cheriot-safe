
// =====================================================
// Copyright (c) Microsoft Corporation.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//    http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =====================================================


//#define __DEBUG_RTC__
#include <packet.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//#include <subsystem_defs.h>
#include <gloss.h>

//============================================
// WritePacket
//============================================
uint32_t WritePacket( const char * packet)
{
	#if defined(SSY_CPU_WRITE_SLAVE) && defined(SSY_HSP_SCARLETT)
		
        #ifdef SSY_CPU_PKT_LOCK_ADDR
            getlock(SSY_CPU_PKT_LOCK_ADDR);
        #endif

		ptrWRITE_SLAVE_t write_slv = (ptrWRITE_SLAVE_t)SSY_CPU_WRITE_SLAVE;
		while(write_slv->cmd_stat != SLAVE_CMD_IDLE);

		write_slv->cmd_stat = SLAVE_CMD_RDY;
		write_slv->packet = packet;
		write_slv->packet_length = strlen(packet);

		hw_write32((uint32_t*)SSY_CPU_PSP_IRQ_INTEN_ADDR, hw_read32((uint32_t*)SSY_CPU_PSP_IRQ_INTEN_ADDR) | (SSY_CPU_RP2SP_MSG_INTEN_VAL));
		hw_write32((uint32_t*)SSY_CPU_RP2SP_MB_INTEN_ADDR, 0x1);
		hw_write32((uint32_t*)SSY_CPU_RP2SP_MB_CNTL_ADDR, 0x1);

		EI_IRQ();
		while(write_slv->cmd_stat != SLAVE_CMD_IDLE);
		DI_IRQ();

		#ifdef SSY_CPU_PKT_LOCK_ADDR
			releaselock(SSY_CPU_PKT_LOCK_ADDR);
		#endif

	#else
		#ifdef SSY_CPU_PKT_LOCK_ADDR
			getlock(SSY_CPU_PKT_LOCK_ADDR);
		#endif

		uint32_t i;
		uint32_t packet_length = strlen(packet);
		#ifndef NO_PKTS4PRINT
		char str[9];
		uint8_t mg_num[3] = MAGIC_STRING;
		
		// Send Plus
		putc('+');

		// Send Magic Number
		for(i=0;i<sizeof(mg_num);i++) {
			putc(mg_num[i]);
		}

		// Send packet count
		ConvertInt2HexString(packet_length, str, 4);
		for(i=0;i<4;i++) {
			putc(str[i]);	
		}

		// Send Packet
		for(i=0;i<packet_length;i++) {
			putc(packet[i]);
		}

		// Send minus
		putc('-');
		#else
		// Send Packet w/o leading P<cpu_num>
		for(i=2;i<packet_length;i++) {
			putc(packet[i]);
		}
		#endif

		#ifdef SSY_CPU_PKT_LOCK_ADDR
			releaselock(SSY_CPU_PKT_LOCK_ADDR);
		#endif

	#endif

	return 0;
	
}


