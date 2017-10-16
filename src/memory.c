/*
  C BASED FORTH-83 MULTI-TASKING KERNEL MEMORY MANAGEMENT

  Copyright (C) 1989-1990 by Mikael R.K. Patel

  Computer Aided Design Laboratory (CADLAB)
  Department of Computer and Information Science
  Linkoping University
  S-581 83 LINKOPING
  SWEDEN

  Email: mip@ida.liu.se
  
  Started on: 8 November 1989

  Last updated on: 26 June 1990

  Dependencies:
       (cc) memory.h, io.h, kernel.h

  Description:
       Handles low level access to memory and dictionary allocation.
  
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


#include "kernel.h"
#include "io.h"
#include "memory.h"

VOID memory_initiate(size)
    INT32 size;
{
    /* Allocate dictionary area and setup dictionary pointer */

    dictionary = (PTR32) malloc((unsigned) size);
    if (dictionary == NIL) {
	(VOID) fprintf(io_errf, "memory: cannot allocate dictionary area\n");
	exit(0);
    }
    dp = dictionary;
}

VOID memory_finish()
{
    /* Future clean up function for memory management package */
}
