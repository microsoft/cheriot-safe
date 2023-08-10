
char * pfgets(char *s, uint32_t size){
  callRpc("gets",s,size);
  return s;  
}
