/*
  C BASED FORTH-83 MULTI-TASKING KERNEL APPLICATION: TILE FORTH

  Copyright (C) 1988-1990 by Mikael R.K. Patel

  Computer Aided Design Laboratory (CADLAB)
  Department of Computer and Information Science
  Linkoping University
  S-581 83 LINKOPING
  SWEDEN

  Email: mip@ida.liu.se
  
  Started on: 30 June 1988

  Last updated on: 26 June 1990

  Dependencies:
       (cc) kernel.h, error.h, memory.h, io.h

  Description:
       A 32-bit Forth-83 Standard written in C. Illustrating the use of
       the multi-tasking forth kernel, memory, io and error packages. 
  
       Allows parameters to be given to forth and selection of inter-
       action symbol. Thus providing the basic interface for making forth
       programs act as compile-and-go applications.

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


/* EXTERNAL DEFINITIONS */

#include "kernel.h"
#include "error.h"
#include "memory.h"
#include "io.h"


/* VERSION BANNER */

#define BANNER "TILE Forth version 3.33, Copyright (C) 1990, by Mikael Patel\n"


/* STRUCTURE SIZES */

#define DICTIONARYSIZE 1024L * 1024L
#define USERSIZE 1024L
#define PARAMSIZE 256L
#define RETURNSIZE 256L


/* ACCESS TO APPLICATION ARGUMENTS */

static INT32 ARGC;
static PTR32 ARGV;
static INT32 ARGS;
static CSTR  ARGI;


/* ARGUMENT CHECK AND ACCESS MACROS */

#define ARGEQ(i, s) (*argv[i] == *s && *(argv[i] + 1) == *(s + 1))
#define ARGEV(i) (atol(argv[i] + 2))


/* APPLICATION IO DISPATCH. RUN ON IO-WAIT FOR PERIODICAL ACTIONS */

VOID io_dispatch()
{
    /* Any application action which requires periodical attention */
}


/* EXAMPLE OF APPLICATION VOCABULARY */

VOID doarguments()
{
    spush(ARGC - ARGS, INT32);
}

NORMAL_CODE(arguments, forth, "argc", doarguments);

VOID doargument()
{
    if (!tos.INT32 && !ARGI)
	tos.INT32 = *ARGV;
    else
	tos.INT32 = *((PTR32) (INT32) ARGV + tos.INT32 + ARGS);
}

NORMAL_CODE(argument, arguments, "argv", doargument);


/* MAIN WITH APPLICATION STARTUP OF FORTH TOP-LOOP */

main(argc, argv)
    int argc;
    char *argv[];
{
    INT32 i, flag;
    INT32 dictionarysize, usersize, paramsize, returnsize;

    /* Initiate default size values */
    dictionarysize = DICTIONARYSIZE;
    usersize = USERSIZE;
    paramsize = PARAMSIZE;
    returnsize = RETURNSIZE;     

    /* Check for size arguments */
    i = 1;
    flag = i < argc;
    while (flag) {
	
	/* Assume no more arguments */
	flag = FALSE;

	/* Look for dictionary size argument */
	if (ARGEQ(i, "-d")) {
	    dictionarysize = ARGEV(i);
	    flag = TRUE;
	}

	/* Look for parameter stack size argument */
	if (ARGEQ(i, "-p")) {
	    paramsize = ARGEV(i);
	    flag = TRUE;
	}

	/* Look for return stack size argument */
	if (ARGEQ(i, "-r")) {
	    returnsize = ARGEV(i);
	    flag = TRUE;
	}

	/* Look for user area size argument */
	if (ARGEQ(i, "-u")) {
	    usersize = ARGEV(i);
	    flag = TRUE;
	}

	/* Check for more arguments to parse */
	if (flag) {
	    i++;
	    flag = i < argc;
	}
    }

    /* Initiate memory, error, io, and kernel */
    io_initiate(BANNER);
    error_initiate();
    memory_initiate(dictionarysize);
    kernel_initiate((ENTRY) &argument, (ENTRY) &arguments, usersize, paramsize, returnsize);
    
    /* Set up argument counter and pointer */
    ARGC = argc;
    ARGV = (PTR32) argv;
    ARGS = argc - 1;
    ARGI = (CSTR) 0;
    
    /* Load argument files before taking input from standard input */
    for(; i < argc; i++) {

	/* Look for argument or start symbol switch */
	if (STREQ(argv[i], "-a")) {
	    ARGS = i;
	    i = argc;
	}
	else {
	    if (STREQ(argv[i], "-s")) {
		ARGI = argv[i + 1];
		ARGS = i + 1;
		i = argc;
	    }
	    else {

		/* Use the argument as an input file name and try loading it*/
		if (io_infile(argv[i]) == IO_UNKNOWN_FILE) {
		    (VOID) fprintf(io_errf, "%s: file not found\n", argv[i]);
		    kernel_finish();
		    io_finish();
		    error_finish();
		    memory_finish();
		    exit(0);
		}
		else 
		    doquit();
	    }
	}
    }

    /* Use standard input as input stream */
    (VOID) io_infile((CSTR) STDIN);

    /* Check if there was a start symbol argument */
    if (ARGI) {

	/* Find the symbol in the vocabulary */
	verbose = FALSE;
	spush(ARGI, CSTR);
	dofind();
	if (tos.BOOL) {
	    dodrop();
	    docommand();
	}
	else
	    (VOID) fprintf(io_errf, "%s ??\n", ARGI);
    }
    else {
	/* Else start the normal interaction loop */
	verbose = TRUE;
	doquit();
    }

    /* Clean up the kernel, io, error and memory package before exit */
    kernel_finish();
    memory_finish();
    error_finish();
    io_finish();
    exit(0);
}



