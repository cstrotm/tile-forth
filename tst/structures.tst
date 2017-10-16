.( Loading Structures test...) cr

#include structures.f83

structures

.( 1: Print size of primitive fields) cr

sizeof byte .
sizeof word .
sizeof ptr  .
sizeof long .
sizeof enum .
cr


.( 2: Allocate some data) cr
here . new-struct word . here . cr


.( 3: Define a list structures) cr

struct.type LIST ( -- )
  ptr +next ( list -- addr)
struct.init ( list -- )
  nil swap +next !
struct.end

sizeof LIST . new-struct LIST dup . +next @ .  cr


.( 4: Define a double linked list) cr

struct.type QUEUE ( flag -- )
  struct LIST +succ ( queue -- addr)
  struct LIST +pred ( queue -- addr)
struct.init ( flag queue -- )
  swap
  if dup over +succ !
    dup +pred !
  else
    dup +succ as LIST initiate
    +pred as LIST initiate
  then
struct.end

sizeof QUEUE . cr
true new-struct QUEUE dup . dup +succ +next @ . +pred +next @ . cr
false new-struct QUEUE dup . dup +succ +next @ . +pred +next @ . cr


.( 5: Define a block using double linked list and instance function) cr

struct.type BLOCK ( size -- )
  struct QUEUE +queue ( block -- addr)
  long +size ( block -- addr)
struct.init ( size flag block -- )
  tuck +queue as QUEUE initiate
  over allot +size !
struct.does ( block -- addr)
  sizeof BLOCK +
struct.end

: block ( addr -- block)  sizeof BLOCK - ;
: size ( addr -- size)  block +size @ sizeof BLOCK + ;

sizeof BLOCK . 
here 1000 true BLOCK x here swap - . 
x . 
x block . 
x block +size @ .
x size . cr

forth only

