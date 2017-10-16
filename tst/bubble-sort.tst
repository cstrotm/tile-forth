.( Loading Bubble Sort benchmark...) cr

\ A classical benchmark of an O(n**2) algorithm; Bubble sort
\
\ Part of the programs gathered by John Hennessy for the MIPS
\ RISC project at Stanford. Translated to forth by Marty Fraeman
\ Johns Hopkins University/Applied Physics Laboratory.

variable seed ( -- addr)

: initiate-seed ( -- )  74755 seed ! ;
: random  ( -- n )  seed @ 1309 * 13849 + 65535 and dup seed ! ;

500 constant elements ( -- int)

align create list elements cells allot

: initiate-list ( -- )
  list elements cells + list do random i ! cell +loop
;

: dump-list ( -- )
  list elements cells + list do i @ . cell +loop cr
;

: verify-list ( -- )
  list elements 1- cells bounds do
    i 2@ > abort" bubble-sort: not sorted"
  cell +loop
;

: bubble ( -- )
  1 elements 1 do
    list elements i - cells bounds do
      i 2@ > if i 2@ swap i 2! then
    cell +loop 
  loop
;

: bubble-sort ( -- )
  initiate-seed
  initiate-list
  bubble
  verify-list
;

: bubble-with-flag ( -- )
  1 elements 1 do
    true list elements i - cells bounds do
      i 2@ > if i 2@ swap i 2! drop false then
    cell +loop 
    if leave then
  loop
;
  
: bubble-sort-with-flag ( -- )
  initiate-seed
  initiate-list
  bubble-with-flag
  verify-list
;

forth only
