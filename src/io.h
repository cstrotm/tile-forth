/*
  C BASED FORTH-83 MULTI-TASKING IO MANAGEMENT DEFINITIONS

  Copyright (C) 1988-1990 by Mikael R.K. Patel

*/


/* INCLUDE FILES: STANDARD INPUT/OUTPUT */

#include <stdio.h>


/* STANDARD INPUT AND OUTPUT DESCRIPTORS */

#define STDIN  0
#define STDOUT 1


/* WHITE SPACE DEFINITION, CHARACTER MASK AND DIRECTORY SEPERATOR */

#define ISSPACE(c) ((c) <= ' ')
#define CMASK 0377
#define DIRSEPCHAR '/'


/* INFILE BUFFER DEFINITION */

#define BUFSIZE 1024

typedef struct {
    CSTR fn;
    INT  ln;
    INT  fd;
    INT  bufp;
    INT  cc;
    CHAR buf[BUFSIZE];
} file_buffer, *INFILE_BUFFER;

extern INFILE_BUFFER io_infstack[];
extern INT io_infsp;


/* OUTFILE AND ERROR FILE DEFINITION */

extern FILE *io_outf;
extern FILE *io_errf;


/* APPEND ORDER FOR IO_PATH */

#define IO_PATH_FIRST 0
#define IO_PATH_LAST 1


/* IO MANAGE ERROR CODES */

#define IO_NO_ERROR 0
#define IO_EOF -1
#define IO_PATH_DEFINED -1
#define IO_FILE_INCLUDED -1
#define IO_UNKNOWN_FILE -2
#define IO_UNKNOWN_PATH -2
#define IO_TOO_MANY_PATHS -3
#define IO_TOO_MANY_FILES -3


/* EXPORTED MACROS, FUNCTIONS, AND PROCEDURES */

#define io_getchar() \
    ((io_infstack[io_infsp] -> bufp < io_infstack[io_infsp] -> cc) ? \
     (long) io_infstack[io_infsp] -> buf[io_infstack[io_infsp] -> bufp++] & CMASK : \
     (long) io_fillbuf())

#define io_eof() (io_infsp == -1)
#define io_not_eof() (io_infsp > -1)

#define io_source() (io_infstack[io_infsp] -> fn)
#define io_line() (io_infstack[io_infsp] -> ln)
#define io_newline() (++io_line())

INT  io_path();
INT  io_infile();
INT  io_fillbuf();

VOID io_flush();

VOID io_skip();
VOID io_scan();
VOID io_skipspace();

VOID io_initiate();
VOID io_finish();
