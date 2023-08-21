
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

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
//#include <packet.h>
//#include <pluton.h>
#include <stdarg.h>
//#include <subsystem_defs.h>

static const char HexTable[32] = { 
	'0', '1', '2', '3', '4', '5', '6', '7', 
	'8', '9', 'a', 'b', 'c', 'd', 'e', 'f',
	'0', '1', '2', '3', '4', '5', '6', '7', 
	'8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
};

static char str[17];

//==============================================================
// int2ascihex 
//==============================================================
static char * int2ascihex(uint32_t value, int ulcase, int *count)
{
	char * ptr = str+16;
	int cnt;

	cnt = 0;

	*ptr-- = '\0';
	do {
		*ptr = HexTable[(value&0xf)+ulcase];
		cnt++;
		value =(value>>4) &0x0fffffff;	
		if(value == 0) break;
		ptr--;
	} while(ptr > str);

	*count = cnt;

	return ptr ;
}

//==============================================================
// int2asci 
//==============================================================
static char * int2asci(int value, int *count, int sign)
{
	char * ptr = str+16;
	int lvalue = value;

	if(sign != 0 && value < 0) {
		lvalue = -value;
	}

	*ptr-- = '\0';
	do {
		*ptr = HexTable[lvalue%10];
		lvalue = lvalue/10;	
		if(lvalue == 0) break;
		ptr--;
	} while(ptr >  str);

	// Check for negative
	if(value < 0) {
		ptr--;
		*ptr = '-';
	}

	*count = 16-(ptr-str);
	return ptr;
}

//==============================================================
// States
//==============================================================
enum {
	STRING=0,
	FIRST_FORMAT,
	SECOND_FORMAT,
	FORMAT,
};

//==============================================================
// write_char 
//==============================================================
static int write_char_cnt(char * str, int leading, int used, int hex_str, int lead_zero)
{
	int i;
	int cnt = 0;
	char c = (lead_zero != 0) ? '0' : ' ';
	int fill;

	if(hex_str != 0 && lead_zero != 0) {
        *str++ = '0';
        *str++ = 'x';
        cnt+=2;
//		array[cnt++]  = '0';
//		array[cnt++]  = 'x';
	}
	if(leading > used) {
		fill = leading-used;
		for(i=0;(i<fill)&&(i<126);i++) {
			*str++ = c;
            cnt++;
			//array[cnt++] = c;
		}
	}
	if(hex_str != 0 && lead_zero == 0) {
        *str++ = '0';
        *str++ = 'x';
        cnt+=2;
		//array[cnt++]  = '0';
		//array[cnt++]  = 'x';
	}
	//write((uint32_t)stream, array, cnt);
	return cnt;
}

