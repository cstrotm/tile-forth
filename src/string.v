/*
  C BASED FORTH-83 MULTI-TASKING KERNEL: NULL TERMINATED STRINGS

  Copyright (C) 1988-1990 by Mikael R.K. Patel

  Computer Aided Design Laboratory (CADLAB)
  Department of Computer and Information Science
  Linkoping University
  S-581 83 LINKOPING
  SWEDEN

  Email: mip@ida.liu.se

  Started on: 30 June 1988

  Last updated on: 7 September 1990

  Dependencies:
	(cc) kernel.c, kernel.h

  Description:
	Null terminated string extension vocabulary for the tile forth
	multi-tasking kernel.

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

VOID doparenquote()
{
    spush(*ip++, INT32);
}

COMPILATION_CODE(parenquote, forth, "(\")", doparenquote);

VOID doquote()
{
    /* Scan for the string */
    (VOID) io_scan(thetib, '"');

    /* Make a copy of it */
    spush(thetib, CSTR);
    dosdup();
    snip();

    /* If compilation mode then thread a string literal */
    if (state.parameter) {
	spush(&parenquote, CODE_ENTRY);
	dothread();
	docomma();
    }
}

IMMEDIATE_CODE(quote, parenquote, "\"", doquote);

VOID doslength()
{
    tos.INT32 = (INT32) strlen(tos.CSTR);
}

NORMAL_CODE(slength, quote, "$length", doslength);

VOID dosallot()
{
    tos.CSTR = (CSTR) malloc((unsigned) tos.NUM32);
}

NORMAL_CODE(sallot, slength, "$allot", dosallot);

VOID dosdup()
{
    spush((CSTR) strcat((char *) malloc((unsigned) strlen(tos.CSTR) + 1), tos.CSTR), CSTR);
}

NORMAL_CODE(sdup_entry, sallot, "$dup", dosdup);

VOID dosfree()
{
    CSTR s;

    s = spop(CSTR);
    free(s);
}

NORMAL_CODE(sfree, sdup_entry, "$free", dosfree);

VOID dosequal()
{
    CSTR s;

    s = spop(CSTR);
    tos.INT32 = (STREQ(tos.CSTR, s) ? TRUE : FALSE);
}

NORMAL_CODE(sequal, sfree, "$equal", dosequal);

VOID doscompare()
{
    CSTR s;
 
    s = spop(CSTR);
    tos.INT32 = (INT32) strcmp(tos.CSTR, s);
}

NORMAL_CODE(scompare, sequal, "$cmp", doscompare);

VOID doscat()
{
    CSTR s1, s2;

    s2 = spop(CSTR);
    s1 = spop(CSTR);
    (VOID) strcat(s2, s1);
}

NORMAL_CODE(scat, scompare, "$cat", doscat);

VOID dosprint()
{
    CSTR s;

    s = spop(CSTR);
    (VOID) fprintf(io_outf, "%s", s);
}

NORMAL_CODE(sprint, scat, "$print", dosprint);

