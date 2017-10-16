.( Loading Permutation benchmark...) cr

\ A heavily recursive permutation program written by Denny Brown
\
\ Part of the programs gathered by John Hennessy for the MIPS
\ RISC project at Stanford. Translated to forth by Martin Freemen,
\ Johns Hopkins University/Applied Physics Laboratory.

: exchange ( x y -- ) dup @ rot dup @ >r ! r> swap ! ;

: array ( size -- )
  create 1+ cells allot immediate
does> ( index array -- ptr)
  [compile] literal
  ?compile swap
  ?compile cells
  ?compile +
;

10 constant permrange
align permrange array permarray
variable pctr

: initialize-array ( -- )
  8 1 do i 1- i permarray ! loop
;

: permute ( n -- )
  1 pctr +!
  dup 1 = not
  if dup 1- dup recurse
    begin
      dup 0>
    while
      over permarray over permarray exchange
      over 1- recurse
      over permarray over permarray exchange
      1-
    repeat
    drop
  then
  drop
;

: permutations ( -- )
  0 pctr !
  6 1 do
    initialize-array
    7 permute
  loop
  pctr @ 43300 = not abort" permutations: wrong result"
;

forth only
  
