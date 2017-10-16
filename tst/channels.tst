.( Loading Multi-tasking channel test...) cr

#include multi-tasking.f83

structures multi-tasking


.( 1: Channel and functions for wire binding to task functional units)

ONE-TO-ONE CHAN binding ( -- chan)

: bind ( x -- )  binding receive swap ! ;
: wire ( x -- )  binding send ;
: WIRE ( -- )    ONE-TO-ONE CHAN this wire ;


.( 2: Use a task and three channels to multiply two numbers) cr

16 16 task.type MULTIPLY ( -- )
  ptr a ( -- addr)
  ptr b ( -- addr)
  ptr c ( -- addr)
task.body
  a bind b bind c bind
  begin
    a @ receive b @ receive * c @ send
  again
task.end

MULTIPLY m1 WIRE w1 WIRE w2 WIRE w3

: * ( x y -- z)  w1 send w2 send w3 receive ;

100 90 * . cr


.( 3: Run factorial as a task with two channels using the multiply task) cr

16 16 task.type FACTORIAL ( -- )
  ptr a ( -- addr)
  ptr b ( -- addr)
task.body 
  a bind b bind
  begin
    1 a @ receive 1+ 1 do
      i * 
    loop
    b @ send
  again
task.end

FACTORIAL f1 WIRE n WIRE n!

: fac ( n -- n!)
  n send
  ." I'm waiting.."
  begin
    n! ?avail not
  while
    ." .."
    1 delay
  repeat
  ." done" cr
  n! receive
;

5 fac . cr

forth only


