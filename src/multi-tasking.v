/*
  C BASED FORTH-83 MULTI-TASKING KERNEL: MULTI-TASKING EXTENSIONS

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
	Multi-tasking kernel extension vocabulary.

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

static ENTRY toterminate = (ENTRY) &terminate;

NORMAL_CONSTANT(foreground_entry, forth, "foreground", (INT32) &foreground);

NORMAL_CONSTANT(running_entry, foreground_entry, "running", (INT32) &tp);

VOID douser()
{
    spush(NORMAL, INT32);
    spush(USER, INT32);
    spush(' ', INT32);
    doword();
    doentry();
}

NORMAL_CODE(user, running_entry, "user", douser);

TASK make_task(users, params, returns, action)
    INT32 users, params, returns, action;
{
    INT32 size;
    TASK t;

    /* Calculate size of task and allocate */
    size = sizeof(task_header) + users + (params + returns) * sizeof(INT32);
    t = (TASK) malloc((unsigned) size);

    /* Initiate queues structure, status and environment */
    t -> queue.succ = t -> queue.pred = (QUEUE) t;
    t -> status = READY;

    t -> s0 = t -> sp = (PTR32) ((PTR8) t + size - returns * sizeof(INT32));
    t -> r0 = t -> rp = (PTR32) ((PTR8) t + size);
    t -> ip = (action ? (PTR32) action : (PTR32) &toterminate);
    t -> fp = NIL;
    t -> ep = NIL;

    /* Return task pointer */
    return t;
}

VOID dotask()
{
    INT32 users, params, returns, action;

    action  = spop(INT32);
    returns = spop(INT32);
    params  = spop(INT32);
    users   = spop(INT32);
    spush(make_task(users, params, returns, action), TASK);
}

NORMAL_CODE(task_entry, user, "task", dotask);

VOID dofork()
{
    TASK t;
    INT32 size;

    register INT32 n;
    register PTR8 to;
    register PTR8 from;


    /* Allocate memory for the new task */
    size = ((PTR8) r0) - ((PTR8) tp);
    t = (TASK) malloc((unsigned) size);
    
    /* Push top of stack for clean state */
    sdrop();

    /* Copy the current task */
    n = size;
    to = (PTR8) t;
    from = (PTR8) tp;
    while (--n != -1) *to++ = *from++;

    /* Assign the new fields */
    t -> s0 = (PTR32) ((INT32) ((PTR8) t) + ((PTR8) s0) - ((PTR8) tp));
    t -> sp = (PTR32) ((INT32) ((PTR8) t) + ((PTR8) sp) - ((PTR8) tp));
    t -> ip = ip;
    t -> r0 = (PTR32) ((INT32) ((PTR8) t) + ((PTR8) r0) - ((PTR8) tp));
    t -> rp = (PTR32) ((INT32) ((PTR8) t) + ((PTR8) rp) - ((PTR8) tp));
    t -> fp = (fp ? (PTR32) ((INT32) ((PTR8) t) + ((PTR8) fp) - ((PTR8) tp)) : NIL);
    t -> ep = (ep ? (PTR32) ((INT32) ((PTR8) t) + ((PTR8) ep) - ((PTR8) tp)) : NIL);
    
    /* Pop back top of stack */
    sdup();

    /* Push pointer to child task as result to parent task */
    spush(t, TASK);
    
    /* Schedule the child task and push parent */
    spush(t, TASK);
    t = tp;
    doschedule();

    /* Push pointer to parent task as result to child task */
    tos.TASK = t;
}

NORMAL_CODE(fork_entry, task_entry, "fork", dofork);

VOID doresume()
{
    TASK t;

    t = tos.TASK;

    /* Check if the task to resume is the current task and active */
    if (t -> status && t != tp) {

	/* Store the state of the current task */
	tp -> sp = (PTR32) sp;
	tp -> s0 = (PTR32) s0;
	tp -> ip = ip;
	tp -> rp = rp;
	tp -> r0 = r0;
	tp -> fp = fp;
	tp -> ep = ep;

	/* Indicate task switch to the virtual machine */
	running = FALSE;
    
	/* Restore the parameter task */
	sp = (PTR) t -> sp;
	s0 = (PTR) t -> s0;
	ip = t -> ip;
	rp = t -> rp;
	r0 = t -> r0;
	fp = t -> fp;
	ep = t -> ep;
	tp = t;
    }

    /* Load top of stack again */
   sdrop();
}

NORMAL_CODE(resume, fork_entry, "resume", doresume);

VOID doschedule()
{
    /* Put the task after the current task */
    spush(tp -> queue.succ, QUEUE);
    doenqueue();

    /* Resume the task now */
    dodetach();

    /* Restore parameter and return stack */
    spush(tp, TASK);
    rpush(&toterminate);

    /* Mark the task as running */
    tp -> status = RUNNING;
}

NORMAL_CODE(schedule, resume, "schedule", doschedule);

VOID dodetach()
{
    /* Resume the next task in the system task queue */
    spush(tp -> queue.succ, QUEUE);
    doresume();
}

NORMAL_CODE(detach, schedule , "detach", dodetach);

VOID doterminate()
{
    TASK t = tp;

    /* Check if the task is the foreground task */
    if (tp == foreground) {

	/* Empty the return stack and signal end of execution to inner loop */
	rinit();
	running = FALSE;
	tasking = FALSE;

	/* Foreground should always terminate on last exit */
	ip = (PTR32) &toterminate;
    }
    else {

	/* else remove the current task from the system task queue */
	dodetach();
	t -> status = TERMINATED;
	spush(t, TASK);
	dodequeue();
    }
}

NORMAL_CODE(terminate, detach, "terminate", doterminate);

