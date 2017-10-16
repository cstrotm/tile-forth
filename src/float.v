/*
  C BASED FORTH-83 MULTI-TASKING KERNEL: FLOATING POINT NUMBERS

  Copyright (C) 1990 by Mikael R.K. Patel

  Computer Aided Design Laboratory (CADLAB)
  Department of Computer and Information Science
  Linkoping University
  S-581 83 LINKOPING
  SWEDEN

  Email: mip@ida.liu.se

  Started on: 12 April 1990

  Last updated on: 26 June 1990

  Dependencies:
	(cc) kernel.c, kernel.h

  Description:
	Floating point number extension vocabulary for the tile forth
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


VOID doitof()
{
    coerce(INT32, FLOAT32);
}

NORMAL_CODE(itof, forth, "i>f", doitof);

VOID doftoi()
{
    coerce(FLOAT32, INT32);
}

NORMAL_CODE(ftoi, itof, "f>i", doftoi);

VOID dofplus()
{
    binary(+, FLOAT32);
}

NORMAL_CODE(fplus, ftoi, "f+", dofplus);

VOID dofminus()
{
    binary(-, FLOAT32);
}

NORMAL_CODE(fminus, fplus, "f-", dofminus);

VOID doftimes()
{
    binary(*, FLOAT32);
}

NORMAL_CODE(ftimes, fminus, "f*", doftimes);

VOID dofdivide()
{
    binary(/, FLOAT32);
}

NORMAL_CODE(fdivide, ftimes, "f/", dofdivide);

VOID dofonedivide()
{
   unary(1.0 /, FLOAT32);
}

NORMAL_CODE(fonedivide, fdivide, "1/f", dofonedivide);

VOID dofnegate()
{
    unary(-, FLOAT32);
}

NORMAL_CODE(fnegate, fonedivide, "fnegate", dofnegate);

VOID dofdot()
{
    FLOAT32 f;

    f = spop(FLOAT32);
    (VOID) fprintf(io_outf, "%g ", f);
}

NORMAL_CODE(fdot, fnegate, "f.", dofdot);

VOID doqfloat()
{
    FLOAT32 f;
    CHAR c;

    doqnumber();
    if (tos.BOOL) return; else sdrop();

    if (sscanf(tos.CSTR, "%f%1c", &f, &c) == 1) {
	tos.FLOAT32 = f;
	spush(TRUE, BOOL);
    }
    else {
	spush(FALSE, BOOL);
    }
}

NORMAL_CODE(qfloat, fdot, "?float", doqfloat);