//==============================================================
// vsprintf 
//==============================================================
int pvsprintf(char * line, const char *format, va_list ap)
{
	//va_list ap;
	//va_start(ap, format);

    char * lptr = line;
	char c, *s, cval, *pfmt;
	int d; 
    //int lcnt;
    int count;
	int state = STRING;
	int size;
    int fmt_cnt;
    int lead_zero;
    int hex_str;
    int x;
	uint32_t u;

	//lcnt = 0;
	lead_zero = hex_str = size = 0;
	fmt_cnt = 0;
	pfmt = (char*) format;
	while((cval=*format++)) {
		switch(state) {
			case STRING:
				if(cval == '%') {
					state = FIRST_FORMAT;
				} else {
					fmt_cnt++;
					//lcnt++;
				}
				break;	
			case FIRST_FORMAT:
                for(x=0;x<fmt_cnt;x++) { *lptr++ = *pfmt++; }
                    
				//write((uint32_t)stream, pfmt, fmt_cnt);
				//lcnt += fmt_cnt;
				fmt_cnt = 0;	
				size = 0;
				hex_str = 0;
				lead_zero = 0;
				if(cval == '%') {
					fmt_cnt++;
					//lcnt++;
					pfmt = (char*) format-1;
					state = STRING;
					break;
				} else if(cval == '#') {
					hex_str = 1;
					state = SECOND_FORMAT;
					break;
				}
			case SECOND_FORMAT:
				if(cval == '0') {
					lead_zero = 1;
					state = FORMAT;
					break;
				}
			case FORMAT:
				switch(cval) {
					case 'u':
					case 'i':
					case 'd':
						d = va_arg(ap, int);
						s = int2asci(d,&count,'u'-cval);
						lptr += write_char_cnt(lptr, size, count, 0, lead_zero);
                        for(x=0;x<count;x++) { *lptr++ = *s++; }
						//lcnt+= write_char_cnt(stream, size, count, 0, lead_zero);
						//write((uint32_t)stream, s, count);
						//lcnt += count;
						state = STRING;
						pfmt = (char*) format;
						break;
					case 'c':
						c = (char) va_arg(ap, int);
						lptr += write_char_cnt(lptr, size, 1, 0, 0);
                        *lptr++ = c;
						//lcnt+= write_char_cnt(stream, size, 1, 0, 0);
						//write((uint32_t)stream,&c,1);
						state = STRING;
						pfmt = (char*) format;
						break;
					case 's':
						s = va_arg(ap, char *);
						count = (int)strlen(s);
						lptr += write_char_cnt(lptr, size, count, 0, 0);
                        for(x=0;x<count;x++) { *lptr++ = *s++; }
						//lcnt+= write_char_cnt(stream, size, count, 0, 0);
						//write((uint32_t)stream,s,count);
						//lcnt += count;
						state = STRING;
						pfmt = (char*) format;
						break;
					case 'X':
					case 'x':
						u = va_arg(ap, uint32_t);
						s = int2ascihex(u, (cval=='X'?16:0),&count);
						lptr += write_char_cnt(lptr, size, count, hex_str, lead_zero);
                        for(x=0;x<count;x++) { *lptr++ = *s++; }
						//lcnt+= write_char_cnt(stream, size, count, hex_str, lead_zero);
						//write((uint32_t)stream,s,count);
						//lcnt += count;
						state = STRING;
						pfmt = (char*) format;
						break;
#if 0
					case 'o':
					case 'f':
					case 'F':
					case 'e':
					case 'E':
					case 'g':
					case 'G':
					case 'a':
					case 'A':
					case 'p':
					case 'n':	
						state = STRING;
						count = 0;
						break;
#endif
					default: 
						if(cval >= 0x30 && cval < 0x3a) {
							size = (size*10) + (cval-0x30);
						}
						state = FORMAT;
						break;
				}
				break;
		}
	}

    for(x=0;x<fmt_cnt;x++) { *lptr++ = *pfmt++; }
    *lptr = '\0';
	//write((uint32_t)stream, pfmt, fmt_cnt);
	//va_end(ap);
    return( (int)(lptr-line));
}

//==============================================================
// fprintf 
//==============================================================
int cfprintf(FILE *stream, const char *format, ...)
{
		char line[1024];
		char * ptr = line;

		va_list ap;
		va_start(ap, format);

		int c_cnt = pvsprintf(ptr, format, ap);
		write((int)stream, line, c_cnt);

		va_end(ap);

		return c_cnt;
}

//==============================================================
// fprintf 
//==============================================================
int pfprintf(FILE *stream, const char *format, ...)
{
		char line[300];
		char * ptr = line;
		*ptr++ = 'P';
		//*ptr++ = __CPU_ID_NUM__;
		*ptr++ = '0';  //hardcode to 0 for git psi_libc, cpu id is/was for print server

		va_list ap;
		va_start(ap, format);

		int c_cnt = pvsprintf(ptr, format, ap);

		//WritePacket(line);

		va_end(ap);

		return c_cnt;
}

//==============================================================
// sprintf 
//==============================================================
int psprintf(char * line, const char *format, ...)
{
    va_list ap;
    va_start(ap, format);
    int c_cnt = pvsprintf(line, format, ap);
    va_end(ap);
    return c_cnt;
}

void print_test_header( const char * test )
{
	pprintf("===================================================\n");
	pprintf(" Starting Test %s\n", test);
	pprintf("===================================================\n");
}

void print_array(uint32_t * arr, const char * str, uint32_t num) {
	uint32_t i;

	for(i=0;i<num;i++) 
	{
		pprintf("%s word %d is 0x%08x\n",str,i,hw_read32(arr+i));
	}
}
