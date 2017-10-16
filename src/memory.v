/*
  C BASED FORTH-83 MULTI-TASKING KERNEL: MEMORY ALLOCATION

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
	Memory allocation extension vocabulary for the multi-tasking
	tile forth kernel.

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

VOID domalloc()
{
    tos.PTR8 = (PTR8) malloc((unsigned) tos.NUM32);
}

NORMAL_CODE(malloc_entry, forth, "malloc", domalloc);

VOID dorealloc()
{
    PTR8 m = spop(PTR8);
    
    tos.PTR8 = (PTR8) realloc((char *) m, (unsigned) tos.NUM32);
}

NORMAL_CODE(realloc_entry, malloc_entry, "realloc", dorealloc);

VOID dofree()
{
    PTR8 m = spop(PTR8);
    
    free(m);
}

NORMAL_CODE(free_entry, realloc_entry, "free", dofree);

