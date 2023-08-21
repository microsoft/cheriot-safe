
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

// Lib Gloss Definitins

#ifndef __GLOSS_H_INCLUDE__
#define __GLOSS_H_INCLUDE__

#include <inttypes.h>

//#ifdef __cplusplus
//extern "C" {
//#endif 

void _flush (int);

//=================================================
// Defines
//=================================================
#define GLOSS_NULL                  (void*)0
#define TRUE                        1
#define FALSE                       0
#define write(fd,str,len)           _write(fd,str,len)
#define flush(fd)                   _flush(fd)
#define flush_uart()                flush(1)
#define read(fd,buf,bytes)          _read(fd,buf,bytes)
#define sbrk(size)                  _sbrk(size)
#define kill(pid,sig)               _kill(pid,sig)
#define getpid()                    _getpid()
#define close(file)                 _close(file)
#define fstat(file,st)              _fstat(file,st)
#define lseek(file,ptr,dir)         _lseek(file,ptr,dir)
#define isatty(file)                _isatty(file)
#define getlock(addr)               _getlock((unsigned int*)(addr))
#define releaselock(addr)           _releaselock((unsigned int*)(addr))

//=================================================
// Typedefs
//=================================================
typedef uint32_t* FILE;

enum STDIO_DEF_e {
    STDIN=0,
    STDOUT=1,
    STDERR=2,
};

//=================================================
// Structures
//=================================================
struct stat {
    int dummy;
};

//=================================================
// Prototypes
//=================================================
uint32_t FlashWriteBuffer( uint32_t faddr, char * buffer, uint32_t bytes);
int _read(int fd, char * buf, int nbytes);
int _write(int file, const char *ptr, int len);
void * _sbrk(int size);
int _kill(int pid, int sig);
int _getpid();
int _close(int file);
int _fstat(int file, struct stat *st);
int _lseek(int file, int ptr, int dir );
int _isatty(int file);
void _getlock(unsigned int *addr);
void _releaselock(unsigned int*);

int MboxFunc(int mbox_id, int func, int *cnt, unsigned int *msg);

//#ifdef __cplusplus
//}
//#endif 

#endif
