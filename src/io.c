/*
  C BASED FORTH-83 MULTI-TASKING IO MANAGEMENT

  Copyright (C) 1988-1990 by Mikael Patel

  Computer Aided Design Laboratory (CADLAB)
  Department of Computer and Information Science
  Linkoping University
  S-581 83 LINKOPING
  SWEDEN

  Email: mip@ida.liu.se
  
  Started on: 30 June 1988

  Last updated on: 26 June 1990

  Dependencies:
       (cc) fcntl.h, errno.h, kernel.h, error.h, memory.h and io.h

  Description:
       Handles low level access to Operating System to allow asynchronous
       input and multi-tasking of Forth level processes while waiting for
       buffer filling. File names are saved so that files are not reloaded. 
  
  Copying:
       This program is free software; you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation; either version 1, or (at your option)
       any later version.

       This program is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.

       You should have received a copy of the GNU General Public License
       along with this program; see the file COPYING.  If not, write to
       the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 

*/


#include <fcntl.h>
#include <errno.h>
#include "kernel.h"
#include "error.h"
#include "memory.h"
#include "io.h"


/* EXTERNAL DEFINED IO DISPATCH ROUTINE, ENVIRONMENT ACCESS AND ERROR CODE */

extern VOID io_dispatch();
extern CSTR getenv();
extern INT  errno;


/* MAXIMUM FILE AND PATH NAME STRING SIZES */

#define FILENAMESIZE 128
#define PATHNAMESIZE 128


/* INFILE BUFFERS STACK AND STACK POINTER */

#define INFSTACKSIZE 32

INFILE_BUFFER io_infstack[INFSTACKSIZE];
INT io_infsp = -1;


/* OUTFILE AND ERROR FILE VARIABLES */

FILE *io_outf;
FILE *io_errf;


/* STACK OF NAMES OF LOADED FILE */

#define INFILESSIZE 64

static CSTR infiles[INFILESSIZE];
static INT infsp = -1;


/* STACK OF FILE SEARCH PATHS */

#define PATHSSIZE 32

static CSTR paths[PATHSSIZE];
static INT psp = -1;


/* IO MANAGEMENT DEFINITONS */

INT io_path(pname, pos)
    CSTR pname;			/* Pointer to path name */
    INT pos;			/* Position to append */
{
    CHAR pathname[PATHNAMESIZE];    
    INT plen = strlen(pname);
    INT i;

    /* Check for null path. Dont add these */
    if (plen == 0) return IO_NO_ERROR;

    /* Check if the path name is an environment variable */
    if (pname[0] == '$') {

	/* Fetch the environment variables value */
	char *paths = (char *) getenv((char *) pname + 1);

	/* If paths are available recursivly add them to the path list */
	if (paths) {
	    while (*paths) {
		char *p = pathname;

		/* Parse list of paths; directories seperated by colon */
		while (*paths && *paths != ':') *p++ = *paths++;
		*p++ = '\0'; 

		/* Append recursively */
		(VOID) io_path(pathname, pos);

		/* Access next path if available */
		if (*paths) paths++;
	    }
	    return IO_NO_ERROR;
	}
	else
	    return IO_UNKNOWN_PATH;
    }

    /* Check that the last character is a slash if not add it */
    if (pname[plen - 1] != DIRSEPCHAR) {
	pname[plen++] = DIRSEPCHAR;
	pname[plen] = '\0';
    }

    /* Check if the path has already been defined */
    for (i = 0; i <= psp; i++)
	if (STREQ(paths[i], pname)) return IO_PATH_DEFINED;
    
    /* Check if space is available on path stack */
    if (psp + 1 == PATHSSIZE) return IO_TOO_MANY_PATHS;

    /* Make space for the new path */
    psp = psp + 1;
    
    /* Check where the path should be appended */
    if (pos == IO_PATH_FIRST) {
	for (i = psp; i > 0; i--) paths[i] = paths[i - 1];
	pos = 0;
    }
    else pos = psp;

    /* Add path string att position given */
    paths[pos] = strcpy((char *) malloc((unsigned) plen + 1), pname);

    return IO_NO_ERROR;
}

