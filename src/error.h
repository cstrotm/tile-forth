/*
  C BASED FORTH-83 MULTI-TASKING KERNEL ERROR MANAGEMENT DEFINITIONS

  Copyright (C) 1989-1990 by Mikael R.K. Patel

*/


/* INCLUDE FILES: SETJUMP */

#include <setjmp.h>


/* WARM RESTART ENVIRONMENT FOR LONGJMP */

extern jmp_buf restart;


/* EXPORTED FUNCTIONS AND PROCEDURES */

VOID error_initiate();
VOID error_restart();
VOID error_fatal();
VOID error_signal();
VOID error_finish();
