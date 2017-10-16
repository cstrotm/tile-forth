.( Loading Macros test...) cr

#include macros.f83

macros

.( 1: Define "nip" and mark it as a macro definition) cr

: nip ( a b -- b) swap drop ; macro

.macro nip cr
1 2 nip . cr

: x ( a b -- b)  nip ;

1 2 x . cr


.( 2: Define "mip" as a double "nip" macro) cr

: mip ( a b c -- c) nip nip ; macro

.macro mip cr
1 2 3 mip . cr


.( 3: Conditional code may also be used as a macro) cr

: ?magic-number ( x -- int) 0> if 42 else -42 then ; macro

.macro ?magic-number cr
1 ?magic-number . cr
0 ?magic-number . cr


.( 4: Macros in macros work the way they should) cr

: add-magic-number ( x -- int) dup ?magic-number + ; macro

.macro add-magic-number cr
10 add-magic-number . cr

forth only