VOID io_flush()
{
    /* Flush any waiting output */
    (VOID) fflush(stdout);    

    /* Close all open files if not end of input stream */
    if (io_not_eof()) {

	/* Close all files but lowest */
	while (io_infsp > 0) (VOID) close(io_infstack[io_infsp--] -> fd);

	/* Close lowest file on file stack if not tty */
	if (!isatty(io_infstack[io_infsp] -> fd))
	    (VOID) close(io_infstack[io_infsp--] -> fd);
    }
}

INT io_infile(fname)
    CSTR fname;			/* Pointer to file name to open as input */
{
    CHAR filename[FILENAMESIZE];
    INT i, j;
    INT fd;
    
    /* Check for standard input as source */
    if (fname == STDIN) {

	/* Check if space is available on file stack */
	if (io_infsp + 1 == INFSTACKSIZE) return IO_TOO_MANY_FILES;

	/* Push standard input as source onto the file buffer stack */
	io_infsp = io_infsp + 1;
	io_infstack[io_infsp] -> fd = STDIN;
	io_infstack[io_infsp] -> bufp = 0;
	io_infstack[io_infsp] -> cc = 0;
	io_infstack[io_infsp] -> fn = NIL;
	io_infstack[io_infsp] -> ln = 1;
	return IO_NO_ERROR;
    }

    /* Expand the file name using the path stack and try opening the file */
    for (i = 0; i <= psp; i++) {

	/* Build the new file name using a path */
	(VOID) strcpy(filename, paths[i]);
	(VOID) strcpy(filename + strlen(paths[i]), fname);

	/* Check if this file has already been loaded */
	for (j = 0; j <= infsp; j++)
	    if (STREQ(infiles[j], filename)) return IO_FILE_INCLUDED;

	/* Try opening the file */
	fd = open(filename, O_RDONLY);

	/* If no errors then save the file name and return file descriptor */
	if (fd != -1) {

	    /* Check if space is available on file stack */
	    if (io_infsp + 1 == INFSTACKSIZE) return IO_TOO_MANY_FILES;

	    /* Push file onto the file buffer stack and use it as source */
	    infsp = infsp + 1;
	    infiles[infsp] = strcpy((char *) malloc((unsigned) strlen(filename) + 1), filename);
	    io_infstack[++io_infsp] -> fd = fd;
	    io_infstack[io_infsp] -> bufp = 0;
	    io_infstack[io_infsp] -> cc = 0;
	    io_infstack[io_infsp] -> fn = infiles[infsp];
	    io_infstack[io_infsp] -> ln = 1;
	    return fd;
	}
    }

    /* The file was not available so return error */
    return IO_UNKNOWN_FILE;
}


