.( Loading Multi-tasking Sieve benchmark...) cr

\ A fancy way of calculating prime numbers using dynamic creation of tasks.
\ Adapted from Barnes, Programming in Ada, 3rd ed., Addison-Wesley, 1989
\ ch. 14 Tasking, sec. 9 Examples of Task Types, pp. 324-327.

#include structures.f83
#include multi-tasking.f83

structures multi-tasking forth definitions

ONE-TO-ONE CHAN parameter		( Parameter passing channel)

16 16 task.type FILTER ( -- )
  ptr  previous				( Channel to previous task)
  long prime				( The local prime number)
  ptr  next				( Channel to next task)
task.body
  parameter receive previous !		( Receive previous task channel)
  parameter receive dup . prime !	( And local prime number parameters)
  nil next !				( Initiate next task channel to nil)
  begin					( For ever and ever do)
    previous @ receive dup		( Retrieve the next number to check)
    prime @ mod				( Check if not divisible)
    if next @ ?dup			( Check if there exists a next channel)
      if send				( Send to next filter task)
      else			
	new-task FILTER drop		( Create a new filter task)
	ONE-TO-ONE new-struct CHAN dup
	next !				( Save reference to next channel)
	parameter send			( Send previous channel name)
	parameter send			( And the prime number)
      then
    else
      drop				( Drop if divisible)
    then				( And try again)
  again
task.end
 
: task-sieve ( -- )
  new-task FILTER drop			( Create the initial filter task)
  ONE-TO-ONE new-struct CHAN		( And its previous channel)
  dup parameter send			( Send the parameters to the task)
  2 parameter send
  1024 3 do				( Send a stream of number and)
    i over send				( let the tasks filter out the)
  loop					( prime numbers)
  drop
;

forth only
