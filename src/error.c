/*
  C BASED FORTH-83 MULTI-TASKING KERNEL ERROR MANAGEMENT 

  Copyright (C) 1989-1990 by Mikael Patel

  Computer Aided Design Laboratory (CADLAB)
  Department of Computer and Information Science
  Linkoping University
  S-581 83 LINKOPING
  SWEDEN

  Email: mip@ida.liu.se
  
  Started on: 7 March 1989

  Last updated on: 20 June 1990

  Dependencies:
       (cc) signal.h, fcntl.h, kernel.h, memory.h, io.h, error.h 

  Description:
       Handles low level signal to error message conversion and printing.
       Low level signals from the run-time environment are transformation
       to forth level exceptions and may be intercepted by an exception
       block.
  
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

#include <signal.h>
#include <fcntl.h>
#include "kernel.h"
#include "memory.h"
#include "io.h"
#include "error.h"


/* ENVIRONMENT FOR LONGJMP AND RESTART AFTER ERROR SIGNAL */

jmp_buf restart;


/* SIGNAL MESSAGE TABLE AND SIZE */

#define SIGNALMSGSIZE 20

static char *signalmsg[SIGNALMSGSIZE] = {
    "io error",
    "hangup",
    "interrupt",
    "quit",
    "illegal instruction",
    "trace trap",
    "abort",
    "emulator trap",
    "arithmetic exception",
    "kill",
    "bus error",
    "segmentation violation",
    "bad argument to system call",
    "write to a pipe or other socket with no one to read it",
    "alarm clock",
    "software termination",
    "urgent condition on IO channel",
    "sendable stop signal not from tty",
    "stop signal from tty",
    "continue after stop"
    };


VOID error_signal(sig)
    long sig;
{
    /* Check which task received the signal */
    if (tp == foreground)
	(VOID) fprintf(io_errf, "foreground#%d: ", foreground);
    else
	(VOID) fprintf(io_errf, "task#%d: ", tp);

    /* Print the signal number and a short description */
    if (sig < SIGNALMSGSIZE)
	(VOID) fprintf(io_errf, "signal#%d: %s\n", sig, signalmsg[sig]);
    else
	(VOID) fprintf(io_errf, "exception#%d: %s\n", sig, ((ENTRY) sig) -> name);

    /* Abort the current virtual machine call */
    doabort();
}

VOID error_fatal(sig)
    int sig;			/* Signal number */
{
    /* Notify the error signal */
    error_signal((long) sig);

    /* Clean up the mess after all the packages */
    io_finish();
    error_finish();
    kernel_finish();
    memory_finish();
    
    /* Exit and pass on the signal number */
    exit(sig);
}

VOID error_restart(sig)
    int sig;			/* Signal number */
{
    /* Check the type of signal and perform an appropriate action */
    switch (sig) {
      case SIGTSTP:
	(VOID) fcntl(STDIN, F_SETFL, 0);
	(VOID) kill(getpid(), SIGSTOP);
	return;
      case SIGCONT:
	(VOID) fcntl(STDIN, F_SETFL, FNDELAY);
	return;
      default:
	/* Check if the lowest file descriptor is a tty */
	if (isatty(io_infstack[0] -> fd)) {
	    
	    /* Close all other files */
	    io_flush();

	    /* Check for interrupt in input management */
	    if ((sig == SIGINT || sig == SIGQUIT) && !running) {

		/* Notify the type of signal */
		error_signal((long) sig);
	    }
	    else
		/* Warm start the kernel and pass on the signal number */
		longjmp(restart, sig);	
	}
	else error_fatal(sig);
    }
}

VOID error_initiate()
{
    /* Add error_fatal and error_restart as signal handlers */
    (VOID) signal(SIGHUP,  error_fatal);
    (VOID) signal(SIGINT,  error_restart);
    (VOID) signal(SIGQUIT, error_restart);
    (VOID) signal(SIGILL,  error_restart);
    (VOID) signal(SIGTRAP, error_fatal);
    (VOID) signal(SIGIOT,  error_fatal);
    (VOID) signal(SIGEMT,  error_fatal);
    (VOID) signal(SIGFPE,  error_restart);
    (VOID) signal(SIGBUS,  error_restart);
    (VOID) signal(SIGSEGV, error_restart);
    (VOID) signal(SIGSYS,  error_restart);
    (VOID) signal(SIGPIPE, error_restart);
    (VOID) signal(SIGALRM, error_restart);
    (VOID) signal(SIGTERM, error_fatal);
    (VOID) signal(SIGURG,  error_restart);
    (VOID) signal(SIGSTOP, error_fatal);
    (VOID) signal(SIGTSTP, error_restart);
    (VOID) signal(SIGCONT, error_restart);
}

VOID error_finish()
{
    /* Future clean up function for the error package */
}