INT io_fillbuf()
{
    BOOL nonblocking;

    /* Check io consistency and foreground task input only */
    if (io_eof() || tp != foreground) error_fatal(0);
    
    /* Flush any waiting output if filling buffer from a terminal */
    if (isatty(io_infstack[io_infsp] -> fd)) (VOID) fflush(stdout);

    /* Check for multi-tasking input operation */
    if (tp != ((TASK) tp -> queue.succ)) {
	(VOID) fcntl(io_infstack[io_infsp] -> fd, F_SETFL, FNDELAY); 
	tp -> status = IOWAITING;
	nonblocking = TRUE;
    }
    else
	nonblocking = FALSE;
	
    /* Allow multi-tasking during waiting for input */
    for (;;) {

	/* Try reading a block from the current input stream */
	if ((io_infstack[io_infsp] -> cc = read(io_infstack[io_infsp] -> fd,
					    io_infstack[io_infsp] -> buf,
					    BUFSIZE)) > 0) {

	    /* Restore to non-blocking input from file and foreground */
	    if (nonblocking) {
		(VOID) fcntl(io_infstack[io_infsp] -> fd, F_SETFL, 0);
		spush(foreground, TASK);
		doresume();
		tp -> status = RUNNING;
	    }

	    /* Initiate the buffer pointer and return the first character */
	    io_infstack[io_infsp] -> bufp = 0;
	    return io_getchar();
	}

	/* Did the read operation result in an end of file */
	if (io_infstack[io_infsp] -> cc == 0 && errno != EWOULDBLOCK) {

	    /* Set back the file mode to synchronous and close the file */
	    if (nonblocking) {
		(VOID) fcntl(io_infstack[io_infsp] -> fd, F_SETFL, 0);
		spush(foreground, TASK);
		doresume();
		tp -> status = RUNNING;
	    }
	    (VOID) close(io_infstack[io_infsp--] -> fd); 
	    
	    /* Check if end of input source */
	    if (io_eof()) return IO_EOF;

	    /* Get character from previous file buffer */
	    return io_getchar();
	}

	/* Run forth level tasks while waiting for input */
	if (tp == foreground) dodetach(); else doinner();
	
	/* Check if the task for empty, i.e., only the foreground */
	if (tp == foreground && tp == ((TASK) tp -> queue.succ)) {
	    (VOID) fcntl(io_infstack[io_infsp] -> fd, F_SETFL, 0); 
	    nonblocking = FALSE;
	}
	
	/* Allow user extension of the io wait loop */
	io_dispatch();
    }
}

VOID io_skip(skpchr)
    CHAR skpchr;		/* Skip character */
{
    CHAR c;

    /* Skip all characters until skip termination character or end of file */
    while (io_not_eof()) {
	c = io_getchar();
	if (c == '\n') io_newline();
	if (c == skpchr) return;
    }
}

VOID io_scan(buf, brkchr)
    CSTR buf;			/* Pointer to scan buffer */
    CHAR brkchr;		/* Break character */
{
    CHAR c;
    
    /* Initiate buffer as null string */
    *buf = '\0';

    /* Check for scanning until white space or special break character */
    if (brkchr == ' ') {

	/* While not white space or end of file */
	while (io_not_eof()) {
	    c = io_getchar();
	    if (c == '\n') io_newline();
	    if (ISSPACE(c)) break;
	    *buf++ = c;
	}
    }
    else {

	/* While not the break character or end of file */
	while (io_not_eof()) {
	    c = io_getchar();
	    if (c == '\n') io_newline();
	    if (c == brkchr) break;
	    *buf++ = c;
	}
    }
    
    /* End the string and return */
    *buf = '\0';
    return;
}

VOID io_skipspace()
{
    CHAR c;
    
    /* Skip all white spaces */
    while (io_not_eof()) {
	c = io_getchar();
	if (c == '\n') io_newline();
	if (!ISSPACE(c)) break;
    }
    
    /* Step back the buffer pointer */
    if (io_not_eof()) io_infstack[io_infsp] -> bufp -= 1;
}

VOID io_initiate(banner)
    CSTR banner;		/* Initiate application message */
{
    INT i;

    /* Assign output and error file */
    io_outf = stdout;
    io_errf = stderr;

    /* Print banner and add initial paths */
    (VOID) printf(banner);
    (VOID) io_path("$PWD", IO_PATH_LAST);
    (VOID) io_path("$HOME", IO_PATH_LAST);
    (VOID) io_path("$TILEPATH", IO_PATH_LAST);

    /* Allocate file buffers */
    for (i = 0; i < INFSTACKSIZE; i++) {
	io_infstack[i] = (INFILE_BUFFER) malloc((unsigned) sizeof(file_buffer));
	if (io_infstack[i] == NIL) {
	    (VOID) fprintf(io_errf, "io: cannot allocate file buffers\n");
	    exit(0);
	}
    }

}    
    
VOID io_finish()
{
    /* Flush any waiting output */
    (VOID) fflush(stdout);    

    /* Close all open files */
    while (io_not_eof()) (VOID) close(io_infstack[io_infsp--] -> fd);
}

