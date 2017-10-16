/*
  C BASED FORTH-83 MULTI-TASKING KERNEL MEMORY MANAGEMENT DEFINITIONS

  Copyright (C) 1989-1990 by Mikael R.K. Patel

*/


/* INCLUDED FILES: SYSTEM MEMORY ALLOCATION */

#ifdef LINT
#include <malloc.h>
#endif

/* EXPORTED MACROS, FUNCTIONS, AND PROCEDURES */

VOID memory_initiate();
VOID memory_finish();
