/*
  C BASED FORTH-83 MULTI-TASKING KERNEL: COMPILER EXTENSION LEVEL DEFINITIONS

  Copyright (C) 1988-1990 by Mikael R.K. Patel

  Computer Aided Design Laboratory (CADLAB)
  Department of Computer and Information Science
  Linkoping University
  S-581 83 LINKOPING
  SWEDEN

  Email: mip@ida.liu.se

  Started on: 30 June 1988

  Last updated on: 12 September 1990

  Dependencies:
       (cc) kernel.c, kernel.h

  Description:
	Compiler extension vocabulary of the tile forth multi-tasking
	kernel.

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

VOID doparenbranch()
{
    fbranch(*ip);
}

COMPILATION_CODE(parenbranch, forth, "(branch)", doparenbranch);

VOID doparenqbranch()
{
    BOOL flag;

    /* Pop flag */
    flag = spop(BOOL);
    
    /* Check flag on top of stack and branch if false */
    if (flag)
	fskip();
    else
	fbranch(*ip);
}

COMPILATION_CODE(parenqbranch, parenbranch, "(?branch)", doparenqbranch);

VOID doparendo()
{
    /* Build a loop frame on return stack */
    rpush(ip++);
    rpush(spop(INT32));
    rpush(spop(INT32));
}

COMPILATION_CODE(parendo, parenqbranch, "(do)", doparendo);

VOID doparenqdo()
{
    /* Check if the start and stop value are equal */
    if (tos.INT32 == snth(0).INT32) {

	/* If equal then branch over the loop block */
	sndrop(1);
	fbranch(*ip);
    }
    else {

	/* else build a loop frame on the return stack */
	rpush(ip++);
	rpush(spop(INT32));
	rpush(spop(INT32));
    }
}

COMPILATION_CODE(parenqdo, parendo, "(?do)", doparenqdo);

VOID doparenloop()
{
    /* Increment the index by one and check if within loop range */
    rnth(1) += 1;
    if (rnth(0) > rnth(1)) {

	/* Branch if still within range */
	fbranch(*ip);
	return;
    }

    /* Else remove the loop frame from the return stack and skip */
    rndrop(3);
    fskip();
}

COMPILATION_CODE(parenloop, parenqdo, "(loop)", doparenloop);

VOID doparenplusloop()
{
    register INT32 d;

    /* Pop the decrement value */
    d = spop(INT32);

    /* Increment the index with the top of stack value */
    rnth(1) += d;

    /* Check direction and if the index is still within the loop range */
    if (d > 0) {
	if (rnth(0) > rnth(1)) {
	    fbranch(*ip);
	    return;
	}
    }
    else {
	if (rnth(0) < rnth(1)) {
	    fbranch(*ip);
	    return;
	}
    }

    /* Else remove the loop frame from the return stack and skip */
    rndrop(3);
    fskip();
}

COMPILATION_CODE(parenplusloop, parenloop, "(+loop)", doparenplusloop);


/* COMPILATION LITERALS */

VOID doparenliteral()
{ 
    spush(*ip++, INT32);
}

COMPILATION_CODE(parenliteral, parenplusloop, "(literal)", doparenliteral);

VOID doparendotquote()
{
    (VOID) fprintf(io_outf, "%s", *ip++);
}

COMPILATION_CODE(parendotquote, parenliteral, "(.\")", doparendotquote);

VOID doparenabortquote()
{
    BOOL flag;

    /* Pop flag from top of stack */
    flag = spop(BOOL);
    
    /* Check flag on top of stack. If true then abort and give message */
    if (flag) {
	doparendotquote();
	docr();
	doabort();
    }
    else fskip();
}

COMPILATION_CODE(parenabortquote, parendotquote, "(abort\")", doparenabortquote);

VOID doparensemicolon()
{
    fsemicolon();
}

COMPILATION_CODE(parensemicolon, parendotquote, "(;)", doparensemicolon);

VOID doparendoes()
{
    fdoes();
}

COMPILATION_CODE(parendoes, parensemicolon, "(does>)", doparendoes);


/* THREADING PRIMITIVES */

VOID dothread()
{
    *dp++ = spop(INT32);
}

NORMAL_CODE(thread, parendoes, "thread", dothread);

VOID dounthread()
{
    unary(*(PTR32), INT32);
}

NORMAL_CODE(unthread, thread, "unthread", dounthread);


VOID doforwardmark()
{
    dohere();
    spush(0, INT32);
    docomma();
}

COMPILATION_CODE(forwardmark, unthread, ">mark", doforwardmark);

VOID dobackwardmark()
{
    dohere();
}

COMPILATION_CODE(backwardmark, forwardmark, "<mark", dobackwardmark);

VOID doforwardresolve()
{
    dohere();
    doover();
    dominus();
    doswap();
    dostore();
}

COMPILATION_CODE(forwardresolve, backwardmark, ">resolve", doforwardresolve);

VOID dobackwardresolve()
{
    dohere();
    dominus();
    docomma();
}

COMPILATION_CODE(backwardresolve, forwardresolve, "<resolve", dobackwardresolve);

