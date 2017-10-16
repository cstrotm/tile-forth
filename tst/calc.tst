.( Loading Infix Calculator test...) cr

#include parser.f83
#include calc.f83

parser

\ Some test code for the simple calculator

calc parse" 10+(12*11) "

calc parse" -(10*-10)-(8*20) "
calc parse" 12*900/(10-9)*100 "
calc parse" (((20*(10+10)))) "
calc parse" 100+100/19"
calc parse" /10 "

calc interact

10+(12*11)
-(10*-10)-(8*20)
12*900/(10-9)*100
(((20*(10+10)))) 
100+100/19
/10

forth


\ High Level Extended Backus-Naur Form definition

#include calc.bnf

parser

\ Some test code for the simple calculator

calc parse" 10+(12*11) "
calc parse" -(10*-10)-(8*20) "
calc parse" 12*900/(10-9)*100 "
calc parse" (((20*(10+10)))) "
calc parse" 100+100/19"
calc parse" /10 "

calc interact

10+(12*11)
-(10*-10)-(8*20)
12*900/(10-9)*100
(((20*(10+10)))) 
100+100/19
/10

forth

forth only
