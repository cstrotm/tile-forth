.( Loading Locals test...) cr

locals


.( 1: Redefinition of the basic stack operations using argument binding) cr

: swap { a b } b a ;
: dup { a } a a ;
: drop { a } ;
: rot { a b c } b c a ;

1 2 .s swap cr
3   .s dup cr
    .s drop cr
    .s rot cr
    .s cr
drop drop drop 


.( 2: Recursive factorial function with argument binding) cr

: recursive { n }
  n 0>
  if n 1- recurse n *
  else 1 then
;

5 recursive . cr


.( 3: Tail recursive factorial function) cr

: tail-recursive { n a }
  n 0>
  if n 1- n a * tail-recurse
  else a then
;
    
5 1 tail-recursive . cr


.( 4: Iterative factorial function with a local variable) cr

: iterative { n | a }
  1 -> a
  n 1+ 1 do
    i a * -> a
  loop
  a
;

5 iterative . cr

forth only

