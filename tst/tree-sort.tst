.( Loading Tree Sort benchmark...) cr

\ A classical benchmark of an O(log n) algorithm; Tree Sort
\
\ Part of the programs gathered by John Hennessy for the MIPS
\ RISC project at Stanford. Translated to forth by Marty Fraeman,
\ Johns Hopkins University/Applied Physics Laboratory.

: exchange ( x y -- ) dup @ rot dup @ >r ! r> swap ! ;

variable seed

: initiate-seed ( -- )  74755 seed ! ;
: random  ( -- n )  seed @ 1309 * 13849 + 65535 and dup seed ! ;

\ These structure access words were originally developed by
\ at JHU/APL by Ben Ballard and John Hayes
\ Structure access words
\ Examples of use:
\ structure foo  \ declare a structure named foo
\       wrd: .thing1 \ with a one word field named .thing1
\    2 wrds: .thing2 \ and a two word field named .thing2
\ endstructure
\
\ structure foobar \ another structure
\           wrd: .thing
\    foo struct: .blah \ nested structure
\ endstructure
\
\ foobar makestruct test \ allocate space for a structure instance
\ 1234 test .blah .thing1 ! \ access structure

: structure ( --- structure offset0)
  create here 0 , 0
does> ( structure -- size)
  @
;

: struct: ( offset1 size --- offset2)
  create over , +
does> ( structure field -- field-addr)
  @ +
; 

: wrds: ( offset1 size --- offset2)  cells struct: ;
: wrd: ( offset1 --- offset2)  cell struct: ;
: endstructure ( structure size --- ) swap ! ;
: makestruct ( size --- )  create allot ;
: malloc  ( structure -- instance)  here swap allot ;

\ The Tree Sort definitions:

structure node ( -- )
 wrd: .left
 wrd: .right
 wrd: .val
endstructure

5000 constant tree-size
variable tree

: create-node ( n t -- )
  node malloc dup >r swap !
  r@ .val !
  nil r@ .left !
  nil r> .right !
;

: insert-node ( n t -- )
  2dup .val @ >
  if dup .left @ nil =
    if 2dup .left create-node
    else
      2dup .left @ recurse
    then
  else 2dup .val @ <
    if dup .right @ nil =
      if 2dup .right create-node
      else
	2dup .right @ recurse
      then
    then
  then
  2drop
;

: verify-tree ( t -- f)
  true >r dup .left @ nil = not
  if dup .left @ .val @ over .val @ > not
    if r> drop false >r 
    else dup .left @ recurse r> and >r then
  then 
  dup .right @ nil = not
  if dup .right @ .val @ over .val @ < not
    if r> drop false >r
    else dup .right @ recurse r> and >r then
 then
 drop r>
;

: dump-tree ( t -- )
  dup nil = not
  if dup .right @ recurse
    dup .val @ .
    dup .left @ recurse
  then
  drop
;

: tree-sort   ( -- )
  initiate-seed
  random tree create-node
  tree @
  tree-size 0 do
    random over insert-node
  loop
  verify-tree not abort" trees: wrong result"
;

forth only
