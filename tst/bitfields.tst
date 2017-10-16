.( Loading Bitfields test...) cr

#include bitfields.f83

bitfields

.( 1: Create a demo bit field definition) cr

bitfield.type STATUS-REG ( -- )
  bit    ERROR ( -- pos width)
3 bits   ERROR.CODE ( -- pos width)
  nibble INDEX ( -- pos width)
  bit    INDIRECT ( -- pos width)
  byte   OP.CODE ( -- pos width)
bitfield.end


.( 2: Print information about the fields) cr

ERROR . . cr
ERROR.CODE . . cr
INDEX . . cr
INDIRECT . . cr
OP.CODE . . cr


.( 3: Access some data with the fields) cr

binary

10101001000101111 ERROR drop b@ .
10101001000101111 INDIRECT drop b@ . cr

10101001000101111 ERROR f@ .
10101001000101111 ERROR.CODE f@ .
10101001000101111 INDEX f@ .
10101001000101111 INDIRECT f@ .
10101001000101111 OP.CODE f@ . cr

10101001000101111 ERROR <f@ .
10101001000101111 ERROR.CODE <f@ .
10101001000101111 INDEX <f@ .
10101001000101111 INDIRECT <f@ .
10101001000101111 OP.CODE <f@ . cr


.( 4: Change bit fields in some data) cr

0        10101001000101111 ERROR drop b!    ERROR drop b@ .
1        10101001000101111 INDIRECT drop b! INDIRECT drop b@ . cr

0        10101001000101111 ERROR f!      ERROR f@ .
101      10101001000101111 ERROR.CODE f! ERROR.CODE f@ .
1111     10101001000101111 INDEX f!      INDEX f@ . 
1        10101001000101111 INDIRECT f!   INDIRECT f@ . 
10111111 10101001000101111 OP.CODE f!    OP.CODE f@ . cr

decimal

forth only
