.( Loading Ranges test...) cr

#include ranges.f83
#include blocks.f83

blocks ranges 


.( 1: Create some typical ranges and print them) cr

[1901..2001] range YEAR_NUMBER ( -- from to)
[1..12]      range MONTH_NUMBER ( -- from to)
[1..31]      range DAY_NUMBER ( -- from to)
[1..24]      range HOUR_NUMBER ( -- from to)
[1..60]      range MINUTE_NUMBER ( -- from to)
[1..60]      range SECOND_NUMBER ( -- from to)

MONTH_NUMBER . . cr
YEAR_NUMBER . . cr
DAY_NUMBER . . cr


.( 2: Count number of odd numbers in the ranges) cr

: count-odd-numbers ( from to -- n)
  0 -rot
  block[ ( count index -- count+1)
    1 and if 1+ then
  ];
  map-range
; 

YEAR_NUMBER count-odd-numbers . 
MONTH_NUMBER count-odd-numbers .
DAY_NUMBER count-odd-numbers . cr


.( 3: Test membership function) cr

3 YEAR_NUMBER ?member-range .
3 MONTH_NUMBER ?member-range .
3 DAY_NUMBER ?member-range . cr


.( 4: Conditional iteration; print a sub-range) cr

: 3dup ( x y z -- x y z x y z)
  >r 2dup r@ -rot r>
;

: .sub.range ( upper from to -- )
  3dup ?member-range
  if block[ dup . over = ]; ?map-range
  else
    2drop 
  then
  drop
;

4 DAY_NUMBER .sub.range cr


.( 5: Union and intersections of ranges) cr

DAY_NUMBER YEAR_NUMBER ?intersection-range . cr
DAY_NUMBER MONTH_NUMBER intersection-range .range cr
DAY_NUMBER MONTH_NUMBER union-range .range cr

forth only


