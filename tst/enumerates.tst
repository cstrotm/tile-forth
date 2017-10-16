.( Loading Enumerates test...) cr

#include enumerates.f83

enumerates

.( 1: Define a set of small numbers as enumerates and check their values) cr

enum.type SMALL-NUMBERS ( -- )
  enum ZERO ( -- enum)
  enum ONE ( -- enum)
  enum TWO ( -- enum)
  enum THREE ( -- enum)
  enum FOUR ( -- enum)
  enum FIVE ( -- enum)
enum.end
  
ZERO . ONE . TWO . THREE . FOUR . FIVE . cr

5 >enum SMALL-NUMBERS .name cr


.( 2: Define a set of operation code and give the values for each enumerate) cr

enum.type OP-CODES ( -- )
  enum LOAD ( -- enum)
  enum STORE ( -- enum)
  enum ADD ( -- enum)
  enum SUB ( -- enum)
  enum MUL ( -- enum)
enum.end

LOAD . STORE . ADD . SUB . MUL . cr

forth only
