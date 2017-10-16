.( Loading Colburn Sieve benchmark...) cr

\ This is the "Colburn Sieve" as published in a letter to the editor
\ of Dr. Dobbs' Journal.  It is the same algorithm as the first, but
\ is a better Forth implementation of the algorithm.  It uses a
\ DO .. LOOP in the inner loop instead of  BEGIN .. WHILE .. REPEAT
\ This version is a more fair comparison of Forth in relation to other
\ languages.  For comparisons between different Forth systems, both
\ versions are widely used.  It is necessary to state which version
\ you are using in order for your benchmark to be useful.
\
\ The Colburn Sieve typically runs in about 60% of the time of the
\ Byte sieve.

decimal

8192 constant size ( -- int)
create flags ( -- addr) size allot

: do-prime ( -- )
  flags  size 1 fill 
  0 size 0 do
    flags i + c@
    if 3 i + i + dup i + size <
      if size flags +
	over i + flags + do
	  0 i c! dup
	+loop
      then
      drop 1+
   then
 loop
 1899 = not abort" prime: wrong result"
; 

: colburn-sieve ( -- )
  10 0 do do-prime loop
;

forth only
