/*
  C BASED FORTH-83 MULTI-TASKING KERNEL: LOCAL VARIABLES AND ARGUMENT BINDING

  Copyright (C) 1988-1990 by Mikael R.K. Patel

  Computer Aided Design Laboratory (CADLAB)
  Department of Computer and Information Science
  Linkoping University
  S-581 83 LINKOPING
  SWEDEN

  Email: mip@ida.liu.se

  Started on: 30 June 1988

  Last updated on: 20 April 1990

  Dependencies:
       (cc) kernel.c, kernel.h

  Description:
	Local variables and argument binding extension vocabulary of
	the tile forth multi-tasking kernel.

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

static ENTRY theframed = NIL;

VOID doremovelocals()
{
    /* Check if the last definition used an argument definition */
    if (theframed != NIL) {
	
	/* Restore the vocabulary structure */
	spush(theframed, ENTRY);
	dorestore();
	theframed = NIL;
    }
}

VOID doparenlink()  
{
    flink();
}

COMPILATION_CODE(parenlink, forth, "(link)", doparenlink);

VOID doparenunlink()  
{    
    funlink();
}

COMPILATION_CODE(parenunlink, parenlink, "(unlink)", doparenunlink);

VOID doparenunlinksemicolon() 
{
    funlink();
    fsemicolon();
}

COMPILATION_CODE(parenunlinksemicolon, parenunlink, "(unlink;)", doparenunlinksemicolon);

VOID doparenunlinkdoes()
{
    funlink();
    fdoes();
    fsemicolon();
}

COMPILATION_CODE(parenunlinkdoes, parenunlinksemicolon, "(unlinkdoes>)", doparenunlinkdoes);

VOID doparenlocal()
{
    spush(((PTR32) (INT32) fp - *ip++), PTR32);
}

COMPILATION_CODE(parenlocal, parenunlinkdoes, "(local)", doparenlocal);

VOID doparenlocalstore()
{
    *((PTR32) (INT32) fp - *ip++) = spop(INT32);
}

COMPILATION_CODE(parenlocalstore, parenlocal, "(local!)", doparenlocalstore);

VOID doparenlocalfetch()
{
    spush(*((PTR32) (INT32) fp - *ip++), INT32);
}

COMPILATION_CODE(parenlocalfetch, parenlocalstore, "(local@)", doparenlocalfetch);

VOID doassignlocal()
{
    *((PTR32) (INT32) fp - ((ENTRY) *ip++) -> parameter) = spop(INT32);
}

COMPILATION_CODE(assignlocal, parenlocalfetch, "->", doassignlocal);

COMPILATION_CODE(localexit, assignlocal, "exit", doparenunlinksemicolon);

VOID docurlebracket()
{
    BOOL  frameflag = TRUE;
    BOOL  argflag   = TRUE;
    INT32 arguments = 0;
    INT32 locals    = 0;

    /* Check only one active lexical levels allowed */
    if (theframed) {
	if (io_source())
	    (VOID) fprintf(io_errf, "%s:%i:", io_source(), io_line());
	(VOID) fprintf(io_errf, "%s: illegal argument binding\n", theframed -> name);
	doremovelocals();
	doabort();
	return;
    }

    /* Save pointer to latest defintion to allow removal of local names */
    theframed = current -> last;

    /* While the end of the frame description is not found */
    while (frameflag) {

	/* Scan the next symbol */
    	spush(' ', INT32);
	doword();

	if (io_eof()) {
	    if (io_source())
		(VOID) fprintf(io_errf, "%s:%i:", io_source(), io_line());
	    (VOID) fprintf(io_errf, "locals: end of file during scan of parameter list\n");
	    doabort();
	    return;
	}

	/* Check if it marks the end of the argument section */
	if (STREQ(tos.CSTR, "|")) {
	    argflag = 0;
	}
	else {
	    /* else check if its the end of the frame description */
            if (STREQ(tos.CSTR, "}")) {
	    	frameflag = FALSE;
	    }
	    else {
		/* Or the beginning of the return description */
	    	if (STREQ(tos.CSTR, "--")) {
		    sdrop();
		    spush('}', INT32);
		    doword();
		    frameflag = FALSE;
		}
		else {
		    /* If not then make the symbol a local variable */
		    if (argflag)
			arguments++;
		    else
			locals++;
		    (VOID) make_entry(tos.CSTR, 
				      (INT32) LOCAL, 
				      (INT32) COMPILATION, 
				      arguments + locals);
		}
	    }
	}
	sdrop();
    }

    /* Compile the parameter binding linkage */
    spush(&parenlink, CODE_ENTRY);
    dothread();

    /* And the appropriate frame size */
    spush(arguments, INT32);
    docomma();
    spush(locals, INT32);
    docomma();
}

COMPILATION_IMMEDIATE_CODE(curlebracket, localexit, "{", docurlebracket);

