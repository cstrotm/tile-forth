.( Loading Byte Magazine Sieve benchmark...) cr

\ This is the "standard" sieve benchmark as published in Byte Magazine.
\ The algorithm is wrong in the sense that it gives an incorrect count
\ of the number of primes.  That doesn't affect it's usefulness as a
\ benchmark.
\
\ This benchmark tends to be relatively insensitive to the efficiency
\ of "nesting" (calling a colon definition), since it is implemented
\ almost entirely with very low level words, which are code words in
\ most Forth implementations.  This is reasonably fair, however, since
\ studies have shown that in many Forth programs, code words get
\ executed on the order of 8 times more frequently than colon
\ definitions.

decimal

8192 constant size ( -- int)
create flags ( -- addr) size allot

: do-prime ( -- )
  flags size 1 fill
  0 size 0 do
    flags i + c@
    if i dup + 3 + dup i +
      begin
	dup size <
      while
	0 over flags + c!
	over +
      repeat
      2drop 1+
    then
  loop
  1899 = not abort" prime: wrong result"
;

: byte-sieve ( -- )
  10 0 do do-prime loop
;

forth only
