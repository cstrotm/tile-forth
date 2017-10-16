/*
  C BASED FORTH-83 MULTI-TASKING KERNEL: DOUBLE LINKED LIST

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
	Double linked list (queues) extension vocabulary for the tile
	forth multi-tasking kernel.

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

VOID doqemptyqueue()
{
    compare(== ((INT32) tos.QUEUE -> succ), INT32);
}

NORMAL_CODE(qemptyqueue, forth, "?empty-queue", doqemptyqueue);

VOID doenqueue()
{
    register QUEUE t, q;

    q = spop(QUEUE);
    t = spop(QUEUE);

    t -> pred = q -> pred;
    t -> succ = q;

    q -> pred -> succ = t;
    q -> pred = t;
}

NORMAL_CODE(enqueue, qemptyqueue, "enqueue", doenqueue);

VOID dodequeue()
{
    register QUEUE t;

    t = spop(QUEUE);

    t -> succ -> pred = t -> pred;
    t -> pred -> succ = t -> succ;

    t -> succ = t -> pred = t;
}

NORMAL_CODE(dequeue, enqueue, "dequeue", dodequeue);

