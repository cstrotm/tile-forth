.( Loading Matrix Multiplication benchmark...) cr

\ A classical benchmark of an O(n**3) algorithm; Matrix Multiplication
\
\ Part of the programs gathered by John Hennessy for the MIPS
\ RISC project at Stanford. Translated to forth by  Marty Fraeman,
\ Johns Hopkins University/Applied Physics Laboratory.

variable seed

: initiate-seed ( -- )  74755 seed ! ;
: random  ( -- n )  seed @ 1309 * 13849 + 65535 and dup seed ! ;

40 constant row-size
row-size cells constant row-byte-size

row-size row-size * constant mat-size
mat-size cells constant mat-byte-size

align create ima mat-byte-size allot
align create imb mat-byte-size allot
align create imr mat-byte-size allot

: initiate-matrix ( m[row-size][row-size] -- )
  mat-byte-size bounds do
    random dup 120 / 120 * - 60 - i !
  cell +loop
;

: innerproduct ( a[row][*] b[*][column] -- int)
  0 row-size 0 do
    >r over @ over @ * r> + >r
    cell+ swap row-byte-size + swap
    r>
  loop
  >r 2drop r>
;

: matrix-mult  ( -- )
  initiate-seed
  ima initiate-matrix
  imb initiate-matrix 
  imr ima mat-byte-size bounds do
    imb row-byte-size bounds do
      j i innerproduct over ! cell+ 
    cell +loop
  row-size cells +loop
  drop
;

forth only
