.( Loading Blocks test...) cr

#include blocks.f83

locals blocks

.( 1: Define a code block for "nip") cr 

block[ swap drop ]; constant nip ( -- block)

1 2 nip call . cr


.( 2: Define a code block in a colon definition and call it) cr

: foo ( x -- int)
  block[ ( x -- int)
    5 + 3 *
  ]; call
;

6 foo . cr


.( 3: Make a colon definition return a code block depending on parameter) cr

: fie ( flag -- block)
  if block[ 5 + ]; else block[ 8 + ]; then
;

5 true fie call . cr


.( 4: Show that blocks can return blocks as values) cr

5 false
block[ ( flag -- block)
  if block[ 5 + ]; else block[ 8 + ]; then
];
call
call . cr


.( 5: Define a generalized factorial function block) cr

block[ { x y z } 
  x 0>
  if x 1- y z y call x *
  else z call then
]; constant general-fac

: fac ( n -- n!)
  general-fac block[ 1 ]; general-fac call
;

5 fac . cr

forth only

