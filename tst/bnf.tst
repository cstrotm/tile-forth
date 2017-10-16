.( Loading Backus-Naur Form test...) cr

#include parser.f83
#include bnf.f83

parser forth definitions

: first ." first " ;
: next  ." next " ;
: last  ." last " ;

.( 1: Example of execution order: Right-to-left) cr

symbol a
symbol ,

bnf interact

<a> ::= a , <a> @ next
     |  a @ last

forth

a parse" a " cr
a parse" a , a " cr
a parse" a , a , a " cr
a parse" a , a , a , a " cr
  
  
.( 2: Example of inverse exection order: Left-to-right) cr

symbol a
symbol b
symbol c
symbol d
symbol ,

bnf interact

<a> ::= <b> <c>
     |  <b>
<b> ::= a , @ first
     |  a @ first
<c> ::= <d> <c>
     |  <d>
<d> ::= a , @ next
     |  a @ last

forth

a parse" a " cr
a parse" a , a " cr
a parse" a , a , a " cr
a parse" a , a , a , a " cr
  
.( 3: Example of factorization to minimize backtracking) cr

symbol a
symbol b
symbol ,

bnf interact

<a> ::= a <b>
<b> ::= , <a> @ next
     |  <empty> @ last

forth

a parse" a " cr
a parse" a , a " cr
a parse" a , a , a " cr
a parse" a , a , a , a " cr
  
.( 4: Example of Extended Backus-Naur Form: Zero or one time) cr

symbol a
symbol b
symbol c
symbol ,

bnf interact

<a> ::= [ <b> ] <c> a @ last
<b> ::= a , @ first
<c> ::= a , <c> @ next
     |  <empty>

forth

a parse" a " cr
a parse" a , a " cr
a parse" a , a , a " cr
a parse" a , a , a , a " cr
  
.( 5: Example of Extended Backus-Naur Form: Zero or many times) cr

symbol a
symbol b
symbol ,

bnf interact

<a> ::= a { <b> } @ first
<b> ::= , a @ next

forth

a parse" a " cr
a parse" a , a " cr
a parse" a , a , a " cr
a parse" a , a , a , a " cr
  
.( 6: Example of Extended Backus-Naur Form: Zero or one or many times) cr

symbol a
symbol b
symbol c
symbol ,

bnf interact

<a> ::= [ <b> ] { <c> } a @ last
<b> ::= a , @ first
<c> ::= a , @ next

forth

a parse" a " cr
a parse" a , a " cr
a parse" a , a , a " cr
a parse" a , a , a , a " cr
  
forth only
