

#ifndef __HSP_CTYPE_HEADER_INC__
#define __HSP_CTYPE_HEADER_INC__

//=============================================
// Defines
//=============================================
#define C_SP		0x001
#define C_LWR		0x002
#define C_UPR		0x004
#define C_DGT		0x008
#define C_ADGT		0x010
#define C_XDGT		0x020
#define C_ALP	 	0x040
#define C_BLNK		0x080
//#define C_CTL		0x100

//=============================================
// Prototypes
//=============================================
//#ifdef __cplusplus
//extern "C" {
//#endif

int isctype(int c, int type);


//#ifdef __cplusplus
//}
//#endif


#define isalpha(c) 		isctype(c, C_ALP)
#define isdigit(c) 		isctype(c, C_DGT)
#define isxdigit(c) 	isctype(c, C_XDGT)
#define isspace(c) 		isctype(c, C_SP)
#define isupper(c) 		isctype(c, C_UPR)
#define islower(c) 		isctype(c, C_LWR)
#define isblank(c) 		isctype(c, C_BLNK)

#endif
