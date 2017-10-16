.( Loading Debugger test...) cr
 
#include debugger.f83

debugger 


.( 1: Define a debuggable tail-recursive function) cr

: foo ( n -- )
  ?dup if ." foo " 1- tail-recurse else cr then
;

12 foo 
trace foo
12 foo 
.profile


.( 2: Redefine it as a recursive function) cr

: fie ( n -- )
  ?dup if ." fie " 1- recurse else cr then
;

12 fie 
trace fie
12 fie 
.profile


.( 3: Run the break point function) cr

break foo

10 foo *return* .s drop cr cr
10 foo *call* .s cr cr
10 foo *execute* .s cr
       *profile*
5      *execute* .s cr
       *profile*
       *return* .s cr
10 foo *abort* 


.( 4: Fibonacci number function; recursive and tail recursive) cr

: fib ( n -- m)
  dup 1 > if dup 1- recurse swap 2- recurse + then
;

trace fib
10 fib . cr
.profile

: fib-tail ( a b c -- m)
  ?dup if 1- -rot over + swap rot tail-recurse else nip then
;

: fib-iter ( n -- m)
  1 0 rot fib-tail
;

trace fib-tail
trace fib-iter
10 fib-iter . cr
.profile

forth only


