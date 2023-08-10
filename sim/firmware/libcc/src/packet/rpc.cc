
#include <packet.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define NEW_RPC
#ifdef NEW_RPC

//==============================================================================
uint32_t callRpc(
		 const char* callString, 
		 char* result, 
		 const uint32_t resultLen
		 ){
  uint16_t len = strlen(callString) +1;  //+1 for char code
  char buf[9];
  uint16_t i;
  char c = '\0';

  //Send the RPC call/packet
  putcPktHeader(buf,len,PACKET_RPC_CHAR);
  for(i=0; i<len-1; i++){
    putc(callString[i]);
  }
  putc('-');

  //Process what is recieved next 
  while(c != PACKET_RPC_CHAR ){

    if(getcPktHeader(buf,&c,&len)) continue;

    switch(c){

      //RPC result
      case PACKET_RPC_CHAR:        
	while(len>0){
	  *result++ = getc();
	  len--;
	}
        break;

      //Read memory
      case PACKET_READADDR_CHAR:
	getcReadPacketAndRespond(buf,len);
        break;

      //Write memory
      case PACKET_BINLOAD_CHAR:
	getcBinloadPacket(buf,len);
        break;

      default:
        pprintf("callRpc: Ignoring Unknown command char '%c' for callRpc\n", c);
	break;
    } //switch
    
  } //while
  return 0;
}



#else


//callString - string representation of the call including args
uint32_t callRpc(const char* callString, char* result, const uint32_t resultLen){
  uint32_t bytes_read;
  char buf[0x1004];                //4K+some spare

  buf[sizeof(buf)-1] = '\0';       //sanity to detect overrun
  
  buf[0] = PACKET_RPC_CHAR;
  strcpy(buf+1,callString);

  WritePacket(buf);                //Send RPC packet to the host  

  buf[0] = '\0';
  while(buf[0] != PACKET_RPC_CHAR){
    bytes_read = ReadPacket(buf);  //Get the result, or any reads or writes between...

    //Eventually may want to move the read and write out of here
    //use software int to handle them, or context swtich back to psiClient
    switch(buf[0]){
      case PACKET_RPC_CHAR: 
        break;
      case PACKET_READADDR_CHAR:
        //pprintf("callRpc: ReadCmd incercepted buf %s bytes_read %d\n", buf, bytes_read);
        ReadCmd(buf, bytes_read);
        buf[0] = '\0';
        break;
      case PACKET_BINLOAD_CHAR:
        //pprintf("callRpc: BinLoadCmd incercepted via callRpc\n");
        BinLoadCmd(buf, bytes_read);
        buf[0] = '\0';
        break;
      default:
        pprintf("callRpc: Ignoring Unknown command char for callRpc\n");      
    }
    if( buf[sizeof(buf)-1] != '\0'){
      pprintf("callRpc: FATAL BUFFER OVERRUN\n");
      exit(1);
    }    
  }

  strcpy(result,buf+1); //strip off the r

  return 0;  //Likely want to have some error handling at some point...    
}


#endif
