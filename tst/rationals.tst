.( Loading Rational number test...) cr

#include rationals.f83

rationals


.( 1: Management of undefined values and infinity) cr

1/1 undefined r+ undefined ?r= .
1/1 undefined r- undefined ?r= .
1/1 undefined r* undefined ?r= .
1/1 undefined r/ undefined ?r= .
cr
1/1 infinity r+  infinity ?r= .
1/1 infinity r-  -infinity ?r= .
1/1 infinity r*  infinity ?r= .
1/1 infinity r/  zero ?r= .
cr
1/1 -infinity r+ -infinity ?r= .
1/1 -infinity r- infinity ?r= .
1/1 -infinity r* -infinity ?r= .
1/1 -infinity r/ zero ?r= .
cr
infinity infinity r+ infinity ?r= .
infinity infinity r- undefined ?r= .
infinity infinity r* infinity ?r= .
infinity infinity r/ undefined ?r= .
cr
infinity -infinity r+ undefined ?r= .
infinity -infinity r- infinity ?r= .
infinity -infinity r* -infinity ?r= .
infinity -infinity r/ undefined ?r= .
cr


.( 2: Literal and constant rational number) cr

12/2387 rational y ( -- num denum)

y r. cr
y 1/r r. cr
y y r+ r. cr
y y r- r. cr
y y r* r. cr
y y r/ r. cr 
y r>i . cr


.( 3: Literal rational number in code) cr

: x ( -- x y)
  -115/38
;

x r. cr
x 1/r r. cr
x y r+ r. cr
x y r- r. cr
x y r* r. cr
x y r/ r. cr
x r>i . cr


.( 4: Relational functions on rational numbers) cr

x x ?r= . cr
x y ?r= . cr
x y ?r> . cr
x y ?r< . cr


.( 5: A rational variable) cr

RATIONAL z

-10/90 20/13 r+ z 2!
z 2@ r. cr
x z 2@ r/ r. cr
y z 2@ r* r. cr

forth only
