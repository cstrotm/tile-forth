.( Loading Fibonacci benchmark...) cr

\ This is a standard benchmark used for interpretive languages such as
\ Lisp. Computation of Fibonacci for 20 in MacLisp interpreter on a
\ DEC KA10 takes about 3.6 minutes. The Scheme-79 chip was reported
\ by G.J. Sussman et al. in IEEE COMPUTER, July 1981, to perform
\ the task in about a minute at 1595 ns clock period and 32K Lisp cells.
\
\ The recursive and tail recursive versions in forth. Demonstrates
\ the power of forth (**4).

: fib ( n -- m)
  dup 1 >
  if dup 1- recurse
    swap 2- recurse +
  then
;
  
: recursive-fib ( -- )
  20 fib 6765 = not abort" recursive-fib: wrong result"
;

: fib-tail ( a b c -- m)
  ?dup
  if 1- -rot over + swap rot tail-recurse
  else nip then
;

: fib-iter ( n -- m) 1 0 rot fib-tail ;

: tail-recursive-fib ( -- )
  1000 0 do
    20 fib-iter
    6765 = not abort" tail-recursive-fib: wrong result"
  loop
;

forth only

