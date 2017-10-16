.( Loading Stacks test...) cr

#include stacks.f83

stacks forth definitions


.( 1: Create a small stack to test this library) cr

3 STACK foo ( -- stack)
foo .stack cr


.( 2: Push elements until the stack is full) cr

foo ?full-stack . foo ?empty-stack . cr
10 foo push foo .stack cr
foo ?full-stack . foo ?empty-stack . cr
11 foo push foo .stack cr
foo ?full-stack . foo ?empty-stack . cr
12 foo push foo .stack cr
foo ?full-stack . foo ?empty-stack . cr
cr


.( 3: Access and change the top of stack) cr

foo @ @ 1+ foo @ ! foo .stack cr
cr


.( 4: Pop elements until the stack is empty) cr

foo pop foo .stack cr drop 
foo ?full-stack . foo ?empty-stack . cr

foo pop foo .stack cr drop 
foo ?full-stack . foo ?empty-stack . cr

foo pop foo .stack cr drop 
foo ?full-stack . foo ?empty-stack . cr

forth only
