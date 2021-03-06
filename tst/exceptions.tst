.( Loading Exceptions test...) cr

( Should be used in interactive mode only

#include multi-tasking.f83

multi-tasking exceptions forth definitions

.( 1: Low level errors generated by hardware) cr
10 0 /					( Try some real errors)
0 @					( Divide by zero, seg. violation)
1198203980 @				( and bus error. All on a SUN-3/60)

.( 2: Example of simulating low level errors, i.e., signals) cr
3 raise					( Simulates a quit signal)
5 raise					( and a trace trap signal)
0 raise					( and an input package error)

.( 3: Example of user defined errors types, i.e., exceptions) cr
exception zero-divide			( User defined exception)
zero-divide raise			( And default error message)

.( 4: Example showing that the errors are only local to a task) cr
0 SEMAPHORE synch ( -- semaphore)

16 16 task.type FOO
task.body
  ." Task#" running @ . ." scheduled" cr
  synch wait
  10 0 /
  ." You shouldn't receive this message" cr
task.end

FOO foo

16 16 task.type FIE
task.body
  ." Task#" running @ . ." schedule" cr
  synch wait
  zero-divide raise
  ." You shouldn't receive this message" cr
task.end

FIE fie

who
synch signal				( Signal to the tasks to continue)
synch signal
who					( Show that they are terminated)

.( 5: Forth level exception block definition examples) cr

.( 5.1: Example of transformation of signal to exception) cr
: div ( x y -- q)
  /
exception> ( x y signal -- )
  drop zero-divide raise ;		( Transform signal to an exception)

10 0 div

.( 5.2: Example of user level messages) cr
: divide ( x y - )
  div
exception> ( x y signal -- )
  abort" divide: you shouldn't divide by zero" ;

10 0 divide cr

.( 5.3: Example of a retry exception handling) cr
: divide ( x y -- )
  div
exception> ( x y exception -- )
  case
    zero-divide of 1+ recurse endof
    raise
  endcase ;

10 0 divide . cr

)

forth only
