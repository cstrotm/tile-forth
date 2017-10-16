/*
  C BASED FORTH-83 MULTI-TASKING KERNEL: EXCEPTION MANAGEMENT

  Copyright (C) 1988-1990 by Mikael R.K. Patel

  Computer Aided Design Laboratory (CADLAB)
  Department of Computer and Information Science
  Linkoping University
  S-581 83 LINKOPING
  SWEDEN

  Email: mip@ida.liu.se

  Started on: 30 June 1988

  Last updated on: 22 April 1990

  Dependencies:
	(cc) kernel.c, kernel.h

  Description:
	Error signal and exception extension vocabulary of the 
	tile forth multi-tasking kernel.

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

VOID doexception()
{
    spush(NIL, INT32);
    spush(NORMAL, INT32);
    spush(EXCEPTION, INT32);
    spush(' ', INT32);
    doword();
    doentry();
}

NORMAL_CODE(exception, forth, "exception", doexception);

VOID doparenexceptionsemicolon()
{  
    fthrow();
}

COMPILATION_CODE(parenexceptionsemicolon, exception, "(exception;)", doparenexceptionsemicolon);

VOID doparenexceptionunlinksemicolon()
{  
    funlink();
    fthrow();
}

COMPILATION_CODE(parenexceptionunlinksemicolon, parenexceptionsemicolon, "(exceptionunlink;)", doparenexceptionunlinksemicolon);

VOID doparenexception()
{   
    fcatch();
}

COMPILATION_CODE(parenexception, parenexceptionunlinksemicolon, "(exception>)", doparenexception);

VOID doexceptionsharp()
{  
    ENTRY t;

    /* Set up pointer to last definition */
    dolast();
    t = spop(ENTRY);
    
    /* Compile an exit of the current definition */
    if (theframed != NIL) {	
	spush(&parenexceptionunlinksemicolon, CODE_ENTRY);
    }
    else {
	spush(&parenexceptionsemicolon, CODE_ENTRY);
    }
    dothread();
    doremovelocals();
    
    /* Redefine the code type of the last definition */
    t -> code = (INT32) dp;
    
    /* Compile the run time exception management definition */
    spush(&parenexception, CODE_ENTRY);
    dothread();
}

COMPILATION_IMMEDIATE_CODE(exceptionsharp, parenexception, "exception>", doexceptionsharp);

VOID doraise()
{  
    INT32 s = spop(INT32);
    
    /* Check if there is an exception block available */
    if (ep != NIL) {

	/* Restore the call environment */
	rp = ep;
	ep = (PTR32) rpop();
	fp = (PTR32) rpop();
	ip = (PTR32) rpop();
	sp = (PTR) rpop();
	tos.INT32 = rpop();

	/* Pass on the signal or exception to the exception block */
	spush(s, INT32);
    }
    else {
	
	/* Call low level management of signal */
	(VOID) error_signal(s);
    }
}

NORMAL_CODE(raise, exceptionsharp, "raise", doraise);

